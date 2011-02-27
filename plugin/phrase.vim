"=============================================================================
" File: phrase.vim
" Author: t9md <taqumd@gmail.com>
" Version: 1.0
" WebPage: http://github.com/t9md/vim-phrase
" License: BSD
" Usage:
"   to change or add comment string for filetype
"   set Phrase_comment_str in your .vimrc
"
"   let g:phrase_dir = "$HOME/.vim/phrase"
"
"   Comment string setting
"   ------------------------------------------------------------------
"   let g:phrase_commment = {}
"   let g:phrase_comment.vim = '"'
"   let g:phrase_comment.lua = '--'
"
"   Keymap Example
"   -----------------------------------------------------------------
"    let mapleader = ","
"    nnoremap <silent> <Leader>pl  :PhraseList<CR>
"    vnoremap <silent> <Leader>pl  :<C-u>PhraseList<CR>
"    nnoremap <silent> <Leader>pe  :PhraseEdit<CR>
"    vnoremap <silent> <Leader>pe  :PhraseEdit<CR>
"    vnoremap <silent> <Leader>pc  :PhraseCreate<CR>

"for line continuation - i.e dont want C in &cpo
let s:old_cpo = &cpo
set cpo&vim

" Main
"=================================================================
let g:Phrase = {}

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
    let selection = getline(a:firstline, a:lastline)
    call g:Phrase.edit(&ft)
    let comment_str = self.get_comment_str()
    let subject = comment_str . " Phrase: " . inputdialog("Phrase: ")
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

fun! g:Phrase.list(...) range dict
    let query = !empty(a:1) ? a:1 : &ft

    let fname = self.phrase_filename(query)
		let phrase_file = expand(g:phrase_dir . "/" . fname)
		if !filereadable(phrase_file)
			echohl Type | echo "phrase file not readable" | echohl Normal
			return
		endif

		let bufname = '[ phrase list ]'

		call s:open_buffer(bufname)
		nnoremap <buffer> q <C-w>c
		setlocal bufhidden=hide buftype=nofile noswapfile
    let phrase_list = filter(readfile(phrase_file), 'v:val =~# " Phrase:"')

    call setline(1, phrase_list)

		" setlocal bufhidden=hide buftype=nofile noswapfile nobuflisted
		nnoremap <buffer> q <C-w>c

    let b:phrase = query
    syn match PhraseMark '.*Phrase:'
    hi def link PhraseMark Define
    nnoremap <buffer> <CR> :<C-u>call g:Phrase.open(b:phrase)<CR>
endfun

fun! g:Phrase.open(query)
    let search = getline('.')
    call g:Phrase.edit(a:query)
    call search(search)
    normal zt
endfun

" fun! g:Phrase.ext_candidate(...)
" let flist = split(glob(g:phrase_dir . "/*"), "\n")
" return map(flist, 'fnamemodify(v:val,":e")')
" endfun

fun! g:Phrase_ext_candidate(...)
    let flist = split(glob(g:phrase_dir . "/*"), "\n")
    return map(flist, 'fnamemodify(v:val,":e")')
endfun

fun! g:Phrase.edit(...)
    let query = !empty(a:1) ? a:1 :
                \ !empty(&ft) ?
                \ &ft :
                \ input("Filetype: ",'','customlist,g:Phrase_ext_candidate')

    let fname = self.phrase_filename(query)
    " belowright split
    let phrase_file = g:phrase_dir . '/' . fname
    " execute "edit " g:phrase_dir . "/" . fname

    if s:select_bufferwin(phrase_file) == -1
        call s:open_buffer(phrase_file)
    endif
endfun

function! s:select_bufferwin(bufname)
    let expanded = expand(a:bufname)
    let canonical_bufname = fnamemodify(expanded, ':p:~')
    let winno = bufwinnr(canonical_bufname)
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

