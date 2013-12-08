let s:old_cpo = &cpo
set cpo&vim

function! unite#filters#sorter_phrase#define() "{{{
  return s:sorter
endfunction "}}}

let s:sorter = {
      \ 'name': 'sorter_phrase',
      \ 'description' : 'sort phrase with author''s priority',
      \ }

function! s:sortfunc(c1, c2) "{{{1
  return a:c1.source__phrase_priority - a:c2.source__phrase_priority
endfunction

function! s:sorter.filter(candidates, context) "{{{1
  return sort(a:candidates, function('s:sortfunc'))
endfunction
"}}}

let &cpo = s:old_cpo
unlet s:old_cpo

" vim: foldmethod=marker

