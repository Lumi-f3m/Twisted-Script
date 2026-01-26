local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- Customization 🎨
local BOX_COLOR = Color3.fromRGB(255, 38, 38) -- Tactical Red

local function createEsp(player)
    local box = Drawing.new("Square")
    box.Thickness = 1
    box.Filled = false
    box.Visible = false

    local nameTag = Drawing.new("Text")
    nameTag.Size = 13
    nameTag.Center = true
    nameTag.Outline = true
    nameTag.Color = Color3.new(1, 1, 1)
    nameTag.Visible = false

    local connection
    connection = RunService.RenderStepped:Connect(function()
        local char = player.Character
        
        -- 1. TEAM & LIFE CHECK
        if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") then
            
            -- Skip Teammates
            if player.Team == LocalPlayer.Team and player.Team ~= nil then
                box.Visible = false; nameTag.Visible = false
                return
            end

            local hum = char.Humanoid
            if hum.Health <= 0 then
                box.Visible = false; nameTag.Visible = false
                return 
            end

            local hrp = char.HumanoidRootPart
            local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)

            if onScreen then
                -- 2. ACCURATE BOUNDS CALCULATION
                local cf, size = char:GetBoundingBox()
                
                -- Calculate 3D corners to project into 2D screen space
                local corners = {
                    cf * CFrame.new(size.X/2, size.Y/2, size.Z/2),
                    cf * CFrame.new(-size.X/2, -size.Y/2, -size.Z/2)
                }
                
                local minX, minY = math.huge, math.huge
                local maxX, maxY = -math.huge, -math.huge

                for _, corner in pairs(corners) do
                    local sPos = Camera:WorldToViewportPoint(corner.Position)
                    minX, minY = math.min(minX, sPos.X), math.min(minY, sPos.Y)
                    maxX, maxY = math.max(maxX, sPos.X), math.max(maxY, sPos.Y)
                end

                -- 3. APPLY VISUALS (No Wallcheck Math!)
                box.Size = Vector2.new(maxX - minX, maxY - minY)
                box.Position = Vector2.new(minX, minY)
                box.Color = BOX_COLOR
                box.Visible = true

                nameTag.Text = string.format("%s [%dm]", player.Name, math.floor(pos.Z))
                nameTag.Position = Vector2.new((minX + maxX) / 2, minY - 20)
                nameTag.Visible = true
            else
                box.Visible = false; nameTag.Visible = false
            end
        else
            box.Visible = false; nameTag.Visible = false
        end
    end)

    -- Cleanup when player leaves or script stops
    Players.PlayerRemoving:Connect(function(p)
        if p == player then
            connection:Disconnect()
            box:Remove(); nameTag:Remove()
        end
    end)
end

-- Initialize for everyone
for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer then createEsp(p) end end
Players.PlayerAdded:Connect(createEsp)

