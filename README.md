What is this?
==================================
phrase.vim is utility for

  * gather userful phrase to consolidated file
  * recall by viewing useful phrase

I mainly use this plugin for gather useful phrase for several programming languages.

Setting
================================
*required setting* each phrase file is stored under this directory

    let g:phrase_dir = "$HOME/.vim/phrase"

or try

    let g:phrase_dir = "$HOME/.vim/bundle/phrase_example"

Comment string setting
------------------------------------------------------------------
To change or add comment string for &filetype
set following in .vimrc
This comment string is used to comment out *Phrase:* header

    let g:phrase_commment = {}
    let g:phrase_comment.vim = '"'
    let g:phrase_comment.lua = '--'

Keymap Example
-----------------------------------------------------------------
     " mapleader default is '\', I use ',' instead.
     let mapleader = ","
     nnoremap <silent> <Leader>pl  :PhraseList<CR>
     vnoremap <silent> <Leader>pl  :<C-u>PhraseList<CR>
     nnoremap <silent> <Leader>pe  :PhraseEdit<CR>
     vnoremap <silent> <Leader>pe  :PhraseEdit<CR>
     vnoremap <silent> <Leader>pc  :PhraseCreate<CR>

Usage
-----------------------------------------------------------------
     " list phrase for &filetype then <CR> to jump.
     :PhaseList ruby
     " specifying extention is OK
     :PhaseList rb
     " if you ommit arg, current &filetype's phrase is opend
     :PhaseList

     " Directly edit phrase file by
     :PhaseEdit ruby
     " specifying extention is OK
     :PhaseEdit pl
     " if you ommit arg, current &filetype's phrase is opend
     :PhaseEdit

     " visually select text to create new phrase, then
     :'<,'>PhraseCreate<CR>
