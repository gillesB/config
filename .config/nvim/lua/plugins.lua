require 'paq' {
  'savq/paq-nvim', -- Let Paq manage itself

  'justinmk/vim-printf',

  -- git clone https://github.com/sunaku/dasht
  -- dasht-docsets-install python
  'sunaku/vim-dasht',

  'https://github.com/justinmk/vim-ipmotion.git',
  'https://github.com/justinmk/vim-gtfo.git',
  'https://github.com/justinmk/vim-dirvish.git',

  {
    'glacambre/firenvim',
    run = function() vim.fn['firenvim#install'](0) end,
  },

  'https://github.com/justinmk/vim-sneak.git',

  'tpope/vim-characterize',
  'tpope/vim-scriptease',
  'tpope/vim-apathy',
  'tpope/vim-dadbod',

  {'will133/vim-dirdiff', opt=true},
  -- gh wrapper: https://github.com/pwntester/octo.nvim
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',

  'tpope/vim-surround',

  'tpope/vim-dispatch',

  'tpope/vim-repeat',
  'tpope/vim-eunuch',
  'tpope/vim-rsi',

  'tpope/vim-unimpaired',
  'tpope/vim-endwise',
  'tommcdo/vim-lion',
  'tommcdo/vim-exchange',

  'haya14busa/vim-edgemotion',

  'tpope/vim-obsession',

  'AndrewRadev/linediff.vim',
  {'mbbill/undotree', opt=true},

  'tpope/vim-commentary',

  {'guns/vim-sexp', opt=true},
  {'guns/vim-clojure-highlight', opt=true},

  {'tpope/vim-salve', opt=true},
  {'tpope/vim-fireplace', opt=true},

  'justinmk/nvim-repl',

  'leafgarland/typescript-vim',
  {'chrisbra/Colorizer', opt=true},

  'junegunn/fzf',
  'junegunn/fzf.vim',

  'tpope/vim-projectionist',

  -- use'mfussenegger/nvim-lsp-compl',
  'neovim/nvim-lspconfig',

  'nvim-lua/plenary.nvim',
  'lewis6991/gitsigns.nvim',

  -- :packadd nvim-treesitter | packadd playground
  { 'nvim-treesitter/playground', opt=true, },
  { 'nvim-treesitter/nvim-treesitter', opt=true,
    -- run = function() vim.cmd('TSUpdate') end,
  },
}

vim.cmd([[nnoremap <silent> gK :call Dasht([expand('<cword>'), expand('<cWORD>')])<CR>]])

-- Disable netrw, but autoload it for `gx`.
vim.cmd([[
  let g:loaded_netrwPlugin = 0
  nnoremap <silent> <Plug>NetrwBrowseX :call netrw#BrowseX(expand((exists("g:netrw_gx")? g:netrw_gx : '<cfile>')),netrw#CheckIfRemote())<CR>
  nmap gx <Plug>NetrwBrowseX
]])

vim.cmd([[
  nnoremap <D-v> "+p
  inoremap <D-v> <esc>"+pa
]])

vim.cmd([[
  let g:sneak#label = 1
  let g:sneak#use_ic_scs = 1
  let g:sneak#absolute_dir = 1
  map <M-;> <Plug>Sneak_,
]])

vim.g.surround_indent = 0
vim.g.surround_no_insert_mappings = 1

vim.g.dispatch_no_tmux_make = 1  -- Prefer job strategy even in tmux.
vim.cmd([[nnoremap mT mT:FocusDispatch VIMRUNTIME= TEST_FILE=<c-r>% TEST_FILTER= TEST_TAG= make functionaltest<S-Left><S-Left><S-Left><Left>]])
-- nnoremap <silent> yr  :<c-u>set opfunc=<sid>tmux_run_operator<cr>g@
-- xnoremap <silent> R   :<c-u>call <sid>tmux_run_operator(visualmode(), 1)<CR>

vim.cmd([[
  nmap <C-j> m'<Plug>(edgemotion-j)
  nmap <C-k> m'<Plug>(edgemotion-k)
  xmap <C-j> m'<Plug>(edgemotion-j)
  xmap <C-k> m'<Plug>(edgemotion-k)
  omap <C-j> <Plug>(edgemotion-j)
  omap <C-k> <Plug>(edgemotion-k)
]])

