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

if CoreGui:FindFirstChild("NHack_Premium") then CoreGui.NHack_Premium:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NHack_Premium"
ScreenGui.Parent = CoreGui

-- Main Menu
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 550, 0, 350)
Main.Position = UDim2.new(0.5, -275, 0.5, -175)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

-- Sidebar
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 140, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Main
local SCorner = Instance.new("UICorner", Sidebar)
SCorner.CornerRadius = UDim.new(0, 12)

-- Logo (NHack)
local Logo = Instance.new("TextLabel")
Logo.Size = UDim2.new(1, 0, 0, 60)
Logo.Text = "NHack"
Logo.TextColor3 = Color3.fromRGB(255, 38, 38)
Logo.Font = Enum.Font.GothamBold
Logo.TextSize = 24
Logo.BackgroundTransparency = 1
Logo.Parent = Sidebar

-- Tab Container
local Pages = Instance.new("Frame")
Pages.Size = UDim2.new(1, -150, 1, -20)
Pages.Position = UDim2.new(0, 150, 0, 10)
Pages.BackgroundTransparency = 1
Pages.Parent = Main

local function CreatePage(name)
    local p = Instance.new("Frame")
    p.Name = name
    p.Size = UDim2.new(1, 0, 1, 0)
    p.BackgroundTransparency = 1
    p.Visible = false
    p.Parent = Pages
    Instance.new("UIListLayout", p).Padding = UDim.new(0, 10)
    return p
end

local CombatPage = CreatePage("Combat")
local VisualsPage = CreatePage("Visuals")

-- Custom Components (Matching your image)
local function AddToggle(parent, name, url, flag)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    btn.Text = "  " .. name
    btn.TextColor3 = Color3.fromRGB(150, 150, 150)
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Font = Enum.Font.Gotham
    btn.Parent = parent
    Instance.new("UICorner", btn)

    btn.MouseButton1Click:Connect(function()
        _G[flag] = not _G[flag]
        btn.TextColor3 = _G[flag] and Color3.fromRGB(255, 38, 38) or Color3.fromRGB(150, 150, 150)
        if _G[flag] then loadstring(game:HttpGet(url))() end
    end)
end

-- Sidebar Buttons
local function AddTab(name, page)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.8, 0, 0, 40)
    btn.Position = UDim2.new(0.1, 0, 0, 70 + (#Sidebar:GetChildren() * 45))
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    btn.Text = name
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.Gotham
    btn.Parent = Sidebar
    Instance.new("UICorner", btn)

    btn.MouseButton1Click:Connect(function()
        for _, v in pairs(Pages:GetChildren()) do if v:IsA("Frame") then v.Visible = false end end
        page.Visible = true
    end)
end

AddTab("Combat", CombatPage)
AddTab("Visuals", VisualsPage)

-- Populate Pages
local base = "https://raw.githubusercontent.com/Lumi-f3m/BloxStrike-Script/refs/heads/main/scripts/"
AddToggle(CombatPage, "Aimbot Toggle", base.."aimbot.lua", "AimbotEnabled")
AddToggle(VisualsPage, "Box ESP", base.."boxESP.lua", "BoxEspEnabled")
AddToggle(VisualsPage, "Chams", base.."chams.lua", "ChamsEnabled")

CombatPage.Visible = true -- Default page
