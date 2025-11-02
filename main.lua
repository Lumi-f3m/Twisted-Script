-- ✅️ Mobile friendly
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "quick script",
   Icon = 0,
   LoadingTitle = "ahh script",
   LoadingSubtitle = "by Lumi_f3m",
   ShowText = "LumiCB",
   Theme = "AmberGlow", -- sonething something

   ToggleUIKeybind = "L", -- Keybind to toggle the UI

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false,

   -- Save configs
   ConfigurationSaving = {
      Enabled = false,
      FolderName = nil,
      FileName = "Big Hub"
   },

   Discord = {
      Enabled = false,
      Invite = "noinvitelink",
      RememberJoins = true 
   },

   -- Not used
   KeySystem = false,
   KeySettings = {
      Title = "100% not 12345",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided",
      FileName = "Key",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"12345"}
   }
})

Rayfield:Notify({
   Title = "Script Loaded",
   Content = "Script Executed!",
   Duration = 4,
   Image = nil,
})

-- Variables
local RunService = game:GetService("RunService")
local lighting = game:GetService("Lighting")

-- Actual Stuff tho
local MainTab = Window:CreateTab("Main", 4483362458)
local VisualsSection = MainTab:CreateSection("Visuals")
local ESPSection = MainTab:CreateSection("ESP")

-- --- Fullbright Variables & Logic ---
local FullbrightActive = false
local defaultBrightness = lighting.Brightness 
local connection = nil -- Heartbeat connection for Fullbright

local function runFullbright()
    connection = RunService.Heartbeat:Connect(function()
        if FullbrightActive then
             -- Set brightness, Ambient, and OutdoorAmbient to high values
             lighting.Brightness = 100
             lighting.Ambient = Color3.new(1, 1, 1)
             lighting.OutdoorAmbient = Color3.new(1, 1, 1)
        end
    end)
end

-- --- ESP Variables & Logic (New) ---
local targetContainer = workspace:FindFirstChild("storm_related") and workspace.storm_related:FindFirstChild("storms")
local ESPActive = false
local activeHighlights = {} -- Stores part -> highlight reference
local espConnection = nil -- Heartbeat connection for ESP
local ESP_COLOR = Color3.fromRGB(255, 0, 0) -- Bright Red outline

-- Function to remove all currently active highlights
local function cleanupESP()
    if espConnection then
        espConnection:Disconnect()
        espConnection = nil
    end

    -- Destroy all stored Highlight instances
    for part, highlight in pairs(activeHighlights) do
        highlight:Destroy()
    end
    activeHighlights = {} 
end

-- Function to check for parts and ensure they have a highlight (runs every frame)
local function updateESP()
    if not targetContainer then return end

    -- 1. Iterate through the target container for new parts
    for _, part in ipairs(targetContainer:GetDescendants()) do
        if part:IsA("BasePart") and not activeHighlights[part] then
            -- Create a new Highlight instance
            local highlight = Instance.new("Highlight")
            highlight.Name = "ESPHighlight"
            highlight.FillTransparency = 1 -- Hide the fill, just show the outline
            highlight.OutlineColor = ESP_COLOR
            highlight.DepthMode = Enum.DepthMode.AlwaysOnTop -- See through walls
            highlight.Parent = part
            
            -- Store the reference
            activeHighlights[part] = highlight
        end
    end

    -- 2. Clean up highlights for parts that have been destroyed or moved
    for part, highlight in pairs(activeHighlights) do
        if not part.Parent or not part:IsDescendantOf(targetContainer) then
             highlight:Destroy()
             activeHighlights[part] = nil
        end
    end
end

-- --- UI COMPONENTS ---

-- 1. Fullbright Toggle Component (Uses Visuals Section)
local FullbrightToggle = MainTab:CreateToggle({ 
   Name = "Robust Fullbright",
   Info = "Resets lighting every frame to bypass common anti-exploits.",
   CurrentValue = false,
   Flag = "FullbrightRobust", 
   SectionParent = VisualsSection, 
   Callback = function(Value)
        FullbrightActive = Value 
        
        if FullbrightActive then
            print("Robust Fullbright Activated.")
            runFullbright()
        else
            print("Robust Fullbright Deactivated.")
            
            if connection then
                connection:Disconnect()
                connection = nil
            end
            
            -- Restore original lighting settings
            lighting.Brightness = defaultBrightness 
            lighting.Ambient = Color3.new(0, 0, 0) 
            lighting.OutdoorAmbient = Color3.new(0, 0, 0)
        end
   end,
})


-- 2. Storm ESP Toggle Component (Uses ESP Section)
local StormESPToggle = MainTab:CreateToggle({ 
   Name = "Storm ESP",
   Info = "Outlines objects under 'storms' (visible through walls).",
   CurrentValue = false,
   Flag = "StormESP", 
   SectionParent = ESPSection, 
   Callback = function(Value)
        if not targetContainer then
            Rayfield:Notify({
               Title = "ESP Error",
               Content = "Target container 'storms' not found in workspace.",
               Duration = 4,
            })
            return
        end

        ESPActive = Value 
        
        if ESPActive then
            print("Storm ESP Activated.")
            -- Start the frame-based update loop
            espConnection = RunService.Heartbeat:Connect(updateESP) 
        else
            print("Storm ESP Deactivated.")
            cleanupESP() -- Stop the loop and destroy highlights
        end
   end,
})
