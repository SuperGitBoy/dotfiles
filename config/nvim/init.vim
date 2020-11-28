" Basic settings
filetype plugin on
syntax on
set encoding=utf-8
scriptencoding utf-8
set number relativenumber
set mouse=a
" set termguicolors
set virtualedit=block
set ttimeoutlen=0
set showbreak=↪
set noshelltemp
set shortmess=atI

" Undo settings
set undofile
set undolevels=100
set undoreload=100
set undodir=~/.config/nvim/_undo/
set backupdir=~/.config/nvim/_backup/
set directory=~/.config/nvim/_swap/

" set mapleader to space
nnoremap <SPACE> <Nop>
let mapleader=" "

" when scrolling, keep cursor 3 lines away from screen border
set scrolloff=7
set sidescrolloff=7

" System Clipboard
set clipboard+=unnamedplus

" Make double-<Esc> clear search highlights
nnoremap <silent> <Esc><Esc> <Esc>:nohlsearch<CR><Esc>

" Enable autocompletion
"set wildmode=longest,list,full
set wildmode=list:full

" Disable autocomment on new line
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Split directions and navigation
set splitbelow splitright
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" vim-plug config
" to install vim-plug:
" sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
call plug#begin('~/.local/share/nvim/plugged')
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'
Plug 'zchee/deoplete-jedi'
Plug 'vim-airline/vim-airline'
Plug 'jiangmiao/auto-pairs'
Plug 'preservim/nerdtree'
Plug 'junegunn/fzf', { 'do' : { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'majutsushi/tagbar'
Plug 'arcticicestudio/nord-vim'
Plug 'tpope/vim-surround'
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
Plug 'tpope/vim-repeat'
Plug 'neomake/neomake'
Plug 'lambdalisue/suda.vim'
call plug#end()

"theme
colorscheme nord

" suda.vim config
let g:suda_smart_edit = 1

" Goyo config
let g:goyo_width=120
let g:goyo_height=90

"deoplete config
let g:deoplete#enable_at_startup = 1
autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif
inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"

" Plugin key-mappings.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
imap <expr><TAB>
			\ pumvisible() ? "\<C-n>" :
			\ neosnippet#expandable_or_jumpable() ?
			\    "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
			\ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

" For conceal markers.
"if has('conceal')
"  set conceallevel=2 concealcursor=niv
"endif

" Zoom / Restore window.
function! s:ZoomToggle() abort
	if exists('t:zoomed') && t:zoomed
		execute t:zoom_winrestcmd
		let t:zoomed = 0
	else
		let t:zoom_winrestcmd = winrestcmd()
		resize
		vertical resize
		let t:zoomed = 1
	endif
endfunction
command! ZoomToggle call s:ZoomToggle()
nnoremap <silent> <C-W><C-o> :ZoomToggle<CR>

" tagbar toggle <F8>
nmap <silent> <F8> :TagbarToggle<CR>

" Highlight yanked text
augroup highlight_yank
	autocmd!
	autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank("IncSearch", 1000)
augroup END

" Goyo and Limelight integration
function! NumberToggle()
	if ((&nu)&&(&rnu) == 1)
		set nonu nornu
	else
		set nu rnu
	endif
endfunction()

augroup EnterGoyo
	autocmd! User GoyoEnter Limelight 0.5
	call NumberToggle()
	set scrolloff=999
augroup END

augroup LeaveGoyo
	autocmd! User GoyoLeave Limelight!
	call NumberToggle()
	set scrolloff=7
augroup END

nnoremap <silent> <leader>g :Goyo<CR>

" Personal Keybindings
nnoremap <silent> <C-s>n :NERDTreeToggle<CR>
nnoremap <silent> <C-s>f :FZF<CR>
tnoremap <Esc> <C-\><C-n>
nnoremap Q <Nop>

" Auto Insert mode in Terminal
autocmd TermOpen * startinsert

function! CreateNewTabShell()
	split
	terminal
	resize 7
	set wfh
	setlocal nonumber
	setlocal norelativenumber
endfunction()

nnoremap <silent> <C-s>t :call CreateNewTabShell()<CR>

" Python
autocmd FileType python map <buffer> <F5> :term python3 % <CR>

" Delete key doesn't yank
nnoremap <del> "_x
vnoremap <del> "_x

" CapsLock switch
au VimEnter * silent! !xmodmap -e 'clear Lock' -e 'keycode 0x42 = Escape'
au VimLeave * silent! !xmodmap -e 'clear Lock' -e 'keycode 0x42 = Caps_Lock'

" redraw window so search terms are centered
nnoremap n nzz
nnoremap N Nzz
