# Why this was made?
This was made to test a anticheat of mine, where I used a metatable hook as a test.
This project was made mainly for educational purposes, and should **NOT** be used in different games.

# How does this bypass anticheats?
This project hooks a game metatable using hookfunction(metatable[__any], newcclosure(func))

Explanation:

``newcclosure`` - Converts a Lua function to a cpp function (C++)

``hookfunction`` - Hooks a function with another function, similar to getmetatable(game).__index (EXPLOITS ONLY) [Localscripts/Serverscripts do not have access to the game's metatable]

``hookmetamethod`` - Edits a metamethod with the 3 arguments: object, metamethodtype: string ("__index" | "__newindex" | "__namecall"), function (any), and always has to be called by the client otherwise it'll crash

# Well, how do I make a anticheat to prevent them from scanning __index and __namecall stuff?
Don't worry, here's some sample.
Firstly, define a protectString function.
```lua
local function protectString(String)
    -- Format a string, first argument is the string you request.
    -- The second argument, is a cpp terminator (Lua runs in C++, that's why)
    -- The third argument generates a random tick, so the exploiters won't be able to bypass.
    return string.format("%s%s%.2f", String, string.rep("\000", 5), os.clock() - tick() * math.random(0, 256))
end
```
Now, we must get the game metatable stuff (not hookable though.)
```lua
local __namecall, __newindex, __index;

__namecall = function(self: Instance, method: string, ...)
    return self[protectString(method)](self, ...) -- This returns the packed arguments and unpacks them.
end

-- define __index and __newindex within the xpcall and debug.info function
xpcall(function() return game.____ end, function() __index = debug.info(2, "f") end)
xpcall(function() game.____ = nil end, function() __namecall = debug.info(2, "f") end)

```

## Using it
```lua
local function protectString(String)
    -- Format a string, first argument is the string you request.
    -- The second argument, is a cpp terminator (Lua runs in C++, that's why)
    -- The third argument generates a random tick, so the exploiters won't be able to bypass.
    return string.format("%s%s%.2f", String, string.rep("\000", 5), os.clock() - tick() * math.random(0, 256))
end
```
Now, we must get the game metatable stuff (not hookable though.)
```lua
local __namecall, __newindex, __index;

__namecall = function(self: Instance, method: string, ...)
    return self[protectString(method)](self, ...) -- This returns the packed arguments and unpacks them.
end

-- define __index and __newindex within the xpcall and debug.info function
xpcall(function() return game.____ end, function() __index = debug.info(2, "f") end)
xpcall(function() game.____ = nil end, function() __namecall = debug.info(2, "f") end)

-- Get workspace.Gravity:
print(__index(workspace, "Gravity"))

-- Edit workspace name to "Hello world 123!"
__newindex(workspace, "Name", "Hello world 123!")

-- Get children of Workspace
table.foreach(__namecall(workspace, "GetChildren", nil), print)

-- Firing a remote event
__namecall(__namecall(game, "FindFirstChild", "YourRemoteHere"), "FireServer", ...:arguments_here)
-- You'll eventually get the hang of it
```

# How do ScriptContext Hooks work:
- It disables every connections in ScriptContext, making the localscripts that report the errors not be able to report to the server, or kick.
- Hooks the ``Error.Connect(ScriptContext[self], ...)`` function so the localscripts can't report anything later on

Example of a simple ScriptContext detection:
```lua
-- Add a new ScriptContext.Error connection
game:GetService("ScriptContext")["Error"]:Connect(function(errorMessage, stackTrace, script)
    -- Check if a script does not exist (localscript prefferably)
    -- Add some checks
    local isProperScript = pcall(function() return script ~= nil or script:IsA("BasePart") end) -- Usually, CoreScripts error when a method is called. Idc whether it checks if it's a basepart or not, atleast it works lol
    local isLocalScript, Response = pcall(function()
        -- Check if the script that errored is a proper localscript
        if not isProperScript then
            -- We have detected CoreScript, meaning it's not a normal script
            return false
        end

        -- Atleast it works ¯\_(ツ)_/¯
        return script:IsA("LocalScript")
    end)

    -- Sanity-check if its a localscript or serverscript, and if not then the player is exploiting, using a ScriptContext Bypass
    if not isProperScript and ((not isLocalScript or not Response) or not script) == true then
        -- whatever punishment, for example ill just kick the localplayer
        -- if you want you can literally ban the player by sending a fireserver request to a remoteevent/remotefunction, literally whatever you want
        game.Players.LocalPlayer["Kick\000this wont be hooked unless someone makes a bypass for this lol"](game.Players.LocalPlayer, "Exploits detected")
    end
end)
```
Please remember that the exploiter can just loop disable every connections, as they FULLY control the client due to the ``UNC API``.
# How to prevent anti-kick hooks.
Firstly, we must understand what they do.
First, they define the old variable, to save like a backup of the original metamethod.
```lua
setreadonly(getrawmetatable(game), false) -- Unlock the metatable so its readable and editable
local old = getrawmetatable(game).__namecall
```
Secondly, they will define a function to check if the developer wants to kick the exploiter.
```lua
local isKicking = function(self: Instance, ...) -- "..." are the args, passed by the client.
    local method = getnamecallmethod(); -- Returns a function of what the script attempted to call.
    if (tostring(method):lower():match("kick")) then -- Check if the namecall method "Kick" was called.
        return task.wait(tonumber("inf")) -- Wait infinity seconds to prevent the scripts from running.
    end
    return old(self, ...); -- Call the old metatable, to prevent 
end
```
Thirdly, they will finally edit the metamethod.
```lua
old = hookmetamethod(game, "__namecall", newcclosure(isKicking))
```
Combined script:
```lua
-- basic stuff
setreadonly(getrawmetatable(game), false) -- Unlock the metatable so its readable and editable
local old = getrawmetatable(game).__namecall -- Gain the "__namecall" metamethod.

-- define a isKicking function
local isKicking = function(self: Instance, ...) -- "..." are the args, passed by the client.
    local method = getnamecallmethod(); -- Returns a function of what the script attempted to call.
    if (tostring(method):lower():match("kick")) then -- Check if the namecall method "Kick" was called.
        return task.wait(tonumber("inf")) -- Wait infinity seconds to prevent the scripts from running.
    end
    return old(self, ...); -- Call the old metatable, to prevent 
end

--  hook the metatable
old = hookmetamethod(game, "__namecall", newcclosure(isKicking))
```
