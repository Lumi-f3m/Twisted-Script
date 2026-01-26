_G.ChamsEnabled = true

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function applyChams(player)
    if player == LocalPlayer then return end

    local function setup(char)
        -- The Kill Switch check inside the loop-equivalent
        task.spawn(function()
            while char and char.Parent do
                if not _G.ChamsEnabled then
                    local hl = char:FindFirstChild("NHack_Cham")
                    if hl then hl:Destroy() end
                    break -- Stops the check
                end
                
                -- Team Check
                if player.Team == LocalPlayer.Team and player.Team ~= nil then
                    local hl = char:FindFirstChild("NHack_Cham")
                    if hl then hl:Destroy() end
                else
                    -- Apply/Update Cham
                    local hl = char:FindFirstChild("NHack_Cham") or Instance.new("Highlight")
                    hl.Name = "NHack_Cham"
                    hl.FillColor = Color3.fromRGB(255, 38, 38)
                    hl.OutlineColor = Color3.new(1, 1, 1)
                    hl.FillTransparency = 0.5
                    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    hl.Parent = char
                end
                task.wait(1) -- Check every second to save performance
            end
        end)
    end

    if player.Character then setup(player.Character) end
    player.CharacterAdded:Connect(setup)
end

for _, p in pairs(Players:GetPlayers()) do applyChams(p) end
Players.PlayerAdded:Connect(applyChams)
