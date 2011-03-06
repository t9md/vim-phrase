"=============================================================================
" File: phrase.vim
" Author: t9md <taqumd@gmail.com>
" Version: 1.0
" WebPage: http://github.com/t9md/vim-phrase
" License: BSD
" Usage:

if exists('g:loaded_phrase')
  finish
endif
let g:loaded_phrase = 1

"for line continuation - i.e dont want C in &cpo
let s:old_cpo = &cpo
set cpo&vim

" Main
"=================================================================
let g:Phrase = {}

if !exists('g:phrase_author')
  let g:phrase_author = "$USER"
endif

if !exists('g:phrase_basedir')
  let g:phrase_basedir = split(&rtp,',')[0] . "/" . "phrase"
endif


let g:phrase_dir = expand(g:phrase_basedir . '/'. g:phrase_author)

let s:default_comment = {
            \"vim": '"',
            \"ruby": "#",
            \"perl": "#",
            \"sh": "#",
            \"python": "#",
            \"javascript": "//",
            \}

let s:default_ft2ext = {
            \ 'perl': 'pl',
            \ 'ruby': 'rb',
            \ 'python': 'py',
            \ 'javascript': 'js',
            \ }

fun! g:Phrase.get_comment_str() dict
    if !exists("g:phrase_comment")
        let g:phrase_comment = {}
    endif
    return get(extend(s:default_comment, g:phrase_comment, "force"), &ft, '#')
endfun

fun! g:Phrase.phrase_filename(query) dict
    if !exists("g:phrase_ft2ext")
        let g:phrase_ft2ext = {}
    endif
    let table = extend(s:default_ft2ext, g:phrase_ft2ext, "force")
    let ext   = get(table, a:query, a:query)
    let base = "phrase"
    let fname = !empty(ext) ? base . "." . ext : base
    return fname
endfun

fun! g:Phrase.create() range dict
    let title = inputdialog("Phrase: ","", -1)
    if title == -1 | return | endif

    let selection = getline(a:firstline, a:lastline)
    let comment_str = self.get_comment_str()
    call g:Phrase.edit(&ft)

    let subject = comment_str . " Phrase: " . title
    let sepalator = comment_str . repeat('=', 70)
    let phrase = [ subject, sepalator ]
    call extend(phrase, selection)
    call extend(phrase, [""])
    call append(0, phrase)
    let cmd = "normal! 3ggV".(len(selection)-1)."jo"
    execute cmd
endfun

function! s:open_buffer(filename)
  let opt = winwidth(0) * 2 < winheight(0) * 5 ? "" : "vertical"
	exe "belowright " . opt . " split " . a:filename
  " return opt
endfunction

function! s:split()
  let opt = winwidth(0) * 2 < winheight(0) * 5 ? "" : "vertical"
	exe "belowright " . opt . " split"
endfunction

let s:phrase_list_buffer = '[ phrase list ]'
let s:phrase_list_buffer_nr = -1

fun! s:phrase_list_buffer_open()
    let win = bufwinnr(s:phrase_list_buffer_nr)
    if win != -1 " found!
        execute win."wincmd w"
        return
    end

    call s:split()
    if s:phrase_list_buffer_nr == -1
        execute 'edit ' . s:phrase_list_buffer
        nnoremap <buffer> q <C-w>c
        setlocal bufhidden=hide buftype=nofile noswapfile nobuflisted
        let s:phrase_list_buffer_nr = bufnr('%')
    else
        execute 'silent buffer ' . s:phrase_list_buffer_nr
    endif
endfun

function! s:phrase_list_refresh(file, query)
    silent normal! gg"_dG
    let phrase_list = filter(readfile(a:file), 'v:val =~# " Phrase:"')
    call setline(1, phrase_list)

    let b:phrase = a:query
    syn match PhraseMark '.*Phrase:'
    hi def link PhraseMark Define
    nnoremap <buffer> <CR> :<C-u>call g:Phrase.open(b:phrase)<CR>
endfunction

fun! g:Phrase.list(...) range dict
    let query = !empty(a:1) ? a:1 : &ft

    let fname = self.phrase_filename(query)
    let phrase_file = expand(g:phrase_dir ."/" . fname)
    if !filereadable(phrase_file)
        echohl Type | echo "phrase file not readable" | echohl Normal
        return
    endif

    call s:phrase_list_buffer_open()
    call s:phrase_list_refresh(phrase_file, query)
endfun

fun! g:Phrase.open(query)
    let search = getline('.')
    call g:Phrase.edit(a:query)
    call search(search)
    normal zt
endfun

" fun! g:Phrase_ext_candidate(...)
    " let flist = split(glob(g:phrase_dir."/" . g:phrase_author . "/*"), "\n")
    " return map(flist, 'fnamemodify(v:val,":e")')
" endfun

fun! g:Phrase.edit(...)
  if !isdirectory(g:phrase_dir)
    let answer = input("create " . g:phrase_dir . "?[y/n] ")
    if answer == 'y'
      call mkdir(g:phrase_dir, 'p')
    end
  endif

    let query = !empty(a:1) ? a:1 :
                \ !empty(&ft) ?
                \ &ft :
                \ input("Filetype: ",'','customlist,g:Phrase_ext_candidate')

    let fname = self.phrase_filename(query)
    " belowright split
    let phrase_file = g:phrase_dir . '/' . fname

    let phrase_file = fnamemodify(expand(phrase_file), ':p')
    if s:select_bufferwin(phrase_file) == -1
        call s:open_buffer(phrase_file)
    endif
endfun

function! s:select_bufferwin(bufname)
    let winno = bufwinnr(a:bufname)
    if winno != -1
        execute winno . ':wincmd w'
    endif
    return winno
endfunction

" Create command
"=================================================================
command! -nargs=? PhraseList :call g:Phrase.list(<q-args>)
command! -nargs=? PhraseEdit :call g:Phrase.edit(<q-args>)
command! -nargs=0 -range PhraseCreate :<line1>,<line2>call g:Phrase.create()

let &cpo = s:old_cpo

