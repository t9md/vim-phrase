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

function! s:extract_title(filetype, string) "{{{1
  let comment   = s:table.comment_for(a:filetype)
  let comment_l = get(comment, 0)
  let comment_r = get(comment, 1, '')
  let pattern   = '^\V'. comment_l .'\v\s+Phrase:\s+\zs.*\ze\s*\V'. comment_r . '\v$'
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

function! s:create_dir(dir) "{{{1
  if inputdialog("create " . a:dir . "?[y/n] ") ==? 'y'
    call mkdir(a:dir, 'p')
  endif
endfunction
"}}}

let s:phrase = {}

function! s:phrase.prepare(ext) "{{{1
  let prompt = "Phrase for '" . a:ext . "'"
  let title = inputdialog(prompt, '', -1)
  call s:ensure(title !=# - 1, 'Cancelled')

  return self._prepare(title, &filetype)
endfunction

function! s:phrase._prepare(title, filetype) "{{{1
  return {
        \ 'subject':   s:commentout(a:filetype, s:phrase_anchor . a:title, 1),
        \ 'separator': s:commentout(a:filetype, s:phrase_separator, 0),
        \ 'body':      getline(line("'<"), line("'>"))
        \ }
endfunction

function! s:phrase.edit(ext) "{{{1
  let path = simplify(s:phrase_dir . "/phrase.". a:ext)
  if !isdirectory(s:phrase_dir)
    call s:create_dir(s:phrase_dir)
  endif
  call s:ensure(isdirectory(s:phrase_dir), "fail to create dir '" . s:phrase_dir . "'")

  let winno = bufwinnr(path)
  if winno != -1
    execute winno . ':wincmd w'
  else
    let opt = winwidth(0) * 2 < winheight(0) * 5 ? "" : "vertical"
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
            \ 'title': s:extract_title(a:filetype, line),
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
finish
if expand("%:p") !=# expand("<sfile>:p")
  finish
endif

function! s:test(ft, str) "{{{1
  echo "ft   : " . a:ft
  echo "ext  : " . s:table.ext_for(a:ft)
  let cmted = s:commentify(a:ft, " Phrase: " .a:str, 1)
  echo "cmted: " . cmted
  let title = s:extract_title(a:ft, cmted)
  echo "title: " . title
  echo "origi: " . a:str
  if a:str !=# title
    echo 'ERR'
  endif
  echo ''
endfunction


function! s:run_test() "{{{1
  let str = "ABCDEFG"
  let ft = ''
  call s:test(ft, str)
  call s:test('haskell', str)
  call s:test('vim', str)
  " echo PP(s:table)
  for ft in keys(s:table._table)
    " echo ft
    call s:test(ft, str)
  endfor
endfunction

" PP table._table

call s:run_test()
"}}}


" vim: foldmethod=marker
