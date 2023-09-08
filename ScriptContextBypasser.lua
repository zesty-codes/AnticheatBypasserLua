local SC = game:GetService("ScriptContext")
local getconnections = getconnections or get_connections or connections or dumpconnections
function checkForBannedConnections()
    for i,v in pairs(getconnections(SC.Error)) do
        if i and v then
            v:Disconnect()
            v = nil
        end
    end
end
local metatable = (getrawmetatable or get_raw_metatable or getraw_metatable or debug and debug.getmetatable)(game)
local backup;
backup = hookfunction(metatable.__namecall, newcclosure(function(self, ...)
    local args = {...}
    if self == SC and not checkcaller() then
        return game.DescendantAdded.Connect
    end
    return backup(self, ...)
end))
checkForBannedConnections()
