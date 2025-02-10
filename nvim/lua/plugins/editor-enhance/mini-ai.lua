if true then
  return {}
end

return {
  "echasnovski/mini.ai",
  version = "*",
  config = function()
    require("mini.ai").setup()
  end,
}
