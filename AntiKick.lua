local lplr = game:GetService("Players").LocalPlayer
local metatable = (getrawmetatable or get_raw_metatable or getraw_metatable or debug and debug.getmetatable)(game)
local backup;
backup = hookfunction(metatable.__namecall, newcclosure(function(self, ...)
    local args = {...}
    local method = (getnamecallmethod or get_namecall_method or get_name_call_method or function() return game.DescendantAdded end)()
    if self == lplr and (rawequal(tostring(method):lower(), "kick") or rawequal(tostring(method):lower(), "destroy") or rawequal(tostring(method):lower(), "remove")) then
        return nil
    end
    return backup(self, ...)
end))
