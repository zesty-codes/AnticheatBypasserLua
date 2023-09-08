-- zestycodes on top
-- whenever you wanna edit the localplayer's cframe, you will automically get tweened to the CFrame
-- Example, what you sees: game.Players.LocalPlayer.Character.HumanoidRootPart = CFrame.new(0, 999, 0)
-- This is what the roblox lua (executor) sees: game["Tween Service"]:Create(game.Players.LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {CFrame = CFrame.new(0, 999, 0)}):Play()
local lplr = game:GetService("Players")
local tween = game:GetService("TweenService")
local metatable = (getrawmetatable or get_raw_metatable or getraw_metatable or debug and debug.getmetatable)(game)
local backup;
local game = game.PlaceId
local speed = 4.9
if game == 5602055394 then
    speed = 14
elseif game == 142823291 then
    speed = 8
end
backup = hookfunction(metatable.__newindex, newcclosure(function(self, property, value)
    if property == "CFrame" and (self:IsA("Part") or self:IsA("BasePart") or self:IsA("MeshPart")) and checkcaller() then
        return tween:Create(self, TweenInfo.new(speed, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {CFrame = value}):Play()
    end
    return backup(self, property, value)
end))
