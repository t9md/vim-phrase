function! s:plog(msg) "{{{1
  call vimproc#system('echo "' . PP(a:msg) . '" >> ~/vim.log')
endfunction
"}}}

let s:phrase_anchor         = " Phrase: "
let s:phrase_header_width   = 70
let s:phrase_separator      = repeat('=', s:phrase_header_width)
let s:phrase_dir            = expand(g:phrase_basedir . '/'. g:phrase_author)

" Utility:
let s:table = phrase#table#get()

function! s:commentout(filetype, string, is_subject) "{{{1
  let comment = copy(s:table.comment_for(a:filetype))
  if a:is_subject
    let string = len(comment) == 1
          \ ? a:string
          \ : a:string . repeat(" ", s:phrase_header_width - len(a:string))
  else
    let string = a:string
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
  if inputdialog("create " . a:dir . "?[y/n] ") ==? 'y'
    call mkdir(a:dir, 'p')
  endif
endfunction
"}}}

let s:phrase = {}

function! s:phrase.prepare(ext) "{{{1
  let prompt = "Phrase for '" . a:ext . "'"
  let subject = inputdialog(prompt, '', -1)
  call s:ensure(subject !=# - 1, 'Cancelled')

  let body = getline(line("'<"), line("'>"))
  return self._prepare(subject, body, &filetype)
endfunction

function! s:phrase._prepare(subject, body, filetype) "{{{1
  return {
        \ 'subject':   s:commentout(a:filetype, s:phrase_anchor . a:subject, 1),
        \ 'separator': s:commentout(a:filetype, s:phrase_separator, 0),
        \ 'body':      a:body,
        \ }
endfunction

function! s:phrase.edit(ext) "{{{1
  let path = simplify(s:phrase_dir . "/phrase.". a:ext)
  if !isdirectory(s:phrase_dir)
    call s:mkdir(s:phrase_dir)
    call s:ensure(isdirectory(s:phrase_dir), 
          \ "fail to create dir '" . s:phrase_dir . "'")
  endif

  let winno = bufwinnr(path)
  if winno != -1
    execute winno . ':wincmd w'
  else
    let opt = ( winwidth(0) * 2 ) < (winheight(0) * 5 ) ? '' : 'vertical'
    exe 'belowright' opt 'split' path
  endif
endfunction

function! s:phrase.start(ope, ...) "{{{1
  try
    let ext = empty(a:000) ? self.get_ext() : a:1
    call s:ensure(!empty(ext), 'empty extention')

    if a:ope == 'create'
      let phrase = self.prepare(ext)
      call s:ensure(!empty(phrase), 'empty phrase')
    endif

    call self.edit(ext)

    if a:ope ==# 'create'
      call append(0, [ phrase.subject, phrase.separator ] + phrase.body + [''])
      execute "normal! 3ggV". (len( phrase.body ) - 1). "jo"
    endif
  catch /phrase\.vim/
    echom v:exception
  endtry
endfunction

function! s:phrase.files(ext)
  return split(globpath(&runtimepath, 'phrase/*/'. 'phrase.'.a:ext),'\n')
endfunction

function! s:phrase.all(ext, filetype) "{{{1
  let R = []
  for file in self.files(a:ext)
    call extend(R,  self._parse(file, a:filetype))
  endfor
  return R
endfunction

function! s:phrase._parse(file, filetype) "{{{1
  let R      = []
  let author = fnamemodify(a:file, ":h:t")

  for [idx, line] in map(readfile(a:file),'[v:key, v:val]')
    if line =~# s:phrase_anchor
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


function! s:phrase.get_ext()
  return (exists('b:phrase_ext') && !empty('b:phrase_ext'))
        \ ? b:phrase_ext : s:table.ext_for(&filetype)
endfunction

" Public:
function! phrase#get_ext() "{{{1
  return s:phrase.get_ext()
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
" }}}

" Test: {{{1
if expand("%:p") !=# expand("<sfile>:p")
  finish
endif

function! s:run_test() "{{{1
  let subject = 'Sample Phrase for filetype: '
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

" PP table._table

call s:run_test()
"}}}


" vim: foldmethod=marker
