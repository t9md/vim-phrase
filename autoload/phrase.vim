function! s:plog(msg) "{{{1
  call vimproc#system('echo "' . PP(a:msg) . '" >> ~/vim.log')
endfunction
"}}}

let s:CONSTANTS = {
      \ 'anchor': ' Phrase: ',
      \ 'header_width': 78,
      \ 'separator': '=',
      \ 'phrasedir': simplify(expand(g:phrase_basedir . '/phrase/'. g:phrase_author)),
      \ }

" Utility:
let s:table = phrase#table#get()

function! s:commentout(filetype, string, is_subject) "{{{1
  let comment       = copy(s:table.comment_for(a:filetype))
  let comment_width = len(join(comment, ''))
  if a:is_subject
    let string = len(comment) == 1
          \ ? a:string
          \ : a:string . repeat(" ",
          \    s:CONSTANTS.header_width - (comment_width + strdisplaywidth(a:string)))
  else
    let string = repeat('=', s:CONSTANTS.header_width - comment_width)
  endif
  return join(insert(comment, string, 1), "")
endfunction

function! s:extract_subject(filetype, string) "{{{1
  let c   = s:table.comment_for(a:filetype)
  let c_L = escape(get(c, 0), '\')
  let c_R = escape(get(c, 1, ''), '\')
  let pattern   = '^\V'. c_L .'\v\s+Phrase:\s+\zs.*\ze\s*\V'. c_R . '\v$'
  return s:strip(matchstr(a:string, pattern))
endfunction

function! s:strip(str) "{{{1
  return matchstr(a:str, '^\s*\zs.\{-}\ze\s*$')
endfunction

function! s:ensure(expr, msg) "{{{1
  if !a:expr
    throw "phrase.vim: " . a:msg
  endif
endfunction

function! s:mkdir(dir) "{{{1
  let ret = confirm('create basedir [' . a:dir . '] ?', "&No\n&Yes", 1)
  call s:ensure(ret ==# 2, "Cancelled")
  call mkdir(a:dir, 'p')
endfunction
"}}}

let s:phrase = {}
function! s:phrase.prepare(body, filetype) "{{{1
  let prompt = 'Phrase subject: '
  let subject = inputdialog(prompt, '', -1)
  call s:ensure(subject !=# -1, 'Cancelled')
  return {
        \ 'subject':  subject,
        \ 'separator': s:CONSTANTS.separator,
        \ 'body':      a:body,
        \ }
endfunction

function! s:phrase.edit(phrase_file) "{{{1
  let winno = bufwinnr(a:phrase_file)
  if winno != -1
    execute winno . ':wincmd w'
  else
    let opt = ( winwidth(0) * 2 ) < (winheight(0) * 5 ) ? '' : 'vertical'
    exe 'belowright' opt 'split' a:phrase_file
  endif
endfunction

function! s:phrase.search_dirs() "{{{1
  let base = expand(g:phrase_basedir)
  let rtp  = split(&runtimepath, ',')

  let R = []
  if index(rtp, base)  == - 1
    call insert(rtp, base, 0)
  else
    let R = rtp
  endif
  return R
endfunction

function! s:phrase.find(who, ...) "{{{1
  let patterns = !empty(a:000) ? a:000 : self.file_patterns()
  let R = []
  for pattern in patterns
    call extend(R, split(s:phrase._find(a:who, pattern), "\n"))
    if !empty(R)
      return R
    endif
  endfor
  return ''
endfunction

function! s:phrase.find_one(...) "{{{1
  let found = call(self.find, a:000, self)
  return !empty(found) ? found[0] : ''
endfunction

function! s:phrase._find(who, pattern) "{{{1
  let dirs = join(self.search_dirs(), ',')
  let pattern = join([ 'phrase', a:who, a:pattern ], '/')
  return globpath(dirs, pattern)
endfunction

function! s:phrase.file_patterns() "{{{1
  let R = []
  let file = get(b:, 'phrase_file', '')
  if !empty(file)
    return add(R, file)
  endif
  let prefix = 'phrase__' . &filetype
  let ext = expand('%:e')
  if !empty(ext)
    call add(R, prefix . '.' . ext)
  endif
  call add(R, prefix . '.'. '*')
  return R
endfunction

function! s:phrase._parse(file, filetype) "{{{1
  let R      = []
  let author = fnamemodify(a:file, ":h:t")

  for [idx, line] in map(readfile(a:file),'[v:key, v:val]')
    if line =~# s:CONSTANTS.anchor
      call add(R, {
            \ 'author': author,
            \ 'subject': s:extract_subject(a:filetype, line),
            \ 'file': a:file,
            \ 'line': idx + 1,
            \ })
    endif
  endfor
  return R
endfunction

function! s:phrase.mkdir() "{{{1
  if !isdirectory(s:CONSTANTS.phrasedir)
    call s:mkdir(s:CONSTANTS.phrasedir)
    call s:ensure(isdirectory(s:CONSTANTS.phrasedir), 
          \ "fail to create dir '" . s:CONSTANTS.phrasedir . "'")
  endif
endfunction
"}}}

" Public:
function! phrase#myfiles(A, L, P) "{{{1
  let R = []
  for file in split(globpath(s:CONSTANTS.phrasedir, '*'), "\n")
    let f = fnamemodify(file, ':p:t')
    if f =~# '^\V' . a:A
      call add(R, f)
    endif
  endfor
  return R
endfunction


function! phrase#edit(...) "{{{1
  try
    call s:phrase.mkdir()
    let file = call(s:phrase.find_one, [g:phrase_author] + a:000, s:phrase)
    if empty(file)
      let ext = expand('%:e')
      let prompt = "Phrase file name? File name format\nphrase__{category}.{ext}: "
      echohl Type
      let _file = input(prompt, 'phrase__' . &filetype . '.' . ext)
      echohl Normal
      let file = join([s:CONSTANTS.phrasedir, _file], '/')
    endif
    call s:phrase.edit(file)
  catch /phrase\.vim/
    echom v:exception
  endtry
endfunction


function! phrase#create(...) range "{{{1
  try
    let body = getline(a:firstline, a:lastline)
    let phrase = s:phrase.prepare(body, &filetype)
    call s:ensure(!empty(phrase), 'empty phrase')

    call call('phrase#edit', a:000)

    " commentout need to be delayed to use phrasefile's &filetype
    " for when gathering phrase from other &filetype's file.
    let phrase.subject = s:commentout(&filetype, s:CONSTANTS.anchor . phrase.subject, 1)
    let phrase.separator = s:commentout(&filetype, phrase.separator, 0)

    call s:ensure( strdisplaywidth(phrase.subject) <= s:CONSTANTS.header_width,
          \'phrase subject width exceeed '. s:CONSTANTS.header_width )

    call append(0, [ phrase.subject, phrase.separator ] + phrase.body + [''])
    execute "normal! 3ggV". (len( phrase.body ) - 1). "jo"
  catch /phrase\.vim/
    echom v:exception
  endtry
endfunction

function! phrase#all(...) "{{{1
  let files =  s:phrase.find('*')
  let R = []
  for file in files
    call extend(R, s:phrase._parse(file, &filetype))
  endfor
  return R
endfunction
" }}}

" Test: {{{1
if expand("%:p") !=# expand("<sfile>:p")
  finish
endif

function! s:run_test() abort "{{{1
  let subject = 'Sample Phrase for filetype: コレはサンプルです。'
  let body = getline(line("'<"), line("'>"))
  let body = ['this is', 'sample', 'body' ]
  for filetype in keys(s:table._table)
    " phrase create test
    let subject_org = subject . filetype
    let phrase =  s:phrase._prepare(subject_org, body, filetype)
    echo join([ phrase.subject, phrase.separator ] + phrase.body + [''],"\n")

    " extract subject
    let subject_extracted = s:extract_subject(filetype, phrase.subject)
    if subject_org !=# subject_extracted
      echo 'ERR: ' . filetype
      PP subject_org
      PP subject_extracted
      " throw filetype
      echo ''
      echo ''
    endif
  endfor
endfunction
" call s:run_test()
" vim: foldmethod=marker
