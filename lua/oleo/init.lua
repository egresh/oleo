local module = {}

local helpers = require("oleo/helpers")
local sumneko = require("oleo/helpers/sumneko_lua")
local maximizer = require("oleo/maximizer")

-- convenience functions exported into module namespace
for _, module_name in ipairs({ helpers, sumneko }) do
    for func_name, func in pairs(module_name) do
        module[func_name] = func
    end
end

module.helpers = helpers
module.sumneko = sumneko
module.maximizer = maximizer

module.unload_oleo = function()
    local modules = {
        "oleo",
        "oleo/helpers",
        "oleo/helpers/sumneko_lua",
    }

    helpers.unload(modules)
end

module.maximizer.toggle()

return module
