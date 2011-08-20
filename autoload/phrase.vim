let s:phrase_anchor = " Phrase: "
let s:phrase_header_width = 70
let s:phrase_separator = repeat('=', s:phrase_header_width)
let s:phrase_list_buffer = '[ phrase list ]'
let s:phrase_list_buffer_nr = -1

" FT_DATA: {{{
" FORMAT:
" filetype | extension  | comment_left | comment_right
let s:ft_data = [
      \ 'aap               aap            #                    ',
      \ 'abc               abc            %                    ',
      \ 'acedb             acedb          //                   ',
      \ 'actionscript      as             //                   ',
      \ 'ada               ada            --                   ',
      \ 'ahdl              ahdl           --                   ',
      \ 'ahk               ahk            ;                    ',
      \ 'amiga             amiga          ;                    ',
      \ 'aml               aml            /*                   ',
      \ 'ampl              ampl           #                    ',
      \ 'apache            apache         #                    ',
      \ 'applescript       applescript    --                   ',
      \ 'asm               asm            ;                    ',
      \ 'awk               awk            #                    ',
      \ 'basic             basic          ''                   ', 
      \ 'bbx               bbx            %                    ',
      \ 'bc                bc             #                    ',
      \ 'bib               bib            %                    ',
      \ 'bindzone          bindzone       ;                    ',
      \ 'bst               bst            %                    ',
      \ 'btm               btm            ::                   ',
      \ 'c                 c              /*         */        ',
      \ 'calibre           calibre        //                   ',
      \ 'caos              caos           *                    ',
      \ 'catalog           catalog        --         --        ',
      \ 'cfg               cfg            #                    ',
      \ 'cg                cg             //                   ',
      \ 'ch                ch             //                   ',
      \ 'cl                cl             #                    ',
      \ 'clean             clean          //                   ',
      \ 'clipper           clipper        //                   ',
      \ 'clojure           clojure        ;                    ',
      \ 'cmake             cmake          #                    ',
      \ 'conkyrc           conkyrc        #                    ',
      \ 'cpp               cpp            //                   ',
      \ 'crontab           crontab        #                    ',
      \ 'cs                cs             //                   ',
      \ 'csp               csp            --                   ',
      \ 'cterm             cterm          *                    ',
      \ 'cucumber          cucumber       #                    ',
      \ 'cvs               cvs            CVS:                 ',
      \ 'd                 d              //                   ',
      \ 'dakota            dakota         #                    ',
      \ 'dcl               dcl            $!                   ',
      \ 'debcontrol        debcontrol     #                    ',
      \ 'debsources        debsources     #                    ',
      \ 'def               def            ;                    ',
      \ 'desktop           desktop        #                    ',
      \ 'dhcpd             dhcpd          #                    ',
      \ 'diff              diff           #                    ',
      \ 'django            django         <!--       -->       ',
      \ 'dns               dns            ;                    ',
      \ 'docbk             docbk          <!--       -->       ',
      \ 'dosbatch          dosbatch       REM                  ',
      \ 'dosini            dosini         ;                    ',
      \ 'dot               dot            //                   ',
      \ 'dracula           dracula        ;                    ',
      \ 'dsl               dsl            ;                    ',
      \ 'dylan             dylan          //                   ',
      \ 'ebuild            ebuild         #                    ',
      \ 'ecd               ecd            #                    ',
      \ 'eclass            eclass         #                    ',
      \ 'eiffel            eiffel         --                   ',
      \ 'elf               elf            ''                   ',
      \ 'elmfilt           elmfilt        #                    ',
      \ 'erlang            erlang         %                    ',
      \ 'eruby             erb            <%#        %>        ',
      \ 'expect            expect         #                    ',
      \ 'exports           exports        #                    ',
      \ 'factor            factor         !                    ',
      \ 'fgl               fgl            #                    ',
      \ 'focexec           focexec        -*                   ',
      \ 'form              form           *                    ',
      \ 'foxpro            foxpro         *                    ',
      \ 'fstab             fstab          #                    ',
      \ 'fvwm              fvwm           #                    ',
      \ 'fx                fx             //                   ',
      \ 'gams              gams           *                    ',
      \ 'gdb               gdb            #                    ',
      \ 'gdmo              gdmo           --                   ',
      \ 'genshi            genshi         <!--       -->       ',
      \ 'gitcommit         gitcommit      #                    ',
      \ 'gitconfig         gitconfig      ;                    ',
      \ 'gitrebase         gitrebase      #                    ',
      \ 'gnuplot           gnuplot        #                    ',
      \ 'groovy            groovy         //                   ',
      \ 'gsp               gsp            <%--       --%>      ',
      \ 'gtkrc             gtkrc          #                    ',
      \ 'h                 h              //                   ',
      \ 'haml              haml           -#                   ',
      \ 'haskell           hs             {-         -}        ',
      \ 'hb                hb             #                    ',
      \ 'hercules          hercules       //                   ',
      \ 'hog               hog            #                    ',
      \ 'hostsaccess       hostsaccess    #                    ',
      \ 'htmlcheetah       htmlcheetah    ##                   ',
      \ 'htmldjango        htmldjango     <!--       -->       ',
      \ 'htmlos            htmlos         #          /#        ',
      \ 'ia64              ia64           #                    ',
      \ 'icon              icon           #                    ',
      \ 'idl               idl            //                   ',
      \ 'idlang            idlang         ;                    ',
      \ 'inform            inform         !                    ',
      \ 'inittab           inittab        #                    ',
      \ 'ishd              ishd           //                   ',
      \ 'iss               iss            ;                    ',
      \ 'ist               ist            %                    ',
      \ 'java              java           //                   ',
      \ 'javacc            javacc         //                   ',
      \ 'javascript        js             //                   ',
      \ 'jess              jess           ;                    ',
      \ 'jgraph            jgraph         (*         *)        ',
      \ 'jproperties       jproperties    #                    ',
      \ 'jsp               jsp            <%--       --%>      ',
      \ 'kix               kix            ;                    ',
      \ 'kscript           kscript        //                   ',
      \ 'lace              lace           --                   ',
      \ 'ldif              ldif           #                    ',
      \ 'less              less           /*         */        ',
      \ 'lilo              lilo           #                    ',
      \ 'lilypond          lilypond       %                    ',
      \ 'lisp              lisp           ;                    ',
      \ 'llvm              llvm           ;                    ',
      \ 'lotos             lotos          (*         *)        ',
      \ 'lout              lout           #                    ',
      \ 'lprolog           lprolog        %                    ',
      \ 'lscript           lscript        ''                   ',
      \ 'lss               lss            #                    ',
      \ 'lua               lua            --                   ',
      \ 'lynx              lynx           #                    ',
      \ 'lytex             lytex          %                    ',
      \ 'mail              mail           >                    ',
      \ 'mako              mako           ##                   ',
      \ 'man               man            ."                   ',
      \ 'map               map            %                    ',
      \ 'maple             maple          #                    ',
      \ 'markdown          markdown       <!--       -->       ',
      \ 'masm              masm           ;                    ',
      \ 'master            master         $                    ',
      \ 'mason             mason          <% #       %>        ',
      \ 'matlab            matlab         %                    ',
      \ 'mel               mel            //                   ',
      \ 'mib               mib            --                   ',
      \ 'mkd               mkd            >                    ',
      \ 'mma               mma            (*         *)        ',
      \ 'model             model          $          $         ',
      \ 'moduala.          moduala.       (*         *)        ',
      \ 'modula2           modula2        (*         *)        ',
      \ 'modula3           modula3        (*         *)        ',
      \ 'monk              monk           ;                    ',
      \ 'mush              mush           #                    ',
      \ 'named             named          //                   ',
      \ 'nasm              nasm           ;                    ',
      \ 'nastran           nastran        $                    ',
      \ 'natural           natural        /*                   ',
      \ 'ncf               ncf            ;                    ',
      \ 'newlisp           newlisp        ;                    ',
      \ 'nroff             nroff          \"                   ',
      \ 'nsis              nsis           #                    ',
      \ 'ntp               ntp            #                    ',
      \ 'objc              objc           //                   ',
      \ 'objcpp            objcpp         //                   ',
      \ 'objj              objj           //                   ',
      \ 'ocaml             ocaml          (*         *)        ',
      \ 'occam             occam          --                   ',
      \ 'omlet             omlet          (*         *)        ',
      \ 'omnimark          omnimark       ;                    ',
      \ 'ooc               ooc            //                   ',
      \ 'openroad          openroad       //                   ',
      \ 'opl               opl            REM                  ',
      \ 'ora               ora            #                    ',
      \ 'ox                ox             //                   ',
      \ 'pascal            pascal         {          }         ',
      \ 'patran            patran         $                    ',
      \ 'pcap              pcap           #                    ',
      \ 'pccts             pccts          //                   ',
      \ 'pdf               pdf            %                    ',
      \ 'pfmain            pfmain         //                   ',
      \ 'php               php            //                   ',
      \ 'pic               pic            ;                    ',
      \ 'pike              pike           //                   ',
      \ 'pilrc             pilrc          //                   ',
      \ 'pine              pine           #                    ',
      \ 'plm               plm            //                   ',
      \ 'plsql             plsql          --                   ',
      \ 'po                po             #                    ',
      \ 'postscr           postscr        %                    ',
      \ 'pov               pov            //                   ',
      \ 'povini            povini         ;                    ',
      \ 'ppd               ppd            %                    ',
      \ 'ppwiz             ppwiz          ;;                   ',
      \ 'processing        processing     //                   ',
      \ 'prolog            prolog         %                    ',
      \ 'ps1               ps1            #                    ',
      \ 'psf               psf            #                    ',
      \ 'ptcap             ptcap          #                    ',
      \ 'python            py             #                    ',
      \ 'perl              pl             #                    ',
      \ 'puppet            pp             #                    ',
      \ 'r                 r              #                    ',
      \ 'radiance          radiance       #                    ',
      \ 'ratpoison         ratpoison      #                    ',
      \ 'rc                rc             //                   ',
      \ 'rebol             rebol          ;                    ',
      \ 'registry          registry       ;                    ',
      \ 'remind            remind         #                    ',
      \ 'resolv            resolv         #                    ',
      \ 'rgb               rgb            !                    ',
      \ 'rib               rib            #                    ',
      \ 'robots            robots         #                    ',
      \ 'ruby              rb             #                    ',
      \ 'sa                sa             --                   ',
      \ 'samba             samba          ;                    ',
      \ 'sass              sass           //                   ',
      \ 'sather            sather         --                   ',
      \ 'scala             scala          //                   ',
      \ 'scheme            scheme         ;                    ',
      \ 'scilab            scilab         //                   ',
      \ 'scsh              scsh           ;                    ',
      \ 'scss              scss           /*         */        ',
      \ 'css               css            /*         */        ',
      \ 'sed               sed            #                    ',
      \ 'sgmldecl          sgmldecl       --         --        ',
      \ 'sgmllnx           sgmllnx        <!--       -->       ',
      \ 'sicad             sicad          *                    ',
      \ 'simula            simula         %                    ',
      \ 'sinda             sinda          $                    ',
      \ 'skill             skill          ;                    ',
      \ 'slang             slang          %                    ',
      \ 'slice             slice          //                   ',
      \ 'slrnrc            slrnrc         %                    ',
      \ 'sm                sm             #                    ',
      \ 'smarty            smarty         {*         *}        ',
      \ 'smil              smil           <!         >         ',
      \ 'smith             smith          ;                    ',
      \ 'sml               sml            (*         *)        ',
      \ 'snnsnet           snnsnet        #                    ',
      \ 'snnspat           snnspat        #                    ',
      \ 'snnsres           snnsres        #                    ',
      \ 'snobol4           snobol4        *                    ',
      \ 'spec              spec           #                    ',
      \ 'specman           specman        //                   ',
      \ 'spectre           spectre        //                   ',
      \ 'spice             spice          $                    ',
      \ 'sql               sql            --                   ',
      \ 'sqlforms          sqlforms       --                   ',
      \ 'sqlj              sqlj           --                   ',
      \ 'sqr               sqr            !                    ',
      \ 'squid             squid          #                    ',
      \ 'st                st             "                    ',
      \ 'stp               stp            --                   ',
      \ 'systemverilog     systemverilog  //                  ',
      \ 'tads              tads           //                   ',
      \ 'tags              tags           ;                    ',
      \ 'tak               tak            $                    ',
      \ 'tasm              tasm           ;                    ',
      \ 'tcl               tcl            #                    ',
      \ 'texinfo           texinfo        @c                   ',
      \ 'texmf             texmf          %                    ',
      \ 'tf                tf             ;                    ',
      \ 'tidy              tidy           #                    ',
      \ 'tli               tli            #                    ',
      \ 'tmux              tmux           #                    ',
      \ 'trasys            trasys         $                    ',
      \ 'tsalt             tsalt          //                   ',
      \ 'tsscl             tsscl          #                    ',
      \ 'txt2tags          txt2tags       %                    ',
      \ 'uc                uc             //                   ',
      \ 'uil               uil            !                    ',
      \ 'vb                vb             ''                   ',
      \ 'velocity          velocity       ##                   ',
      \ 'vera              vera           /*         */        ',
      \ 'verilog           verilog        //                   ',
      \ 'vgrindefs         vgrindefs      #                    ',
      \ 'vhdl              vhdl           --                   ',
      \ 'vimperator        vimperator     "                    ',
      \ 'vim               vim            "                    ',
      \ 'virata            virata         %                    ',
      \ 'vrml              vrml           #                    ',
      \ 'vsejcl            vsejcl         /*                   ',
      \ 'webmacro          webmacro       ##                   ',
      \ 'wget              wget           #                    ',
      \ 'winbatch          winbatch       ;                    ',
      \ 'wml               wml            #                    ',
      \ 'wvdial            wvdial         ;                    ',
      \ 'xdefaults         xdefaults      !                    ',
      \ 'xkb               xkb            //                   ',
      \ 'xmath             xmath          #                    ',
      \ 'xpm2              xpm2           !                    ',
      \ 'xquery            xquery         (:         :)        ',
      \ 'z8a               z8a            ;                    '
      \ ]
