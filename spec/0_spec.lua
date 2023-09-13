expose("", function()
    setup(function()
        local function has_suffix(state, arguments)
            if #arguments ~= 2 or type(arguments[1]) ~= "string" or type(arguments[2]) ~= "string" then
                return false
            end

            return arguments[2]:sub(-string.len(arguments[1])) == arguments[1]
        end

        local say = require("say")
        say:set("assertion.has_suffix.positive", "Expected %s \nto have property: %s")
        say:set("assertion.has_suffix.negative", "Expected %s \nto not have property: %s")
        assert:register(
            "assertion",
            "has_suffix",
            has_suffix,
            "assertion.has_suffix.positive",
            "assertion.has_suffix.negative"
        )
    end)
end)
