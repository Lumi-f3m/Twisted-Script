_G.SilentAimEnabled = true
_G.SilentAimWallcheck = false
_G.AutoShoot = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local function IsVisible(target)
    if not _G.SilentAimWallcheck then return true end
    local char = target.Character
    if not char then return false end
    local ray = Camera:Raycast(Camera.CFrame.Position, (char.Head.Position - Camera.CFrame.Position), RaycastParams.new())
    return not ray
end

local function GetClosestPlayer()
    local target, closestDist = nil, math.huge
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
            if p.Team ~= LocalPlayer.Team and IsVisible(p) then
                local pos, onScreen = Camera:WorldToViewportPoint(p.Character.Head.Position)
                if onScreen then
                    local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                    if dist < closestDist then
                        closestDist = dist
                        target = p
                    end
                end
            end
        end
    end
    return target
end

RunService.RenderStepped:Connect(function()
    if not _G.SilentAimEnabled then return end
    
    local target = GetClosestPlayer()
    if target and _G.AutoShoot then
        -- This simulates a mouse click for most shooters
        -- Warning: In your own game, this might fire very fast!
        mouse1click() 
    end
end)

-- Hooking the MetaTable (The "Silent" part)
-- This ensures that when the game asks "Where is the mouse?", it gets the enemy head
local mt = getrawmetatable(game)
setreadonly(mt, false)
local oldNamecall = mt.__namecall

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    if _G.SilentAimEnabled and method == "FindPartOnRayWithIgnoreList" then
        local target = GetClosestPlayer()
        if target then
            -- Redirect the ray to the target's head
            args[1] = Ray.new(Camera.CFrame.Position, (target.Character.Head.Position - Camera.CFrame.Position).Unit * 1000)
        end
    end
    return oldNamecall(self, unpack(args))
end)
