" Windows Registry Editor Version 5.00
"
" [HKEY_CLASSES_ROOT\*\shell\Edit with Vim]
"
" [HKEY_CLASSES_ROOT\*\shell\Edit with Vim\command]
" @="nvim-qt.exe \"%L\""
"==============================================================================

let g:loaded_rrhelper = 1
let g:did_install_default_menus = 1  " avoid stupid menu.vim (saves ~100ms)

try
  lua require('plugins')
catch
  fun! InstallPlug() " Bootstrap plugin manager on new systems.
lua << EOF
  print(vim.fn.system({'git', 'clone', 'https://github.com/savq/paq-nvim.git',
    vim.fn.stdpath('data')..'/site/pack/paqs/start/paq-nvim'}))
EOF
  endfun
endtry

" Use <C-L> to:
"   - redraw
"   - clear 'hlsearch'
"   - update the current diff (if any)
" Use {count}<C-L> to:
"   - reload (:edit) the current buffer
nnoremap <silent><expr> <C-L> (v:count ? ':<C-U>:call <SID>save_change_marks()\|edit\|call <SID>restore_change_marks()<CR>' : '')
      \ . ':nohlsearch'.(has('diff')?'\|diffupdate':'')
      \ . '<CR><C-L>'

command! Session if filereadable(stdpath('config').'/session.vim') | exe 'source '.stdpath('config').'/session.vim'
      \ | else | exe 'Obsession '.stdpath('config').'/session.vim' | endif
set sessionoptions-=blank

"==============================================================================
" general settings / options
"==============================================================================
set fillchars+=msgsep:‾,eob:·
set inccommand=split

" https://github.com/neovim/neovim/issues/3463#issuecomment-148757691
" autocmd CursorHold,FocusGained,FocusLost * silent! rshada|silent! wshada
" :checktime is SLOW
" autocmd CursorHold,FocusGained * silent! checktime

set shada^=r/tmp/,r/private/,rfugitive:,rzipfile:,rterm:,rhealth:
set jumpoptions+=view
set cpoptions-=_
set guicursor+=n:blinkon175
au UIEnter * set guifont=Menlo:h20

" Don't mess with 'tabstop', with 'expandtab' it isn't used.
" Set softtabstop=-1 to mirror 'shiftwidth' is used.
set expandtab shiftwidth=2 softtabstop=-1
autocmd FileType * autocmd CursorMoved * ++once if !&expandtab | set listchars+=tab:\ \  | endif

let g:mapleader = "z,"

set undofile
set list
set fileformats=unix,dos

" [i, [d
set path+=/usr/lib/gcc/**/include
" neovim
set path+=build/src/nvim/auto/**,.deps/build/src/**/,src,src/nvim
" DWIM 'includeexpr': make gf work on filenames like "a/…" (in diffs, etc.).
set includeexpr=substitute(v:fname,'^[^\/]*/','','')

let g:sh_noisk = 1
set lazyredraw  " no redraws in macros
set cmdheight=2
set ignorecase " case-insensitive searching
set smartcase  " but become case-sensitive if you type uppercase characters

set foldopen-=search
set timeoutlen=3000
set noshowmode " Hide the mode text (e.g. -- INSERT --)
set foldlevelstart=99 "open all folds by default
if has('patch-7.4.314') | set shortmess+=c | endif

nnoremap <silent> yoz :<c-u>if &foldenable\|set nofoldenable\|
      \ else\|setl foldmethod=indent foldnestmax=2 foldlevel=0 foldenable\|set foldmethod=manual\|endif<cr>

nnoremap yoT :<c-u>setlocal textwidth=<C-R>=(!v:count && &textwidth != 0) ? 0 : (v:count ? v:count : 80)<CR><CR>

set nostartofline
set cursorline
set diffopt+=hiddenoff,linematch:60

