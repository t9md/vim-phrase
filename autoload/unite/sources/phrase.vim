function! s:plog(msg) "{{{1
  call vimproc#system('echo "' . PP(a:msg) . '" >> ~/vim.log')
endfunction

let s:phrase_default_author_priority = 1

let s:unite_source = {
      \ "name": "phrase",
      \ "description": 'phrase',
      \ "hooks": {},
      \ "filters": ['matcher_context', 'sorter_phrase'],
      \ }

function! s:unite_source.hooks.on_init(args, context) "{{{
  let a:context.source__ext      = phrase#get_ext()
  let a:context.source__filetype = &filetype
endfunction"}}}

function! s:unite_source.gather_candidates(args, context)
  if empty(a:context.source__ext)
    return []
  endif
  call unite#print_message("[phrase]: " . a:context.source__ext)

  let index = 0
  let candidates = []
  for phrase in phrase#all(a:context.source__ext, a:context.source__filetype)
    let index += 1
    let priority = get(g:phrase_author_priority,
          \ phrase.author, s:phrase_default_author_priority) * -1000000

    call add(candidates, {
          \   "word": "[". phrase.author. "] ". phrase.subject,
          \   "source": "phrase",
          \   "kind": "jump_list",
          \   "source__phrase_priority": priority + index,
          \   "action__path": phrase.file,
          \   "action__line": phrase.line,
          \ })
  endfor
  return candidates
endfunction

function! unite#sources#phrase#define() "{{{
  return s:unite_source
endfunction "}}}
