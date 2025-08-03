" Generated vimrc from Neovim RC

let mapleader = " "

" 1. Clear search highlighting with <Esc>
nnoremap <Esc> :nohlsearch<CR>

" 2. Replace the word under cursor globally (press <leader>ss, then adjust as needed)
" nnoremap <leader>ss :%s/\<<C-R><C-W>\>/<C-R><C-W>/gI<Left><Left><Left>

" 3. System clipboard operations
set clipboard=unnamedplus       " use the + register by default
nnoremap <leader>Y "+Y          " yank whole line
nnoremap <leader>y "+y          " yank selection or motion
vnoremap <leader>y "+y

" 4. “Black hole” deletes
nnoremap <leader>d "_d
vnoremap <leader>d "_d

" 5. Paste over visual selection without clobbering the unnamed register
xnoremap <leader>p "_dP

" 6. Yank entire buffer to clipboard
" nnoremap <C-C> :%y+<CR>

" 7. Save file with <C-S>
" if has('gui_running') || &term =~ 'kitty\|alacritty'
"  nnoremap <C-S> :w<CR>
" endif

" 8. Window navigation
" nnoremap <C-H> <C-W>h
" nnoremap <C-J> <C-W>j
" nnoremap <C-K> <C-W>k
" nnoremap <C-L> <C-W>l

" 9. Buffer management
" nnoremap <leader>b :enew<CR>    " new (empty) buffer

" 10. Toggle line‑numbering
" nnoremap <leader>n :set nu!<CR>
" nnoremap <leader>rn :set rnu!<CR>

" 11. Better joining: keep cursor in place
" nnoremap J mzJ`z

" 12. Move visual blocks up/down and reselect
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" 13. Center search jumps
nnoremap n nzzzv
nnoremap N Nzzzv

" 14. Disable accidental Q
nnoremap Q <Nop>

" 15. Quick insert empty lines
" nnoremap [<leader> O<Esc>
" nnoremap ]<leader> o<Esc>

" 16. Scroll half‑page and recenter
nnoremap <C-U> <C-U>zz
nnoremap <C-D> <C-D>zz

" 17. Display wrapped lines correctly
nnoremap j gj
nnoremap k gk
