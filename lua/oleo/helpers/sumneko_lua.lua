-- support functions
local helpers = require('oleo/helpers')

local function get_sumneko_settings_for(table)
    local buf = vim.api.nvim_get_current_buf()
    local lsp_clients = vim.lsp.buf_get_clients(buf)

    for _, client in pairs(lsp_clients) do
        if client.name == "sumneko_lua" then
            local fields = vim.fn.split(table, '\\.')
            local table_walker = client

            for field = 1, #fields do
                table_walker = table_walker[fields[field]]
            end

            return table_walker
        end
    end

    print("Sumneko not attached to buffer")
    return nil
end

-- module begining
local module = {}

function module.get_sumneko_preload()
    local max_preload = get_sumneko_settings_for('config.settings.Lua.workspace.maxPreload')
    local preload_file_size = get_sumneko_settings_for('config.settings.Lua.workspace.preloadFileSize')

    return { maxPreload = max_preload, preloadFileSize = preload_file_size }
end

function module.sumneko_workspace()
    local libs = module.get_sumneko_workspace()
    table.sort(libs)
    helpers.pp(libs)
end

function module.get_sumneko_workspace()
    local libs = get_sumneko_settings_for('config.settings.Lua.workspace.library')

    local paths = {}

    for path, _ in pairs(libs) do
        table.insert(paths, path)
    end

    return paths
end

function module.sumneko_rtp()
    local rtp = module.get_sumneko_rtp()
    helpers.pp(rtp)
end

function module.get_sumneko_rtp()
     local rtp = get_sumneko_settings_for('config.settings.Lua.runtime.path')

     return rtp
end

return module
