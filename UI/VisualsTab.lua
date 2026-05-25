-- Visuals Tab UI
local VisualsTab = {}

function VisualsTab:Create(Window, PlayerESP, NPCESP)
    local Tab = Window:AddTab("Visuals", "eye")
    
    -- ========================================
    -- PLAYER ESP
    -- ========================================
    
    local PlayerESPBox = Tab:AddLeftGroupbox("Player ESP", "users")
    
    PlayerESPBox:AddToggle("PlayerESPEnabled", {
        Text = "Enable Player ESP",
        Default = false,
        Tooltip = "Show ESP for other players",
        Callback = function(Value)
            if Value then
                PlayerESP:Enable()
            else
                PlayerESP:Disable()
            end
        end,
    })
    
    PlayerESPBox:AddToggle("PlayerESPBox", {
        Text = "Show Box",
        Default = true,
        Tooltip = "Show box around players",
        Callback = function(Value)
            PlayerESP.Settings.ShowBox = Value
        end,
    })
    
    PlayerESPBox:AddToggle("PlayerESPName", {
        Text = "Show Name",
        Default = true,
        Tooltip = "Show player names",
        Callback = function(Value)
            PlayerESP.Settings.ShowName = Value
        end,
    })
    
    PlayerESPBox:AddToggle("PlayerESPHealth", {
        Text = "Show Health",
        Default = true,
        Tooltip = "Show player health",
        Callback = function(Value)
            PlayerESP.Settings.ShowHealth = Value
        end,
    })
    
    PlayerESPBox:AddToggle("PlayerESPDistance", {
        Text = "Show Distance",
        Default = true,
        Tooltip = "Show distance to players",
        Callback = function(Value)
            PlayerESP.Settings.ShowDistance = Value
        end,
    })
    
    PlayerESPBox:AddToggle("PlayerESPTracer", {
        Text = "Show Tracers",
        Default = false,
        Tooltip = "Show lines to players",
        Callback = function(Value)
            PlayerESP.Settings.ShowTracer = Value
        end,
    })
    
    PlayerESPBox:AddToggle("PlayerESPTeamCheck", {
        Text = "Team Check",
        Default = false,
        Tooltip = "Don't show ESP for teammates",
        Callback = function(Value)
            PlayerESP.Settings.TeamCheck = Value
        end,
    })
    
    PlayerESPBox:AddDivider()
    
    PlayerESPBox:AddLabel("Box Color"):AddColorPicker("PlayerESPBoxColor", {
        Default = Color3.fromRGB(255, 255, 255),
        Title = "Box Color",
        Callback = function(Value)
            PlayerESP.Settings.BoxColor = Value
        end,
    })
    
    PlayerESPBox:AddLabel("Name Color"):AddColorPicker("PlayerESPNameColor", {
        Default = Color3.fromRGB(255, 255, 255),
        Title = "Name Color",
        Callback = function(Value)
            PlayerESP.Settings.NameColor = Value
        end,
    })
    
    PlayerESPBox:AddLabel("Tracer Color"):AddColorPicker("PlayerESPTracerColor", {
        Default = Color3.fromRGB(255, 255, 255),
        Title = "Tracer Color",
        Callback = function(Value)
            PlayerESP.Settings.TracerColor = Value
        end,
    })
    
    -- ========================================
    -- NPC ESP
    -- ========================================
    
    local NPCESPBox = Tab:AddRightGroupbox("NPC/Mob ESP", "skull")
    
    NPCESPBox:AddToggle("NPCESPEnabled", {
        Text = "Enable NPC ESP",
        Default = false,
        Tooltip = "Show ESP for NPCs/Mobs",
        Callback = function(Value)
            if Value then
                NPCESP:Enable()
            else
                NPCESP:Disable()
            end
        end,
    })
    
    NPCESPBox:AddToggle("NPCESPBox", {
        Text = "Show Box",
        Default = true,
        Tooltip = "Show box around NPCs",
        Callback = function(Value)
            NPCESP.Settings.ShowBox = Value
        end,
    })
    
    NPCESPBox:AddToggle("NPCESPName", {
        Text = "Show Name",
        Default = true,
        Tooltip = "Show NPC names",
        Callback = function(Value)
            NPCESP.Settings.ShowName = Value
        end,
    })
    
    NPCESPBox:AddToggle("NPCESPHealth", {
        Text = "Show Health",
        Default = true,
        Tooltip = "Show NPC health",
        Callback = function(Value)
            NPCESP.Settings.ShowHealth = Value
        end,
    })
    
    NPCESPBox:AddToggle("NPCESPDistance", {
        Text = "Show Distance",
        Default = true,
        Tooltip = "Show distance to NPCs",
        Callback = function(Value)
            NPCESP.Settings.ShowDistance = Value
        end,
    })
    
    NPCESPBox:AddDivider()
    
    NPCESPBox:AddLabel("Box Color"):AddColorPicker("NPCESPBoxColor", {
        Default = Color3.fromRGB(255, 100, 100),
        Title = "Box Color",
        Callback = function(Value)
            NPCESP.Settings.BoxColor = Value
            NPCESP.Settings.NameColor = Value
        end,
    })
    
    NPCESPBox:AddButton({
        Text = "Rescan NPCs",
        Func = function()
            if NPCESP.Enabled then
                NPCESP:ScanNPCs()
            end
        end,
        Tooltip = "Manually rescan for NPCs in the world",
    })
    
    return Tab
end

return VisualsTab
