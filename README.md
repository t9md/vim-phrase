What is this?
==================================
phrase.vim is utility for

  * gather userful phrase to consolidated file
  * recall by viewing useful phrase

I mainly use this plugin for gather useful phrase for several programming languages.
And intending to share several programming idiom with co-worker.

Try
================================

Create phrase directory.
Copy phrase example file to that directory.

      $ mkdir $HOME/.vim/phrase/$USER
      $ copy phrase_example/* $HOME/.vim/phrase/$USER

Show phrase then enter to jump to that title

      :Phraselist vim

Visually select text in buffer then create phrase from that text.

      :'<,'>PhraseCreate<CR>


Share your phrase with others
==============================
SCENARIO
-----------------------
Assume TARO and HANAKO share their phrase each other.

      # TARO's setting
      let g:phrase_author = "taro"

      # HANAKO's setting
      let g:phrase_author = "hanako"

* Taro pushes his phrase directory into git.
* Hanako pushes his phrase directory into git.
* Taro love Ruby and want to learn Python.
* Hanako love Python and want to learn Ruby.
* Taro pull Hanako's Python phrase from git, Hanako pull Taro's Ruby phrase from git,
  helps learning new language more easily.

DROPBOX
------------------------------------------------------------------------------
Shareing phrase folder with Dropbox is another practical use case.

If you dont't want to .swp files be synced every time your collaborator
view your phrase, disable making swap file in among all collaborators.

      au BufNewFile,BufRead */phrase/*/phrase.* setlocal noswapfile

GITHUB
------------------------------------------------------------------------------
Publish your phrase to github helps other.
My proposal about this type of repository name is ..

#### Repository Name:
  phrase-{your id}

#### Layout:
  put your phrases under 'phrase/{your id}/' sub directory.

      phrase-t9md/phrase/t9md
      phrase-t9md/phrase/t9md/phrase.vim
      phrase-t9md/phrase/t9md/phrase.rb

#### Example repository:
  https://t9md@github.com/t9md/phrase-t9md.git

Keymap Example
-----------------------------------------------------------------

        " mapleader default is '\', I use ',' instead.
        let mapleader = ","
        nnoremap <silent> <Leader>pl  :PhraseList<CR>
        nnoremap <silent> <Leader>pe  :PhraseEdit<CR>
        vnoremap <silent> <Leader>pe  :PhraseEdit<CR>
        vnoremap <silent> <Leader>pc  :PhraseCreate<CR>
        vnoremap <silent> <Leader>pl  :<C-u>PhraseList<CR>

        " If you use Unite plugin
        nnoremap <silent> <Space>p  :<C-u>Unite phrase -start-insert<CR>

Usage
-----------------------------------------------------------------

        " show Ruby's phrase list
        :PhaseList ruby

        " show Ruby's phrase list(by specifying extension)
        :PhaseList rb

        " show phrase list of current &filetype
        :PhaseList

        " Edit Ruby's phrase
        :PhaseEdit ruby

        " Edit Perl's phrase(by specifying extension)
        :PhaseEdit pl

        " Edit phrase of current &filetype
        :PhaseEdit

        " Create phrase from selected text(=range)
        :'<,'>PhraseCreate<CR>

Latest Version
----------------------------------
http://github.com/t9md/vim-phrase
