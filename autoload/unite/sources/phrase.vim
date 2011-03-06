let s:unite_source = {}
let s:unite_source.name = 'phrase'
let s:phrase_anchor = " Phrase:"
function! s:unite_source.gather_candidates(args, context)
  if empty(&ft)
    return []
  endif
  " [ author , path ]
  let phrase_list = map(split(globpath(&runtimepath, 'phrase/*/'. g:Phrase.phrase_filename(&ft)), '\n'),
        \'[ fnamemodify(v:val, ":h:t"), fnamemodify(v:val, ":p")]')

  let phrase_candidate = []
  " remove
  for [ author, phrase_file ] in phrase_list
    let phrase_candidate += s:prepare_candidate(author, phrase_file)
  endfor
  return phrase_candidate
endfunction


function! s:prepare_candidate(author, phrase_file)
  let candidate = []
  let lines = readfile(a:phrase_file)
  for n in range(len(lines))
    let str = lines[n]
    if str =~# s:phrase_anchor
      let phrase = {
            \   "word": "[".a:author."] ". substitute(str,'\(.* Phrase: \)','',''),
            \   "source": "phrase",
            \   "kind": "jump_list",
            \   "action__path": a:phrase_file,
            \   "action__line": n+1
            \ }
      call add(candidate, phrase)
    endif
  endfor
  return candidate
endfor
endfunction

function! unite#sources#phrase#define() "{{{
  return s:unite_source
endfunction "}}}
