"=============================================================================
" File: phrase.vim
" Author: t9md <taqumd@gmail.com>
" Version: 0.1.2
" WebPage: http://github.com/t9md/vim-phrase
" License: BSD
" Version: 0.2

" GUARD: {{{
"============================================================

" if exists('g:loaded_phrase')
  " finish
" endif

let g:loaded_phrase = 1
let s:old_cpo = &cpo
set cpo&vim
" }}}

let s:ft_tbl = {}
let s:separator = repeat('=', 70)
let s:phrase_list_buffer = '[ phrase list ]'
let s:phrase_list_buffer_nr = -1

function! s:set_var(varname, default) "{{{
    if !exists(a:varname)
        let {a:varname} = a:default
    endif
endfunction "}}}

function! s:init() "{{{
    call s:set_var('g:phrase_author', "$USER")
    call s:set_var('g:phrase_basedir', split(&rtp,',')[0] . "/" . "phrase")
    call s:set_var('g:phrase_ft_tbl', {})
    call s:set_var('g:phrase_dir', expand(g:phrase_basedir . '/'. g:phrase_author))
endfunction "}}}

" filetype data {{{
"
" FORMAT:
" filetype | extension  | comment_left | comment_right
let s:ft_data = [
      \ ' aap               aap         #                    ',
      \ ' abc               abc         %                    ',
      \ ' acedb             acedb       //                   ',
      \ ' actionscript      as          //                   ',
      \ ' ada               ada         --                   ',
      \ ' ahdl              ahdl        --                   ',
      \ ' ahk               ahk         ;                    ',
      \ ' amiga             amiga       ;                    ',
      \ ' aml               aml         /*                   ',
      \ ' ampl              ampl        #                    ',
      \ ' apache            apache      #                    ',
      \ ' applescript       applescript --                   ',
      \ ' asm               asm         ;                    ',
      \ ' awk               awk         #                    ',
      \ ' basic             basic       ''                   ', 
      \ ' bbx               bbx         %                    ',
      \ ' bc                bc          #                    ',
      \ ' bib               bib         %                    ',
      \ ' bindzone          bindzone    ;                    ',
      \ ' bst               bst         %                    ',
      \ ' btm               btm         ::                   ',
      \ ' c                 c           /*         */        ',
      \ ' calibre           calibre     //                   ',
      \ ' caos              caos        *                    ',
      \ ' catalog           catalog     --         --        ',
      \ ' cfg               cfg         #                    ',
      \ ' cg                cg          //                   ',
      \ ' ch                ch          //                   ',
      \ ' cl                cl          #                    ',
      \ ' clean             clean       //                   ',
      \ ' clipper           clipper     //                   ',
      \ ' clojure           clojure     ;                    ',
      \ ' cmake             cmake       #                    ',
      \ ' conkyrc           conkyrc     #                    ',
      \ ' cpp               cpp         //                   ',
      \ ' crontab           crontab     #                    ',
      \ ' cs                cs          //                   ',
      \ ' csp               csp         --                   ',
      \ ' cterm             cterm       *                    ',
      \ ' cucumber          cucumber    #                    ',
      \ ' cvs               cvs         CVS:                 ',
      \ ' d                 d           //                   ',
      \ ' dakota            dakota      #                    ',
      \ ' dcl               dcl         $!                   ',
      \ ' debcontrol        debcontrol  #                    ',
      \ ' debsources        debsources  #                    ',
      \ ' def               def         ;                    ',
      \ ' desktop           desktop     #                    ',
      \ ' dhcpd             dhcpd       #                    ',
      \ ' diff              diff        #                    ',
      \ ' django            django      <!--       -->       ',
      \ ' dns               dns         ;                    ',
      \ ' docbk             docbk       <!--       -->       ',
      \ ' dosbatch          dosbatch    REM                  ',
      \ ' dosini            dosini      ;                    ',
      \ ' dot               dot         //                   ',
      \ ' dracula           dracula     ;                    ',
      \ ' dsl               dsl         ;                    ',
      \ ' dylan             dylan       //                   ',
      \ ' ebuild            ebuild      #                    ',
      \ ' ecd               ecd         #                    ',
      \ ' eclass            eclass      #                    ',
      \ ' eiffel            eiffel      --                   ',
      \ ' elf               elf         ''                   ',
      \ ' elmfilt           elmfilt     #                    ',
      \ ' erlang            erlang      %                    ',
      \ ' eruby             erb         <%#        %>        ',
      \ ' expect            expect      #                    ',
      \ ' exports           exports     #                    ',
      \ ' factor            factor      !                    ',
      \ ' fgl               fgl         #                    ',
      \ ' focexec           focexec     -*                   ',
      \ ' form              form        *                    ',
      \ ' foxpro            foxpro      *                    ',
      \ ' fstab             fstab       #                    ',
      \ ' fvwm              fvwm        #                    ',
      \ ' fx                fx          //                   ',
      \ ' gams              gams        *                    ',
      \ ' gdb               gdb         #                    ',
      \ ' gdmo              gdmo        --                   ',
      \ ' genshi            genshi      <!--       -->       ',
      \ ' gitcommit         gitcommit   #                    ',
      \ ' gitconfig         gitconfig   ;                    ',
      \ ' gitrebase         gitrebase   #                    ',
      \ ' gnuplot           gnuplot     #                    ',
      \ ' groovy            groovy      //                   ',
      \ ' gsp               gsp         <%--       --%>      ',
      \ ' gtkrc             gtkrc       #                    ',
      \ ' h                 h           //                   ',
      \ ' haml              haml        -#                   ',
      \ ' haskell           hs          {-         -}        ',
      \ ' hb                hb          #                    ',
      \ ' hercules          hercules    //                   ',
      \ ' hog               hog         #                    ',
      \ ' hostsaccess       hostsaccess #                    ',
      \ ' htmlcheetah       htmlcheetah ##                   ',
      \ ' htmldjango        htmldjango  <!--       -->       ',
      \ ' htmlos            htmlos      #          /#        ',
      \ ' ia64              ia64        #                    ',
      \ ' icon              icon        #                    ',
      \ ' idl               idl         //                   ',
      \ ' idlang            idlang      ;                    ',
      \ ' inform            inform      !                    ',
      \ ' inittab           inittab     #                    ',
      \ ' ishd              ishd        //                   ',
      \ ' iss               iss         ;                    ',
      \ ' ist               ist         %                    ',
      \ ' java              java        //                   ',
      \ ' javacc            javacc      //                   ',
      \ ' javascript        js          //                   ',
      \ ' jess              jess        ;                    ',
      \ ' jgraph            jgraph      (*         *)        ',
      \ ' jproperties       jproperties #                    ',
      \ ' jsp               jsp         <%--       --%>      ',
      \ ' kix               kix         ;                    ',
      \ ' kscript           kscript     //                   ',
      \ ' lace              lace        --                   ',
      \ ' ldif              ldif        #                    ',
      \ ' less              less        /*         */        ',
      \ ' lilo              lilo        #                    ',
      \ ' lilypond          lilypond    %                    ',
      \ ' lisp              lisp        ;                    ',
      \ ' llvm              llvm        ;                    ',
      \ ' lotos             lotos       (*         *)        ',
      \ ' lout              lout        #                    ',
      \ ' lprolog           lprolog     %                    ',
      \ ' lscript           lscript     ''                   ',
      \ ' lss               lss         #                    ',
      \ ' lua               lua         --                   ',
      \ ' lynx              lynx        #                    ',
      \ ' lytex             lytex       %                    ',
      \ ' mail              mail        >                    ',
      \ ' mako              mako        ##                   ',
      \ ' man               man         ."                   ',
      \ ' map               map         %                    ',
      \ ' maple             maple       #                    ',
      \ ' markdown          markdown    <!--       -->       ',
      \ ' masm              masm        ;                    ',
      \ ' mason             mason       <% #       %>        ',
      \ ' master            master      $                    ',
      \ ' matlab            matlab      %                    ',
      \ ' mel               mel         //                   ',
      \ ' mib               mib         --                   ',
      \ ' mkd               mkd         >                    ',
      \ ' mma               mma         (*         *)        ',
      \ ' model             model       $          $         ',
      \ ' moduala.          moduala.    (*         *)        ',
      \ ' modula2           modula2     (*         *)        ',
      \ ' modula3           modula3     (*         *)        ',
      \ ' monk              monk        ;                    ',
      \ ' mush              mush        #                    ',
      \ ' named             named       //                   ',
      \ ' nasm              nasm        ;                    ',
      \ ' nastran           nastran     $                    ',
      \ ' natural           natural     /*                   ',
      \ ' ncf               ncf         ;                    ',
      \ ' newlisp           newlisp     ;                    ',
      \ ' nroff             nroff       \"                   ',
      \ ' nsis              nsis        #                    ',
      \ ' ntp               ntp         #                    ',
      \ ' objc              objc        //                   ',
      \ ' objcpp            objcpp      //                   ',
      \ ' objj              objj        //                   ',
      \ ' ocaml             ocaml       (*         *)        ',
      \ ' occam             occam       --                   ',
      \ ' omlet             omlet       (*         *)        ',
      \ ' omnimark          omnimark    ;                    ',
      \ ' ooc               ooc         //                   ',
      \ ' openroad          openroad    //                   ',
      \ ' opl               opl         REM                  ',
      \ ' ora               ora         #                    ',
      \ ' ox                ox          //                   ',
      \ ' pascal            pascal      {          }         ',
      \ ' patran            patran      $                    ',
      \ ' pcap              pcap        #                    ',
      \ ' pccts             pccts       //                   ',
      \ ' pdf               pdf         %                    ',
      \ ' pfmain            pfmain      //                   ',
      \ ' php               php         //                   ',
      \ ' pic               pic         ;                    ',
      \ ' pike              pike        //                   ',
      \ ' pilrc             pilrc       //                   ',
      \ ' pine              pine        #                    ',
      \ ' plm               plm         //                   ',
      \ ' plsql             plsql       --                   ',
      \ ' po                po          #                    ',
      \ ' postscr           postscr     %                    ',
      \ ' pov               pov         //                   ',
      \ ' povini            povini      ;                    ',
      \ ' ppd               ppd         %                    ',
      \ ' ppwiz             ppwiz       ;;                   ',
      \ ' processing        processing  //                   ',
      \ ' prolog            prolog      %                    ',
      \ ' ps1               ps1         #                    ',
      \ ' psf               psf         #                    ',
      \ ' ptcap             ptcap       #                    ',
      \ ' python            py          #                    ',
      \ ' perl              pl          #                    ',
      \ ' puppet            pp          #                    ',
      \ ' r                 r           #                    ',
      \ ' radiance          radiance    #                    ',
      \ ' ratpoison         ratpoison   #                    ',
      \ ' rc                rc          //                   ',
      \ ' rebol             rebol       ;                    ',
      \ ' registry          registry    ;                    ',
      \ ' remind            remind      #                    ',
      \ ' resolv            resolv      #                    ',
      \ ' rgb               rgb         !                    ',
      \ ' rib               rib         #                    ',
      \ ' robots            robots      #                    ',
      \ ' ruby              rb          #                    ',
      \ ' sa                sa          --                   ',
      \ ' samba             samba       ;                    ',
      \ ' sass              sass        //                   ',
      \ ' sather            sather      --                   ',
      \ ' scala             scala       //                   ',
      \ ' scheme            scheme      ;                    ',
      \ ' scilab            scilab      //                   ',
      \ ' scsh              scsh        ;                    ',
      \ ' scss              scss        /*         */        ',
      \ ' sed               sed         #                    ',
      \ ' sgmldecl          sgmldecl    --         --        ',
      \ ' sgmllnx           sgmllnx     <!--       -->       ',
      \ ' sicad             sicad       *                    ',
      \ ' simula            simula      %                    ',
      \ ' sinda             sinda       $                    ',
      \ ' skill             skill       ;                    ',
      \ ' slang             slang       %                    ',
      \ ' slice             slice       //                   ',
      \ ' slrnrc            slrnrc      %                    ',
      \ ' sm                sm          #                    ',
      \ ' smarty            smarty      {*         *}        ',
      \ ' smil              smil        <!         >         ',
      \ ' smith             smith       ;                    ',
      \ ' sml               sml         (*         *)        ',
      \ ' snnsnet           snnsnet     #                    ',
      \ ' snnspat           snnspat     #                    ',
      \ ' snnsres           snnsres     #                    ',
      \ ' snobol4           snobol4     *                    ',
      \ ' spec              spec        #                    ',
      \ ' specman           specman     //                   ',
      \ ' spectre           spectre     //                   ',
      \ ' spice             spice       $                    ',
      \ ' sql               sql         --                   ',
      \ ' sqlforms          sqlforms    --                   ',
      \ ' sqlj              sqlj        --                   ',
      \ ' sqr               sqr         !                    ',
      \ ' squid             squid       #                    ',
      \ ' st                st          "                    ',
      \ ' stp               stp         --                   ',
      \ ' systemverilog     systemverilo//                   ',
      \ ' tads              tads        //                   ',
      \ ' tags              tags        ;                    ',
      \ ' tak               tak         $                    ',
      \ ' tasm              tasm        ;                    ',
      \ ' tcl               tcl         #                    ',
      \ ' texinfo           texinfo     @c                   ',
      \ ' texmf             texmf       %                    ',
      \ ' tf                tf          ;                    ',
      \ ' tidy              tidy        #                    ',
      \ ' tli               tli         #                    ',
      \ ' tmux              tmux        #                    ',
      \ ' trasys            trasys      $                    ',
      \ ' tsalt             tsalt       //                   ',
      \ ' tsscl             tsscl       #                    ',
      \ ' txt2tags          txt2tags    %                    ',
      \ ' uc                uc          //                   ',
      \ ' uil               uil         !                    ',
      \ ' vb                vb          ''                   ',
      \ ' velocity          velocity    ##                   ',
      \ ' vera              vera        /*         */        ',
      \ ' verilog           verilog     //                   ',
      \ ' vgrindefs         vgrindefs   #                    ',
      \ ' vhdl              vhdl        --                   ',
      \ ' vimperator        vimperator  "                    ',
      \ ' vim               vim         "                    ',
      \ ' virata            virata      %                    ',
      \ ' vrml              vrml        #                    ',
      \ ' vsejcl            vsejcl      /*                   ',
      \ ' webmacro          webmacro    ##                   ',
      \ ' wget              wget        #                    ',
      \ ' winbatch          winbatch    ;                    ',
      \ ' wml               wml         #                    ',
      \ ' wvdial            wvdial      ;                    ',
      \ ' xdefaults         xdefaults   !                    ',
      \ ' xkb               xkb         //                   ',
      \ ' xmath             xmath       #                    ',
      \ ' xpm2              xpm2        !                    ',
      \ ' xquery            xquery      (:         :)        ',
      \ ' z8a               z8a         ;                    '
      \ ]
