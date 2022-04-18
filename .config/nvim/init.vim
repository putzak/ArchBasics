" Plugins List
call plug#begin('~/.local/share/nvim/site/autoload')
    " other plugins...
    " --------- adding the following three plugins for Latex ---------
    Plug 'SirVer/ultisnips'
    Plug 'honza/vim-snippets'
    Plug 'lervag/vimtex'
    Plug 'Konfekt/FastFold'
    Plug 'matze/vim-tex-fold'
    Plug 'Shougo/deoplete.nvim'
    Plug 'roxma/nvim-yarp'
    Plug 'roxma/vim-hug-neovim-rpc'
    " other plugins...
call plug#end()

" Autocomplete
call deoplete#custom#var('omni', 'input_patterns', {
    \ 'tex': g:vimtex#re#deoplete
    \})

" Use deoplete.
let g:deoplete#enable_at_startup = 1

" Line numbers
set number
" set relativenumber
