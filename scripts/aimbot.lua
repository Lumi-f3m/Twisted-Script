-- Old (Test)

_G.AimbotEnabled = true
_G.AimbotSmoothness = 0.5
_G.FOVRadius = 100
_G.ShowFOV = true
_G.AimPart = "Head"

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1
FOVCircle.NumSides = 64
FOVCircle.Radius = _G.FOVRadius
FOVCircle.Filled = false
FOVCircle.Transparency = 0.7
FOVCircle.Color = Color3.fromRGB(255, 38, 38)
FOVCircle.Visible = _G.ShowFOV

local function GetCorrectMousePos()
    local pos = UserInputService:GetMouseLocation()
    local inset = GuiService:GetGuiInset()
    return Vector2.new(pos.X, pos.Y - inset.Y)
end

local function GetClosestPlayer()
    local target = nil
    local shortestDistance = _G.FOVRadius
    local mousePos = GetCorrectMousePos()

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild(_G.AimPart) then
            if player.Team ~= LocalPlayer.Team or player.Team == nil then
                local pos, onScreen = Camera:WorldToViewportPoint(player.Character[_G.AimPart].Position)
                if onScreen then
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
    if not _G.AimbotEnabled then
        FOVCircle:Remove()
        connection:Disconnect()
        return
    end

    local mousePos = GetCorrectMousePos()
    FOVCircle.Visible = _G.ShowFOV
    FOVCircle.Radius = _G.FOVRadius
    FOVCircle.Position = mousePos

    if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) or UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
        local target = GetClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild(_G.AimPart) then
            local targetPos = Camera:WorldToViewportPoint(target.Character[_G.AimPart].Position)
            local moveX = (targetPos.X - mousePos.X) * (1 - _G.AimbotSmoothness)
            local moveY = (targetPos.Y - mousePos.Y) * (1 - _G.AimbotSmoothness)
            
            -- mousemoverel is standard for most mobile/PC executors
            if mousemoverel then
                mousemoverel(moveX, moveY)
            end
        end
    end
end)