"}}}

function! s:init_ft_tbl() "{{{
  for ent in s:ft_data
    let [ft, ext; cmt] =  split(ent,'\s\+')
    let s:ft_tbl[ft] = { 'ext': ext, 'cmt': cmt }
  endfor
  call extend(s:ft_tbl, g:phrase_ft_tbl, "force")
endfunction "}}}

function! s:get_ft_tbl(ft) "{{{
    return get(s:ft_tbl, a:ft, {"ext": a:ft , "cmt": ["#"] })
endfunction "}}}

function! s:commentify(ft, str) "{{{
  let cmt = copy(s:get_ft_tbl(a:ft).cmt)
  return join(insert(cmt, a:str, 1), " ")
endfunction "}}}

function! s:strip(str) "{{{
  return substitute(a:str, '^\s*\(.\{-}\)\s*$', '\1', '')
endfunction "}}}

function! s:ext(ft) "{{{
  return s:get_ft_tbl(a:ft).ext
endfunction "}}}

function! s:split(...) "{{{
    let file = a:0 > 0 ? a:1 : ""
    let opt = winwidth(0) * 2 < winheight(0) * 5 ? "" : "vertical"
    exe "belowright " . opt . " split " . file
endfunction "}}}

function! s:open_listwin() "{{{
  let win = bufwinnr(s:phrase_list_buffer_nr)
  if win != -1 " found!
    execute win."wincmd w"
    return
  end

  call s:split()
  if s:phrase_list_buffer_nr == -1
    execute 'edit ' . s:phrase_list_buffer
    nnoremap <buffer> q <C-w>c
    setlocal bufhidden=hide buftype=nofile noswapfile nobuflisted
    let s:phrase_list_buffer_nr = bufnr('%')
  else
    execute 'silent buffer ' . s:phrase_list_buffer_nr
  endif
