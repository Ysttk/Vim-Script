let OfficeMode = 1
let HomeMode = 2

let Mode = OfficeMode
"let Mode = "Home"

set fenc=utf-8
set fencs=utf-8,usc-bom,gb18030,abk,ab2312,cp936

set nocompatible
set history=100
set confirm

"set font
set guifont=Courier_New:h10:cANSI

set clipboard+=unnamed
set filetype=a
filetype plugin on
filetype indent on

syntax on

setlocal noswapfile
set bufhidden=hide

set wildmenu

set ruler

set backspace=2

set whichwrap+=<,>,h,l

set mouse =a
"set selection=exclusive
"set selectmode=mouse,key

set shortmess=atI

set report=0

set noerrorbells


set showmatch
set matchtime=5
set ignorecase
set hlsearch

set incsearch

set scrolloff=3

set novisualbell

set statusline=%F%m%r%h%w\[FORMAT=%{&ff}]\[TYPE=%Y]\[POS=%l,%v][%p%%]\%{strftime(\"%d/%m/%y\-\%H:%M\")}

set laststatus=2

set formatoptions=tcrqn

set autoindent
set smartindent
set cindent

if Mode == OfficeMode
    set tabstop=4

    set softtabstop=4
    set shiftwidth=4

    set noexpandtab

	"set bdir=G:\tmp\vim
else
    set tabstop=2
    set shiftwidth=2

    set softtabstop=2
    set expandtab
endif

set nowrap

set smarttab

set number

let g:GrepFileMarkTimes = {}
function MarkGrepFile()
	let lineN = line('.')
"	if has_key(g:GrepFileMarkTimes, lineN)
"		echo g:GrepFileMarkTimes[lineN]
"	else
"		echo "no key!"
"	endif
	if  has_key(g:GrepFileMarkTimes, lineN) && 
				\(g:GrepFileMarkTimes[lineN]>0) 
		exec "normal ^xxxxxxxxxxxx"
		let g:GrepFileMarkTimes[lineN]=0
	else
		exec "normal I[----------]"
		let g:GrepFileMarkTimes[lineN]=1
	endif
endfunction


if @% =~ '\.lua$'
	set foldmethod=indent
	"set foldmethod=syntax
	"set foldmethod=diff
	"set foldmethod=manual
elseif @% =~ '\.grep$'
	map m :call MarkGrepFile() <CR>
endif


"c/c++/java programing
"compile the program
map <F7> : call Compile() <CR>
function Compile()
exec "w"
exec "!clear"
if @% =~ '\.c$'
	exec "!gcc -o %<.x -lm -Wall -pg -g % -L/usr/local/lib `pkg-config --libs --cflags gtk+-2.0`"
elseif @% =~ '\.cpp$'
	exec "!g++ -o %<.x -Wall -g %"
elseif @% =~ '\.cxx$'
	exec "!g++ -o %<.x -Wall -g %"
elseif @% =~ '\.java$'
	exec "!javac -g -deprecation %"
elseif @% =~ '\.upc$'
	exec "!upcc -T 1 -pthreads 1 -opt -opt-enable=forall-opt -save-all-temps % -o %<.x"
endif
endfunction

imap <F7> <ESC> <F7>

"debug the program
map <F5> : call CompileAndDebug() <CR>
function CompileAndDebug()
	call Compile()
	if @% =~ '\.java$'
		exec "!jdb ./%<"
	else
		exec "!gdb ./%<.x"
	endif
endfunction

imap <F5> <ESC> <F5>

"run the program
map <F6> : call CompileAndRun() <CR>
function CompileAndRun()
	call Compile()
	if @%=~ '\.java$'
		exec "!java %<"
	else
		exec "!./%<.x"
	endif
endfunction

imap <F6> <ESC> <F6>

"save file
map <F2> :call SaveFile() <CR>
function SaveFile()
	exec "w"
endfunction

imap <F2> <ESC> <F2> <i>


"glance over the output file use less with line number
map <F3> :call GlanceOverOutput() <CR>

function GlanceOverOutput()
	exec "!less -N %<.out"
endfunction

map <C-H> <C-W>h
map <C-J> <C-W>j
map <C-K> <C-W>k
map <C-L> <C-W>l

set nobackup
set nowritebackup
set noswapfile

let NERDTreeShowBookmarks = 1
let NERDTreeShowFiles = 1
let NERDTreeShowHidden = 0
let NERDTreeQuitOnOpen = 0

map <C-T> :NERDTreeToggle <CR>

set grepprg=grep\ -n

let g:GlobalToolsDir = "D:\\Tools\\Bins\\"


function GrepSearch(str)
	"echo a:str
	"without use template file 'tempname()'
	"let tmpFile = tempname()
	let tmpFile = tempname() 
	let tmpFile2 = tempname().".grep"
	let locationFile = tempname()
	let pythonCmd = g:GlobalToolsDir."FindModifiedLines.py"
	silent exec "!grep -nr \"\\<".a:str."\\>\" * | grep lua: >".tmpFile
		\." && copy ".tmpFile." ".tmpFile2
		\." && vim ".tmpFile2
		\." && ".pythonCmd." ".tmpFile." ".tmpFile2." ".locationFile
	"let qflist = getqflist()
	"if len(qflist) >= 1
		silent exec "split ".expand("<abuf>")
		exec "cfile ".locationFile
	"endif
endfunction

function GrepSearchCurrentWord()
	"echo expand("<cword>")
	call GrepSearch( expand("<cword>") )
endfunction


"map <C-S> :grep -r <cword> *.lua <CR>
map <C-S> :call GrepSearch( expand("<cword>") ) <CR>
"map key ',' to be meaningless key
map , : <CR>
map <C-N> :lnext <CR> ,
map <C-P> :lprevious <CR> ,

