" GUARD:
if exists('g:loaded_phrase')
  finish
endif
let g:loaded_phrase = 1
let s:old_cpo = &cpo
set cpo&vim

" Main:
function! s:set_options(options) "{{{1
  for [varname, value] in items(a:options)
    if !exists(varname)
      let {varname} = value
    endif
    unlet value
  endfor
endfunction
"}}}

let s:options = {
      \ 'g:phrase_author':          expand("$USER"),
      \ 'g:phrase_basedir':         "~/.vim",
      \ 'g:phrase_author_priority': {},
      \ }

call s:set_options(s:options)

function! s:phrase_set_category() "{{{1
  " set phrase_ext by checking last 2 line in buffer.
  for line in getline(line('$') -1, line('$'))
    if line =~# 'phrase: '
      let b:phrase_category = matchstr(line,'phrase: \zs.*')
      return
    endif
  endfor
endfunction
"}}}

" AutoCmd:
augroup plugin-phrase
    autocmd!
    autocmd BufReadPost * call <SID>phrase_set_category()
augroup END

" KeyMap:
nnoremap <silent> <Plug>(phrase-edit)   :<C-u>call phrase#start('edit')<CR>
xnoremap <silent> <Plug>(phrase-create) :<C-u>call phrase#start('create')<CR>

" Command:
command! -nargs=? -complete=customlist,phrase#myfiles
      \ PhraseEdit   :call phrase#start('edit'  , <f-args>)

command! -nargs=? -range PhraseCreate :call phrase#start('create', <f-args>)

" Finish:
let &cpo = s:old_cpo
" vim: foldmethod=marker
