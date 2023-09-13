local buffer = require("bdelete.buffer")

local M = {}

--- Get a activity flag representation from the BufInfo
---@param bufinfo bdelete.BufInfo
---@return string
function M.active_flag(bufinfo)
    if bufinfo.loaded ~= 0 and not vim.tbl_isempty(bufinfo.windows) then
        return "a"
    elseif bufinfo.hidden ~= 0 then
        return "h"
    end
end

--- Get a readonly flag representation from the BufInfo
---@param bufinfo bdelete.BufInfo
---@return string
function M.readonly_flag(bufinfo)
    if not vim.api.nvim_buf_get_option(bufinfo.bufnr, "modifiable") then
        return "-"
    elseif vim.api.nvim_buf_get_option(bufinfo.bufnr, "readonly") then
        return "="
    end
    return " "
end

--- Get a modified flag representation from the BufInfo
---@param bufinfo bdelete.BufInfo
---@return string
function M.modified_flag(bufinfo)
    if bufinfo.changed ~= 0 then
        return "+"
    end
    return " "
end

--- Get a name of the BufInfo
---@param bufinfo bdelete.BufInfo
---@return string
function M.name(bufinfo)
    if bufinfo.name == "" then
        return ""
    end
    if vim.bo[bufinfo.bufnr].buftype == "" then
        return vim.fn.fnamemodify(bufinfo.name, ":~:.")
    end
    return bufinfo.name
end

--- Get a formatter to represents BufInfo
---@return fun(bufinfo: bdelete.BufInfo): string
function M.get_formatter()
    local cur_bufnr = buffer.current_number()
    local alt_bufnr = buffer.alternate_number()
    ---@param bufinfo bdelete.BufInfo
    return function(bufinfo)
        local cursor_flag = " "
        if bufinfo.bufnr == cur_bufnr then
            cursor_flag = "%"
        elseif bufinfo.bufnr == alt_bufnr then
            cursor_flag = "#"
        end
        return string.format(
            "%s%s%s%s %q",
            cursor_flag,
            M.active_flag(bufinfo),
            M.readonly_flag(bufinfo),
            M.modified_flag(bufinfo),
            M.name(bufinfo)
        )
    end
end

return M
