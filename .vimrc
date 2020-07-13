" Setting `nocompatible` switches from the default Vi-compability
" mode and enables useful Vim functionality. 
set nocompatible

" Activate color-scheme
colo nnkd

" Hack for tmux
set background=dark

" Turn on syntax highlighting.
syntax on

" Disable the default Vim startup message.
set shortmess+=I

" Show line numbers.
set number

" Enable relative line numbering mode.
set relativenumber

" Always show the status line at the bottom.
set laststatus=2

" Intuitive behavior to backspace.
set backspace=indent,eol,start

" By default, Vim doesn't let you hide a buffer (i.e. have a buffer that isn't
" shown in any window) that has unsaved changes. This is to prevent you from "
" forgetting about unsaved changes and then quitting e.g. via `:qa!`.
set hidden

" Enable the case-insensitive search when all characters in the string being 
" searched are lowercase. However, the search becomes case-sensitive if it 
" contains any capital letters. 
set ignorecase
set smartcase

" Enable searching, while typing, rather than waiting till you press enter.
set incsearch

" Key bindings
let mapleader = "\<Space>"

" Unbind some useless/annoying default key bindings.
nmap Q <Nop> 

" Disable audible bell
set noerrorbells visualbell t_vb=

" Disable arrow keys, while in the normal more. 
nnoremap <Left>  :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up>    :echoe "Use k"<CR>
nnoremap <Down>  :echoe "Use j"<CR>

" Disable arrow keys, while in the insert mode.
inoremap <Left>  <ESC>:echoe "Use h"<CR>
inoremap <Right> <ESC>:echoe "Use l"<CR>
inoremap <Up>    <ESC>:echoe "Use k"<CR>
inoremap <Down>  <ESC>:echoe "Use j"<CR>

" Easier split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" More natural split opening
nnoremap <leader>d :vsp<cr>
set splitright
nnoremap <leader>s :split<cr>
set splitbelow

" tabs
nnoremap <leader>] :tabn<cr>
nnoremap <leader>[ :tabp<cr>
nnoremap <leader>T :tabe<cr>

" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')
	Plug 'ctrlpvim/ctrlp.vim'
	Plug 'tpope/vim-fugitive'
	Plug 'jreybert/vimagit'
	Plug 'tpope/vim-rhubarb'
	Plug 'preservim/nerdtree'
	Plug 'vim-airline/vim-airline'
	Plug 'airblade/vim-gitgutter'
	Plug 'w0rp/ale'
	Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
	Plug 'junegunn/fzf.vim'

	" Language plugins
	" Scala plugins
	if executable('scalac')
		Plug 'derekwyatt/vim-scala', { 'for': 'scala' }
	endif

	" Rust Plugins
	if executable('rustc')
		Plug 'rust-lang/rust.vim', { 'for': 'rust' }
		Plug 'racer-rust/vim-racer', { 'for': 'rust' }
	endif

call plug#end()

"Git Gutter

" Use fontawesome icons as signs 
let g:gitgutter_sign_added = '+'
let g:gitgutter_sign_modified = '>'
let g:gitgutter_sign_removed = '-'
let g:gitgutter_sign_removed_first_line = '^'
let g:gitgutter_sign_modified_removed = '<'

" Update sign column every quarter second
set updatetime=250

" Jump between hunks
nmap <leader>gn <Plug>(GitGutterNextHunk)  " git next
nmap <leader>gp <Plug>(GitGutterPrevHunk)  " git previous

" Hunk-add and hunk-revert for chunk staging
nmap <leader>ga <Plug>(GitGutterStageHunk)  " git add (chunk)
nmap <leader>gu <Plug>(GitGutterUndoHunk)   " git undo (chunk)

" Open vimagit pane
nnoremap <leader>gs :Magit<CR>       " git status

" Push to remote
nnoremap <leader>gP :! git push<CR>  " git Push

" Enable deletion of untracked files in Magit
let g:magit_discard_untracked_do_delete=1

" Show commits for every source line
nnoremap <Leader>gb :Gblame<CR>  " git blame

" Open visual selection in the browser
vnoremap <Leader>gb :Gbrowse<CR>

" Add the entire file to the staging area
nnoremap <Leader>gaf :Gw<CR>      " git add file
" CtrlP Settings
" Set local working directory if it was invoked without an explicit
" starting directory.
let g:ctrlp_working_path_mode = 'ra'

" Change the default mapping and the default command to invoke CtrlP
" let g:ctrlp_map = '<c-p>'
" let g:ctrlp_cmd = 'CtrlP'

" Exclude files and directories, while searhing
set wildignore+=*/tmp/*,*.so,*.swp,*.zip
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'

" Ignore files in .gitignore
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']

" NERDTree config
autocmd StdinReadPre * let s:std_in=1

" Open a NERDTree automatically when vim starts up if no files were
" specified
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" Open NERDTree automatically when vim starts up on opening a directory
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | exe 'cd '.argv()[0] | endif

" Close vim if the only window left open is a NERDTree 
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Shortcut for opening NERDTree
map <leader>n :NERDTreeToggle<CR>


" Ripgrep for search
if executable('rg')
  set grepprg=rg\ -i\ --vimgrep

  " Ripgrep on /
  command! -nargs=+ -complete=file -bar Rg silent! grep! <args>|cwindow|redraw!
  nnoremap <leader>/ :Rg<SPACE>
endif

" FZF
if executable('rg')
  let $FZF_DEFAULT_COMMAND = 'rg --files --no-messages "" .'
  set grepprg=rg\ --vimgrep
endif

let g:fzf_command_prefix = 'Fzf'
if executable('fzf')
	nnoremap <leader>v :FzfFiles<cr>
	nnoremap <leader>u :FzfTags<cr>
	nnoremap <leader>j :call fzf#vim#tags("'".expand('<cword>'))<cr>

	if executable('rg')
		" :Find <term> runs `rg <term>` and passes it to fzf
		command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --color "always" '.shellescape(<q-args>), 1, <bang>0)
		nnoremap <leader>/ :Find
		nnoremap <leader>' :execute "Find " . expand("<cword>")<cr>
	endif
	else
		nnoremap <leader>v :CtrlP<Space><cr>
endif


" Racer
set hidden
let g:racer_cmd = "~/.cargo/bin/racer"
let g:racer_experimental_completer = 1
au FileType rust nmap <leader>rx <Plug>(rust-doc)
au FileType rust nmap <leader>rd <Plug>(rust-def)
au FileType rust nmap <leader>rs <Plug>(rust-def-split)

" Rust
let g:rustfmt_autosave = 1


" ALE
let g:airline#extensions#ale#enabled = 1
let g:ale_linters = {'go': ['golint', 'gofmt'], 'sql': ['sqlint']}
let g:ale_lint_delay = 800
