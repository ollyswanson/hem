-- TODO: Relics from that horrible Java experiment, moving them here but not making use of them for now
return {
  "mfussenegger/nvim-dap",
}

-- function M.dap_mappings(bufnr)
--   wk({
--     ["<leader>b"] = {
--       ["<space>"] = { '<cmd>lua require("dap").repl.toggle()<CR>', "toggle repl" },
--       b = { '<cmd>lua require("dap").toggle_breakpoint()<CR>', "breakpoint" },
--       c = { '<cmd>lua require("dap").continue()<CR>', "continue" },
--       i = { '<cmd>lua require("dap").step_into()<CR>', "step into" },
--       l = { '<cmd>lua require("dap").run_last()<CR>', "run last" },
--       o = { '<cmd>lua require("dap").step_over()<CR>', "step over" },
--       x = { '<cmd>lua require("dap").step_out()<CR>', "step out" },
--       v = { '<cmd>lua require("dap.ui.variables").hover()<CR>', "debug value" },
--     },
--   }, {
--     buffer = bufnr,
--   })

--   wk({
--     ["<leader>b"] = {
--       name = "show",
--       v = { '<cmd>lua require("dap.ui.variables").visual_hover()<CR>', "debug value" },
--     },
--   }, {
--     buffer = bufnr,
--     mode = "v",
--   })
-- end
