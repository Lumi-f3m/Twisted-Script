--[[
   Hey!
   I am Lumi, the current developer of this Bloxstike script. Give me time to build it. This will be completely open source and free :D
   This project will NOT be Obfuscated and we'll be testing ESP first :D (Check out the ESP.lua file)
   If you use any component in this script, Please give me some credit atleast. (I wouldn't mind either way)
]]
-- I hope you enjoy it <3

local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

-- Ensure NHack doesn't double-load
if CoreGui:FindFirstChild("NHack_Main") then CoreGui.NHack_Main:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NHack_Main"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- NH Floating Button (Mobile)
local MobileBtn = Instance.new("TextButton")
MobileBtn.Size = UDim2.new(0, 45, 0, 45)
MobileBtn.Position = UDim2.new(0, 10, 0.5, -22)
MobileBtn.BackgroundColor3 = Color3.fromRGB(255, 38, 38)
MobileBtn.Text = "NH"
MobileBtn.TextColor3 = Color3.new(1, 1, 1)
MobileBtn.Font = Enum.Font.GothamBold
MobileBtn.Parent = ScreenGui
Instance.new("UICorner", MobileBtn).CornerRadius = UDim.new(1, 0)

-- Main Menu
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 200, 0, 260)
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -130)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = true
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "NHack v1.0"
Title.TextColor3 = Color3.fromRGB(255, 38, 38)
Title.Font = Enum.Font.GothamBold
Title.BackgroundTransparency = 1
Title.Parent = MainFrame

local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -20, 1, -50)
Scroll.Position = UDim2.new(0, 10, 0, 45)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 0 -- Clean look for mobile
Scroll.Parent = MainFrame
Instance.new("UIListLayout", Scroll).Padding = UDim.new(0, 8)

-- Master Toggle Logic
local function AddToggle(name, url, globalFlag)
    local active = false
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 38)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    btn.Text = name .. ": OFF"
    btn.TextColor3 = Color3.fromRGB(120, 120, 120)
    btn.Font = Enum.Font.Gotham
    btn.Parent = Scroll
    Instance.new("UICorner", btn)

    btn.MouseButton1Click:Connect(function()
        active = not active
        _G[globalFlag] = active
        
        if active then
            btn.BackgroundColor3 = Color3.fromRGB(255, 38, 38)
            btn.TextColor3 = Color3.new(1, 1, 1)
            btn.Text = name .. ": ON"
            task.spawn(function()
                loadstring(game:HttpGet(url))()
            end)
        else
            btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            btn.TextColor3 = Color3.fromRGB(120, 120, 120)
            btn.Text = name .. ": OFF"
        end
    end)
end

-- Loadstrings
local base = "https://raw.githubusercontent.com/Lumi-f3m/BloxStrike-Script/refs/heads/main/scripts/"
AddToggle("Box ESP", base .. "boxESP.lua", "BoxEspEnabled")
AddToggle("Box Wallcheck", base .. "boxESP_Wallcheck.lua", "BoxWallEnabled")
AddToggle("Chams", base .. "chams.lua", "ChamsEnabled")
AddToggle("Chams Wallcheck", base .. "chams_wallcheck.lua", "ChamsWallEnabled")

-- Interaction
local function toggleUI() MainFrame.Visible = not MainFrame.Visible end
MobileBtn.MouseButton1Click:Connect(toggleUI)
UserInputService.InputBegan:Connect(function(io, p)
    if not p and io.KeyCode == Enum.KeyCode.M then toggleUI() end
end)
