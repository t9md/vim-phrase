let s:save_cpo = &cpo
set cpo&vim

function! unite#filters#sorter_phrase#define()"{{{
  return s:sorter
endfunction"}}}

let s:sorter = {
      \ 'name' : 'sorter_phrase',
      \ 'description' : "sort by phrase's priority",
      \}

function! s:sorter.filter(candidates, context)"{{{
  " for can in a:candidates
    " call unite#print_message(can.source__phrase_author_priority)
    " call unite#print_message(can.source__phrase_author)
  " endfor
  return unite#util#sort_by(a:candidates, 'v:val.source__phrase_priority')
endfunction"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker

