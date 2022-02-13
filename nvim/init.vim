"--------------------------------------------------------------------------
" General settings
"--------------------------------------------------------------------------
  set completeopt=menuone,noinsert,noselect
  set mouse=a
  set splitright
  set splitbelow
  set expandtab
  set tabstop=2
  set shiftwidth=2 
  set number
  set ignorecase
  set smartcase
  set incsearch
  set diffopt+=vertical
  set hidden
  set nobackup
  set nowritebackup
  set cmdheight=1
  set shortmess+=c
  set signcolumn=yes
  set updatetime=750
  filetype plugin indent on
  let mapleader = " "
  if (has("termguicolors"))
  	set termguicolors
  endif
  let g:netrw_banner=0
  let g:markdown_fenced_languages = ['javascript', 'js=javascript', 'jason=javascript', 'xml', 'html', 'css' ]
  nnoremap <leader>v :e $MYVIMRC<CR>


"--------------------------------------------------------------------------
" Plugins
"--------------------------------------------------------------------------
" Automatically install vim-plug

  let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
  if empty(glob(data_dir . '/autoload/plug.vim'))
    silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
  endif
  
  call plug#begin(data_dir . '/plugins')

  " Plugins for Enhanced Appearance
    Plug 'dracula/vim', { 'as': 'dracula' }
    Plug 'itchyny/lightline.vim'
    Plug 'itchyny/vim-gitbranch'
  
  " Plugins for Enhanced Productivity
    Plug 'szw/vim-maximizer'
    Plug 'christoomey/vim-tmux-navigator'
    Plug 'kassio/neoterm'
    Plug 'tpope/vim-commentary'
    Plug 'sbdchd/neoformat'
  
  " Plugins for Fuzzy Finding and Git
    Plug 'junegunn/fzf',{'dir': '~/.fzf', 'do': './install --all' }
    Plug 'junegunn/fzf.vim'
    Plug 'tpope/vim-fugitive'
    Plug 'airblade/vim-gitgutter'

  " Plugins for the Language Server Protocol
    Plug 'neovim/nvim-lspconfig'
    Plug 'nvim-lua/completion-nvim'
    Plug 'janko/vim-test'


  call plug#end()



"--------------------------------------------------------------------------
" Plugins Configuration
"--------------------------------------------------------------------------
"
" dracula/vim
  colorscheme dracula

" itchyny/lightline.vim and itchyny/vim-gitbranch
  let g:lightline = {
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'gitbranch#name'
      \ },
      \ 'colorscheme': 'darcula',
      \ }


" szw/vim-maximizer
  nnoremap <leader>m :MaximizerToggle!<CR>

" kassio/neoterm
  let g:neoterm_default_mod = 'vertical'
  let g:neoterm_size = 60
  let g:neoterm_autoinsert = 1
  nnoremap <c-q> :Ttoggle<CR>
  inoremap <c-q> <Esc>:Ttoggle<CR>
  tnoremap <c-q> <c-\><c-n>:Ttoggle<CR>

" sbdchd/neoformat
  nnoremap <leader>F :Neoformat prettier<CR>

" junegunn/fzf.vim
  nnoremap <leader><space> :GFiles<CR>
  nnoremap <leader>ff :Rg<CR>
  inoremap <expr> <c-x><c-f> fzf#vim#complete#path(
    \ "find . -path '*/\.*' -prune -o -print \| sed '1d;s:^..::'",
    \ fzf#wrap({'dir': expand('%:p:h')}))
  if has('nvim')
    au! TermOpen * tnoremap <buffer> <Esc> <c-\><c-n>
    au! FileType fzf tunmap <buffer> <Esc>
  endif

" tpope/vim-fugitive
  nnoremap <leader>gg :G<CR>

" neovim/nvim-lspconfig
  lua require'lspconfig'.gopls.setup{}
  nnoremap <silent>gd <cmd>lua vim.lsp.buf.definition()<CR>
  nnoremap <silent>gh <cmd>lua vim.lsp.buf.hover()<CR>
  nnoremap <silent>gH <cmd>lua vim.lsp.buf.code_action()<CR>
  nnoremap <silent>gD <cmd>lua vim.lsp.buf.implementation()<CR>
  nnoremap <silent><c-k>  <cmd>lua vim.lsp.buf.signature_help()<CR>
  nnoremap <silent>gr <cmd>lua vim.lsp.buf.references()<CR>
  nnoremap <silent>gR <cmd>lua vim.lsp.buf.Rename()<CR>

" janki/vim-test
  nnoremap <silent> tt :TestNearest<CR>
  nnoremap <silent> tf :TestFile<CR>
  nnoremap <silent> ts :TestSuite<CR>
  nnoremap <silent> t_ :TestLast<CR>
  let test#strategy = "neovim"
  let test#neovim#term_position = "vertical"
