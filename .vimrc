" =================== Must have =======================
" Switch from the default Vi-compability
set nocompatible

" Intuitive behaviour for backspace
set backspace=indent,eol,start

" Disable nasty bells
set noerrorbells visualbell t_vb=
" ==================== Apearance ======================
" Set default color scheme
color delek

" Enable syntax highlight
syntax on

" Disable startup message
set shortmess+=I

" Display line numbers
set number

" Display relative number
set relativenumber

" Always show the status line at the bottom
set laststatus=2

" Vertical split adds to right
set splitright

" Horizontal split adds to bottom
set splitbelow

" ===================== Search ========================
" Ignore case while the search term is written in lowercase
set ignorecase

" Enable case-sensetive search if some letters in a search term is not in
" lowercase 
set smartcase

" Search during writing a search term
set incsearch

" ================== Key Bindings =====================
let mapleader = "\<Space>"

" Split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Split opening
nnoremap <leader>\| :vsp<cr>
nnoremap <leader>_ :split<cr>

" Switch between tabs
nnoremap <leader>] :tabn<cr>
nnoremap <leader>[ :tabp<cr>
nnoremap <leader>T :tabe<cr>

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

" Show commits for every source line
nnoremap <Leader>gb :Gblame<CR>  " git blame

" Open visual selection in the browser
vnoremap <Leader>gb :Gbrowse<CR>

" Add the entire file to the staging area
nnoremap <Leader>gaf :Gw<CR>      " git add file

" Toogle NERDTree
map <leader>n :NERDTreeToggle<CR>

" fzf, CtrlP, ripgrep
" Find a file that contains a search term 
nnoremap <leader>F :execute "Find " . expand("<cword>")<cr>

" Find a file by its name
nnoremap <leader>f :FzfFiles<cr>

" Show recently opened files
nnoremap <leader>p :CtrlP<Space><cr>

" ================== Key Unbindings ====================
nmap Q <Nop> 
nmap q <Nop> 

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

" ===================== Plugins ========================
call plug#begin('~/.vim/plugged')
	Plug 'ctrlpvim/ctrlp.vim'
	Plug 'tpope/vim-fugitive'
	Plug 'airblade/vim-gitgutter'
	Plug 'jreybert/vimagit'
	Plug 'preservim/nerdtree'
	Plug 'vim-airline/vim-airline'
	Plug 'w0rp/ale'
	Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
	Plug 'junegunn/fzf.vim'
call plug#end()

" =================== Git Gutter =======================
" Configure signs 
let g:gitgutter_sign_added = '+'
let g:gitgutter_sign_modified = '>'
let g:gitgutter_sign_removed = '-'
let g:gitgutter_sign_removed_first_line = '^'
let g:gitgutter_sign_modified_removed = '<'

" Colorize signs
highlight GitGutterAdd    guifg=#009900 ctermfg=2
highlight GitGutterChange guifg=#bbbb00 ctermfg=3
highlight GitGutterDelete guifg=#ff2222 ctermfg=1

" Update sign column interval (ms)
set updatetime=250

" Enable deletion of untracked files in Magit
let g:magit_discard_untracked_do_delete=1

" ====================== CtrlP ==========================
" Set local working directory
let g:ctrlp_working_path_mode = 'ra'

" Exclude files and directories, while searhing
set wildignore+=*/tmp/*,*.so,*.swp,*.zip
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']

" ====================== NerdTree =======================
" NERDTree config
autocmd StdinReadPre * let s:std_in=1

" Open a NERDTree automatically when vim starts up if no files were specified
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" Open NERDTree automatically when vim starts up on opening a directory
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | exe 'cd '.argv()[0] | endif

" Close vim if the only window left open is a NERDTree 
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" ====================== RipGrep & FZF ==================
if executable('rg')
  let $FZF_DEFAULT_COMMAND = 'rg --files --no-messages "" .'
  set grepprg=rg\ -i\ --vimgrep
endif

function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

let g:fzf_command_prefix = 'Fzf'

" Register command 'Find' to use ripgrep to search through files content. 
command! -nargs=* -bang Find call RipgrepFzf(<q-args>, <bang>0)

" [Tags] Command to generate tags file
let g:fzf_tags_command = 'ctags -R'

" ======================== Ale ==========================
let g:airline#extensions#ale#enabled = 1
let g:ale_linters = {'go': ['golint', 'gofmt'], 'sql': ['sqlint']}
let g:ale_lint_delay = 800
