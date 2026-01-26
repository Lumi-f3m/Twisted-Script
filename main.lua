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

if CoreGui:FindFirstChild("NHack_Main") then CoreGui.NHack_Main:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NHack_Main"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- Mobile Toggle Button
local MobileBtn = Instance.new("TextButton")
MobileBtn.Size = UDim2.new(0, 50, 0, 50)
MobileBtn.Position = UDim2.new(0, 15, 0.5, -25)
MobileBtn.BackgroundColor3 = Color3.fromRGB(255, 38, 38)
MobileBtn.Text = "NH"
MobileBtn.TextColor3 = Color3.new(1, 1, 1)
MobileBtn.Font = Enum.Font.GothamBold
MobileBtn.Parent = ScreenGui
Instance.new("UICorner", MobileBtn).CornerRadius = UDim.new(1, 0)

-- Menu Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 220, 0, 320)
MainFrame.Position = UDim2.new(0.5, -110, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame)

local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -20, 1, -50)
Scroll.Position = UDim2.new(0, 10, 0, 45)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 0
Scroll.Parent = MainFrame
Instance.new("UIListLayout", Scroll).Padding = UDim.new(0, 10)

-- --- UI Logic ---
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
        btn.BackgroundColor3 = _G[globalFlag] and Color3.fromRGB(255, 38, 38) or Color3.fromRGB(25, 25, 25)
        btn.TextColor3 = _G[globalFlag] and Color3.new(1, 1, 1) or Color3.fromRGB(150, 150, 150)
        btn.Text = name .. (_G[globalFlag] and ": ON" or ": OFF")
        if _G[globalFlag] then task.spawn(function() loadstring(game:HttpGet(url))() end) end
    end)
end

local function AddSlider(name, min, max, default, callback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(1, 0, 0, 50)
    sliderFrame.BackgroundTransparency = 1
    sliderFrame.Parent = Scroll

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Text = name .. ": " .. default
    label.TextColor3 = Color3.new(1, 1, 1)
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
        local pos = math.clamp((input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
        fill.Size = UDim2.new(pos, 0, 1, 0)
        local val = math.floor(min + (max - min) * pos)
        label.Text = name .. ": " .. val
        callback(val)
    end

    bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local connection
            connection = UserInputService.InputChanged:Connect(function(move)
                if move.UserInputType == Enum.UserInputType.MouseMovement or move.UserInputType == Enum.UserInputType.Touch then
                    update(move)
                end
            end)
            UserInputService.InputEnded:Connect(function(ended)
                if ended.UserInputType == Enum.UserInputType.MouseButton1 or ended.UserInputType == Enum.UserInputType.Touch then
                    connection:Disconnect()
                end
            end)
        end
    end)
end

-- --- Load ---
local base = "https://raw.githubusercontent.com/Lumi-f3m/BloxStrike-Script/refs/heads/main/scripts/"
AddToggle("Aimbot", base .. "aimbot.lua", "AimbotEnabled")
AddSlider("FOV", 10, 500, 100, function(v) _G.FOVRadius = v end)
AddSlider("Smooth", 0, 95, 50, function(v) _G.AimbotSmoothness = v/100 end)
AddToggle("Box ESP", base .. "boxESP.lua", "BoxEspEnabled")
AddToggle("Chams", base .. "chams.lua", "ChamsEnabled")

-- --- Show/Hide ---
MobileBtn.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)
UserInputService.InputBegan:Connect(function(io, p) if not p and io.KeyCode == Enum.KeyCode.M then MainFrame.Visible = not MainFrame.Visible end end)
