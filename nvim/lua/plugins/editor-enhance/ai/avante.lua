return {
  dir = "/Volumes/t7ex/Documents/Github/avante.nvim",
  -- "yetone/avante.nvim",
  -- enabled = false,
  event = "VeryLazy",
  build = "make",
  opts = {
    -- provider = "openai", -- Only recommend using Claude
    claude = {
      endpoint = "https://" .. os.getenv("ANTHROPIC_DOMAIN"),
      model = "claude-3-5-sonnet-20240620",
      temperature = 0,
      max_tokens = 4096,
    },
    file_selector = {
      provider = "snacks",
      -- Options override for custom providers
      provider_opts = {},
    },
    mappings = {
      ask = "<leader>aa",
      edit = "<leader>ae",
      refresh = "<leader>ar",
      --- @class AvanteConflictMappings
      diff = {
        ours = "co",
        theirs = "ct",
        none = "c0",
        both = "cb",
        next = "]x",
        prev = "[x",
      },
      jump = {
        next = "]]",
        prev = "[[",
      },
      submit = {
        normal = "<C-s>",
        insert = "<C-s>",
      },
      toggle = {
        debug = "<leader>ad",
        hint = "<leader>ah",
      },
    },
  },
  dependencies = {
    "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    --- The below is optional, make sure to setup it properly if you have lazy=true
    {
      "MeanderingProgrammer/render-markdown.nvim",
      opts = {
        file_types = { "markdown", "Avante" },
      },
      ft = { "markdown", "Avante" },
    },
  },
}
