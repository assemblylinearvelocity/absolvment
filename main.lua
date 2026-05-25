local GITHUB_BASE = "https://raw.githubusercontent.com/assemblylinearvelocity/absolvment/main/"

local function loadModule(path)
    local success, result = pcall(function()
        return game:HttpGet(GITHUB_BASE .. path)
    end)
    if not success then
        warn("[Absolvment] Failed to fetch:", path, "|", result)
        return nil
    end
    local loadSuccess, module = pcall(function()
        return loadstring(result)()
    end)
    if not loadSuccess then
        warn("[Absolvment] Failed to execute:", path, "|", module)
        return nil
    end
    return module
end

if shared.Absolvment then
    pcall(function()
        if shared.Absolvment.detach then
            shared.Absolvment.detach()
        end
    end)
end

task.spawn(function()
    local Library = loadModule("GUI/Library.lua")
    if not Library then return warn("Failed to load Library") end
    
    local ThemeManager = loadModule("GUI/addons/ThemeManager.lua")
    if not ThemeManager then return warn("Failed to load ThemeManager") end
    
    local SaveManager = loadModule("GUI/addons/SaveManager.lua")
    if not SaveManager then return warn("Failed to load SaveManager") end
    
    local PlayerESP = loadModule("Game/Visuals/PlayerESP.lua")
    if not PlayerESP then return warn("Failed to load PlayerESP") end
    
    local NPCESP = loadModule("Game/Visuals/NPCESP.lua")
    if not NPCESP then return warn("Failed to load NPCESP") end
    
    local VisualsTab = loadModule("UI/VisualsTab.lua")
    if not VisualsTab then return warn("Failed to load VisualsTab") end
    
    local AutomationTab = loadModule("UI/AutomationTab.lua")
    if not AutomationTab then return warn("Failed to load AutomationTab") end
    
    local MiscTab = loadModule("UI/MiscTab.lua")
    if not MiscTab then return warn("Failed to load MiscTab") end
    
    local SettingsTab = loadModule("UI/SettingsTab.lua")
    if not SettingsTab then return warn("Failed to load SettingsTab") end
    
    local Absolvment = {}
    
    function Absolvment.init()
        Library.ForceCheckbox = false
        Library.ShowToggleFrameInKeybinds = true
        
        local Window = Library:CreateWindow({
            Title = "Absolvment Hub",
            Footer = "version: 1.0.0 (Revival)",
            Icon = 123532668007594,
            NotifySide = "Right",
            ShowCustomCursor = true,
        })
        
        VisualsTab:Create(Window, PlayerESP, NPCESP)
        AutomationTab:Create(Window)
        MiscTab:Create(Window)
        SettingsTab:Create(Window, Library, ThemeManager, SaveManager)
        
        ThemeManager:SetLibrary(Library)
        SaveManager:SetLibrary(Library)
        
        SaveManager:IgnoreThemeSettings()
        SaveManager:SetIgnoreIndexes({ "MenuKeybind" })
        
        ThemeManager:SetFolder("AbsolvmentHub")
        SaveManager:SetFolder("AbsolvmentHub/Absolvment")
        
        SaveManager:LoadAutoloadConfig()
        
        Library:Notify({
            Title = "Absolvment Hub",
            Description = "Successfully loaded! (Revival v1.0.0)",
            Time = 4,
        })
        
        print("[Absolvment] Loaded successfully!")
    end
    
    function Absolvment.detach()
        pcall(function() PlayerESP:Disable() end)
        pcall(function() NPCESP:Disable() end)
        if Library then Library:Unload() end
    end
    
    shared.Absolvment = Absolvment
    
    local ok, err = xpcall(Absolvment.init, function(e)
        warn("Init failed:", e, debug.traceback())
        Absolvment.detach()
    end)
    
    if not ok then
        warn("Initialization failed:", err)
    end
end)
