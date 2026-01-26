_G.BhopEnabled = true
_G.AutoStrafe = true
_G.NoSlow = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local lastMousePos = UserInputService:GetMouseLocation().X

RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChild("Humanoid")
    local hrp = char and char:FindFirstChild("HumanoidRootPart")

    if not hum or not hrp then return end

    -- 1. NO SLOW (Keep max speed 16)
    if _G.NoSlow then
        if hum.WalkSpeed < 16 then
            hum.WalkSpeed = 16
        end
    end

    -- 2. AUTO BHOP (Jump exactly when touching floor)
    if _G.BhopEnabled and UserInputService:IsKeyDown(Enum.KeyCode.Space) then
        if hum.FloorMaterial ~= Enum.Material.Air then
            hum.Jump = true
        end
    end

    -- 3. CS-STYLE AUTO STRAFE
    if _G.AutoStrafe and hum.FloorMaterial == Enum.Material.Air then
        local currentMousePos = UserInputService:GetMouseLocation().X
        
        -- If moving mouse Left, press A
        if currentMousePos < lastMousePos then
            hrp.Velocity = hrp.Velocity + (workspace.CurrentCamera.CFrame.RightVector * -0.5)
        -- If moving mouse Right, press D
        elseif currentMousePos > lastMousePos then
            hrp.Velocity = hrp.Velocity + (workspace.CurrentCamera.CFrame.RightVector * 0.5)
        end
        lastMousePos = currentMousePos
    end
end)

