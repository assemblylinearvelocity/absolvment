-- Misc Tab UI
local MiscTab = {}

function MiscTab:Create(Window)
    local Tab = Window:AddTab("Misc", "package")
    
    -- ========================================
    -- MOVEMENT
    -- ========================================
    
    local MovementBox = Tab:AddLeftGroupbox("Movement", "navigation")
    
    MovementBox:AddLabel("Coming Soon!")
    MovementBox:AddLabel("Features to be added:", true)
    MovementBox:AddLabel("• Fly", true)
    MovementBox:AddLabel("• Speed", true)
    MovementBox:AddLabel("• Noclip", true)
    MovementBox:AddLabel("• Auto Sprint", true)
    
    -- ========================================
    -- TELEPORTS
    -- ========================================
    
    local TeleportBox = Tab:AddRightGroupbox("Teleports", "map-pin")
    
    TeleportBox:AddLabel("Coming Soon!")
    TeleportBox:AddLabel("Features to be added:", true)
    TeleportBox:AddLabel("• Teleport to Boss", true)
    TeleportBox:AddLabel("• Teleport to Items", true)
    TeleportBox:AddLabel("• Teleport to Potentials", true)
    
    return Tab
end

return MiscTab