vim.cmd([====[
  inoremap (<CR> (<CR>)<Esc>O
  inoremap {<CR> {<CR>}<Esc>O
  inoremap {; {<CR>};<Esc>O
  inoremap {, {<CR>},<Esc>O
  inoremap [<CR> [<CR>]<Esc>O
  inoremap ([[ ([[<CR>]])<Esc>O
  inoremap ([=[ ([=[<CR>]=])<Esc>O
  inoremap [; [<CR>];<Esc>O
  inoremap [, [<CR>],<Esc>O
]====])

vim.g.obsession_no_bufenter = 1  -- https://github.com/tpope/vim-obsession/issues/40

vim.g.linediff_buffer_type = 'scratch'

vim.g.clojure_fold = 1
vim.g.sexp_filetypes = ''

vim.g.salve_auto_start_repl = 1

vim.cmd([[
  nmap yx       <Plug>(ReplSend)
  nmap yxx      <Plug>(ReplSendLine)
  xmap <Enter>  <Plug>(ReplSend)
  nnoremap <c-q> :Repl<CR>
]])

vim.g.fzf_command_prefix = 'Fz'

vim.api.nvim_set_var('projectionist_heuristics', {
    ['package.json'] = {
      ['package.json'] = {['alternate'] = {'package-lock.json'}},
      ['package-lock.json'] = {['alternate'] = {'package.json'}},
    },
    ['*.sln'] = {
      ['*.cs'] = {['alternate'] = {'{}.designer.cs'}},
      ['*.designer.cs'] = {['alternate'] = {'{}.cs'}},
    },
    ['/*.c|src/*.c'] = {
      ['*.c'] = {['alternate'] = {'../include/{}.h', '{}.h'}},
      ['*.h'] = {['alternate'] = '{}.c'},
    },
    ['Makefile'] = {
      ['Makefile'] = {['alternate'] = 'CMakeLists.txt'},
      ['CMakeLists.txt'] = {['alternate'] = 'Makefile'},
    },
  })

-- Eager-load these plugins so we can override their settings. {{{
vim.cmd([[
  runtime! plugin/rsi.vim
  runtime! plugin/commentary.vim
]])

local function on_attach(client, bufnr)
  -- require'lsp_compl'.attach(client, bufnr, { server_side_fuzzy_completion = true })
  vim.cmd([[
  nnoremap <buffer> K <cmd>lua vim.lsp.buf.hover()<cr>
  nnoremap <buffer> crq <cmd>lua vim.diagnostic.setqflist()<cr>
  nnoremap <buffer> crr <cmd>lua vim.lsp.buf.code_action()<cr>
  nnoremap <buffer> crR <cmd>lua vim.lsp.buf.rename()<cr>
  nnoremap <buffer> gO <cmd>lua vim.lsp.buf.document_symbol()<cr>
  nnoremap <buffer> gd <cmd>lua vim.lsp.buf.definition()<cr>
  nnoremap <buffer> gr <cmd>lua vim.lsp.buf.references()<cr>
  nnoremap <buffer> gi <cmd>lua vim.lsp.buf.implementation()<cr>
  setlocal omnifunc=v:lua.vim.lsp.omnifunc
  ]])
end

-- xxx
local idk = function()
  require'lspconfig'.clangd.setup{
    cmd = { [[/usr/local/opt/llvm/bin/clangd]] },
    on_attach = on_attach,
    on_exit = function(...)
      require'vim.lsp.log'.error('xxx on_exit: '..vim.inspect((...)))
    end,
  }
  require'lspconfig'.tsserver.setup{
    on_attach = on_attach,
  }

  require('gitsigns').setup()
  vim.cmd([[
    hi! link GitSignsChange Normal
  ]])

end

local function setup_lua_lsp()  -- https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#sumneko_lua
  -- if vim.fn.exepath('lua-language-server') == '' then
  --   vim.cmd(string.format('autocmd UIEnter * ++once echom "lua-language-server not found'))
  -- end

  local runtime_path = vim.split(package.path, ';')
  table.insert(runtime_path, 'lua/?.lua')
  table.insert(runtime_path, 'lua/?/init.lua')

  require'lspconfig'.sumneko_lua.setup {
    cmd = {'lua-language-server'};
    on_attach = on_attach,
    settings = {
      Lua = {
        runtime = {
          -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
          version = 'LuaJIT',
          -- Setup your lua path
          path = runtime_path,
        },
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = {'vim'},
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          library = vim.api.nvim_get_runtime_file('', true),
        },
        -- Do not send telemetry data containing a randomized but unique identifier
        telemetry = {
          enable = false,
        },
      },
    },
  }
end

local function set_esc_keymap()
  vim.cmd([[autocmd TermOpen * tnoremap <buffer> <Esc> <C-\><C-N>]])
  if 1 == vim.fn.exists('$NVIM')  then
    local function parent_chan()
      local ok, chan = pcall(vim.fn.sockconnect, 'pipe', vim.env.NVIM, {rpc=true})
      return ok and chan or nil
    end
    local chan = parent_chan()
    if not chan then return end
    -- Unmap <Esc> in the parent so it gets sent to the child (this) Nvim.
    local esc_mapdict = vim.fn.rpcrequest(chan, 'nvim_exec_lua', [[return vim.fn.maparg('<Esc>', 't', false, true)]], {})
    if esc_mapdict.rhs == [[<C-\><C-N>]] then
      vim.fn.rpcrequest(chan, 'nvim_exec_lua', [=[vim.cmd('tunmap <buffer> <Esc>')]=], {})
      vim.fn.chanclose(chan)
      vim.api.nvim_create_autocmd({'VimLeave'}, { callback = function()
        chan = parent_chan()
        if not chan then return end
        -- Restore the <Esc> mapping on VimLeave.
        vim.fn.rpcrequest(chan, 'nvim_exec_lua', [=[
          local esc_mapdict = ...
          vim.fn.mapset('t', false, esc_mapdict)
        ]=], {esc_mapdict})
        vim.fn.chanclose(chan)
      end, })
    end
  end
end

set_esc_keymap()
idk()
setup_lua_lsp()
