local module = {}

local helpers = require("oleo/helpers")
local sumneko = require("oleo/helpers/sumneko_lua")

-- convenience functions exported into module namespace
for _, module_name in ipairs({ helpers, sumneko }) do
    for func_name, func in pairs(module_name) do
        module[func_name] = func
    end
end

module.helpers = helpers
module.sumneko = sumneko

module.unload = function()
    local modules = {
        "oleo",
        "oleo/helpers",
        "oleo/helpers/sumneko_lua",
    }

    helpers.unload(modules)
end

return module

-- print('---- PACKAGE PATH ----')
-- k

-- local pp = vim.fn.split(package.path, ';')
-- for k,v in ipairs(pp) do
--     print(v)
-- end

-- print('---- RUNTIMEPATH ----')
-- local rp = vim.fn.split(vim.o.runtimepath, ',')
-- for k,v in pairs(rp) do
--     print(v)
-- end

-- print('---- nvim_list_runtime_paths ----')
-- local can = vim.api.nvim_list_runtime_paths()
-- for k,v in pairs(can) do
--     print(v)
-- end
