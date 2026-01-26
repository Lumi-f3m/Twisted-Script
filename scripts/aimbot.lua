-- Old (Test)

_G.AimbotEnabled = true
_G.AimbotSmoothness = 0.5 -- Higher = Slower/Smoother
_G.FOVRadius = 100
_G.ShowFOV = true
_G.AimPart = "Head" -- Can be "HumanoidRootPart" or "Head"

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- 1. Create the FOV Circle
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1
FOVCircle.NumSides = 64
FOVCircle.Radius = _G.FOVRadius
FOVCircle.Filled = false
FOVCircle.Transparency = 0.7
FOVCircle.Color = Color3.fromRGB(255, 38, 38) -- NHack Red
FOVCircle.Visible = _G.ShowFOV

local function GetClosestPlayer()
    local target = nil
    local shortestDistance = _G.FOVRadius

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild(_G.AimPart) then
            -- Team Check
            if player.Team ~= LocalPlayer.Team or player.Team == nil then
                local pos, onScreen = Camera:WorldToViewportPoint(player.Character[_G.AimPart].Position)
                if onScreen then
                    -- Calculate distance from mouse to player head
                    local mousePos = UserInputService:GetMouseLocation()
                    local distance = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
                    
                    if distance < shortestDistance then
                        target = player
                        shortestDistance = distance
                    end
                end
            end
        end
    end
    return target
end

local connection
connection = RunService.RenderStepped:Connect(function()
    -- KILL SWITCH
    if not _G.AimbotEnabled then
        FOVCircle:Remove()
        connection:Disconnect()
        return
    end

    -- Update FOV Circle Visuals
    FOVCircle.Visible = _G.ShowFOV
    FOVCircle.Radius = _G.FOVRadius
    FOVCircle.Position = UserInputService:GetMouseLocation()

    -- AIMBOT LOGIC (Only works when holding Right Click)
    if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local target = GetClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild(_G.AimPart) then
            local targetPos = Camera:WorldToViewportPoint(target.Character[_G.AimPart].Position)
            local mousePos = UserInputService:GetMouseLocation()
            
            -- CAMERA SMOOTHING MATH
            -- We lerp the camera's current focus towards the target
            local moveX = (targetPos.X - mousePos.X) * (1 - _G.AimbotSmoothness)
            local moveY = (targetPos.Y - mousePos.Y) * (1 - _G.AimbotSmoothness)
            
            mousemoverel(moveX, moveY) -- Standard executor function
        end
    end
end)
