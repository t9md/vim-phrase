" GUARD:
if expand("%:p") ==# expand("<sfile>:p")
  unlet! g:loaded_phrase
endif

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

let s:is_windows = has('win16') || has('win32') || has('win64') || has('win95')
let s:options = {
      \ 'g:phrase_author': expand("$USER"),
      \ 'g:phrase_basedir': s:is_windows ? "$HOME/vimfiles" : "$HOME/.vim",
      \ 'g:phrase_author_priority': {},
      \ }

call s:set_options(s:options)

function! s:phrase_set_phrase_file() "{{{1
  " set phrase_ext by checking last 2 line in buffer.
  for line in getline(line('$') -1, line('$'))
    if line =~# 'phrase_file: '
      let b:phrase_file = matchstr(line,'phrase_file: \zs.*')
      return
    endif
  endfor
endfunction
"}}}

" AutoCmd:
augroup plugin-phrase
    autocmd!
    autocmd BufReadPost * call <SID>phrase_set_phrase_file()
augroup END

" KeyMap:
nnoremap <silent> <Plug>(phrase-edit)   :<C-u>call phrase#edit()<CR>
xnoremap <silent> <Plug>(phrase-create) :call phrase#create()<CR>

" Command:
command! -nargs=? -complete=customlist,phrase#myfiles
      \ PhraseEdit   :call phrase#edit(<f-args>)
command! -nargs=? -range -complete=customlist,phrase#myfiles
      \ PhraseCreate   :'<,'>call phrase#create(<f-args>)

" Finish:
let &cpo = s:old_cpo
" vim: foldmethod=marker
