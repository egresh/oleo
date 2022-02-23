local module = {}

local helpers = require("oleo/helpers")
local sumneko = require("oleo/helpers/sumneko_lua")
local maximizer = require("oleo/maximizer")
local rspec = require("oleo/rspec_qf_toggle")

-- convenience functions exported into module namespace
for _, module_name in ipairs({ helpers, sumneko }) do
    for func_name, func in pairs(module_name) do
        module[func_name] = func
    end
end

module.helpers = helpers
module.sumneko = sumneko
module.maximizer = maximizer
module.rspec = rspec

module.unload_oleo = function()
    local modules = {
        "oleo",
        "oleo/helpers",
        "oleo/helpers/sumneko_lua",
        "oleo/maximizer",
        "oleo/rspec_qf_toggle"
    }

    helpers.unload(modules)
end

module.maximizer.toggle()

return module
