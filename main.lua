--[[
   Hey!
   I am Lumi, the current developer of this Bloxstike script. Give me time to build it. This will be completely open source and free :D
   This project will NOT be Obfuscated and we'll be testing ESP first :D (Check out the ESP.lua file)
   If you use any component in this script, Please give me some credit atleast. (I wouldn't mind either way)
]]
 -- I hope you enjoy it <3
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

-- 1. Setup Main ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NHack_Main"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- 2. Floating Mobile Button
local MobileBtn = Instance.new("TextButton")
MobileBtn.Size = UDim2.new(0, 50, 0, 50)
MobileBtn.Position = UDim2.new(0, 10, 0.5, -25)
MobileBtn.BackgroundColor3 = Color3.fromRGB(255, 38, 38)
MobileBtn.Text = "NH"
MobileBtn.TextColor3 = Color3.new(1, 1, 1)
MobileBtn.Font = Enum.Font.GothamBold
MobileBtn.Parent = ScreenGui
Instance.new("UICorner", MobileBtn).CornerRadius = UDim.new(1, 0)

-- 3. Main Menu Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 220, 0, 300)
MainFrame.Position = UDim2.new(0.5, -110, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 45)
Title.Text = "NHack Console"
Title.TextColor3 = Color3.fromRGB(255, 38, 38)
Title.Font = Enum.Font.GothamBold
Title.BackgroundTransparency = 1
Title.Parent = MainFrame

local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -20, 1, -60)
Scroll.Position = UDim2.new(0, 10, 0, 50)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 2
Scroll.Parent = MainFrame
Instance.new("UIListLayout", Scroll).Padding = UDim.new(0, 10)

-- 4. TOGGLE FUNCTION (The Logic)
local function AddToggle(name, url, globalFlag)
    local active = false
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.Text = name .. ": OFF"
    btn.TextColor3 = Color3.fromRGB(150, 150, 150)
    btn.Font = Enum.Font.Gotham
    btn.Parent = Scroll
    Instance.new("UICorner", btn)

    btn.MouseButton1Click:Connect(function()
        active = not active
        if active then
            -- Turn ON
            _G[globalFlag] = true 
            btn.BackgroundColor3 = Color3.fromRGB(255, 38, 38)
            btn.TextColor3 = Color3.new(1, 1, 1)
            btn.Text = name .. ": ON"
            
            -- Run the loadstring
            task.spawn(function()
                loadstring(game:HttpGet(url))()
            end)
        else
            -- Turn OFF
            _G[globalFlag] = false -- This triggers the Kill-Switch in the script
            btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            btn.TextColor3 = Color3.fromRGB(150, 150, 150)
            btn.Text = name .. ": OFF"
        end
    end)
end

-- 5. Add your Loadstrings with their unique Global Flags
AddToggle("Box ESP", "https://raw.githubusercontent.com/Lumi-f3m/BloxStrike-Script/refs/heads/main/scripts/boxESP.lua", "BoxEspEnabled")
AddToggle("Box Wallcheck", "https://raw.githubusercontent.com/Lumi-f3m/BloxStrike-Script/refs/heads/main/scripts/boxESP_Wallcheck.lua", "BoxWallEnabled")
AddToggle("Chams", "https://raw.githubusercontent.com/Lumi-f3m/BloxStrike-Script/refs/heads/main/scripts/chams.lua", "ChamsEnabled")
AddToggle("Chams Wallcheck", "https://raw.githubusercontent.com/Lumi-f3m/BloxStrike-Script/refs/heads/main/scripts/chams_wallcheck.lua", "ChamsWallEnabled")

-- 6. Visibility Toggles (M and Button)
local function toggleUI() MainFrame.Visible = not MainFrame.Visible end
MobileBtn.MouseButton1Click:Connect(toggleUI)
UserInputService.InputBegan:Connect(function(io, p)
    if not p and io.KeyCode == Enum.KeyCode.M then toggleUI() end
end)
