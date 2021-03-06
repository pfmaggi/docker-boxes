" An example for a vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2008 Jul 02
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" =======================================
" Installing from scratch?
" ln -s /Users/reborg/prj/my/dot/rc/vimrc .vimrc
" ln -s /Users/reborg/prj/my/dot/vim .vim
" vim +BundleInstall +qall
" =======================================
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-commentary'
Plugin 'altercation/vim-colors-solarized'
Bundle 'gabrielelana/vim-markdown'
Plugin 'bling/vim-airline'
Plugin 'L9'
Plugin 'FuzzyFinder'
Plugin 'airblade/vim-gitgutter'
Plugin 'majutsushi/tagbar'
Plugin 'mileszs/ack.vim'
" Plugin 'scrooloose/syntastic'

" Clojure Here
Plugin 'tpope/vim-fireplace'
" Plugin 'tpope/vim-salve'
" Plugin 'tpope/vim-projectionist'
" Plugin 'tpope/vim-dispatch'
" Plugin 'tpope/vim-leiningen'
" Plugin 'tpope/vim-classpath'
Plugin 'guns/vim-sexp'
Plugin 'tpope/vim-sexp-mappings-for-regular-people'
Plugin 'guns/vim-clojure-static'
Plugin 'jpalardy/vim-slime'
Plugin 'neovim/node-host'

" Haskell
Plugin 'Shougo/vimproc.vim'
Plugin 'raichoo/haskell-vim'
Plugin 'Twinside/vim-hoogle'
Plugin 'eagletmt/ghcmod-vim'

" Asciidoc
" Plugin 'dagwieers/asciidoc-vim'
Plugin 'mjakl/vim-asciidoc'
" Plugin 'asciidoc/vim-asciidoc'
" Plugin 'dahu/vimple'
" Plugin 'dahu/Asif'
" Plugin 'vim-scripts/SyntaxRange'
" Plugin 'dahu/vim-asciidoc'

" other stuff
Plugin 'davidoc/taskpaper.vim'
Plugin 'vim-scripts/BufOnly.vim'

call vundle#end()

" Slime settings
let g:slime_target = "tmux"
let g:slime_paste_file = "$HOME/.slime_paste"
let g:slime_default_config = {"socket_name": "default", "target_pane": "2"}

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
set hlsearch

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END
else
  set autoindent=false

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

" ##################################################################
" ##################################################################
"                  Start Renzo's Customizations
" ##################################################################
" ##################################################################

" Solarized
syntax on
set background=dark
" set t_Co=256
" let g:solarized_termcolors=256
" let g:solarized_contrast = "high"
" let g:solarized_visibility= "high"
colorscheme solarized
let g:html_use_css = 1

" Paredit
let g:paredit_mode = 0                          " disable the beast
let g:paredit_electric_return=0
" au FileType arc call PareditInitBuffer()        " add another file type paredit control

" setting for syntax for file types
autocmd BufNewFile,BufRead *.pom set ft=taskpaper
autocmd BufNewFile,BufRead *.json set ft=javascript
autocmd BufNewFile,BufRead *.asciidoc set ft=asciidoc
autocmd BufNewFile,BufRead *.dockerfile set ft=sh

autocmd BufNewFile,BufRead *.adoc set ft=asciidoc
autocmd FileType asciidoc set nonumber
autocmd FileType asciidoc set spell spelllang=en_us

autocmd BufNewFile,BufRead *.pig set ft=pig
autocmd BufNewFile,BufReadPost *.cljx setfiletype clojure
autocmd BufNewFile,BufReadPost *.edn setfiletype clojure
autocmd BufNewFile,BufReadPost *.eg setfiletype lisp

" turn-on distraction free writing mode for txt
" au BufNewFile,BufRead *.{mdown,mkd,mkdn,markdown,mdwn,md,adoc} call DistractionFreeWriting()
" function! DistractionFreeWriting()
"   colorscheme solarized
"   set background=light
"   set laststatus=0                   " don't show status line
"   set noruler                        " don't show ruler
"   set linebreak                      " break the lines on words
"   set nonumber
"   set nocursorline
" endfunction

" Use softtabs
set softtabstop=2
set shiftwidth=2
set tabstop=2
set expandtab

" Useful expansions
imap hh <Space>=><Space>
imap kk <Esc>:w <cr>
imap jj <Esc>: <cr>

" highlight line with cursor
set cursorline
hi CursorLine ctermbg=17
"hi CursorLine cterm=underline

" remove search highlighting on hit return command mode
map <Enter> :nohlsearch<Enter>

" Show line numbers
set number

" highlight matching brackets
set matchpairs+=<:>

