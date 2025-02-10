-- https://theosteiner.de/debugging-javascript-frameworks-in-neovim
return {
  {
    -- debugger
    "microsoft/vscode-js-debug", 
    build = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out",
  },
  {
    -- adapter
    "mxsdev/nvim-dap-vscode-js",
    config = function()
      require("dap-vscode-js").setup({
        debugger_path = vim.fn.resolve(vim.fn.stdpath("data") .. "/lazy/vscode-js-debug"),
        adapters = { "chrome", "pwa-node", "pwa-chrome", "pwa-msedge", "pwa-extensionHost" },
      })
    end,
  },
  -- ## Parse launch.json
  { "Joakker/lua-json5", build = "./install.sh" },
  {
    "mfussenegger/nvim-dap",
    optional = true,
    opts = function()
      local dap = require("dap")
      if not dap.adapters["pwa-node"] then
        require("dap").adapters["pwa-node"] = {
          type = "server",
          host = "localhost",
          port = "${port}",
          executable = {
            command = "node",
            -- 💀 Make sure to update this path to point to your installation
            args = {
              require("mason-registry").get_package("js-debug-adapter"):get_install_path()
                .. "/js-debug/src/dapDebugServer.js",
              "${port}",
            },
          },
        }
      end
      for _, language in ipairs({ "typescript", "javascript", "typescriptreact", "javascriptreact" }) do
        dap.configurations[language] = {
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch Test Current File (pwa-node with deno)",
            cwd = vim.fn.getcwd(),
            runtimeArgs = { "test", "--inspect-brk", "--allow-all", "${file}" },
            runtimeExecutable = "deno",
            attachSimplePort = 9229,
          },
          -- {
          --   type = "pwa-node",
          --   request = "attach",
          --   name = "Attach",
          --   processId = require("dap.utils").pick_process,
          --   cwd = "${workspaceFolder}",
          -- },
        }
      end
    end,
  },
}
