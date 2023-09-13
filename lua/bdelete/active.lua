local buffer = require("bdelete.buffer")
local format = require("bdelete.format")
local core = require("bdelete.core")
local static = require("bdelete.static")
local M = {}

local opts = vim.tbl_keys(static)
local labels = "&" .. vim.fn.join(opts, "\n&")

--- Open a menu to choose one of behaviors below.
---@param params bdelete.Params
function M.menu(params)
    local choice = vim.fn.confirm("Wipeout Buffers? (<ESC> to cancel)", labels, 1)
    local option = opts[choice]
    if option == nil then
        return
    end
    local selection = static[option]
    if selection == nil then
        return
    end
    selection(params)
end

--- Lets you interactively select which buffers to wipe.
---@param params bdelete.Params
function M.select(params)
    local filter = buffer.build_filter(params)
    local bufs = vim.tbl_filter(filter, buffer.all())
    if vim.tbl_isempty(bufs) then
        vim.api.nvim_echo({ { "There's no buffer closable", "ErrorMsg" } }, false, {})
        return
    end
    vim.ui.select(bufs, {
        prompt = "Select buffers:",
        format_item = format.get_formatter(),
    }, function(choise)
        if choise then
            core.one(params, choise)
        end
    end)
end

return M
