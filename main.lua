--[[
   Hey!
   I am Lumi, the current developer of this Bloxstike script. Give me time to build it. This will be completely open source and free :D
   This project will NOT be Obfuscated and we'll be testing ESP first :D (Check out the ESP.lua file)
   If you use any component in this script, Please give me some credit atleast. (I wouldn't mind either way)
]]
-- I hope you enjoy it <3

local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Cleanup existing UI to prevent double-loading
if CoreGui:FindFirstChild("NHack_Glass") then CoreGui.NHack_Glass:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NHack_Glass"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- Top Pill Toggle
local Pill = Instance.new("TextButton")
Pill.Size = UDim2.new(0, 80, 0, 30)
Pill.Position = UDim2.new(0.5, -40, 0, 15)
Pill.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Pill.Text = "NHACK"
Pill.TextColor3 = Color3.fromRGB(255, 38, 38)
Pill.Font = Enum.Font.GothamBold
Pill.TextSize = 11
Pill.Parent = ScreenGui
Instance.new("UICorner", Pill).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", Pill).Color = Color3.fromRGB(255, 38, 38)

-- Main Glass Frame
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 420, 0, 320)
Main.Position = UDim2.new(0.5, -210, 0.5, -160)
Main.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
Main.BackgroundTransparency = 0.15
Main.BorderSizePixel = 0
Main.Visible = true
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

-- Navigation Bar
local Navbar = Instance.new("Frame")
Navbar.Size = UDim2.new(1, 0, 0, 50)
Navbar.BackgroundTransparency = 1
Navbar.Parent = Main

local TabHolder = Instance.new("Frame")
TabHolder.Size = UDim2.new(0, 300, 1, 0)
TabHolder.Position = UDim2.new(0.5, -150, 0, 0)
TabHolder.BackgroundTransparency = 1
TabHolder.Parent = Navbar
local TabList = Instance.new("UIListLayout", TabHolder)
TabList.FillDirection = Enum.FillDirection.Horizontal
TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center
TabList.Padding = UDim.new(0, 15)

-- Content Area
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -30, 1, -70)
Content.Position = UDim2.new(0, 15, 0, 55)
Content.BackgroundTransparency = 1
Content.Parent = Main

local function CreatePage(name)
    local p = Instance.new("ScrollingFrame")
    p.Name = name
    p.Size = UDim2.new(1, 0, 1, 0)
    p.BackgroundTransparency = 1
    p.Visible = false
    p.ScrollBarThickness = 0
    p.Parent = Content
    Instance.new("UIListLayout", p).Padding = UDim.new(0, 8)
    return p
end

local CombatPage = CreatePage("Combat")
local VisualsPage = CreatePage("Visuals")
local MovePage = CreatePage("Movement")

-- Feature Card Component
local function AddFeature(parent, name, url, flag, isAddon)
    local card = Instance.new("TextButton")
    card.Size = isAddon and UDim2.new(0.92, 0, 0, 35) or UDim2.new(1, 0, 0, 45)
    card.BackgroundColor3 = isAddon and Color3.fromRGB(22, 22, 22) or Color3.fromRGB(28, 28, 28)
    card.Text = (isAddon and "      └─ " or "   ") .. name
    card.TextColor3 = Color3.fromRGB(160, 160, 160)
    card.TextXAlignment = Enum.TextXAlignment.Left
    card.Font = Enum.Font.GothamSemibold
    card.Parent = parent
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)

    card.MouseButton1Click:Connect(function()
        _G[flag] = not _G[flag]
        local active = _G[flag]
        
        -- Smooth visual feedback
        TweenService:Create(card, TweenInfo.new(0.25), {
            TextColor3 = active and Color3.fromRGB(255, 38, 38) or Color3.fromRGB(160, 160, 160),
            BackgroundColor3 = active and Color3.fromRGB(35, 25, 25) or (isAddon and Color3.fromRGB(22, 22, 22) or Color3.fromRGB(28, 28, 28))
        }):Play()

        -- Execution logic with Debugging
        if active and url then
            task.spawn(function()
                local success, result = pcall(function()
                    return game:HttpGet(url)
                end)
                
                if success then
                    loadstring(result)()
                else
                    warn("NHack Load Error: Could not reach URL -> " .. url)
                end
            end)
        end
    end)
end

-- Tab Button Component
local function AddTab(name, page)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 85, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(100, 100, 100)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.Parent = TabHolder

    btn.MouseButton1Click:Connect(function()
        for _, v in pairs(Content:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end
        for _, v in pairs(TabHolder:GetChildren()) do 
            if v:IsA("TextButton") then v.TextColor3 = Color3.fromRGB(100, 100, 100) end 
        end
        page.Visible = true
        btn.TextColor3 = Color3.fromRGB(255, 38, 38)
    end)
end

-- Navigation Setup
AddTab("COMBAT", CombatPage)
AddTab("VISUALS", VisualsPage)
AddTab("MOVE", MovePage)

-- GitHub Paths (Ensure these match your repo exactly!)
local base = "https://raw.githubusercontent.com/Lumi-f3m/BloxStrike-Script/refs/heads/main/scripts/"

-- COMBAT PAGE
AddFeature(CombatPage, "Silent Aim", base.."silent_aim.lua", "SilentAimEnabled")
AddFeature(CombatPage, "Silent Wallcheck", nil, "SilentAimWallcheck", true)
AddFeature(CombatPage, "Auto Shoot", nil, "AutoShoot", true)

-- VISUALS PAGE
AddFeature(VisualsPage, "Box ESP", base.."boxESP.lua", "BoxEspEnabled")
AddFeature(VisualsPage, "ESP Wallcheck", nil, "VisualsWallcheck", true)
AddFeature(VisualsPage, "Chams", base.."chams.lua", "ChamsEnabled")
AddFeature(VisualsPage, "Chams Wallcheck", nil, "ChamsWallcheck", true)

-- MOVEMENT PAGE
AddFeature(MovePage, "Auto BHop", base.."movement.lua", "BhopEnabled")
AddFeature(MovePage, "Auto Strafe", nil, "AutoStrafe", true)
AddFeature(MovePage, "Anti-Slow (16 Speed)", nil, "NoSlow", true)

-- Toggle Menu Logic
Pill.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

-- Keybind for PC
UserInputService.InputBegan:Connect(function(io, p)
    if not p and io.KeyCode == Enum.KeyCode.M then Main.Visible = not Main.Visible end
end)

-- Default Page
CombatPage.Visible = true
TabHolder:FindFirstChild("TextButton").TextColor3 = Color3.fromRGB(255, 38, 38)
