"=============================================================================
" File: phrase.vim
" Author: t9md <taqumd@gmail.com>
" WebPage: http://github.com/t9md/vim-phrase
" License: BSD
" Version: 0.4

" GUARD: {{{1
"============================================================
if exists('g:phrase_dev') | unlet! g:loaded_phrase | endif
if exists('g:loaded_phrase')
  finish
endif
let g:loaded_phrase = 1

let s:old_cpo = &cpo
set cpo&vim

" INIT: {{{1
function! s:set_default(varname, default)
    if !exists(a:varname)
        let {a:varname} = a:default
    endif
endfunction

call s:set_default('g:phrase_debug', 0)
call s:set_default('g:phrase_author', expand("$USER"))
call s:set_default('g:phrase_basedir', split(&rtp,',')[0] . "/" . "phrase")
call s:set_default('g:phrase_ft_tbl', {})
call s:set_default('g:phrase_dir', expand(g:phrase_basedir . '/'. g:phrase_author))

function! s:set_phrase_ext() "{{{
  " set phrase_ext by checking last 2 line in buffer.
  for line in getline(line('$')-1, line('$'))
    if line =~# 'phrase: '
      let b:phrase_ext = matchstr(line,'phrase: \zs.*')
      return
    endif
  endfor
endfunction "}}}

" AutoCmd: {{{1
augroup Phrase
    autocmd!
    autocmd BufReadPost * call <SID>set_phrase_ext()
augroup END

" KEYMAP: {{{1
"=================================================================
nnoremap <silent> <Plug>(phrase-edit)   :<C-u>PhraseEdit<CR>
nnoremap <silent> <Plug>(phrase-list)   :<C-u>PhraseList<CR>
xnoremap <silent> <Plug>(phrase-create) :<C-u>PhraseCreate<CR>

" COMMAND: {{{1
"=================================================================
command! -nargs=? PhraseList          :call phrase#list(<f-args>)
command! -nargs=? PhraseEdit          :call phrase#edit(<f-args>)
command! -range PhraseCreate :call phrase#create()

" FINISH: {{{1
let &cpo = s:old_cpo
" vim: foldmethod=marker
