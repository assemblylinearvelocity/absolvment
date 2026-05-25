-- Absolvment Hub - Main Script
-- Clean rewrite by your team

print("[Absolvment] Loading...")

-- Load UI Library
local Library = loadfile("GUI/Library.lua")()
local ThemeManager = loadfile("GUI/addons/ThemeManager.lua")()
local SaveManager = loadfile("GUI/addons/SaveManager.lua")()

-- Load Game Modules (Backend)
local PlayerESP = loadfile("Game/Visuals/PlayerESP.lua")()
local NPCESP = loadfile("Game/Visuals/NPCESP.lua")()

-- Load UI Tabs (Frontend)
local VisualsTab = loadfile("UI/VisualsTab.lua")()
local AutomationTab = loadfile("UI/AutomationTab.lua")()
local MiscTab = loadfile("UI/MiscTab.lua")()
local SettingsTab = loadfile("UI/SettingsTab.lua")()

-- Library Options
Library.ForceCheckbox = false
Library.ShowToggleFrameInKeybinds = true

-- Create Window
local Window = Library:CreateWindow({
    Title = "Absolvment Hub",
    Footer = "version: 1.0.0 (Revival)",
    Icon = 123532668007594,
    NotifySide = "Right",
    ShowCustomCursor = true,
})

-- ========================================
-- CREATE TABS
-- ========================================

-- Create Visuals Tab (with ESP modules)
VisualsTab:Create(Window, PlayerESP, NPCESP)

-- Create Automation Tab (placeholder for now)
AutomationTab:Create(Window)

-- Create Misc Tab (placeholder for now)
MiscTab:Create(Window)

-- Create Settings Tab (with theme & save manager)
SettingsTab:Create(Window, Library, ThemeManager, SaveManager)

-- ========================================
-- THEME & SAVE MANAGER SETUP
-- ========================================

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })

ThemeManager:SetFolder("AbsolvmentHub")
SaveManager:SetFolder("AbsolvmentHub/Absolvment")

-- Load autoload config
SaveManager:LoadAutoloadConfig()

-- ========================================
-- CLEANUP
-- ========================================

Library:OnUnload(function()
    print("[Absolvment] Unloading...")
    
    -- Disable all ESP
    if PlayerESP.Enabled then
        PlayerESP:Disable()
    end
    if NPCESP.Enabled then
        NPCESP:Disable()
    end
    
    print("[Absolvment] Unloaded!")
end)

-- ========================================
-- READY
-- ========================================

Library:Notify({
    Title = "Absolvment Hub",
    Description = "Successfully loaded! (Revival v1.0.0)",
    Time = 4,
})

print("[Absolvment] Loaded successfully!")
