call unite#util#set_default('g:phrase_author', $USER)

if !exists('g:phrase_author_priority')
  let g:phrase_author_priority = {}
  let g:phrase_author_priority[g:phrase_author] = 0
endif

let s:phrase_anchor = " Phrase: "
let s:phrase_default_priority = 100
let s:unite_source = {
            \ "name": "phrase",
            \ "filters": ['converter_default', 'matcher_default', 'sorter_phrase' ],
            \ "description": 'phrase',
            \ "hooks": {},
            \ }

function! s:unite_source.hooks.on_init(args, context) "{{{
  let a:context.source__ext = 
        \ !empty(a:args) ? a:args[0] :
        \ exists('b:phrase_ext') && !empty('b:phrase_ext') ? b:phrase_ext  :
        \ phrase#get_ext_from_filetype(&filetype)
endfunction"}}}

function! s:unite_source.gather_candidates(args, context)
  if empty(a:context.source__ext)
    return []
  endif
  call unite#print_message("[phrase]: " . a:context.source__ext)

  " [ author , path ]
  " let phrase_list = map(split(globpath(&runtimepath, 'phrase/*/phrase.'. a:context.source__ext), '\n'),
        " \'[ fnamemodify(v:val, ":h:t"), fnamemodify(v:val, ":p")]')

  let phrase_candidate = []
  for phrase in phrase#get_all(a:context.source__ext)
    let priority = get(g:phrase_author_priority, phrase.author, s:phrase_default_priority)
    let c = {
          \   "word": "[". phrase.author. "] ". phrase.title,
          \   "source": "phrase",
          \   "kind": "jump_list",
          \   "source__phrase_priority": priority,
          \   "action__path": phrase.file,
          \   "action__line": phrase.line
          \ }
    call add(phrase_candidate, c)
  endfor
  return phrase_candidate
endfunction

" function! s:prepare_candidate(phrase_file, author, priority)
  " let candidate = []
  " for phrase in phrase#get()
    " let c = {
          " \   "word": "[". phrase.author. "] ". phrase.title,
          " \   "source": "phrase",
          " \   "kind": "jump_list",
          " \   "source__phrase_priority": a:priority,
          " \   "action__path": phrase.file,
          " \   "action__line": phrase.line
          " \ }
    " call add(candidate, c)
  " endfor
  " return candidate
" endfunction

function! unite#sources#phrase#define() "{{{
  return s:unite_source
endfunction "}}}
