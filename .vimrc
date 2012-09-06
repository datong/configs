" Basics
syntax on               " enable syntax highlighting
set showmatch           " show matching brackets (),{},[]
set number
set nocompatible
set background=dark
set encoding=utf-8
set termencoding=utf-8 
set shell=/bin/bash
filetype on
set complete=k          " global autocompletion
set completeopt+=longest
set smarttab

" 不要响铃，更不要闪屏
set visualbell t_vb=
au GUIEnter * set t_vb=
set viminfo='100,:10000,<50,s10,h
set history=10000
set wildmenu
set delcombine " 组合字符一个个地删除
set laststatus=2 " 总是显示状态栏
" 首先尝试最长的，接着轮换补全项
set wildmode=longest:full,full
set ambiwidth=double
set shiftround
set diffopt+=vertical,context:3,foldcolumn:0
set fileencodings=ucs-bom,utf-8,gb18030,cp936,latin1
set fileformats=unix,dos,mac
set formatoptions=croqn2mB1
set formatexpr=autofmt#uax14#formatexpr()
set nojoinspaces
set virtualedit=block
set nostartofline
" set guioptions=egmrLtai
set guioptions=acit
set mousemodel=popup
" 没必要，而且很多时候 = 表示赋值
set isfname-==
set nolinebreak
set nowrapscan
set scrolloff=5
set sessionoptions=blank,buffers,curdir,folds,help,options,tabpages,winsize,slash,unix,resize
set shiftwidth=2
set winaltkeys=no
set noequalalways
set listchars=eol:$,tab:>-,nbsp:~
set display=lastline
set completeopt+=longest
set maxcombine=4
set cedit=<C-Y>
set whichwrap=b,s,[,]
set tags+=./../tags,./../../tags,./../../../tags

command Thunar silent !thunar %:p:h

" Indenting, Folding..
set tabstop=4           " numbers of spaces of tab character
set shiftwidth=4        " numbers of spaces to (auto)indent
set softtabstop=4       " counts n spaces when DELETE or BCKSPCE is used
set expandtab           " insert spaces instead of tab chars
set autoindent         	" always set autoindenting on
set nosmartindent       " intelligent indenting -- DEPRECATED by cindent
set nocindent           " set C style indenting off
set foldenable
set foldmethod=marker


" searching
set hlsearch            " highlight all search results
set incsearch           " increment search
set ignorecase          " case-insensitive search
set smartcase           " upper-case sensitive search

set laststatus=2        " occasions to show status line, 2=always.
" set cmdheight=1         " command line height
set ruler               " ruler display in status lin
set ruler
set showmode            " show mode at bottom of screen

" set previewheight=5

" Set taglist plugin options
let Tlist_Use_Right_Window = 1
let Tlist_Exit_OnlyWindow = 1
let Tlist_Enable_Fold_Column = 0
let Tlist_Compact_Format = 1
let Tlist_File_Fold_Auto_Close = 0
let Tlist_Inc_Winwidth = 1

" Toggle taglist script
"map <F7> :Tlist<CR>
"进行Tlist的设置
"TlistUpdate可以更新tags
map <F3> :silent! Tlist<CR> "按下F3就可以呼出了
let Tlist_Ctags_Cmd='ctags' "因为我们放在环境变量里，所以可以直接执行
let Tlist_Use_Right_Window=1 "让窗口显示在右边，0的话就是显示在左边
let Tlist_Show_One_File=0 "让taglist可以同时展示多个文件的函数列表，如果想只有1个，设置为1
let Tlist_File_Fold_Auto_Close=1 "非当前文件，函数列表折叠隐藏
let Tlist_Exit_OnlyWindow=1 "当taglist是最后一个分割窗口时，自动推出vim
let Tlist_Process_File_Always=0 "是否一直处理tags.1:处理;0:不处理。不是一直实时更新tags，因为没有必要
let Tlist_Inc_Winwidth=0


" Fix filetype detection
au BufNewFile,BufRead .torsmorc* set filetype=rc
au BufNewFile,BufRead *.inc set filetype=php
au BufNewFile,BufRead *.sys set filetype=php
au BufNewFile,BufRead grub.conf set filetype=grub
au BufNewFile,BufRead *.dentry set filetype=dentry
au BufNewFile,BufRead *.blog set filetype=blog

" C file specific options
au FileType c,cpp set cindent
au FileType c,cpp set formatoptions+=ro

" HTML abbreviations
au FileType html,xhtml,php,eruby imap bbb <br />
au FileType html,xhtml,php,eruby imap aaa <a href=""><left><left>
au FileType html,xhtml,php,eruby imap iii <img src="" /><left><left><left><left>
au FileType html,xhtml,php,eruby imap ddd <div class=""><left><left>

" Session Settings
set sessionoptions=blank,buffers,curdir,folds,help,resize,tabpages,winsize
map <c-q> :mksession! ~/.vim/.session <cr>
map <c-s> :source ~/.vim/.session <cr>

