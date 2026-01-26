_G.BhopEnabled = true
_G.AutoStrafe = true
_G.NoSlow = true
_G.TargetSpeed = 18 -- Your new preferred speed

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local lastMousePos = UserInputService:GetMouseLocation().X

RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    
    local hum = char:FindFirstChild("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return end

    -- 1. HARD-LOCK SPEED (The No-Slow)
    -- This overrides landing lag, stuns, and weight
    if _G.NoSlow then
        hum.WalkSpeed = _G.TargetSpeed
    end

    -- 2. AUTO BHOP (ChangeState is better for 18+ speed)
    if _G.BhopEnabled and UserInputService:IsKeyDown(Enum.KeyCode.Space) then
        if hum.FloorMaterial ~= Enum.Material.Air then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end

    -- 3. SOURCE-STYLE AUTO STRAFE
    if _G.AutoStrafe and hum.FloorMaterial == Enum.Material.Air then
        local currentMousePos = UserInputService:GetMouseLocation().X
        local delta = currentMousePos - lastMousePos
        
        -- Subtle air-drift math
        if delta > 0 then
            hrp.CFrame = hrp.CFrame * CFrame.new(-0.08, 0, 0) -- Adjusted for 18 speed
        elseif delta < 0 then
            hrp.CFrame = hrp.CFrame * CFrame.new(0.08, 0, 0)
        end
        
        lastMousePos = currentMousePos
    end
end)