" turn off the bell
set vb t_vb=

" Invoke a web browser
function! Browser ()
  let line0 = getline (".")
  let line = matchstr (line0, "http[^ ]*")
  :if line==""
  let line = matchstr (line0, "ftp[^ ]*")
  :endif
  :if line==""
  let line = matchstr (line0, "file[^ ]*")
  :endif
  let line = escape (line, "#?&;|%")
  ":if line==""
  " let line = "\"" . (expand("%:p")) . "\""
  ":endif
  exec ':silent !open ' . "\"" . line . "\""
endfunction
map ,w :call Browser ()<CR>

" no backups
set noswapfile
set nowritebackup

" Some initial folding settings
" Then you can toggle folding with za. You can fold everything with zM and unfold
" everything with zR. zm and zr can be used to get those folds just right
" set foldmethod=indent   "fold based on indent
" set foldnestmax=10      "deepest fold is 10 levels
" set foldlevelstart=10

" markdown support
" http://plasticboy.com/markdown-vim-mode/
augroup mkd
autocmd BufRead,BufNewFile *.mkd set ai formatoptions=tcroqn2 comments=n:>
autocmd BufRead,BufNewFile *.markdown set ai formatoptions=tcroqn2 comments=n:>
augroup END

" going hard core, disabling arrows
"noremap  <Up> ""
"noremap! <Up> <Esc>
"noremap  <Down> ""
"noremap! <Down> <Esc>
"noremap  <Left> ""
"noremap! <Left> <Esc>
"noremap  <Right> ""
"noremap! <Right> <Esc>

" display cursor line
set cursorline

" Specky configuration
" http://www.vim.org/scripts/script.php?script_id=2286
let g:speckyBannerKey = "<C-S>b"
let g:speckyQuoteSwitcherKey = "<C-S>'"
let g:speckyRunRdocKey = "<C-S>r"
let g:speckySpecSwitcherKey = "<C-S>x"
let g:speckyRunSpecKey = "<C-S>s"
let g:speckyRunSpecCmd = "spec -fs"
let g:speckyRunRdocCmd = "fri -L -f plain"
let g:speckyWindowType = 2

" DEVELOPMENT STUFF
" Run single test mapping
" http://www.vim.org/scripts/script.php?script_id=2869
" nmap <silent> <leader>t <Plug>ExecuteRubyTest
" set makeprg=spec
nmap <leader>E :Eval<cr>
nmap <leader>e :%Eval<cr>

" toggle paste without indentation for
" copy pasting from other application
set pastetoggle=<F2>

" softwrap enable me
set linebreak

" map ack to \f
" let mapleader=","
map <leader>f :Ack

" don't bother alert me when unsaved buffers
set hidden

" Turn on smartcase for searches
set smartcase
set ignorecase

" Fuzzy File Finder
nmap <leader>t :FufFile **/<CR>
nmap <leader>b :FufBuffer<CR>
let g:fuf_dir_exclude = '\v(^|[/\\])(\.(hg|git|bzr|svn)|CVS|docs|dist|doc|target|out|AAMakePDF)($|[/\\])'
let g:fuf_file_exclude = '\v\~$|\.(o|exe|dll|bak|orig|swp|wav|png|jpg|gif)$|(^|[/\\])(\.(hg|git|bzr|svn)|CVS|db|target|out|Vendors|logs|classes|select2|docs|doc|dist|AAMakePDF)($|[/\\])'
" fix fuzzyfinder color scheme for buffer list
hi Pmenu guifg=lightgray guibg=darkgrey gui=NONE ctermfg=yellow ctermbg=black cterm=NONE

" format xml file with xmllint
map ,xml :%!xmllint --format --encode UTF-8 -<CR>

" shortcut to open clojure core
map ,core :e /Users/reborg/prj/3rdparties/clojure/src/clj/clojure/core.clj<CR>

" clean up html with tidy
map ,html :!tidy -q -i --show-errors 0<CR>

" project specific vimrc load on matching folders
" autocmd BufRead,BufNewFile ~/prj/blah/hydra/* so ~/prj/blablah/mps3/.vimrc
" autocmd BufRead,BufNewFile ~/prj/blah/mps3/* so ~/prj/blah/mps3/.vimrc
" autocmd BufRead,BufNewFile ~/prj/blah/pips-client/* so ~/prj/blah/pips-client/.vimrc
" autocmd BufRead,BufNewFile ~/prj/blah/libraries/directory-mounter/trunk/* so ~/prj/blah/libraries/directory-mounter/trunk/.vimrc

