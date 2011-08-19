" Phrase: Good keymap
"===========================================================
"-----------------------------------------------------------------
" 1. not good
"-----------------------------------------------------------------
nnoremap          tt  <C-]>
nnoremap <silent> tn  :<C-u>tag<CR>
nnoremap <silent> tp  :<C-u>pop<CR>
nnoremap <silent> tl  :<C-u>tags<CR>

"-----------------------------------------------------------------
" 2. good
"-----------------------------------------------------------------

nnoremap          [tag]   <Nop>
nmap              t       [tag]
nnoremap          [tag]t  <C-]>
nnoremap <silent> [tag]n  :<C-u>tag<CR>
nnoremap <silent> [tag]p  :<C-u>pop<CR>
nnoremap <silent> [tag]l  :<C-u>tags<CR>
nnoremap [t    :echo "but you have to wait! til &timeout"<CR>

"-----------------------------------------------------------------
" 3. best
"-----------------------------------------------------------------

nnoremap     <SID>[tag]        <Nop>
nmap              t            <SID>[tag]
nnoremap          <SID>[tag]t  <C-]>
nnoremap <silent> <SID>[tag]n  :<C-u>tag<CR>
nnoremap <silent> <SID>[tag]p  :<C-u>pop<CR>
nnoremap <silent> <SID>[tag]l  :<C-u>tags<CR>
nnoremap [t    :echo "but you have to wait! til &timeout"<CR>

"-----------------------------------------------------------------

" Phrase: rb-appscript
"===========================================================
ruby << ENDRUBY
require 'rubygems'
require 'appscript'
ENDRUBY

fun! ITermWrite(cmd)
  ruby Appscript.app('iTerm').current_terminal.sessions.write(:text => VIM::evaluate('a:cmd'))
endfun

" Phrase: Python Interface
"===========================================================
fun! PyDelLines(start,end)
python << EOF
cb = vim.current.buffer
start = int(vim.eval('a:start'))
end = int(vim.eval('a:end'))
del cb[start:end]
EOF
endfun
nnoremap <buffer> <F6> :call PyTest()<CR>

" Phrase: expand()
"============================================================
echo expand("%")     | "file base name 'hoge.vim'
echo expand("%:p")   | " filename (full path) '/home/hoge/hoge.vim
echo expand("%:p:h") | " dirname  '/home/hoge
echo expand("%:p:t") | "file base name 'hoge.vim
echo expand("%:p:e") | "extention only 'vim
echo expand("%:p:r") | "delete extention '/home/hoge/hoge

" Phrase: OOP Style Array implementation
"============================================================
let s:m = {}
fun! s:m.shift()
	return remove(self.data, 0)
endfun

fun! s:m.unshift(val)
	return insert(self.data, a:val, 0)
endfun

fun! s:m.pop()
	return remove(self.data, -1)
endfun

fun! s:m.push(val)
	return add(self.data, a:val)
endfun

fun! s:m.concat(ary)
	return extend(self.data, a:ary)
endfun

let Array = {}
fun! Array.new(data)
	let obj = {}
	let obj.data = a:data
	call extend(obj, s:m, 'error')
	return obj
endfun

echo "-setup--"
let a = Array.new(range(5))
echo a.data
echo "-shift--"
echo a.shift()
echo a.data
echo "-shift--"
echo a.shift()
echo a.data
echo "-pop--"
echo a.pop()
echo a.data
echo "-unshift--"
call a.unshift(99)
echo a.data
echo "-push--"
call a.push(99)
echo a.data
echo "-push-2-"
call a.push([99])
echo a.data
echo "-concat--"
call a.concat([1,2,3,4])
echo a.data
finish

" Phrase: SaveExcursion
"============================================================
fun! g:SaveExcursion(fun)
let win_saved = winsaveview()
let org_win = winnr()
let org_buf = bufnr('%')

try
  let result = a:fun.call()
finally
  if (winnr() != org_win)| execute org_win . "wincmd w"  | endif
  if (bufnr('%') != org_buf)| edit #| endif
  call winrestview(win_saved)
endtry

return result
endfun

fun! PasteToTarget()

let fun = {}
fun! fun.call()
  call g:Pm.next_mark()
  normal P`[V`]
  redraw!
  sleep 500m
  normal <Esc>
endfun

call g:SaveExcursion(fun)
endfun