if exists('g:vscode')
  xnoremap Y "+y

  nnoremap <silent> <c-k> <Cmd>call VSCodeCall('editor.action.showHover')<CR>
  nnoremap <silent> gD <Cmd>call VSCodeCall('editor.action.goToImplementation')<CR>
  nnoremap <silent> gr <Cmd>call VSCodeCall('references-view.find')<CR>
  nnoremap <silent> gR <Cmd>call VSCodeCall('references-view.findImplementations')<CR>
  nnoremap <silent> <delete> <Cmd>call VSCodeCall('editor.debug.action.toggleBreakpoint')<CR>
  " nnoremap <silent> gO <Cmd>call VSCodeCall('workbench.action.gotoSymbol')<CR>
  nnoremap <silent> gO <Cmd>call VSCodeCall('outline.focus')<CR>
  nnoremap <silent> z/ <Cmd>call VSCodeCall('workbench.action.showAllSymbols')<CR>
  nnoremap <silent> - <Cmd>call VSCodeCall('workbench.files.action.showActiveFileInExplorer')<CR>
  nnoremap <silent> <c-b> <Cmd>call VSCodeCall('workbench.action.showAllEditorsByMostRecentlyUsed')<CR>
  nnoremap <silent> ]c <Cmd>call VSCodeCall('workbench.action.editor.nextChange')<CR>
  nnoremap <silent> [c <Cmd>call VSCodeCall('workbench.action.editor.previousChange')<CR>

  nnoremap <silent> UD <Cmd>call VSCodeCall('git.openChange')<CR>
  nnoremap <silent> UW <Cmd>call VSCodeCall('git.stage')<CR>
  nnoremap <silent> UB <Cmd>call VSCodeCall('gitlens.toggleFileBlame')<CR>
  finish
endif

"colorscheme {{{
func! s:colors() abort
    " Clear `Normal` cterm values, so terminal emulators won't treat negative
    " space as extra whitespace (makes mouse-copy nicer).
    hi Normal cterm=NONE ctermfg=NONE ctermbg=NONE guifg=white guibg=black
    " hi NormalNC ctermbg=234
    hi! link MsgSeparator WinSeparator
    hi Cursor gui=NONE cterm=NONE guibg=#F92672 guifg=white ctermbg=47 ctermfg=black
    hi Whitespace ctermfg=LightGray
    hi SpecialKey ctermfg=241 guifg=#626262
    hi! link SpecialChar Whitespace
    hi! link NonText Comment
    hi Comment guifg=#7E8E91 ctermfg=244
    hi! link Constant Normal

    hi QuickFixLine guifg=black guibg=cyan ctermfg=black ctermbg=cyan
    " Special should be (at least slightly) distinct from SpecialKey.
    hi Special ctermfg=LightCyan guifg=LightCyan
    " hi Special guifg=#F92672 gui=NONE ctermfg=197 cterm=NONE

    " cyan
    hi Identifier cterm=NONE ctermfg=cyan guifg=cyan gui=NONE
    hi! link Statement Identifier
    hi! link Exception Identifier
    hi! link Title Identifier
    " affects:
    "   - NONE string in 'hi Normal ctermfg=NONE …'
    "   - helpHeader
    hi! link PreProc Special

    hi! link Type Identifier
    hi String guifg=LightGreen guibg=NONE gui=NONE ctermfg=LightGreen ctermbg=NONE cterm=NONE
    hi MoreMsg guifg=cyan guibg=NONE gui=NONE ctermfg=cyan ctermbg=NONE cterm=NONE
    hi! link Question MoreMsg

    hi Todo guibg=white guifg=black ctermbg=white ctermfg=black
    hi! link WildMenu Search

    " completion/popup menu
    hi Pmenu guifg=#FFFFFF guibg=#585858 gui=NONE ctermfg=255 ctermbg=240 cterm=NONE
    hi! link PmenuSel Search
    hi PmenuSbar guibg=darkgray ctermbg=darkgray
    hi PmenuThumb ctermbg=lightgreen ctermfg=lightgreen

    " tabline
    " hi default link TabLineFill TabLine
    hi! link TabLineFill TabLine

    " diff (unified)
    hi diffAdded       guifg=#00ff5f gui=NONE      ctermfg=lightgreen  cterm=NONE
    hi diffRemoved     guifg=#ff5f5f gui=NONE      ctermfg=203 cterm=NONE
    hi link diffSubname Normal

    " diff (side-by-side)
    hi DiffAdd         guifg=#000000 guibg=#00ff5f ctermfg=0   ctermbg=lightgreen  gui=NONE cterm=NONE
    hi DiffChange      guifg=#FFFFFF guibg=#4C4745 ctermfg=255 ctermbg=239 gui=NONE cterm=NONE
    hi DiffDelete      guifg=#ff5f5f guibg=NONE    ctermfg=203 ctermbg=NONE gui=NONE cterm=NONE
    hi DiffText        guifg=black   guibg=cyan    ctermfg=16  ctermbg=cyan gui=NONE cterm=NONE

    "If 242 is too dark, keep incrementing...
    hi! link FoldColumn CursorLine
    hi Folded          guifg=#465457 guibg=NONE    ctermfg=242 ctermbg=NONE

    hi Error           guifg=#FFFFFF   guibg=Red   ctermfg=15 ctermbg=9
    hi ErrorMsg        ctermfg=203 ctermbg=NONE guifg=#ff5f5f guibg=#161821
    " alternative: 227, 185, 191 (too green)
    hi WarningMsg      guifg=#d7ff5f ctermfg=185

    " alternative: 227, 185, 191 (too green)
    " hi Search guifg=#000000 guibg=#d7ff5f ctermfg=0 ctermbg=227 gui=NONE cterm=NONE
    hi! Search ctermbg=LightCyan ctermfg=black guibg=LightCyan guifg=black
    hi! link IncSearch QuickFixLine
    hi! link CurSearch IncSearch
    hi! link Substitute QuickFixLine

    hi Visual gui=NONE cterm=NONE guifg=black guibg=white ctermfg=black ctermbg=white
    hi StatusLine cterm=bold,reverse gui=bold,reverse
    hi! link ColorColumn StatusLine
    hi! StatusLineNC cterm=underline ctermfg=243 ctermbg=234 gui=underline guifg=white guibg=black

    hi! link Directory Identifier
    hi CursorLine guibg=#303030 ctermbg=235 cterm=NONE
    hi! link CursorColumn CursorLine
    hi! link CursorLineSign CursorLine
    hi! link CursorLineFold CursorLine
    hi! link LineNr CursorLine
    hi! link SignColumn Normal
    hi! link CursorLineNr Normal

    hi SpellBad ctermbg=red ctermfg=255 cterm=undercurl gui=undercurl guisp=Red
    hi SpellCap ctermbg=lightgrey ctermfg=red cterm=undercurl gui=undercurl guisp=white
    hi! link SpellRare SpellCap

    hi Underlined ctermfg=NONE cterm=underline gui=underline guifg=NONE

    " other
    hi helpHyperTextJump cterm=underline ctermfg=cyan gui=underline guifg=cyan
    hi MatchParen cterm=bold,underline ctermfg=lightgreen ctermbg=NONE guifg=black guibg=white
endfunc
autocmd VimEnter * call <SID>colors()
"}}}

"==============================================================================
" text, tab and indent 

set formatoptions+=rno1l/
" don't syntax-highlight long lines
set synmaxcol=200

set linebreak
set nowrap

" key mappings/bindings =================================================== {{{

"tnoremap <expr> <C-R> '<C-\><C-N>"'.nr2char(getchar()).'pi'

" copy selection to gui-clipboard
xnoremap Y "+y
" copy entire file contents (to gui-clipboard if available)
nnoremap yY :let b:winview=winsaveview()<bar>exe 'keepjumps keepmarks norm ggVG"+y'<bar>call winrestview(b:winview)<cr>
inoremap <insert> <C-r>+

" Put fnameescape('…')
cnoremap <m-E> <c-r>=fnameescape('')<left><left>
" Put filename tail.
cnoremap <m-F> <c-r>=fnamemodify(@%, ':t')<cr>
" inVerse search: line NOT containing pattern
cnoremap <m-/> \v^(()@!.)*$<Left><Left><Left><Left><Left><Left><Left>

nnoremap g: :lua 
nnoremap z= <cmd>setlocal spell<CR>z=
nnoremap ' `
inoremap <C-space> <C-x><C-o>

" niceblock
xnoremap <expr> I (mode()=~#'[vV]'?'<C-v>^o^I':'I')
xnoremap <expr> A (mode()=~#'[vV]'?'<C-v>0o$A':'A')


nnoremap g> :set nomore<bar>echo repeat("\n",&cmdheight)<bar>40messages<bar>set more<CR>

xnoremap g/ <Esc>/\%V

" word-wise i_CTRL-Y
inoremap <expr> <c-y> pumvisible() ? "\<c-y>" : matchstr(getline(line('.')-1), '\%' . virtcol('.') . 'v\%(\k\+\\|.\)')

" current-file directory
noremap! <c-r><c-\> <c-r>=expand('%:p:h', 1)<cr>

noremap! <c-r>? <c-r>=substitute(getreg('/'), '[<>\\]', '', 'g')<cr>

" mark position before search
nnoremap / ms/

nnoremap <expr> n 'Nn'[v:searchforward]
nnoremap <expr> N 'nN'[v:searchforward]

" manage windows
"       [count]<c-w>s and [count]<c-w>v create a [count]-sized split
"       [count]<c-w>| and [count]<c-w>_ resize the current window
" user recommendation:
"       <c-w>eip
" available:
"       <c-w><space>{motion}
"       <c-_> (<c-->)
nnoremap <silent><M-h> <C-\><C-N><C-w><C-h>
nnoremap <silent><M-j> <C-\><C-N><C-w><C-j>
nnoremap <silent><M-k> <C-\><C-N><C-w><C-k>
nnoremap <silent><M-l> <C-\><C-N><C-w><C-l>
inoremap <silent><M-h> <C-\><C-N><C-w><C-h>
inoremap <silent><M-j> <C-\><C-N><C-w><C-j>
inoremap <silent><M-k> <C-\><C-N><C-w><C-k>
inoremap <silent><M-l> <C-\><C-N><C-w><C-l>
tnoremap <silent><M-h> <C-\><C-N><C-w><C-h>
tnoremap <silent><M-j> <C-\><C-N><C-w><C-j>
tnoremap <silent><M-k> <C-\><C-N><C-w><C-k>
tnoremap <silent><M-l> <C-\><C-N><C-w><C-l>
nnoremap Zh     :leftabove vsplit<CR>
nnoremap Zj     :belowright split<CR>
nnoremap Zk     :aboveleft split<CR>
nnoremap Zl     :rightbelow vsplit<CR>
nmap     ZH     Zh
nmap     ZJ     Zj
nmap     ZK     Zk
nmap     ZL     Zl
nnoremap <M-n> :call <SID>buf_new()<CR>
nnoremap <silent><expr> <tab> (v:count > 0 ? '<C-w>w' : ':call <SID>switch_to_alt_win()<CR>')
nnoremap <silent>      <s-tab>  <C-^>
nnoremap <m-i> <c-i>
" inoremap <c-r><c-w> <esc>:call <sid>switch_to_alt_win()<bar>let g:prev_win_buf=@%<cr><c-w><c-p>gi<c-r>=g:prev_win_buf<cr>
" nnoremap y@%   :<c-u>let @"=@%<cr>

" Fit current window (vertically) to the buffer text.
nnoremap <silent> <m-=> <cmd>exe min([winheight('%'),line('$')]).'wincmd _'<bar>setlocal winfixheight<cr>
" Fit current window (vertically) to the selected text.
xnoremap <silent> <m-=> <esc><cmd>exe (line("'>") - line("'<") + 1).'wincmd _'<bar>setlocal winfixheight<cr>

" go to the previous window (or any other window if there is no 'previous' window).
func! s:switch_to_alt_win() abort
  let currwin = winnr()
  wincmd p
  if winnr() == currwin "window didn't change; no previous window.
    wincmd w
  endif
endf

func! s:get_alt_winnr() abort
  call s:switch_to_alt_win()
  let n = winnr()
  call s:switch_to_alt_win()
  return n
endf

" manage tabs
nnoremap <silent> <M-t>    :tab split<cr>
nnoremap <silent> ZT       :tabclose<cr>
" move tab to Nth position
nnoremap <expr> <M-L> ':<C-u>tabmove '.(v:count ? (v:count - 1) : '+1').'<CR>'
nnoremap <expr> <M-H> ':<C-u>tabmove '.(v:count ? (v:count - 1) : '-1').'<CR>'

" manage buffers
nnoremap <expr><silent> ZB  ':<c-u>call <SID>buf_kill('. !v:count .')<cr>'

" quickfix window (in quickfix: toggles between qf & loc list)
nnoremap <silent><expr> <M-q> '@_:'.(&bt!=#'quickfix'<bar><bar>!empty(getloclist(0))?'lclose<bar>botright copen':'cclose<bar>botright lopen')
      \.(v:count ? '<bar>wincmd L' : '').'<CR>'

nnoremap <expr> zt (v:count > 0 ? '@_zt'.v:count.'<c-y>' : 'zt')
nnoremap <expr> zb (v:count > 0 ? '@_zb'.v:count.'<c-e>' : 'zb')
nnoremap <up> <c-u>
nnoremap <down> <c-d>

if has('nvim') && isdirectory(stdpath('data').'/site/pack/paqs/start/vim-fugitive')
  func! s:ctrl_g(cnt) abort
    redraw
    redir => msg | silent exe "norm! 1\<c-g>" | redir END
    " Show git branch.
    echo FugitiveHead(7) msg[2:] (a:cnt?strftime('%Y-%m-%d %H:%M',getftime(expand('%:p'))):'')
    " Show current directory.
    echo 'dir:' fnamemodify(getcwd(), ':~')
    " Show current session.
    echo 'ses:' (strlen(v:this_session) ? fnamemodify(v:this_session, ':~') : '<none>')
    " Show current context.
    " https://git.savannah.gnu.org/cgit/diffutils.git/tree/src/diff.c?id=eaa2a24#n464
    echohl ModeMsg
    echo getline(search('\v^[[:alpha:]$_]', 'bn', 1, 100))
    echohl None
  endf
  nnoremap <C-g> :<c-u>call <sid>ctrl_g(v:count)<cr>

  func! s:fug_detect() abort
    if !exists('b:git_dir')
      call FugitiveDetect()
    endif
  endfunc
endif

nmap <expr> <C-n> &diff?']c]n':(luaeval('({pcall(require, "gitsigns")})[1]')?'<cmd>lua require("gitsigns").next_hunk({wrap=false})<cr>':']n')
nmap <expr> <C-p> &diff?'[c[n':(luaeval('({pcall(require, "gitsigns")})[1]')?'<cmd>lua require("gitsigns").prev_hunk({wrap=false})<cr>':'[n')

" version control
xnoremap <expr> D (mode() ==# "V" ? ':Linediff<cr>' : 'D')
nnoremap <expr>   Ub              '@_<cmd>G blame '..(v:count?'--ignore-revs-file ""':'')..'<cr>'
nnoremap <silent> Uc              :G commit --edit -m <c-r>=shellescape(trim(join(<sid>git_do(['log', '-1', '--format=%s']))))<cr><cr>
nnoremap <silent> Ud              :<C-U>if &diff<bar>diffupdate<bar>elseif !v:count && empty(<SID>git_do(['diff', '--', FugitivePath()]))<bar>echo 'no changes'<bar>else<bar>exe 'Gvdiffsplit'.(v:count ? ' HEAD'.repeat('^', v:count) : '')<bar>call feedkeys('<c-v><c-l>')<bar>endif<cr>
nnoremap <silent> Ue              :Gedit<cr>
nnoremap          Uf              :G commit --fixup=
nnoremap <silent> Ug              :echo 'use UU'<cr>
nnoremap <expr>   Ul              '@_<cmd>G log --pretty="%h%d %s  %aL (%cr)" --date=relative'.(v:count?'':' -- %').'<cr>'
nnoremap          U:              :G log --pretty="%h%d %s  %aL (%cr)" --date=relative 
nnoremap          Um              :G log --pretty="%h%d %s  %aL (%cr)" --date=relative -L :<C-r><C-w>:<C-r>%
nnoremap <silent> Up              :<c-u>call <sid>fug_detect()<bar>call <sid>git_blame_line(FugitiveGitPath(expand('%')), line('.'))<CR>
nnoremap <silent> Ur              :Gread<cr>
nnoremap <silent> Us              :G<cr>
nnoremap <silent> Uu              :Gedit <C-R><C-W><cr>
nnoremap <silent> Uw              :call <sid>fug_detect()<bar>Gwrite<cr>
nnoremap <expr>   Ux              '@_:.GBrowse '.(v:count?'@':'<cr>')
xnoremap <expr>   Ux              ':.GBrowse '.(v:count?'@':'<cr>')

nmap UB Ub
nmap UC Uc
nmap UD Ud
nmap UE Ue
nmap UF Uf
nmap UG Ug
nmap UL Ul
nmap UM Um
nmap UP Up
nmap UR Ur
nmap US Us
nmap UU Uu
nmap UW Uw
nmap UX Ux
xmap UX Ux

"linewise partial staging in visual-mode.
xnoremap <c-p> :diffput<cr>
xnoremap <c-o> :diffget<cr>
nnoremap <expr> dp &diff ? 'dp' : ':Printf<cr>'

" Executes git cmd in the context of b:git_dir.
function! s:git_do(cmd) abort
  call s:fug_detect()
  " git 1.8.5: -C is a (more reliable) alternative to --git-dir/--work-tree.
  return systemlist(['git', '-C', fnamemodify(b:git_dir, ':p:h:h')] + a:cmd)
endfunction

" Gets the git commit hash associated with the given file line.
function! s:git_sha(filepath, line) abort
  if '' ==# s:trimws_ml(a:filepath)
    throw 'invalid (empty) filepath'
  elseif !exists("b:git_dir")
    throw 'Missing b:git_dir'
  elseif a:line <= 0
    throw 'Invalid a:line: '.a:line
  endif

  let cmd_out = join(s:git_do(['blame', '--root', '-l', '-L'.a:line.','.a:line, '--', a:filepath]))
  if cmd_out =~# '\v^0{40,}'
    return ''
  endif

  return matchstr(cmd_out, '\w\+\ze\W\?', 0, 1)
endfunction

function! s:git_blame_line(filepath, line) abort
  if '' ==# s:trimws_ml(a:filepath)
    echo 'cannot blame'
    return
  endif

  if 'blob' ==# get(b:,'fugitive_type','')
    " Use fugitive blame in fugitive buffers, instead of git directly.
    let commit_id = substitute(execute('.Gblame'), '\v\_s*(\S+)\s+.*', '\1', '')
  else
    " Use git directly.
    let commit_id = s:git_sha(a:filepath, a:line)
  endif

  if commit_id ==# ''
    echo 'not committed'
    return
  elseif commit_id ==# 'fatal'
    echo 'cannot blame'
    return
  endif

  " Find commit(s) with 0 parents.
  " Note: `git blame` prepends a caret ^ to root commits unless --root is
  "       passed. But it doesn't always mark the 'root' commits we are
  "       interested in, so collect them explicitly with `git rev-list`.
  let b:git_root_commits = get(b:, 'git_root_commits', s:git_do(['rev-list', '--max-parents=0', 'HEAD']))

  if -1 != index(b:git_root_commits, commit_id)
    echo 'root commit'
    return
  endif

  exe 'Gpedit '.commit_id
endfunction

" :help :DiffOrig
command! DiffOrig leftabove vnew | set bt=nofile | r ++edit # | 0d_ | diffthis | wincmd p | diffthis

nnoremap yo<space> :set <C-R>=(&diffopt =~# 'iwhiteall') ? 'diffopt-=iwhiteall' : 'diffopt+=iwhiteall'<CR><CR>

" Format filters
" ideas: https://github.com/sbdchd/neoformat
nnoremap gqax    :%!tidy -q -i -xml -utf8<cr>
nnoremap gqah    :%!tidy -q -i -ashtml -utf8<cr>
nnoremap gqaj    :%!python -m json.tool<cr>
nnoremap gqav    :call append('$', json_encode(eval(join(getline(1,'$')))))<cr>'[k"_dVgg:%!python -m json.tool<cr>

" available mappings:
"   visual: c-\ <space> m R c-r c-n c-g c-a c-x c-h,<bs><tab>
"   insert: c-\ c-g
"   normal: vd gy c-f c-t c-b c-j c-k + _ c-\ g= zu z/ m<enter> zy zi zp m<tab> q<special> y<special> q<special>
"           c<space>
"           !@       --> async run

func! s:compare_numbers(n1, n2) abort
  return a:n1 == a:n2 ? 0 : a:n1 > a:n2 ? 1 : -1
endfunc

func! s:compare_bufs(b1, b2) abort
  let b1_visible = index(tabpagebuflist(), a:b1) >= 0
  let b2_visible = index(tabpagebuflist(), a:b2) >= 0
  " - sort by buffer number (descending)
  " - prefer loaded, NON-visible buffers
  if bufloaded(a:b1)
    if bufloaded(a:b2)
      if b1_visible == b2_visible
        return s:compare_numbers(a:b1, a:b2)
      endif
      return s:compare_numbers(b2_visible, b1_visible)
    endif
    return 1
  endif
  return !bufloaded(a:b2) ? s:compare_numbers(a:b1, a:b2) : 1
endf

func! s:buf_find_displayed_bufs() abort " find all buffers displayed in any window, any tab.
  let bufs = []
  for i in range(1, tabpagenr('$'))
    call extend(bufs, tabpagebuflist(i))
  endfor
  return bufs
endf

func! s:buf_is_valid(bnr) abort
  " Exclude:
  "   - current
  "   - unlisted
  "   - buffers marked as 'readonly' AND 'modified' (netrw brain-damage)
  " Include: normal buffers; 'help' buffers
  return buflisted(a:bnr)
    \  && ("" ==# getbufvar(a:bnr, "&buftype") || "help" ==# getbufvar(a:bnr, "&buftype"))
    \  && a:bnr != bufnr("%")
    \  && -1 == index(tabpagebuflist(), a:bnr)
    \  && !(getbufvar(a:bnr, "&modified") && getbufvar(a:bnr, "&readonly"))
endfunc

" Gets the first empty, unchanged buffer not in the current tabpage.
func! s:buf_find_unused() abort
  for i in range(1, bufnr('$'))
    if bufexists(i)
          \&& -1 == index(tabpagebuflist(), i)
          \&& nvim_buf_get_changedtick(i) <= 2
          \&& buflisted(i)
          \&& bufname(i) ==# ''
          \&& getbufvar(i, '&buftype') ==# ''
      return i
    endif
  endfor
  return 0
endf

" Switches to a new (empty, unchanged) buffer or creates a new one.
func! s:buf_new() abort
  let newbuf = s:buf_find_unused()
  if newbuf == 0
    enew
  else
    exe 'buffer' newbuf
  endif
endf

func! s:buf_find_valid_next_bufs() abort
  let validbufs = filter(range(1, bufnr('$')), '<SID>buf_is_valid(v:val)')
  call sort(validbufs, '<SID>compare_bufs')
  return validbufs
endf

func! s:buf_switch_to_altbuff() abort
  " change to alternate buffer if it is not the current buffer (yes, that can happen)
  if buflisted(bufnr("#")) && bufnr("#") != bufnr("%")
    buffer #
    return 1
  endif

  " change to newest valid buffer
  let lastbnr = bufnr('$')
  if s:buf_is_valid(lastbnr)
    exe 'buffer '.lastbnr
    return 1
  endif

  " change to any valid buffer
  let validbufs = s:buf_find_valid_next_bufs()
  if len(validbufs) > 0
    exe 'buffer '.validbufs[0]
    return 1
  endif

  return 0
endf

" close the current buffer with a vengeance
" BDSN: Buffer DiScipliNe
func! s:buf_kill(mercy) abort
  let origbuf = bufnr("%")
  let origbufname = bufname(origbuf)
  if a:mercy && &modified
    echom 'buffer has unsaved changes (use "[count]ZB" to discard changes)'
    return
  endif

  if !s:buf_switch_to_altbuff()
    " No alternate buffer, create an empty buffer.
    " :bdelete still closes other windows displaying the buffer...
    call s:buf_new()
  endif

  " remove the buffer filename (if any) from the args list, else it might come back in the next session.
  if !empty(origbufname)
    silent! exe 'argdelete '.origbufname
  endif
  " obliterate the buffer and all of its related state (marks, local options, ...), 
  if bufexists(origbuf) "some other mechanism may have deleted the buffer already.
    exe 'bdelete! '.origbuf
  endif
endf

" un-join (split) the current line at the cursor position
nnoremap gj i<c-j><esc>k$
xnoremap x  "_d

nnoremap vK <C-\><C-N>:help <C-R><C-W><CR>

func! s:trimws_ml(s) abort "trim whitespace across multiple lines
  return substitute(a:s, '^\_s*\(.\{-}\)\_s*$', '\1', '')
endf
"why?
" - repeatable
" - faster/more convenient than visual-replace
" - does not modify ' mark
" - DWIM behavior for linewise => characterwise
let s:rr_reg = '"'
func! s:set_reg(reg_name) abort
  let s:rr_reg = a:reg_name
endf
func! s:replace_without_yank(type) abort
  let rr_orig = getreg(s:rr_reg, 1) "save registers and types to restore later.
  let rr_type = getregtype(s:rr_reg)
  let sel_save = &selection
  let &selection = "inclusive"
  let replace_curlin = (1==col("'[") && (col('$')==1 || col('$')==(col("']")+1)) && line("'[")==line("']"))

  if a:type ==? 'line' || replace_curlin
    exe "keepjumps normal! '[V']\"".s:rr_reg."P"
  elseif a:type ==? 'block'
    exe "keepjumps normal! `[\<C-V>`]\"".s:rr_reg."P"
  else
    "DWIM: if pasting linewise contents in a _characterwise_ motion, trim
    "      surrounding whitespace from the content to be pasted.
    if rr_type ==# "V"
      call setreg(s:rr_reg, s:trimws_ml(rr_orig), "v")
    endif
    exe "keepjumps normal! `[v`]\"".s:rr_reg."P"
  endif

  let &selection = sel_save
  call setreg(s:rr_reg, rr_orig, rr_type)
endf

nnoremap <silent> dr  :<C-u>call <sid>set_reg(v:register)<bar>set opfunc=<sid>replace_without_yank<CR>g@
nnoremap <silent> drr :<C-u>call <sid>set_reg(v:register)<cr>0:<C-u>set opfunc=<sid>replace_without_yank<CR>g@$

" text-object: entire buffer
" Elegant text-object pattern hacked out of jdaddy.vim.
function! s:line_outer_movement(count) abort
  if empty(getline(1)) && 1 == line('$')
    return "\<Esc>"
  endif
  let [lopen, copen, lclose, cclose] = [1, 1, line('$'), 1]
  call setpos("'[", [0, lopen, copen, 0])
  call setpos("']", [0, lclose, cclose, 0])
  return "'[o']"
endfunction
xnoremap <expr>   al <SID>line_outer_movement(v:count1)
onoremap <silent> al :normal Val<CR>

" text-object: line
" Elegant text-object pattern hacked out of jdaddy.vim.
function! s:line_inner_movement(count) abort
  "TODO: handle count
  if empty(getline('.'))
    return "\<Esc>"
  endif
  let [lopen, copen, lclose, cclose] = [line('.'), 1, line('.'), col('$')-1]
  call setpos("'[", [0, lopen, copen, 0])
  call setpos("']", [0, lclose, cclose, 0])
  return "`[o`]"
endfunction
xnoremap <expr>   il <SID>line_inner_movement(v:count1)
onoremap <silent> il :normal vil<CR>

" from tpope vimrc
inoremap <M-o> <C-O>o
inoremap <M-O> <C-O>O
inoremap <silent> <C-G><C-T> <C-R>=repeat(complete(col('.'),map(["%Y-%m-%d %H:%M:%S","%a, %d %b %Y %H:%M:%S %z","%Y %b %d","%d-%b-%y","%a %b %d %T %Z %Y","%Y%m%d"],'strftime(v:val)')+[localtime()]),0)<CR>

"do not clobber '[ '] on :write
function! s:save_change_marks() abort
  let s:change_marks = [getpos("'["), getpos("']")]
endfunction
function! s:restore_change_marks() abort
  call setpos("'[", s:change_marks[0])
  call setpos("']", s:change_marks[1])
endfunction
nnoremap z. :call <SID>save_change_marks()<Bar>w ++p<Bar>call <SID>restore_change_marks()<cr>

" select last inserted text
nnoremap gV `[v`]

" repeat last command for each line of a visual selection
xnoremap . :normal .<CR>
" XXX: fix this
" repeat the last edit on the next [count] matches.
nnoremap <silent> gn :normal n.<CR>:<C-U>call repeat#set("n.")<CR>
nnoremap <C-v>q q

" Replay @q or set it from v:register.
nnoremap <expr> q (v:register==#'"')?'q':(':let @'.(empty(reg_recorded())?'q':reg_recorded())." = '<C-R>=substitute(@".v:register.",\"'\",\"''\",\"g\")<CR>'<C-F>010l")
" Replay @q for each line of the visual selection.
xnoremap Q :normal @<c-r>=reg_recorded()<cr><cr>

nnoremap <expr> <c-w><c-q>  (v:count ? ':<c-u>confirm qa<cr>' : '<c-w><c-q>')
nnoremap <expr> <c-w>q      (v:count ? ':<c-u>confirm qa<cr>' : '<c-w><c-q>')
nnoremap <expr> ZZ          (v:count ? ':<c-u>xa!<cr>' : '@_ZZ')
nnoremap <expr> ZQ          (v:count ? ':<c-u>qa!<cr>' : '@_ZQ')
nnoremap <expr> <c-w>=      (v:count ? ':<c-u>windo setlocal nowinfixheight nowinfixwidth<cr><c-w>=' : '@_<c-w>=')

func! s:zoom_toggle(cnt) abort
  if a:cnt  " Fallback to default '|' behavior if count was provided.
    exe 'norm! '.v:count.'|'
  endif

  if 1 == winnr('$')
    return
  endif
  let restore_cmd = winrestcmd()
  wincmd |
  wincmd _
  if exists('t:zoom_restore')
    exe t:zoom_restore
    unlet t:zoom_restore
  elseif winrestcmd() !=# restore_cmd
    let t:zoom_restore = restore_cmd
  endif
endfunc
nnoremap +     :<C-U>call <SID>zoom_toggle(v:count)<CR>
nnoremap <Bar> :<C-U>call <SID>zoom_toggle(v:count)<CR>

func! ReadExCommandOutput(thisbuf, cmd) abort
  redir => l:message
  silent! execute a:cmd
  redir END
  if !a:thisbuf | wincmd n | endif
  silent put=l:message
endf
command! -nargs=+ -bang -complete=command R call ReadExCommandOutput(<bang>0, <q-args>)
inoremap <c-r>R <c-o>:<up><home>R! <cr>

func! s:get_visual_selection_list() abort
  let [lnum1, col1] = getpos("'<")[1:2]
  let [lnum2, col2] = getpos("'>")[1:2]
  let lines = getline(lnum1, lnum2)
  let lines[-1] = lines[-1][: col2 - (&selection ==? 'inclusive' ? 1 : 2)]
  let lines[0] = lines[0][col1 - 1:]
  return lines
endf

func! s:get_visual_selection_searchpattern() abort
  let lines = s:get_visual_selection_list()
  let lines = map(lines, 'escape(v:val, ''/\'')')
  " Join with a _literal_ \n to make a valid search pattern.
  return join(lines, '\n')
endf

"read last visual-selection into command line
cnoremap <c-r><c-v> <c-r>=join(<sid>get_visual_selection_list(), " ")<cr>
inoremap <c-r><c-v> <c-r>=join(<sid>get_visual_selection_list(), " ")<cr>

xnoremap * <esc>ms/\V<c-r>=<sid>get_visual_selection_searchpattern()<cr><cr>
nnoremap <silent> *  ms:<c-u>let @/='\V\<'.escape(expand('<cword>'), '/\').'\>'<bar>call histadd('/',@/)<bar>set hlsearch<cr>
nnoremap <silent> g* ms:<c-u>let @/='\V' . escape(expand('<cword>'), '/\')     <bar>call histadd('/',@/)<bar>set hlsearch<cr>

hi MarkLine guibg=darkred guifg=gray ctermbg=9 ctermfg=15
func! s:markline() abort
  call nvim_buf_add_highlight(bufnr('%'), 0, 'MarkLine', (line('.')-1), 0, -1)
endf
nnoremap <silent> m.  :call <sid>markline()<cr>
nnoremap <silent> m<bs> :call nvim_buf_clear_highlight(bufnr('%'), -1, 0, -1)<cr>

" }}} mappings

augroup vimrc_halo
  autocmd!
  autocmd FocusGained * if winnr('$') > 1 && &buftype!=#'terminal' | setlocal cursorcolumn | endif
    \ | autocmd FocusLost,CursorMoved,CursorMovedI,InsertEnter,WinLeave,WinScrolled * ++once setlocal nocursorcolumn
  " autocmd WinLeave * call setlocal nocursorcolumn
augroup END

augroup vimrc_autocmd
  autocmd!

  autocmd FileType text setlocal textwidth=80
  autocmd BufReadPost *.i setlocal filetype=c

  " Closes the current quickfix list and returns to the alternate window.
  func! s:close_qflist()
    let altwin = s:get_alt_winnr()
    wincmd c
    exe altwin.'wincmd w'
  endf
  autocmd FileType qf nnoremap <buffer> <c-p> <up>
        \|nnoremap <buffer> <c-n> <down>
        \|nnoremap <silent><buffer><nowait> gq :call <sid>close_qflist()<cr>
        \|setlocal nolist

  autocmd CmdwinEnter * nnoremap <nowait><silent><buffer> gq <C-W>c

  " :help restore-cursor
  autocmd BufRead * autocmd FileType <buffer> ++once
    \ if &ft !~# 'commit\|rebase' && line("'\"") > 1 && line("'\"") <= line("$") | exe 'normal! g`"' | endif

  autocmd BufNewFile,BufRead *.txt,README,INSTALL,NEWS,TODO if expand('<afile>:t') !=# 'CMakeLists.txt' | setf text | endif
  autocmd BufNewFile,BufRead *.proj set ft=xml "force filetype for msbuild
  autocmd FileType gitconfig setlocal commentstring=#\ %s
  " For the ":G log" buffer opened by the "UL" mapping.
  autocmd FileType git if get(b:, 'fugitive_type') ==# 'temp'
    \ | exe 'nnoremap <nowait><buffer><silent> <C-n> <C-\><C-n>0j:call feedkeys("p")<CR>'
    \ | exe 'nnoremap <nowait><buffer><silent> <C-p> <C-\><C-n>0k:call feedkeys("p")<CR>'
    \ | exe 'nnoremap <nowait><buffer><silent> gq <C-w>q'
    \ | match Comment /  \S\+ ([^)]\+)$/
    \ | endif
  function! s:setup_gitstatus() abort
    unmap <buffer> U
  endfunction
  autocmd FileType fugitive call <SID>setup_gitstatus()
  autocmd BufWinEnter * if exists("*FugitiveDetect") && empty(expand('<afile>'))|call FugitiveDetect(getcwd())|endif

  autocmd FileType css set omnifunc=csscomplete#CompleteCSS

  "when Vim starts in diff-mode (vim -d, git mergetool):
  "  - do/dp should not auto-fold
  autocmd VimEnter * if &diff | exe 'windo set foldmethod=manual' | endif

  " autocmd VimEnter * if !empty($NVIM)
  "       \ |let g:r=jobstart(['nc', '-U', $NVIM],{'rpc':v:true})
  "       \ |let g:f=fnameescape(expand('%:p'))
  "       \ |noau bwipe
  "       \ |call rpcrequest(g:r, "nvim_command", "tabedit ".g:f)|qa|endif

  " if exists('##TextYankPost')
  "   autocmd TextYankPost * let g:yankring=get(g:,'yankring',[])
  "     \|call add(g:yankring, join(v:event.regcontents[:999], "\n"))|if len(g:yankring)>10|call remove(g:yankring, 0, 1)|endif
  " endif
augroup END

if has('nvim-0.4')  " {{{ TextYankPost highlight
  function! s:hl_yank(operator, regtype, inclusive) abort
    if a:operator !=# 'y' || a:regtype ==# ''
      return
    endif
    " edge cases:
    "   ^v[count]l ranges multiple lines

    " TODO:
    "   bug: ^v where the cursor cannot go past EOL, so '] reports a lesser column.

    let bnr = bufnr('%')
    let ns = nvim_create_namespace('')
    call nvim_buf_clear_namespace(bnr, ns, 0, -1)

    let [_, lin1, col1, off1] = getpos("'[")
    let [lin1, col1] = [lin1 - 1, col1 - 1]
    let [_, lin2, col2, off2] = getpos("']")
    let [lin2, col2] = [lin2 - 1, col2 - (a:inclusive ? 0 : 1)]
    for l in range(lin1, lin1 + (lin2 - lin1))
      let is_first = (l == lin1)
      let is_last = (l == lin2)
      let c1 = is_first || a:regtype[0] ==# "\<C-v>" ? (col1 + off1) : 0
      let c2 = is_last || a:regtype[0] ==# "\<C-v>" ? (col2 + off2) : -1
      call nvim_buf_add_highlight(bnr, ns, 'TextYank', l, c1, c2)
    endfor
    call timer_start(300, {-> nvim_buf_is_valid(bnr) && nvim_buf_clear_namespace(bnr, ns, 0, -1)})
  endfunc
  highlight default link TextYank Visual
  augroup vimrc_hlyank
    autocmd!
    autocmd TextYankPost * call s:hl_yank(v:event.operator, v:event.regtype, v:event.inclusive)
  augroup END
endif  " }}}

" :shell
" Creates a global default :shell with maximum 'scrollback'.
func! s:ctrl_s(cnt, new, here) abort
  let init = { 'prevwid': win_getid() }
  let g:term_shell = a:new ? init : get(g:, 'term_shell', init)
  let d = g:term_shell
  let b = bufnr(':shell')

  if bufexists(b) && a:here  " Edit the :shell buffer in this window.
    exe 'buffer' b
    let d.prevwid = win_getid()
    return
  endif

  " Return to previous window.
  if bufnr('%') == b
    let term_prevwid = win_getid()
    if !win_gotoid(d.prevwid)
      wincmd p
    endif
    if bufnr('%') == b
      " Edge-case: :shell buffer showing in multiple windows in curtab.
      " Find a non-:shell window in curtab.
      let bufs = filter(tabpagebuflist(), 'v:val != '.b)
      if len(bufs) > 0
        exe bufwinnr(bufs[0]).'wincmd w'
      else
        " Last resort: WTF, just go to previous tab?
        " tabprevious
        return
      endif
    endif
    let d.prevwid = term_prevwid
    return
  endif

  " Go to existing :shell or create new.
  let curwinid = win_getid()
  if a:cnt == 0 && bufexists(b) && winbufnr(d.prevwid) == b
    call win_gotoid(d.prevwid)
  elseif bufexists(b)
    let w = bufwinid(b)
    if a:cnt == 0 && w > 0  " buffer exists in current tabpage
      call win_gotoid(w)
    else  " not in current tabpage; go to first found
      let ws = win_findbuf(b)
      if a:cnt == 0 && !empty(ws)
        call win_gotoid(ws[0])
      else
        exe ((a:cnt == 0) ? 'tab split' : a:cnt.'split')
        exe 'buffer' b
        " augroup nvim_shell
        "   autocmd!
        "   autocmd TabLeave <buffer> if winnr('$') == 1 && bufnr('%') == g:term_shell.termbuf | tabclose | endif
        " augroup END
      endif
    endif
  else
    let origbuf = bufnr('%')
    exe ((a:cnt == 0) ? 'tab split' : a:cnt.'split')
    terminal
    setlocal scrollback=-1
    " augroup nvim_shell
    "   autocmd!
    "   autocmd TabLeave <buffer> if winnr('$') == 1 && bufnr('%') == g:term_shell.termbuf | tabclose | endif
    " augroup END
    file :shell
    " XXX: original term:// buffer hangs around after :file ...
    bwipeout! #
    " Set alternate buffer to something intuitive.
    let @# = origbuf
    tnoremap <buffer> <C-s> <C-\><C-n>:call <SID>ctrl_s(0, v:false, v:false)<CR>
  endif
  " if a:enter
  "   startinsert  " enter terminal-mode
  " endif
  let d.prevwid = curwinid
endfunc
nnoremap <C-s> :<C-u>call <SID>ctrl_s(v:count, v:false, v:false)<CR>
nnoremap '<C-s> :<C-u>call <SID>ctrl_s(v:count, v:false, v:true)<CR>

set wildcharm=<C-Z>
nnoremap <expr> <C-b> v:count ? ':<c-u>'.v:count.'buffer<cr>' : ':set nomore<bar>ls<bar>set more<cr>:buffer<space>'
" _opt-in_ to sloppy-search https://github.com/neovim/neovim/issues/3209#issuecomment-133183790
nnoremap <C-f> :edit **/
nnoremap \t    :tag<space>
" See `man fnmatch`.
nnoremap \g  mS:Ggrep! -q -E <C-R>=shellescape(fnameescape(expand('<cword>')))<CR> -- ':/' ':/!*.mpack' ':/!*.pbf' ':/!*.pdf' ':/!*.po' ':(top,exclude,icase)notebooks/' ':/!data/' ':/!work/' ':/!qgis/' ':/!graphhopper_data/'
      \<Home><C-Right><C-Right><C-Right><C-Right><left>
nnoremap \v  mS:<c-u>noau vimgrep /\C/j **<left><left><left><left><left>
" search all file buffers (clear qf first).
nnoremap \b  mS:<c-u>cexpr []<bar>exe 'bufdo silent! noau vimgrepadd/\C/j %'<bar>botright copen<s-left><s-left><left><left><left>
" search current buffer and open results in loclist
nnoremap \c   ms:<c-u>lvimgrep // % <bar>lw<s-left><left><left><left><left>
" search-replace
nnoremap gsal mr:%s/
xnoremap gs   mr:s/\%V

" =============================================================================
" autocomplete / omnicomplete / tags
" =============================================================================
set dictionary+=/usr/share/dict/words
set completeopt-=preview
set complete+=kspell
set wildignore+=tags,gwt-unitCache/*,*/__pycache__/*,build/*,build.?/*,*/node_modules/*
" Files with these suffixes get a lower priority when matching a wildcard
set suffixes+=.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc
      \,.o,.obj,.dll,.class,.pyc,.ipynb,.so,.swp,.zip,.exe,.jar,.gz
" Better `gf`
set suffixesadd=.java,.cs

function! s:fzf_open_file_at_line(e) abort
  "Get the <path>:<line> tuple; fetch.vim plugin will handle the rest.
  execute 'edit' fnameescape(matchstr(a:e, '\v([^:]{-}:\d+)'))
endfunction
function! s:fzf_files() abort
  call fzf#run({
    \ 'source':'find . -type d \( -name build -o -name .git -o -name venv -o -name .vim-src -o -name buildd -o -name buildr -o -name .deps -o -name .vscode-test -o -name node_modules -o -name .coverage \) -prune -false -o -name "*"',
    \ 'sink':{f -> execute('edit '..f)}})
endfunction
function! s:fzf_search_fulltext() abort
  call fzf#run({
    \ 'source':'git grep --line-number --color=never -v "^[[:space:]]*$"',
    \ 'sink':function('<sid>fzf_open_file_at_line')})
endfunction

" Search current-working-directory _or_ current-file-directory
nnoremap <silent><expr> <M-/> v:count ? ':<C-U>call <SID>fzf_search_fulltext()<CR>' : ':<C-U>call <SID>fzf_files()<CR>'
" Search MRU files
nnoremap <silent>       <M-\> :FzHistory<cr>
nnoremap <silent><expr> <C-\> v:count ? 'mS:<C-U>FzLines<CR>' : ':<C-U>FzBuffers<CR>'

nnoremap <silent> gO    :call fzf#vim#buffer_tags('')<cr>
nnoremap <silent> z/    :call fzf#vim#tags('')<cr>


" Slides plugin {{{
func! s:slides_hl() abort
  if hlID('SlidesHide') == 0
    " use folds instead of highlight
  else
    exe 'match SlidesHide /\%>'.(line('w0')-1).'l\n=\{20}=*\n\_.\{-}\zs\n.*\n=\{20}=\_.*/'
  endif
endfunc
func! Slides(...) abort
  let editing = len(a:0) > 0 ? a:1 ==# 'editing' : 0
  if !editing
    set cmdheight=1
    set nowrapscan
    set nohlsearch
  endif

  try
    hi SlidesHide ctermbg=bg ctermfg=bg guibg=bg guifg=bg
  catch /E420/
  endtry
  hi markdownError ctermbg=NONE ctermfg=NONE guifg=NONE guibg=NONE

  nnoremap <buffer><silent> <Down> :keeppatterns /^======<CR>zt<C-Y>:call <SID>slides_hl()<CR>
  nnoremap <buffer><silent> <Up>   :keeppatterns ?^======<CR>zt<C-Y>:call <SID>slides_hl()<CR>
  nmap     <buffer><silent> <C-n>  <Down>
  nmap     <buffer><silent> <C-p>  <Up>
  setlocal colorcolumn=54,67 textwidth=53
  exe printf('hi ColorColumn gui%sg=#555555 cterm%sg=235', 'bf'[&bg], 'bf'[&bg])
  " hi SlidesSign guibg=white guifg=black ctermbg=black ctermfg=white gui=NONE cterm=NONE
  " sign define limit  text== texthl=SlidesSign
  " sign unplace
endf
func! SlidesEnd() abort
  call clearmatches()
  mapclear <buffer>
endf
" }}}

set title
set titlestring=%{getpid().':'.getcwd()}

" special-purpose mappings/commands ===========================================
nnoremap <leader>vft  :e ~/.config/nvim/after/ftplugin<cr>
nnoremap <leader>vv   :exe 'e' fnameescape(resolve($MYVIMRC))<cr>
nnoremap <leader>vp   :exe 'e' stdpath('config')..'/lua/plugins.lua'<cr>
nnoremap <leader>vs :Scriptnames<cr>

nnoremap <leader>== <cmd>set paste<cr>o<cr><c-r>=repeat('=',80)<cr><cr><c-r>=strftime('%Y%m%d')<cr><cr>.<cr><c-r>+<cr>tag=""<esc><cmd>set nopaste<cr>

xnoremap <leader>{ <esc>'<A {`>o}==`<

command! InsertCBreak         norm! i#include <signal.h>raise(SIGINT);
command! CdNvimLuaClient exe 'e '.finddir("nvim", expand("~")."/dev/neovim/.deps/usr/share/lua/**,".expand("~")."/dev/neovim/.deps/usr/share/lua/**")<bar>lcd %
command! CdVim          exe 'e '.finddir(".vim-src", expand("~")."/neovim/**,".expand("~")."/dev/neovim/**")<bar>lcd %
command! NvimTestScreenshot put =\"local Screen = require('test.functional.ui.screen')\nlocal screen = Screen.new()\nscreen:attach()\nscreen:snapshot_util({},true)\"
command! ConvertBlockComment keeppatterns .,/\*\//s/\v^((\s*\/\*)|(\s*\*\/)|(\s*\*))(.*)/\/\/\/\5/
command! -nargs=1 Vimref split ~/dev/neovim/.vim-src/|exe 'lcd %:h'|exe 'Gedit '.(-1 == match('<args>', '\v(\d+\.){2}')
      \? '<args>' : 'v'.matchstr('<args>', '\v(\d+\.){2}(\d)+'))
command! Tags !ctags -R -I EXTERN -I INIT --exclude='build*/**' --exclude='**/build*/**' --exclude='cdk.out/**' --exclude='**/cdk.out/**' --exclude='.vim-src/**' --exclude='**/dist/**' --exclude='node_modules/**' --exclude='**/node_modules/**' --exclude='venv/**' --exclude='**/site-packages/**' --exclude='data/**' --exclude='dist/**' --exclude='notebooks/**' --exclude='Notebooks/**' --exclude='*graphhopper_data/*.json' --exclude='*graphhopper/*.json' --exclude='*.json' --exclude='qgis/**'
  \ --exclude=.git --exclude=.svn --exclude=.hg --exclude="*.cache.html" --exclude="*.nocache.js" --exclude="*.min.*" --exclude="*.map" --exclude="*.swp" --exclude="*.bak" --exclude="*.pyc" --exclude="*.class" --exclude="*.sln" --exclude="*.Master" --exclude="*.csproj" --exclude="*.csproj.user" --exclude="*.cache" --exclude="*.dll" --exclude="*.pdb" --exclude=tags --exclude="cscope.*" --exclude="*.tar.*"
  \ *

" Neovim/Vim development
autocmd BufEnter */.vim-src/* setlocal nolist

function! Cxn_py() abort
  vsplit
  terminal
  call chansend(&channel, "python3\nimport pynvim\n")
  call chansend(&channel, "n = pynvim.attach('socket', path='".g:cxn."')\n")
endfunction
function! Cxn(addr) abort
  silent! unlet g:cxn
  tabnew
  if !empty(a:addr)  " Only start the client.
    let g:cxn = a:addr
    call Cxn_py()
    return
  endif

  terminal
  let nvim_path = executable('build/bin/nvim') ? 'build/bin/nvim' : 'nvim'
  call chansend(&channel, nvim_path." -u NORC\n")
  call chansend(&channel, ":let j=jobstart('nc -U ".v:servername."',{'rpc':v:true})\n")
  call chansend(&channel, ":call rpcrequest(j, 'nvim_set_var', 'cxn', v:servername)\n")
  call chansend(&channel, ":call rpcrequest(j, 'nvim_command', 'call Cxn_py()')\n")
endfunction
command! -nargs=* NvimCxn call Cxn(<q-args>)

function! s:init_lynx() abort
  nnoremap <nowait><buffer> <C-F> i<PageDown><C-\><C-N>
  tnoremap <nowait><buffer> <C-F> <PageDown>

  nnoremap <nowait><buffer> <C-B> i<PageUp><C-\><C-N>
  tnoremap <nowait><buffer> <C-B> <PageUp>

  nnoremap <nowait><buffer> <C-D> i:DOWN_HALF<CR><C-\><C-N>
  tnoremap <nowait><buffer> <C-D> :DOWN_HALF<CR>

  nnoremap <nowait><buffer> <C-U> i:UP_HALF<CR><C-\><C-N>
  tnoremap <nowait><buffer> <C-U> :UP_HALF<CR>

  nnoremap <nowait><buffer> <C-N> i<Delete><C-\><C-N>
  tnoremap <nowait><buffer> <C-N> <Delete>

  nnoremap <nowait><buffer> <C-P> i<Insert><C-\><C-N>
  tnoremap <nowait><buffer> <C-P> <Insert>

  nnoremap <nowait><buffer> u     i<Left><C-\><C-N>
  nnoremap <nowait><buffer> <C-R> i<C-U><C-\><C-N>
  nnoremap <nowait><buffer> <CR>  i<CR><C-\><C-N>
  nnoremap <nowait><buffer> gg    i:HOME<CR><C-\><C-N>
  nnoremap <nowait><buffer> G     i:END<CR><C-\><C-N>
  nnoremap <nowait><buffer> zl    i:SHIFT_LEFT<CR><C-\><C-N>
  nnoremap <nowait><buffer> zL    i:SHIFT_LEFT<CR><C-\><C-N>
  nnoremap <nowait><buffer> zr    i:SHIFT_RIGHT<CR><C-\><C-N>
  nnoremap <nowait><buffer> zR    i:SHIFT_RIGHT<CR><C-\><C-N>
  nnoremap <nowait><buffer> gh    i:HELP<CR><C-\><C-N>
  nnoremap <nowait><buffer> cow   i:LINEWRAP_TOGGLE<CR><C-\><C-N>

  tnoremap <buffer> <C-C> <C-G><C-\><C-N>
  nnoremap <buffer> <C-C> i<C-G><C-\><C-N>
endfunction
command! -nargs=1 Web       vnew|call termopen('lynx -use_mouse '.shellescape(<q-args>))|call <SID>init_lynx()
command! -nargs=1 Websearch vnew|call termopen('lynx -use_mouse https://duckduckgo.com/?q='.shellescape(substitute(<q-args>,'#','%23','g')))|call <SID>init_lynx()

silent! source ~/.vimrc.local