"}}}

" FT_INFO: {{{
"==================================================================
let s:ft_info = {}
function! s:ft_info.init() "{{{
  let tbl = {}
  for ent in s:ft_data
    let [ft, ext; cmt] =  split(ent,'  \+') " separate with *two* or more space
    let tbl[ft] = { 'ext': ext, 'cmt': cmt }
  endfor
  let self._table = extend(tbl, g:phrase_ft_tbl, "force")
endfunction "}}}

function! s:ft_info.get(ft)
  let val = get(self._table, a:ft, {"ext": a:ft , "cmt": ["#"] })
  return val
endfunction
" }}}

" Utility: {{{
"==================================================================
function! s:commentify(ft, string, is_subject) "{{{
  let cmt = copy(s:ft_info.get(a:ft).cmt)
  if a:is_subject
    let string = len(cmt) == 1 ? a:string : a:string . " "
    let string = string . repeat(" ", s:phrase_header_width - len(string))
  else
    let string = a:string
  endif
  return join(insert(cmt, string, 1), "")
endfunction "}}}

let s:metachar = '.*\()[]{}%@$<>'
function! s:extract_title(string, ft) "{{{
  let cmt = s:ft_info.get(a:ft).cmt
  let cmt_l = escape(get(cmt, 0), s:metachar)
  let cmt_r = escape(get(cmt, 1, ""), s:metachar)
  let pattern = '\v^'. cmt_l .'\s+Phrase:\s+\zs.*\ze\s*'. cmt_r . '$'
  " let pattern = '.*'
  return s:strip(matchstr(a:string, pattern))
