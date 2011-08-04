call unite#util#set_default('g:phrase_author', $USER)

if !exists('g:phrase_author_priority')
  let g:phrase_author_priority = {}
  let g:phrase_author_priority[g:phrase_author] = 0
endif

let s:phrase_anchor = " Phrase:"
let s:phrase_default_priority = 100
let s:unite_source = {
            \ "name": "phrase",
            \ "filters": ['converter_default', 'matcher_default', 'sorter_phrase' ],
            \ "description": 'phrase',
            \ "hooks": {},
            \ }

function! s:unite_source.hooks.on_init(args, context) "{{{
  let a:context.source__filetype =  exists('b:phrase_filetype') && !empty('b:phrase_filetype')
        \ ? b:phrase_filetype
        \ : &ft
endfunction"}}}

function! s:unite_source.gather_candidates(args, context)
  if empty(a:context.source__filetype)
    return []
  endif
  call unite#print_message("[phrase]: " . a:context.source__filetype)

  " [ author , path ]
  let phrase_list = map(split(globpath(&runtimepath, 'phrase/*/'. g:Phrase.filename(a:context.source__filetype)), '\n'),
        \'[ fnamemodify(v:val, ":h:t"), fnamemodify(v:val, ":p")]')

  let phrase_candidate = []
  " remove
  for [ author, phrase_file ] in phrase_list
    let priority = get(g:phrase_author_priority, author, s:phrase_default_priority)
    let phrase_candidate += s:prepare_candidate(phrase_file, author, priority)
  endfor
  return phrase_candidate
endfunction

function! s:prepare_candidate(phrase_file, author, priority)
  
  let candidate = []
  for [lnum, text] in filter(map(readfile(a:phrase_file), '[v:key + 1, v:val]'),
        \ 'v:val[1] =~# s:phrase_anchor')
    let phrase = {
          \   "word": "[".a:author."] ". g:Phrase.strip_comment(text, &ft),
          \   "source": "phrase",
          \   "kind": "jump_list",
          \   "source__phrase_priority": a:priority,
          \   "action__path": a:phrase_file,
          \   "action__line": lnum,
          \ }
    call add(candidate, phrase)
  endfor
  return candidate
endfor
endfunction

function! unite#sources#phrase#define() "{{{
  return s:unite_source
endfunction "}}}