endfunction "}}}

function! s:refresh_list(file, ft) "{{{
  silent normal! gg"_dG
  let phrase_list = filter(readfile(a:file), 'v:val =~# " Phrase:"')
  call map(phrase_list, 'g:Phrase.strip_comment(v:val, a:ft)')
  call setline(1, phrase_list)

  let b:phrase_ft = a:ft
  syn match PhraseMark '.*Phrase:'
  hi def link PhraseMark Define
  nnoremap <buffer> <CR> :<C-u>call g:Phrase.open(b:phrase_ft)<CR>
endfunction "}}}

function! s:select_bufferwin(bufname) "{{{
  let winno = bufwinnr(a:bufname)
  if winno != -1
    execute winno . ':wincmd w'
  endif
  return winno
endfunction "}}}

function! s:phrase_filetype_for(query) "{{{
  let ft = 
        \ !empty(a:query)
        \ ? a:query
        \ : exists('b:phrase_filetype') && !empty('b:phrase_filetype')
        \ ? b:phrase_filetype
        \ : &ft
  return ft
endfunction "}}}

function! s:set_phrase_filetype(line) "{{{
  let b:phrase_filetype = matchstr(a:line,'phrase: \zs.*')
endfunction "}}}

let g:Phrase = {}
function! g:Phrase.filename(ft) "{{{
	return join([ "phrase", s:ext(a:ft) ], ".")