endfunction "}}}

function! s:list_with_index(list) "{{{
  return map(a:list,'[v:key, v:val]')
endfunction "}}}

function! s:strip(str) "{{{
  return matchstr(a:str, '^\s*\zs.\{-}\ze\s*$')
endfunction "}}}

function! s:ensure_phrase_dir() "{{{
  if isdirectory(g:phrase_dir)
    return
  endif

  let answer = input("create " . g:phrase_dir . "?[y/n] ")
  if answer == 'y'
    call mkdir(g:phrase_dir, 'p')
  endif
endfunction "}}}

function! s:edit(path) "{{{
  let winno = bufwinnr(a:path)
  if winno != -1
    execute winno . ':wincmd w'
  else
    let opt = winwidth(0) * 2 < winheight(0) * 5 ? "" : "vertical"
    exe "belowright " . opt . " split " . a:path
  endif
endfunction "}}}

function! s:open_listwin() "{{{
  let winno = bufwinnr(s:phrase_list_buffer_nr)
  if winno != -1 " found!
    execute winno."wincmd w"
  else
    let opt = winwidth(0) * 2 < winheight(0) * 5 ? "" : "vertical"
    exe "belowright " . opt . " split"
    silent edit `=s:phrase_list_buffer`
    nnoremap <buffer> q <C-w>c
    setlocal bufhidden=hide buftype=nofile noswapfile nobuflisted
    let s:phrase_list_buffer_nr = bufnr('%')
  endif