" Additional custom specification for ctags regexp-es
" http://stackoverflow.com/questions/2968522/alternatives-to-ctags-cscope-with-objective-c/5790832#5790832
let tlist_objc_settings = 'ObjectiveC;P:protocols;c:class;m:method'

" Shortcut generation of ctags for objc projects
" For this to work: brew install ctags --HEAD
map <silent> ,tobj :!ctags -R --language-force=ObjectiveC --sort=yes --exclude=.git --exclude=Resources --exclude=build --exclude=Vendors *<CR>
" Shortcut generation of ctags for Java projects
map <silent> ,tjava :!ctags -R --language-force=Java --sort=yes --exclude=.git --exclude=.svn --exclude=**/target *<CR>
" Clojure ctags!
map <silent> ,tclj :!ctags -R --langmap=Lisp:+.clj --sort=yes --exclude=.git --exclude=.svn --exclude=**/target *<CR>

" recently moved to Vundle, see top of the file.
" call pathogen#infect('/Users/reborg/prj/pathogen-bundles/{}')

" Fixes Airline not showing on a single pane
set laststatus=2

" Fixes delay pressing ESC to return to command mode from normal mode
set timeoutlen=1000 ttimeoutlen=0

" autotrim space from files on saving
fun! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfun

" strip trailing whitespaces on write file
autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()

" Vim fugitive shortcuts
nnoremap <Leader>gs :Gstatus<CR>
nnoremap <Leader>gd :Gdiff<CR>
nnoremap <Leader>gb :Gblame<CR>
nnoremap <Leader>gc :Gcommit<CR>
nnoremap <Leader>gl :exe ':!cd ' . expand('%:p:h') . '; git log --oneline --decorate --graph':w'<CR>
nnoremap <Leader>gr :Gread<CR>
nnoremap <Leader>gw :Gwrite<CR>
nnoremap <Leader>gp :Git push<CR>
nnoremap <Leader>g+ :Silent Git stash<CR>:e<CR>
nnoremap <Leader>g- :Silent Git stash pop<CR>:e<CR>

" Haskell stuff
" au BufEnter *.hs compiler ghc
let g:haddock_browser = "/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome"
" let g:ghc = "/usr/bin/ghc"
nmap <leader>= :TagbarToggle<CR>
let g:tagbar_autofocus = 1

" ghcmod
au FileType haskell map <LocalLeader>in :GhcModInfo<cr>
au FileType haskell map <LocalLeader>ty :GhcModType<cr>
au FileType haskell map <LocalLeader>ch :GhcModCheck<cr>
au FileType haskell map <LocalLeader>li :GhcModLint<cr>
au FileType haskell map <LocalLeader>ex :GhcModExpand<cr>
au FileType haskell map <LocalLeader>cl :GhcModTypeClear<cr>
autocmd BufWritePost *.hs GhcModCheckAndLintAsync
let &l:statusline = '%{empty(getqflist()) ? "[No Errors]" : "[Errors Found]"}' . (empty(&l:statusline) ? &statusline : &l:statusline)

" syntastic
" set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
" set statusline+=%*
" let g:syntastic_always_populate_loc_list = 0
" let g:syntastic_auto_loc_list = 0
" let g:syntastic_check_on_open = 0
" let g:syntastic_check_on_wq = 0
" map <silent> <Leader>e :Errors<CR>
" map <Leader>s :SyntasticToggleMode<CR>

" vim-hoogle
" Hoogle the word under the cursor
nnoremap <silent> <leader>hh :Hoogle<CR>
" Hoogle and prompt for input
nnoremap <leader>hH :Hoogle
" Hoogle for detailed documentation (e.g. "Functor")
nnoremap <silent> <leader>hi :HoogleInfo<CR>
" Hoogle for detailed documentation and prompt for input
nnoremap <leader>hI :HoogleInfo
" Hoogle, close the Hoogle window
nnoremap <silent> <leader>hc :HoogleClose<CR>

" https://github.com/raichoo/haskell-vim
let g:haskell_enable_quantification = 1         " to enable highlighting of forall
let g:haskell_enable_recursivedo = 1            " to enable highlighting of mdo and rec
let g:haskell_enable_arrowsyntax = 1            " to enable highlighting of proc
let g:haskell_enable_pattern_synonyms = 1       " to enable highlighting of pattern
let g:haskell_enable_typeroles = 1              " to enable highlighting of type roles
let g:haskell_enable_static_pointers = 1        " to enable highlighting of static

" Toggle this for vim-sexp to not go into insert mode after wrapping something
let g:sexp_insert_after_wrap = 1
" Toggle this to disable automatically creating closing brackets and quotes
let g:sexp_enable_insert_mode_mappings = 1
