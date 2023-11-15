return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  config = function()
    require("kp.plugins.config.autopairs")
  end
}
