"=============================================================================
" File: phrase.vim
" Author: t9md <taqumd@gmail.com>
" WebPage: http://github.com/t9md/vim-phrase
" License: BSD
" Version: 0.4

" GUARD: {{{1
"============================================================
if exists('g:loaded_phrase')
  if !exists('g:phrase_dev')
    finish
  endif
endif

let g:loaded_phrase = 1
let s:old_cpo = &cpo
set cpo&vim
" INIT: {{{1
function! s:set_var(varname, default)
    if !exists(a:varname)
        let {a:varname} = a:default
    endif
endfunction

call s:set_var('g:phrase_author', "$USER")
call s:set_var('g:phrase_basedir', split(&rtp,',')[0] . "/" . "phrase")
call s:set_var('g:phrase_ft_tbl', {})
call s:set_var('g:phrase_dir', expand(g:phrase_basedir . '/'. g:phrase_author))

function! s:set_phrase_ext(line) "{{{
  let b:phrase_ext = matchstr(a:line,'phrase: \zs.*')
endfunction "}}}

" AutoCmd: {{{1
augroup Phrase
    autocmd!
    autocmd BufReadPost * if getline('$') =~ "phrase: " | call <SID>set_phrase_ext(getline('$')) | endif
augroup END

" KEYMAP: {{{1
"=================================================================
nnoremap <silent> <Plug>(phrase#edit)   :<C-u>call phrase#edit()<CR>
xnoremap <silent> <Plug>(phrase#create) :<C-u>call phrase#create()<CR>

" COMMAND: {{{1
"=================================================================
command! -nargs=? PhraseList :call phrase#list(<q-args>)
command! -nargs=? PhraseEdit :call phrase#edit(<q-args>)
command! -nargs=0 -range PhraseCreate :call phrase#create(<line1>,<line2>)

" FINISH: {{{1
let &cpo = s:old_cpo
" vim: foldmethod=marker