endfunction "}}}

function! g:Phrase.strip_comment(str, ft) "{{{
  let cmt = s:get_ft_tbl(a:ft).cmt
  let cmt_l = get(cmt, 0)
  let cmt_r = get(cmt, 1, "")
  let str = a:str
  let ptn = '^'. escape(cmt_l, '*') .'\s\+Phrase:\s\+\(.*\)'. escape(cmt_r, '*') . '$'
  return s:strip(substitute(str,ptn,'\1',''))
endfunction "}}}

function! g:Phrase.create() range "{{{
  let ft = s:phrase_filetype_for("")
  let title = inputdialog("Phrase[ " . ft . " ]","", -1)
  if title == -1 | return | endif

  " echohl Function
  " let title = input("Phrase: ")
  " echohl Normal
  " if empty(title)| return | endif

  let selection = getline(a:firstline, a:lastline)
  call g:Phrase.edit(ft)

  let subject   = " Phrase: " . title
  let phrase = map([ subject, s:separator ], 's:commentify(ft, v:val)')
  call append(0, phrase + selection + [""])
  let cmd = "normal! 3ggV".(len(selection)-1)."jo"
  execute cmd
endfunction "}}}

function! g:Phrase.path(ft) "{{{
    return expand(g:phrase_dir ."/" . self.filename(a:ft))