endfunction "}}}
" }}}

" INIT: {{{
call s:ft_info.init()
call s:ensure_phrase_dir()
" }}}

" TEST: {{{
let s:dev_mode = 0
function! s:test(ft, str) "{{{
  echo "ft   : " . a:ft
  echo "ext  : " . s:ft_info.get(a:ft).ext
  let cmted = s:commentify(a:ft, " Phrase: " .a:str, 1)
  echo "cmted: " . cmted
  let title = s:extract_title(cmted, a:ft)
  echo "title: " . title
  echo "origi: " . a:str
  let result = a:str == title
  echo "result: " . result
  echo ""
endfunction "}}}
function! s:run_test() "{{{
  let str = "ABCDEFG"
  let ft = ''
  call s:test(ft, str)
  for ft in keys(s:ft_info._table)
    call s:test(ft, str)
  endfor
endfunction "}}}
" let s:dev_mode = 1
if s:dev_mode == 1
  call s:run_test()
  finish
endif
"}}}

" Public API: {{{
"==================================================================
function! phrase#get_ext_from_filetype(filetype) "{{{
  return s:ft_info.get(a:filetype).ext
endfunction "}}}

function! phrase#create(...) "{{{
  let ext = a:0 > 0 ? a:1 : s:get_ext()
  if empty(ext)
    return
  endif
  let  phrase = s:prepare_phrase("Phrase[ " . ext . " ]")
  call s:edit(s:phrase_path(ext))
  call append(0, [phrase.subject, phrase.separator] + phrase.body + [""])
  execute "normal! 3ggV".(len(phrase.body)-1)."jo"
