-- Settings Tab UI
local SettingsTab = {}

function SettingsTab:Create(Window, Library, ThemeManager, SaveManager)
    local Tab = Window:AddTab("UI Settings", "settings")
    
    -- ========================================
    -- MENU SETTINGS
    -- ========================================
    
    local MenuGroup = Tab:AddLeftGroupbox("Menu", "wrench")
    
    MenuGroup:AddToggle("KeybindMenuOpen", {
        Default = Library.KeybindFrame.Visible,
        Text = "Open Keybind Menu",
        Callback = function(value)
            Library.KeybindFrame.Visible = value
        end,
    })
    
    MenuGroup:AddToggle("ShowCustomCursor", {
        Text = "Custom Cursor",
        Default = true,
        Callback = function(Value)
            Library.ShowCustomCursor = Value
        end,
    })
    
    MenuGroup:AddDropdown("NotificationSide", {
        Values = { "Left", "Right" },
        Default = "Right",
        Text = "Notification Side",
        Callback = function(Value)
            Library:SetNotifySide(Value)
        end,
    })
    
    MenuGroup:AddDropdown("DPIDropdown", {
        Values = { "50%", "75%", "100%", "125%", "150%", "175%", "200%" },
        Default = "100%",
        Text = "DPI Scale",
        Callback = function(Value)
            Value = Value:gsub("%%", "")
            local DPI = tonumber(Value)
            Library:SetDPIScale(DPI)
        end,
    })
    
    MenuGroup:AddSlider("UICornerSlider", {
        Text = "Corner Radius",
        Default = Library.CornerRadius,
        Min = 0,
        Max = 20,
        Rounding = 0,
        Callback = function(value)
            Window:SetCornerRadius(value)
        end
    })
    
    MenuGroup:AddDivider()
    MenuGroup:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", { 
        Default = "RightShift", 
        NoUI = true, 
        Text = "Menu keybind" 
    })
    
    MenuGroup:AddButton("Unload", function()
        Library:Unload()
    end)
    
    Library.ToggleKeybind = Library.Options.MenuKeybind
    
    -- ========================================
    -- THEME & CONFIG
    -- ========================================
    
    SaveManager:BuildConfigSection(Tab)
    ThemeManager:ApplyToTab(Tab)
    
    return Tab
end

return SettingsTab
