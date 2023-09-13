describe("bdelete.buffer", function()
    local buffer = require("bdelete.buffer")

    local before_each_handler = function()
        vim.cmd([[bufdo bdelete!]])
    end

    describe("all()", function()
        before_each(before_each_handler)

        it("initial state", function()
            local list = buffer.all()
            assert.are.equals(1, #list)
            assert.are.equals("", list[1].name)
        end)

        it("two buffers", function()
            local name = "test-name"
            vim.cmd("new " .. name)

            local list = buffer.all()
            assert.are.equals(2, #list)
            assert.are.equals("", list[1].name)
            assert.are.has_suffix(name, list[2].name)
        end)

        it("active buffer & hidden buffer", function()
            local name1 = "test-name-1"
            local name2 = "test-name-2"
            vim.cmd("edit " .. name1)
            vim.cmd("edit " .. name2) -- hide first buffer

            local list = buffer.all()
            assert.are.equals(2, #list)
            assert.are.has_suffix(name1, list[1].name)
            assert.are.has_suffix(name2, list[2].name)
        end)
    end)

    describe("current()", function()
        before_each(before_each_handler)

        it("initial state", function()
            local cur = buffer.current()
            assert.are.equals("table", type(cur))
            assert.are.equals("", cur.name)
        end)

        it("new named buffer", function()
            local name = "test-name"
            vim.cmd("new " .. name)
            local cur = buffer.current()
            assert.are.equals("table", type(cur))
            assert.are.has_suffix(name, cur.name)
        end)

        it("edit named buffer", function()
            local name = "test-name"
            vim.cmd("edit " .. name)
            local cur = buffer.current()
            assert.are.equals("table", type(cur))
            assert.are.has_suffix(name, cur.name)
        end)
    end)

    describe("is_running_terminal()", function()
        before_each(before_each_handler)

        it("initial state", function()
            assert.is_false(buffer.is_running_terminal(buffer.current()))
        end)

        it("terminal exited", function()
            vim.cmd([[
                terminal echo hoge
                sleep 1
            ]])
            assert.is_false(buffer.is_running_terminal(buffer.current()))
        end)

        it("terminal running", function()
            vim.cmd([[
                terminal
            ]])
            assert.is_true(buffer.is_running_terminal(buffer.current()))
        end)
    end)
end)