endfunction "}}}

function! phrase#edit(...) "{{{
  let ext = a:0 > 0 ? a:1 : s:get_ext()
  call s:edit(s:phrase_path(ext))
endfunction "}}}

function! s:phrase_path(ext) "{{{
  return simplify(g:phrase_dir ."/phrase.". a:ext)
endfunction "}}}

function! phrase#list(...) "{{{
  call s:ensure_phrase_dir()
  let author = g:phrase_author

  let ext = a:0 > 0 ? a:1 : ""
  let ext =
        \ !empty(ext) ? ext :
        \ exists('b:phrase_ext') && !empty('b:phrase_ext') ? b:phrase_ext :
        \ s:ft_info.get(&filetype).ext
  let fname = "phrase." . ext

  let phrase_path = simplify(expand(g:phrase_dir ."/".fname))

  let phrase_list = phrase#parse(phrase_path)
  let phrase_titles = map(deepcopy(phrase_list), 'v:val.title')

  call s:open_listwin()
  silent normal! gg"_dG
  call append(0, phrase_titles)
  silent normal! gg
  let b:phrase_list = phrase_list
  let b:phrase_path = phrase_path
  nnoremap <buffer> <CR> :<C-u>call <SID>jump_to_title(b:phrase_path, b:phrase_list, getline('.'))<CR>
endfunction "}}}

function! s:jump_to_title(phrase_path, phrase_list, title) "{{{
  let line = -1
  for phrase in a:phrase_list
    if phrase.title == a:title
      let line = phrase.line
      break 
    endif
  endfor
  if line != -1
    call s:edit(a:phrase_path)
    execute "normal! ".  line . "gg"
  endif
endfunction "}}}

function! phrase#files(ext) "{{{
  return split(globpath(&runtimepath, 'phrase/*/'. 'phrase.'.a:ext),'\n')
endfunction "}}}

function! phrase#get_all(ext)"{{{
  let result = []
  for phrase_file in phrase#files(a:ext)
    call extend(result, phrase#parse(phrase_file))
  endfor
  return result
endfunction"}}}

function! s:get_ext() "{{{
  let ext = 
        \ exists('b:phrase_ext') ? b:phrase_ext :
        \ s:ft_info.get(&ft).ext
  return ext
endfunction "}}}

function! s:prepare_phrase(prompt) "{{{
    let title = inputdialog( a:prompt, "", -1 )
    if title == -1
      return ""
    endif
    return {
          \ "subject": s:commentify(&ft, " Phrase: " . title, 1),
          \ "separator": s:commentify(&ft, s:phrase_separator, 0),
          \ "body": getline(line("'<"), line("'>"))
          \ }
endfunction "}}}

function! phrase#parse(file) "{{{
  let phrase_list = []
  let author = fnamemodify(a:file, ":h:t")

  let lines = readfile(a:file)
  for [idx, line] in s:list_with_index(lines)
    if line =~# s:phrase_anchor
      let phrase = {
            \ 'author': author,
            \ 'title': s:extract_title(line, &ft),
            \ 'file': a:file,
            \ 'line': idx + 1,
            \ }
      call add(phrase_list, phrase)
    endif
  endfor
  return phrase_list
endfunction "}}}
" }}}

" vim: foldmethod=marker
