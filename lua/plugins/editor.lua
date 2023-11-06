local U = require("util")
return {

  -- file explorer
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    cmd = "Neotree",
    keys = {
      {
        "<leader>fe",
        function()
          require("neo-tree.command").execute({ toggle = true, dir = vim.loop.cwd() })
        end,
        desc = "Explorer NeoTree (cwd)",
      },
      {
        "<leader>ge",
        function()
          require("neo-tree.command").execute({ source = "git_status", toggle = true })
        end,
        desc = "Git explorer",
      },
      {
        "<leader>be",
        function()
          require("neo-tree.command").execute({ source = "buffers", toggle = true })
        end,
        desc = "Buffer explorer",
      },
    },
    opts = {
      sources = { "filesystem", "buffers", "git_status", "document_symbols" },
      open_files_do_not_replace_types = { "terminal", "Trouble", "qf", "Outline" },
      filesystem = {
        bind_to_cwd = false,
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
        hide_hidden = false, -- only works on Windows for hidden files/directories
      },
      window = {
        mappings = {
          ["<space>"] = "none",
        },
      },
      default_component_configs = {
        indent = {
          with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
          expander_collapsed = "",
          expander_expanded = "",
          expander_highlight = "NeoTreeExpander",
        },
      },
    },
  },

  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    version = false, -- telescope did only one release, so use HEAD for now
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        enabled = vim.fn.executable("make") == 1,
        config = function()
          require("telescope").load_extension("fzf")
        end
      },
    },
    keys = {
      { "<leader>,",  "<cmd>Telescope buffers show_all_buffers=true<cr>",                       desc = "Switch Buffer" },
      { "<leader>:",  "<cmd>Telescope command_history<cr>",                                     desc = "Command History" },
      -- find
      { "<leader>ff", U.telescope("files"), desc = "Find Files (cwd)" },
      { "<leader>fF", U.telescope("files", { cwd = false }), desc = "Find Files (root)" },
      { "<leader>fa", "<cmd> Telescope find_files follow=true no_ignore=true hidden=true <cr>", desc = "Find all" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>",                                             desc = "Buffers" },
      { "<leader>fR", U.telescope("oldfiles", { cwd = vim.loop.cwd() }), desc = "Recent (cwd)" },
      { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent" },
      { "<leader>fc", "<cmd>lua require('telescope.builtin').find_files({cwd = vim.fn.stdpath('config')})<cr>", desc = "Config dir" },
      { "<leader>sg", U.telescope("live_grep"), desc = "Grep (cwd)" },
      { "<leader>sG", U.telescope("live_grep", { cwd = false }), desc = "Grep (root)" },
      { "<leader>sw", U.telescope("grep_string"), desc = "Word (cwd)" },
      { "<leader>sW", U.telescope("grep_string", { cwd = false }), desc = "Word (root)" },
      { "<leader>uC", U.telescope("colorscheme", { enable_preview = true }), desc = "Colorscheme with preview" },
      -- git
      { "<leader>gc", "<cmd>Telescope git_commits<CR>",                                         desc = "commits" },
      { "<leader>gs", "<cmd>Telescope git_status<CR>",                                          desc = "status" },
      -- search
      { '<leader>s"', "<cmd>Telescope registers<cr>",                                           desc = "Registers" },
      { "<leader>sa", "<cmd>Telescope autocommands<cr>",                                        desc = "Auto Commands" },
      { "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>",                           desc = "Buffer" },
      { "<leader>sc", "<cmd>Telescope command_history<cr>",                                     desc = "Command History" },
      { "<leader>sC", "<cmd>Telescope commands<cr>",                                            desc = "Commands" },
      {
        "<leader>sd",
        "<cmd>Telescope diagnostics bufnr=0<cr>",
        desc =
        "Document diagnostics"
      },
      {
        "<leader>sD",
        "<cmd>Telescope diagnostics<cr>",
        desc =
        "Workspace diagnostics"
      },
      { "<leader>sh", "<cmd>Telescope help_tags<cr>",   desc = "Help Pages" },
      {
        "<leader>sH",
        "<cmd>Telescope highlights<cr>",
        desc =
        "Search Highlight Groups"
      },
      {
        "<leader>ss",
        function()
          require("telescope.builtin").lsp_document_symbols({
            symbols = require("util").get_kind_filter(),
          })
        end,
        desc = "Goto Symbol",
      },
      {
        "<leader>sS",
        function()
          require("telescope.builtin").lsp_dynamic_workspace_symbols({
            symbols = require("util").get_kind_filter(),
          })
        end,
        desc = "Goto Symbol (Workspace)",
      },
      { "<leader>sk", "<cmd>Telescope keymaps<cr>",     desc = "Key Maps" },
      { "<leader>sM", "<cmd>Telescope man_pages<cr>",   desc = "Man Pages" },
      { "<leader>sm", "<cmd>Telescope marks<cr>",       desc = "Jump to Mark" },
      { "<leader>so", "<cmd>Telescope vim_options<cr>", desc = "Options" },
      { "<leader>sR", "<cmd>Telescope resume<cr>",      desc = "Resume" },
      { "<leader>uC", "<cmd>Telescope colorscheme<cr>", desc = "Colorscheme" },
    },
    opts = function()
      local actions = require("telescope.actions")
      return {
        defaults = {
          prompt_prefix = " ",
          selection_caret = " ",
          -- open files in the first window that is an actual file.
          -- use the current window if no other window is available.
          get_selection_window = function()
            local wins = vim.api.nvim_list_wins()
            table.insert(wins, 1, vim.api.nvim_get_current_win())
            for _, win in ipairs(wins) do
              local buf = vim.api.nvim_win_get_buf(win)
              if vim.bo[buf].buftype == "" then
                return win
              end
            end
            return 0
          end,
          mappings = {
            i = {
              ["<a-i>"] = find_files_no_ignore,
              ["<a-h>"] = find_files_with_hidden,
              ["<C-Down>"] = actions.cycle_history_next,
              ["<C-Up>"] = actions.cycle_history_prev,
              ["<C-f>"] = actions.preview_scrolling_down,
              ["<C-b>"] = actions.preview_scrolling_up,
            },
            n = {
              ["q"] = actions.close,
            },
          },
        },
      }
    end,
  },

  -- git signs highlights text that has changed since the list
  -- git commit, and also lets you interactively stage & unstage
  -- hunks in a commit.
  {
    "lewis6991/gitsigns.nvim",
    ft = { "gitcommit", "diff" },
    init = function()
      -- load gitsigns only when a git file is opened
      vim.api.nvim_create_autocmd({ "BufRead" }, {
        group = vim.api.nvim_create_augroup("GitSignsLazyLoad", { clear = true }),
        callback = function()
          vim.fn.system("git -C " .. '"' .. vim.fn.expand "%:p:h" .. '"' .. " rev-parse")
          if vim.v.shell_error == 0 then
            vim.api.nvim_del_augroup_by_name "GitSignsLazyLoad"
            vim.schedule(function()
              require("lazy").load { plugins = { "gitsigns.nvim" } }
            end)
          end
        end,
      })
    end,
    -- event = { "BufReadPost", "BufNewFile", "BufWritePost" },
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end

        -- stylua: ignore start
        map("n", "]h", gs.next_hunk, "Next Hunk")
        map("n", "[h", gs.prev_hunk, "Prev Hunk")
        map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
        map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
        map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
        map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
        map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
        map("n", "<leader>ghp", gs.preview_hunk, "Preview Hunk")
        map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame Line")
        map("n", "<leader>ghd", gs.diffthis, "Diff This")
        map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff This ~")
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
      end,
    },
  },

  {
    "echasnovski/mini.bufremove",

    keys = {
      {
        "<leader>bd",
        function()
          local bd = require("mini.bufremove").delete
          if vim.bo.modified then
            local choice = vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname()), "&Yes\n&No\n&Cancel")
            if choice == 1 then -- Yes
              vim.cmd.write()
              bd(0)
            elseif choice == 2 then -- No
              bd(0, true)
            end
          else
            bd(0)
          end
        end,
        desc = "Delete Buffer",
      },
      -- stylua: ignore
      { "<leader>bD", function() require("mini.bufremove").delete(0, true) end, desc = "Delete Buffer (Force)" },
    },
  },
}
