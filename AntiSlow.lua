local metatable = (getrawmetatable or get_raw_metatable or getraw_metatable or debug and debug.getmetatable)(game)
local backup;
backup = hookfunction(metatable.__newindex, newcclosure(function(self, property, value)
    if property == "WalkSpeed" and self:IsA("Humanoid") and not checkcaller() then
        self[property] = 16
        return backup(self, property, 16)
    end
    return backup(self, property, value)
end))
