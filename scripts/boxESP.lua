-- oh.
_G.BoxEspEnabled = true 

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local function createEsp(player)
    local box = Drawing.new("Square")
    box.Thickness = 1
    box.Filled = false
    box.Visible = false

    local nameTag = Drawing.new("Text")
    nameTag.Size = 13
    nameTag.Center = true
    nameTag.Outline = true
    nameTag.Visible = false

    local connection
    connection = RunService.RenderStepped:Connect(function()
        -- THE "KILL SWITCH" CHECK
        if _G.BoxEspEnabled == false then
            box:Remove()
            nameTag:Remove()
            connection:Disconnect() -- This stops the loop forever
            return
        end

        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") then
            -- Team Check
            if player.Team == LocalPlayer.Team and player.Team ~= nil then
                box.Visible = false; nameTag.Visible = false
                return
            end

            local hrp = char.HumanoidRootPart
            local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)

            if onScreen then
                local cf, size = char:GetBoundingBox()
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

                box.Size = Vector2.new(maxX - minX, maxY - minY)
                box.Position = Vector2.new(minX, minY)
                box.Color = Color3.fromRGB(255, 38, 38)
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

    -- Cleanup if player leaves
    Players.PlayerRemoving:Connect(function(p)
        if p == player then
            box:Remove(); nameTag:Remove(); connection:Disconnect()
        end
    end)
end

for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer then createEsp(p) end end
Players.PlayerAdded:Connect(createEsp)