" Set up the status line
fun! <SID>SetStatusLine()
    let l:s1="%-3.3n\\ %f\\ %h%m%r%w"
    let l:s2="[%{strlen(&filetype)?&filetype:'?'},%{&encoding},%{&fileformat}]"
    let l:s3="%=\\ 0x%-8B\\ \\ %-14.(%l,%c%V%)\\ %<%P"
    execute "set statusline=" . l:s1 . l:s2 . l:s3
endfun
set laststatus=2
call <SID>SetStatusLine()

" Turn off blinking
"set visualbell
" Turn off beep
"set noerrorbells
set vb      " don't beep
set t_vb=   " ^

" highlight redundant whitespaces and tabs.
" highlight RedundantSpaces ctermbg=red guibg=red
" match RedundantSpaces /\s\+$\| \+\ze\t\|\t/

if has('gui_running')
    let &guicursor = &guicursor . ",a:blinkon0"
   " colorscheme solarized
   " colorscheme desert
     colorscheme lilypink
     set cursorline
    "set guifont=Monaco\ 11
    set guioptions-=T
    "set guioptions+=g
    "set guioptions-=t
    "set guioptions-=m
    set guioptions-=L
    set guioptions-=l
    set guioptions-=r
    set guioptions-=R
    set guitablabel=%t " set label for tab to just file name
    set anti " Antialias font
    "set transparency=0
elseif (&term =~ 'linux')
    set t_Co=16
    set termencoding=utf-8
    set cursorline
    colorscheme lilypink
else
    set t_Co=256
    set mouse=a   
    set cursorline      
    "colorscheme solarized
    "colorscheme desert
    colorscheme lilypink
    set termencoding=utf-8 
endif

"scope setting
"source ~/.vim/plugin/cscope_maps.vim
map <F12> :call Do_CsTag()<CR>
" 映射 [[[2
" 查找C语言符号，即查找函数名、宏、枚举值等出现的地方
nmap css :cs find s <C-R>=expand("<cword>")<CR><CR>
" 查找函数、宏、枚举等定义的位置，类似ctags所提供的功能
nmap csg :cs find g <C-R>=expand("<cword>")<CR><CR>
" 查找本函数调用的函数
nmap csd :cs find d <C-R>=expand("<cword>")<CR><CR>
" 查找调用本函数的函数
nmap csc :cs find c <C-R>=expand("<cword>")<CR><CR>
" 查找指定的字符串
nmap cst :cs find t <C-R>=expand("<cword>")<CR><CR>
" 查找egrep模式，相当于egrep功能，但查找速度快多了
nmap cse :cs find e <C-R>=expand("<cword>")<CR><CR>
" 查找并打开文件，类似vim的find功能
nmap csf :cs find f <C-R>=expand("<cfile>")<CR><CR>
 " 查找包含本文件的文件
nmap csi :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
" 生成新的数据库
nmap csn :lcd %:p:h<CR>:!my_cscope<CR>
" 自己来输入命令
nmap cs<Space> :cs find

function Do_CsTag()
    let dir = getcwd()
    if filereadable("tags")
        if(g:iswindows==1)
            let tagsdeleted=delete(dir."\\"."tags")
        else
            let tagsdeleted=delete("./"."tags")
        endif
        if(tagsdeleted!=0)
            echohl WarningMsg | echo "Fail to do tags! I cannot delete the tags" | echohl None
            return
        endif
    endif
    if has("cscope")
        silent! execute "cs kill -1"
    endif
    if filereadable("cscope.files")
        if(g:iswindows==1)
            let csfilesdeleted=delete(dir."\\"."cscope.files")
        else
            let csfilesdeleted=delete("./"."cscope.files")
        endif
        if(csfilesdeleted!=0)
            echohl WarningMsg | echo "Fail to do cscope! I cannot delete the cscope.files" | echohl None
            return
        endif
    endif
    if filereadable("cscope.out")
        if(g:iswindows==1)
            let csoutdeleted=delete(dir."\\"."cscope.out")
        else
            let csoutdeleted=delete("./"."cscope.out")
        endif
        if(csoutdeleted!=0)
            echohl WarningMsg | echo "Fail to do cscope! I cannot delete the cscope.out" | echohl None
            return
        endif
    endif
    if(executable('ctags'))
        "silent! execute "!ctags -R --c-types=+p --fields=+S *"
        silent! execute "!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q ."
    endif
    if(executable('cscope') && has("cscope") )
        if(g:iswindows!=1)
            silent! execute "!find . -name '*.h' -o -name '*.c' -o -name '*.cpp' -o -name '*.java' -o -name '*.cs' > cscope.files"
        else
            silent! execute "!dir /s/b *.c,*.cpp,*.h,*.java,*.cs >> cscope.files"
        endif
        silent! execute "!cscope -b"
        execute "normal :"
        if filereadable("cscope.out")
            execute "cs add cscope.out"
        endif
    endif
endfunction

source ~/.vim/indent/python.vim
set nobackup
