describe("Format", function()
    local format = require("bdelete.format")

    before_each(function()
        vim.cmd([[bufdo bdelete!]])
    end)

    it("active_flag (active)", function()
        local old_info = vim.fn.getbufinfo("%")[1]
        assert.is.not_nil(old_info)
        assert.are.equals("a", format.active_flag(old_info))
    end)

    it("active_flag (hidden)", function()
        local new_info = vim.fn.getbufinfo(vim.api.nvim_create_buf(true, false))[1]
        assert.is.not_nil(new_info)
        assert.are.equals("h", format.active_flag(new_info))
    end)

    it("readonly_flag (normal)", function()
        local info = vim.fn.getbufinfo("%")[1]
        assert.are.equals(" ", format.readonly_flag(info))
    end)

    it("readonly_flag (unmodifiable)", function()
        vim.bo.modifiable = false
        local info = vim.fn.getbufinfo("%")[1]
        assert.are.equals("-", format.readonly_flag(info))
    end)

    it("readonly_flag (readonly)", function()
        vim.bo.readonly = true
        local info = vim.fn.getbufinfo("%")[1]
        assert.are.equals("=", format.readonly_flag(info))
    end)

    it("readonly_flag (unmodifiable & readonly)", function()
        vim.bo.readonly = true
        vim.bo.modifiable = false
        local info = vim.fn.getbufinfo("%")[1]
        assert.are.equals("-", format.readonly_flag(info), "unmodifiable flag has high priority")
    end)

    it("modified_flag (default)", function()
        local info = vim.fn.getbufinfo("%")[1]
        assert.are.equals(" ", format.modified_flag(info))
    end)

    it("modified_flag (modified)", function()
        vim.api.nvim_buf_set_lines(0, 0, 0, true, { "test text" })

        local info = vim.fn.getbufinfo("%")[1]
        assert.are.equals("+", format.modified_flag(info))
    end)

    it("name (empty)", function()
        local info = vim.fn.getbufinfo("%")[1]
        assert.are.equals("", format.name(info))
    end)

    it("name (normal buffer)", function()
        local bufnr = vim.fn.bufnr("%")
        vim.api.nvim_buf_set_name(bufnr, vim.env.HOME .. "/foo")

        local info = vim.fn.getbufinfo("%")[1]
        assert.are.equals("~/foo", format.name(info))
    end)

    it("name (scratch buffer)", function()
        local bufnr = vim.api.nvim_create_buf(true, true)
        local name = vim.env.HOME .. "/foo"
        vim.api.nvim_buf_set_name(bufnr, name)

        local info = vim.fn.getbufinfo(bufnr)[1]
        assert.are.equals(name, format.name(info))
    end)
end)