endfunction "}}}

function! g:Phrase.list(...) range "{{{
  let ft = s:phrase_filetype_for(a:1)

  let phrase_file = self.path(ft)
  if !filereadable(phrase_file)
    echohl Type | echo "phrase file not readable" | echohl Normal
    return
  endif
  call s:open_listwin()
  call s:refresh_list(phrase_file, ft)
endfunction "}}}

function! g:Phrase.open(ft) "{{{
  let search = getline('.')
  call g:Phrase.edit(a:ft)
  call search(search)
  normal zt
endfunction "}}}

function! g:Phrase.edit(...) "{{{
  if !isdirectory(g:phrase_dir)
    let answer = input("create " . g:phrase_dir . "?[y/n] ")
    if answer == 'y'
      call mkdir(g:phrase_dir, 'p')
    end
  endif

  let ft = s:phrase_filetype_for(a:1)
  if empty(ft)
      let ft = input("Filetype: ",'')
  endif

  " belowright split
  let phrase_file = self.path(ft)
  let phrase_file = fnamemodify(expand(phrase_file), ':p')
  if s:select_bufferwin(phrase_file) == -1
    call s:split(phrase_file)
  endif
endfunction "}}}

let s:dev_mode = 0
function! s:test(ft, str) "{{{
  echo "ft   : " . a:ft
  echo "ext  : " . s:ext(a:ft)
  echo "cmted: " . s:commentify(a:ft, a:str)
  echo ""
endfunction "}}}
function! s:run_test() "{{{
  let str = "ABCDEFG"
  let ft = 'haskell'   |call s:test(ft, str)
  let ft = 'ruby'      |call s:test(ft, str)
  let ft = 'python'    |call s:test(ft, str)
  let ft = 'lua'       |call s:test(ft, str)
  let ft = 'javascript'|call s:test(ft, str)
  let ft = 'c'         |call s:test(ft, str)
  let ft = 'vim'       |call s:test(ft, str)
  let ft = 'notexist'  |call s:test(ft, str)
  let ft = ''          |call s:test(ft, str)
endfunction "}}}
" let s:dev_mode = 1
if s:dev_mode == 1 "{{{
  call s:run_test()
  finish
endif "}}}

call s:init()
call s:init_ft_tbl()

augroup Phrase
    autocmd!
    autocmd BufReadPost * if getline('$') =~ "phrase: " | call <SID>set_phrase_filetype(getline('$')) | endif
augroup END

" for [key, val ] in items(s:ft_tbl)
    " echo [key, val]
" endfor
" COMMAND: {{{
"=================================================================
command! -nargs=? PhraseList :call g:Phrase.list(<q-args>)
command! -nargs=? PhraseEdit :call g:Phrase.edit(<q-args>)
command! -nargs=0 -range PhraseCreate :<line1>,<line2>call g:Phrase.create()
"}}}
let &cpo = s:old_cpo
" vim: foldmethod=marker
