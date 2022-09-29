local M = {}

-- get the project root for a git project
function M.project_root()
    local root = vim.fn.system("git rev-parse --show-toplevel")

    if string.find(root, "fatal:") then
        root = vim.fn.getcwd()
    else
        root = string.gsub(root, "\n", "")
    end

    return root
end

-- print over a parameter list
function M.pp(...)
    local count = select("#", ...)

    for idx, param in ipairs({ ... }) do
        if count > 1 then
            print("Param " .. idx .. ":")
        end

        for k, v in pairs(param) do
            print(k, v)
        end
    end
end

-- unload modules
function M.unload(modules)
    print("Unloading " .. #modules .. " modules")
    for _, v in pairs(modules) do
        if package.loaded[v] then
            package.loaded[v] = nil
            print("Module " .. v .. " has been unloaded")
        else
            print("Module " .. v .. " wasn't already loaded")
        end
    end
end

function M.put(...)
    local objects = {}
    for i = 1, select("#", ...) do
        local v = select(i, ...)
        table.insert(objects, vim.inspect(v))
    end

    print(table.concat(objects, "\n"))
    return ...
end

function M.dump(...)
    local objects = vim.tbl_map(vim.inspect, { ... })
    print(unpack(objects))
    return ...
end

function M.get_rtp()
    local rtp = vim.o.runtimepath
    local t = {}
    for dir in rtp:gmatch("([%w%-%/%.]+),?") do
        table.insert(t, dir)
    end

    table.sort(t)
    return t
end

function M.rtp()
    local rtp = M.get_rtp()
    M.pp(rtp)
end

function M.show_path()
    return vim.fn.join(vim.opt.path:get(), "\n")
end

function M.show_tagfiles()
    return vim.fn.join(vim.opt.tags:get(), "\n")
end

function M.buf_count()
    local buffers = vim.api.nvim_list_bufs()
    M.dump(buffers)
end

function M.reload_config()
    local loaded = {}
    for k in pairs(package.loaded) do
        table.insert(loaded, k)
        package.loaded[k] = nil
    end

    table.sort(loaded)

    for k, v in ipairs(loaded) do
        print(k, v)
        require(v)
    end
end

function M.dumptotmpfile(tbl, filename)
    local tmpname = "/Users/egresh/tmp/"

    if filename == nil then
        tmpname = tmpname .. "neovim_dump_file.txt"
    else
        tmpname = tmpname .. filename
    end

    vim.api.nvim_command("silent! redir! > " .. tmpname)
    vim.o.more = false
    M.dump(tbl)
    vim.api.nvim_command("redir END")
    vim.o.more = true
    vim.api.nvim_command('call nvim_input("<cr>")')
end

function M.get_package_path()
    local path = {}

    for _, v in ipairs(vim.fn.split(package.path, ";")) do
        table.insert(path, v)
    end

    return path
end

function M.neovim_config_files()
    local scan = require("plenary.scandir")
    local lua_files = scan.scan_dir(vim.fn.stdpath("config") .. "/lua")
    local after_files = scan.scan_dir(vim.fn.stdpath("config") .. "/after")

    local files = {}
    local dirs = { lua_files, after_files }

    for _, tbl in ipairs(dirs) do
        for _, file in ipairs(tbl) do
            table.insert(files, file)
        end
    end

    table.insert(files, 1, vim.env.MYVIMRC)
    return files
end

function M.package_grep(name)
    local matched = {}
    for k, _ in pairs(package.loaded) do
        if k:match(name) then
            table.insert(matched, k)
        end
    end
    return matched
end

function M.winenter()
    local filetype = vim.api.nvim_buf_get_option(0, "filetype")

    if filetype == "toggleterm" then
        vim.cmd("IndentBlanklineDisable")
        return
    elseif filetype ~= "NvimTree" then
        vim.wo.number = true
        vim.wo.relativenumber = true
    end

    vim.wo.signcolumn = "auto:9"
end

function M.load_plugin(plugin)
    print("The plugin is: " .. plugin)
    local status_ok, error = pcall(require(tostring(plugin)))

    if not status_ok then
        print("ERROR: unable to load plugin " .. error)
    else
        print("Plugin Loaded: " .. plugin)
    end
end

function M.format_lualine()
    local bufname = vim.api.nvim_buf_get_name(0)

    if not string.find(bufname, "toggleterm") then
        return { tostring(math.random(10)) }
        -- return {
        --     { "filetype", icon_only = true },
        --     { "filename", file_status = true, path = 0 },
        -- }
    end

    local program_name
    local term_number

    -- expected output...
    -- "term://~/.local/share/neovimwip/nvim//45438:htop;#toggleterm#2"
    _, _, program_name, term_number = string.find(bufname, "%d+:([%w]+);#toggleterm#(%d+)")

    print("the program name is " .. program_name)
    if program_name == nil then
        return ""
    end

    return { string.format("Term: %s # %d", program_name, term_number) }
end

function ConfigureTerminal()
    vim.wo.relativenumber = false
    vim.wo.number = false
    vim.cmd("highlight! link TermCursor Cursor")
    vim.cmd("highlight! TermCursorNC guibg=red guifg=white ctermbg=1 ctermfg=15")
    vim.cmd('exec "normal i"')
end

function M.toggle_quickfix()
    local has_quickfix = false

    for _, window in ipairs(vim.fn.getwininfo()) do
        if window.quickfix == 1 then
            has_quickfix = true
            break
        end
    end

    if has_quickfix then
        vim.api.nvim_command("cclose")
    else
        vim.api.nvim_command("copen")
    end
end

return M
