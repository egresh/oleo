local M = {}

local blank_qf_entry = {
    bufnr = 0,
    col = 0,
    end_col = 0,
    end_lnum = 0,
    lnum = 0,
    module = "",
    nr = -1,
    pattern = "",
    text = "",
    type = "",
    valid = 0,
    vcol = 0,
}

local function get_qf_list_title()
    return vim.fn.getqflist({ title = true }).title
end

local toggled = false
local original_qf_list = {}
local pruned_qf_list = {}
local title

function M.toggle_rspec_qf_list()
    local current_qf_list_title = get_qf_list_title()

    if current_qf_list_title ~= title then
       original_qf_list = {}
       pruned_qf_list = {}
       toggled = false
    end

    if next(original_qf_list) == nil then
        original_qf_list = vim.fn.getqflist()
        title = get_qf_list_title()
    end

    if toggled then
        vim.fn.setqflist(original_qf_list)
        vim.fn.setqflist({}, 'r', {title = title})
        toggled = false
        vim.cmd([[copen]])
        return
    end

    local error_count = 0

    if next(pruned_qf_list) == nil then
        for _, line_metadata in ipairs(original_qf_list) do
            local found_error = false
            local _, _, description = string.find(line_metadata.text, "^%s+(%d+%).*)")

            if string.find(line_metadata.type, "[EIWH]") then
                found_error = true
                error_count = error_count + 1
            end

            if description or found_error then
                table.insert(pruned_qf_list, line_metadata)

                if found_error and error_count > 1 then
                    table.insert(pruned_qf_list, blank_qf_entry)
                end
            end
        end
    end

    vim.fn.setqflist(pruned_qf_list)
    vim.fn.setqflist({}, 'r', { title = title })
    toggled = true
    vim.cmd([[copen]])
end

return M
