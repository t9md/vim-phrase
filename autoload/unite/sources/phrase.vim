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
      let phrase = {
            \   "word": substitute(str,'\(.* Phrase: \)','',''),
            \   "source": s:unite_source.name,
            \   "kind": "jump_list",
            \   "action__path": path,
            \   "action__line": n+1
            \ }
      call add(phrase_list, phrase)
    endif
  endfor
  return phrase_list
endfunction

function! unite#sources#phrase#define() "{{{
  return s:unite_source
endfunction "}}}
