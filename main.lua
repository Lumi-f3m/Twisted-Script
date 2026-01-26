--[[
   Hey!
   I am Lumi, the current developer of this Bloxstike script. Give me time to build it. This will be completely open source and free :D
   This project will NOT be Obfuscated and we'll be testing ESP first :D (Check out the ESP.lua file)
   If you use any component in this script, Please give me some credit atleast. (I wouldn't mind either way)
]]
-- I hope you enjoy it <3

local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

-- Prevent Multi-Loading
if CoreGui:FindFirstChild("NHack_Main") then CoreGui.NHack_Main:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NHack_Main"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- NH Floating Button (Mobile Toggle)
local MobileBtn = Instance.new("TextButton")
MobileBtn.Size = UDim2.new(0, 50, 0, 50)
MobileBtn.Position = UDim2.new(0, 15, 0.5, -25)
MobileBtn.BackgroundColor3 = Color3.fromRGB(255, 38, 38)
MobileBtn.Text = "NH"
MobileBtn.TextColor3 = Color3.new(1, 1, 1)
MobileBtn.Font = Enum.Font.GothamBold
MobileBtn.TextSize = 18
MobileBtn.Parent = ScreenGui
Instance.new("UICorner", MobileBtn).CornerRadius = UDim.new(1, 0)

-- Main Menu Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 240, 0, 360)
MainFrame.Position = UDim2.new(0.5, -120, 0.5, -180)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = true
MainFrame.Active = true
MainFrame.Draggable = true -- High utility for mobile testing
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 45)
Title.Text = "NHack | Owner Console"
Title.TextColor3 = Color3.fromRGB(255, 38, 38)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.BackgroundTransparency = 1
Title.Parent = MainFrame

local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -20, 1, -60)
Scroll.Position = UDim2.new(0, 10, 0, 50)
Scroll.BackgroundTransparency = 1
Scroll.CanvasSize = UDim2.new(0, 0, 1.8, 0) -- Extra space for sliders
Scroll.ScrollBarThickness = 0 
Scroll.Parent = MainFrame
Instance.new("UIListLayout", Scroll).Padding = UDim.new(0, 10)

-- --- UI COMPONENT FUNCTIONS ---

-- 1. Toggles
local function AddToggle(name, url, globalFlag)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    btn.Text = name .. ": OFF"
    btn.TextColor3 = Color3.fromRGB(150, 150, 150)
    btn.Font = Enum.Font.Gotham
    btn.Parent = Scroll
    Instance.new("UICorner", btn)

    btn.MouseButton1Click:Connect(function()
        _G[globalFlag] = not _G[globalFlag]
        if _G[globalFlag] then
            btn.BackgroundColor3 = Color3.fromRGB(255, 38, 38)
            btn.TextColor3 = Color3.new(1, 1, 1)
            btn.Text = name .. ": ON"
            task.spawn(function() loadstring(game:HttpGet(url))() end)
        else
            btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            btn.TextColor3 = Color3.fromRGB(150, 150, 150)
            btn.Text = name .. ": OFF"
        end
    end)
end

-- 2. Sliders
local function AddSlider(name, min, max, default, callback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(1, 0, 0, 50)
    sliderFrame.BackgroundTransparency = 1
    sliderFrame.Parent = Scroll

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Text = name .. ": " .. default
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.Font = Enum.Font.Gotham
    label.BackgroundTransparency = 1
    label.Parent = sliderFrame

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(1, -10, 0, 6)
    bar.Position = UDim2.new(0, 5, 0, 30)
    bar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    bar.Parent = sliderFrame
    Instance.new("UICorner", bar)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(255, 38, 38)
    fill.Parent = bar
    Instance.new("UICorner", fill)

    local function update(input)
        local sizeX = math.clamp((input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
        fill.Size = UDim2.new(sizeX, 0, 1, 0)
        local val = math.floor(min + (max - min) * sizeX)
        label.Text = name .. ": " .. val
        callback(val)
    end

    bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local conn
            conn = RunService.RenderStepped:Connect(function()
                update(UserInputService:GetMouseLocation()) -- Works for Touch too
                if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                    conn:Disconnect()
                end
            end)
        end
    end)
end

-- --- LOADSTRINGS & CONFIG ---
local base = "https://raw.githubusercontent.com/Lumi-f3m/BloxStrike-Script/refs/heads/main/scripts/"

-- ESP SECTION
AddToggle("Box ESP", base .. "boxESP.lua", "BoxEspEnabled")
AddToggle("Box Wallcheck", base .. "boxESP_Wallcheck.lua", "BoxWallEnabled")
AddToggle("Chams", base .. "chams.lua", "ChamsEnabled")
AddToggle("Chams Wallcheck", base .. "chams_wallcheck.lua", "ChamsWallEnabled")

-- AIMBOT SECTION
AddToggle("Aimbot", base .. "aimbot.lua", "AimbotEnabled")
AddSlider("FOV Radius", 30, 600, 100, function(v) _G.FOVRadius = v end)
AddSlider("Smoothness", 0, 90, 50, function(v) _G.AimbotSmoothness = v / 100 end)

-- --- UTILS ---
local function toggleUI() MainFrame.Visible = not MainFrame.Visible end
MobileBtn.MouseButton1Click:Connect(toggleUI)
UserInputService.InputBegan:Connect(function(io, p)
    if not p and io.KeyCode == Enum.KeyCode.M then toggleUI() end
end)
