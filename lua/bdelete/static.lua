local buffer = require("bdelete.buffer")
local core = require("bdelete.core")

local M = {}

--- Wipe buffers other of the one in the current window.
---@param params bdelete.Params
function M.other(params)
    local current = buffer.current_number()
    core.filtered(params, {
        function(item)
            return item.bufnr ~= current
        end,
    })
end

--- Wipe buffers loaded but currently not displayed in any window.
---@param params bdelete.Params
function M.hidden(params)
    core.filtered(params, {
        function(item)
            return #item.windows == 0
        end,
    })
end

--- Wipe buffers having no name.
---@param params bdelete.Params
function M.nameless(params)
    core.filtered(params, {
        function(item)
            return item.name == ""
        end,
    })
end

--- Wipe all buffers.
---@param params bdelete.Params
function M.all(params)
    core.filtered(params)
end

--- Wipe a buffer in the current window.
---@param params bdelete.Params
function M.current(params)
    core.one(params, buffer.current())
end

return M
