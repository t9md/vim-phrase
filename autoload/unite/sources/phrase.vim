let s:unite_source = {}
let s:unite_source.name = 'phrase'
let s:phrase_anchor = " Phrase:"
function! s:unite_source.gather_candidates(args, context)
  if empty(&ft)
    return []
  endif
  let path = resolve(expand(g:phrase_dir . "/". g:Phrase.phrase_filename(&ft)))
  let phrase_list = []
  let lines = readfile(path)

  for n in range(len(lines))
    let str = lines[n]
    if str =~# s:phrase_anchor

            " \ "title": substitute(str,s:phrase_anchor,"","")
      call add(phrase_list, {
            \ "linum": n+1,
            \ "title": substitute(str,'\(.* Phrase: \)','','')
            \ })
    endif
  endfor

  return map(phrase_list, '{
  \   "word": v:val.title,
  \   "source": "phrase",
  \   "kind": "jump_list",
  \   "action__path": path,
  \   "action__line": v:val.linum
  \ }')
endfunction

function! unite#sources#phrase#define() "{{{
  return s:unite_source
endfunction "}}}
" let s:unite_source = {}
" let s:unite_source.name = 'phrase'
" let s:phrase_anchor = " Phrase:"
" function! s:unite_source.gather_candidates(args, context)
  " if empty(&ft) | return [] | endif
  " let path = expand(g:phrase_dir . "/".g:Phrase.phrase_filename(&ft))
  " let phrase_list = []

  " let lines = getbufline(path, 1, '$')
  " for n in range(len(lines))
    " let str = lines[n]
    " if str =~# s:phrase_anchor

            " " \ "title": substitute(str,s:phrase_anchor,"","")
      " call add(phrase_list, {
            " \ "linum": n+1,
            " \ "title": substitute(str,'\(.* Phrase: \)','','')
            " \ })
    " endif
  " endfor

  " return map(phrase_list, '{
  " \   "word": v:val.title,
  " \   "source": "phrase",
  " \   "kind": "jump_list",
  " \   "action__path": path,
  " \   "action__line": v:val.linum
  " \ }')
" endfunction

