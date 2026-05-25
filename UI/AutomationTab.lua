-- Automation Tab UI
local AutomationTab = {}

function AutomationTab:Create(Window)
    local Tab = Window:AddTab("Automation", "zap")
    
    -- ========================================
    -- COMBAT
    -- ========================================
    
    local CombatBox = Tab:AddLeftGroupbox("Combat", "sword")
    
    CombatBox:AddLabel("Coming Soon!")
    CombatBox:AddLabel("Features to be added:", true)
    CombatBox:AddLabel("• Auto Attack", true)
    CombatBox:AddLabel("• Auto Parry", true)
    CombatBox:AddLabel("• Auto Use Skills", true)
    
    -- ========================================
    -- FARMING
    -- ========================================
    
    local FarmBox = Tab:AddRightGroupbox("Farming", "target")
    
    FarmBox:AddLabel("Coming Soon!")
    FarmBox:AddLabel("Features to be added:", true)
    FarmBox:AddLabel("• Auto Farm Mobs", true)
    FarmBox:AddLabel("• Auto Loot", true)
    FarmBox:AddLabel("• Auto Dungeon", true)
    
    return Tab
end

return AutomationTab
