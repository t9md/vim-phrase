What is this?
==================================
phrase.vim is utility for

  * gather userful phrase to consolidated file
  * recall by viewing useful phrase

I mainly use this plugin for gather useful phrase for several programming languages.
and intending to share several programming idiom with co-worker.

Setting
================================
*required setting* each phrase file is stored under this directory

    let g:phrase_dir = "$HOME/.vim/phrase"

or try

    let g:phrase_dir = "$HOME/.vim/bundle/phrase_example"

If you want to share your phrase with other developers,
 you can do by place your phrase yourname's directory.

Assume TARO and HANAKO share their phrase each other.

    # TARO's setting
    let g:phrase_dir = "$HOME/.vim/phrase/taro"

    # HANAKO's setting
    let g:phrase_dir = "$HOME/.vim/phrase/hanako"

Then TARO push his phrase directtory into git or other VCS.
HANAKO olso push her phrase directtory into git or other VCS.
That's it!.

Shareing phrase folder by Dropbox is also good idea.

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

     " If you use Unite plugin
     nnoremap <silent> <Space>p  :<C-u>Unite phrase -start-insert<CR>

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

TODO
-----------------------------------------------------------------
* Wtite vim help file
* Prepare or find someone who organize peoples public phrases into consolidated repository.
* Enable unite plugin to search for specifying username(phrases owner)

