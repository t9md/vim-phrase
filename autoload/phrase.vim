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
  let comment = copy(s:table.comment_for(a:filetype))
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
  if input("create phrase basedir '" . a:dir . " '[(y)/n]?: ", 'y') ==? 'y'
    call mkdir(a:dir, 'p')
  endif
endfunction
"}}}

let s:phrase = {}
function! s:phrase.prepare(category, filetype) "{{{1
  let prompt = printf('[%s] Phrase subject: ', a:category)
  let subject = inputdialog(prompt, '', -1)
  call s:ensure(subject !=# - 1, 'Cancelled')

  let body = getline(line("'<"), line("'>"))
  return self._prepare(subject, body, a:filetype)
endfunction

function! s:phrase._prepare(subject, body, filetype) "{{{1
  " FIXME commentout need to be delayed to use phrasefile's &filetype
  " so that gather phrase from other &filetype's file.
  return {
        \ 'subject':   s:commentout(a:filetype, s:CONSTANTS.anchor . a:subject, 1),
        \ 'separator': s:commentout(a:filetype, s:CONSTANTS.separator, 0),
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


function! s:phrase.start(ope, ...) "{{{1
  try
    if !empty(a:000)
      let phrase_file = s:CONSTANTS.phrasedir . '/' . a:1
      let category    = fnamemodify(a:1, ':r')
      call s:ensure(!empty(category), 'empty category or &filetype')
    else
      let category = self.get_category()
      call s:ensure(!empty(category), 'empty category or &filetype')
      let phrase_file = self.findfile(category)
      if empty(phrase_file)
        let prompt = printf('[%s] file extension:', category)
        let ext = inputdialog(prompt, expand('%:e') , '')
        call s:ensure(!empty(ext), 'empty extention')

        let phrase_file = s:CONSTANTS.phrasedir . '/' . category . '.' . ext
      endif
    endif


    if a:ope == 'create'
      let phrase = self.prepare(category, &filetype)
      call s:ensure(!empty(phrase), 'empty phrase')
      call s:ensure( strdisplaywidth(phrase.subject) <= s:CONSTANTS.header_width,
            \'phrase subject width exceeed '. s:CONSTANTS.header_width )
    endif

    if !isdirectory(s:CONSTANTS.phrasedir)
      call s:mkdir(s:CONSTANTS.phrasedir)
      call s:ensure(isdirectory(s:CONSTANTS.phrasedir), 
            \ "fail to create dir '" . s:CONSTANTS.phrasedir . "'")
    endif
    " call s:plog(phrase_file)
    call self.edit(phrase_file)

    if a:ope ==# 'create'
      call append(0, [ phrase.subject, phrase.separator ] + phrase.body + [''])
      execute "normal! 3ggV". (len( phrase.body ) - 1). "jo"
    endif
  catch /phrase\.vim/
    echom v:exception
  endtry
endfunction

function! s:phrase.findfile(category)
  let files = split(globpath(s:CONSTANTS.phrasedir, a:category . '.*'), "\n")
  if len(files) == 1
    return files[0]
  endif
  let ext = expand('%:e')
  for file in files
    if file =~# ext
      return file
    endif
  endfor
endfunction

function! s:phrase.files(category, ext)
  " if ext is empty, search with only category
  let phrase_file = a:category . '.' . (empty(a:ext) ? '*' : a:ext)

  if !exists('s:search_dir')
    let dir = expand(g:phrase_basedir)
    let rtp = split(&runtimepath, ',')
    if index(rtp, expand(g:phrase_basedir)) == -1
      " insert author's dir as first element
      let s:search_dir = join(insert(rtp, dir, 0), ',')
    else
      let s:search_dir = &runtimepath
    endif
  endif
  return split(globpath(s:search_dir, 'phrase/*/'. phrase_file),'\n')
endfunction

function! s:phrase.all(category, filetype, ext) "{{{1
  " category is not necessarily same as filetype. ex) chef.rb
  " call s:plog([a:category, a:filetype, a:ext])
  let R = []
  for file in self.files(a:category, a:ext)
    call extend(R,  self._parse(file, a:filetype))
  endfor
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
" echo PP( s:phrase.all('vim', 'vim', 'vim'))

function! s:phrase.get_category() "{{{1
  " category is not necessarily same as filetype. ex) chef.rb
  return get(b:, 'phrase_category', &filetype)
endfunction
"}}}
" Public:
function! phrase#get_category() "{{{1
  return s:phrase.get_category()
endfunction

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

function! phrase#start(...) "{{{1
  call call(s:phrase.start, a:000, s:phrase)
endfunction

function! phrase#all(...) "{{{1
  return call(s:phrase.all, a:000, s:phrase)
endfunction

function! phrase#files(...) "{{{1
  return call(s:phrase.files, a:000, s:phrase)
endfunction

function! phrase#list(...) "{{{1
  return call(s:phrase.list, a:000, s:phrase)
endfunction
" }}}

" Test: {{{1
if expand("%:p") !=# expand("<sfile>:p")
  finish
endif

function! s:run_test() "{{{1
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

" echo s:phrase.files('vim', 'vim')

" echo PP( s:phrase.list('vim') )
" PP table._table

" call s:run_test()
"}}}
" echo s:phrase.findfile('help')

" vim: foldmethod=marker
