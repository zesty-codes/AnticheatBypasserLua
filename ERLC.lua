local lplr = game:GetService("Players").LocalPlayer
local request = request or http_request or http and http.request or syn and syn.request
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
