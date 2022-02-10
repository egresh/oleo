local M = {}
local maximizer_sizes = {}

local function deb(message)
   print(message)
end

local function zoom()
    maximizer_sizes.before = vim.fn.winrestcmd()
    vim.cmd('vert resize | resize')
    maximizer_sizes.after = vim.fn.winrestcmd()
    M.zoomed = true

    if M.verbose then
        deb('winrestcmd() before: ' .. maximizer_sizes.before)
        deb('winrestcmd() after:  ' .. maximizer_sizes.after)
        deb('Zoomed')
    end
end

local function restore()
    vim.api.nvim_command(maximizer_sizes.before)
    M.zoomed = false

    if M.verbose then
        deb("Restored using: " .. maximizer_sizes.before)
    end
end

local function verbose_mode(config)
    if config.verbose == M.verbose then
        -- do nothing
    elseif config.verbose == true or config.verbose == false then
        if M.verbose == true and config.verbose == false then
            deb('Maximizer verbose off')
        elseif M.verbose == false and config.verbose == true then
            deb('Maximizer verbose on')
        end
        M.verbose = not M.verbose
    end
end

local function toggle(config)
    verbose_mode(config or {})
    if M.zoomed then
        restore()
    else
        zoom()
    end
end

M.toggle  = toggle
M.verbose = false
M.zoomed  = false

return M
