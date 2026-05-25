local PlayerESP = {}
PlayerESP.Enabled = false
PlayerESP.Connections = {}
PlayerESP.ESPObjects = {}

PlayerESP.Settings = {
    ShowBox = true,
    ShowName = true,
    ShowHealth = true,
    ShowDistance = true,
    ShowTracer = false,
    TeamCheck = false,
    BoxColor = Color3.fromRGB(255, 255, 255),
    NameColor = Color3.fromRGB(255, 255, 255),
    HealthBarColor = Color3.fromRGB(0, 255, 0),
    TracerColor = Color3.fromRGB(255, 255, 255),
    TracerThickness = 1,
    BoxThickness = 1,
}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

function PlayerESP:CreateESP(player)
    if player == LocalPlayer then return end
    if self.ESPObjects[player] then return end
    
    local ESPObject = {
        Player = player,
        Drawings = {}
    }
    
    -- Box
    local Box = Drawing.new("Square")
    Box.Visible = false
    Box.Color = self.Settings.BoxColor
    Box.Thickness = self.Settings.BoxThickness
    Box.Transparency = 1
    Box.Filled = false
    ESPObject.Drawings.Box = Box
    
    -- Name
    local Name = Drawing.new("Text")
    Name.Visible = false
    Name.Color = self.Settings.NameColor
    Name.Size = 16
    Name.Center = true
    Name.Outline = true
    Name.Text = player.Name
    ESPObject.Drawings.Name = Name
    
    -- Health Text
    local HealthText = Drawing.new("Text")
    HealthText.Visible = false
    HealthText.Color = Color3.fromRGB(0, 255, 0)
    HealthText.Size = 14
    HealthText.Center = true
    HealthText.Outline = true
    ESPObject.Drawings.HealthText = HealthText
    
    -- Distance Text
    local Distance = Drawing.new("Text")
    Distance.Visible = false
    Distance.Color = self.Settings.NameColor
    Distance.Size = 14
    Distance.Center = true
    Distance.Outline = true
    ESPObject.Drawings.Distance = Distance
    
    -- Tracer
    local Tracer = Drawing.new("Line")
    Tracer.Visible = false
    Tracer.Color = self.Settings.TracerColor
    Tracer.Thickness = self.Settings.TracerThickness
    Tracer.Transparency = 1
    ESPObject.Drawings.Tracer = Tracer
    
    self.ESPObjects[player] = ESPObject
end

function PlayerESP:RemoveESP(player)
    local ESPObject = self.ESPObjects[player]
    if not ESPObject then return end
    
    for _, drawing in pairs(ESPObject.Drawings) do
        drawing:Remove()
    end
    
    self.ESPObjects[player] = nil
end

function PlayerESP:UpdateESP()
    if not self.Enabled then return end
    
    for player, ESPObject in pairs(self.ESPObjects) do
        if not player or not player.Parent or not player.Character then
            for _, drawing in pairs(ESPObject.Drawings) do
                drawing.Visible = false
            end
            continue
        end
        
        local character = player.Character
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        
        if not humanoidRootPart or not humanoid or humanoid.Health <= 0 then
            for _, drawing in pairs(ESPObject.Drawings) do
                drawing.Visible = false
            end
            continue
        end
        
        if self.Settings.TeamCheck and player.Team == LocalPlayer.Team then
            for _, drawing in pairs(ESPObject.Drawings) do
                drawing.Visible = false
            end
            continue
        end
        
        local vector, onScreen = Camera:WorldToViewportPoint(humanoidRootPart.Position)
        
        if not onScreen then
            for _, drawing in pairs(ESPObject.Drawings) do
                drawing.Visible = false
            end
            continue
        end
        
        local head = character:FindFirstChild("Head")
        if not head then
            for _, drawing in pairs(ESPObject.Drawings) do
                drawing.Visible = false
            end
            continue
        end
        
        local headPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
        local legPos = Camera:WorldToViewportPoint(humanoidRootPart.Position - Vector3.new(0, 3, 0))
        
        local height = math.abs(headPos.Y - legPos.Y)
        local width = height / 2
        
        if self.Settings.ShowBox then
            local Box = ESPObject.Drawings.Box
            Box.Size = Vector2.new(width, height)
            Box.Position = Vector2.new(vector.X - width / 2, vector.Y - height / 2)
            Box.Color = self.Settings.BoxColor
            Box.Visible = true
        else
            ESPObject.Drawings.Box.Visible = false
        end
        
        if self.Settings.ShowName then
            local Name = ESPObject.Drawings.Name
            Name.Position = Vector2.new(vector.X, vector.Y - height / 2 - 16)
            Name.Text = player.Name
            Name.Color = self.Settings.NameColor
            Name.Visible = true
        else
            ESPObject.Drawings.Name.Visible = false
        end
        
        if self.Settings.ShowHealth then
            local HealthText = ESPObject.Drawings.HealthText
            local healthPercent = math.floor((humanoid.Health / humanoid.MaxHealth) * 100)
            HealthText.Position = Vector2.new(vector.X, vector.Y + height / 2 + 2)
            HealthText.Text = string.format("%d HP (%d%%)", math.floor(humanoid.Health), healthPercent)
            
            if healthPercent > 75 then
                HealthText.Color = Color3.fromRGB(0, 255, 0)
            elseif healthPercent > 50 then
                HealthText.Color = Color3.fromRGB(255, 255, 0)
            elseif healthPercent > 25 then
                HealthText.Color = Color3.fromRGB(255, 165, 0)
            else
                HealthText.Color = Color3.fromRGB(255, 0, 0)
            end
            
            HealthText.Visible = true
        else
            ESPObject.Drawings.HealthText.Visible = false
        end
        
        if self.Settings.ShowDistance then
            local Distance = ESPObject.Drawings.Distance
            local distance = (LocalPlayer.Character.HumanoidRootPart.Position - humanoidRootPart.Position).Magnitude
            Distance.Position = Vector2.new(vector.X, vector.Y + height / 2 + 16)
            Distance.Text = string.format("[%d studs]", math.floor(distance))
            Distance.Color = self.Settings.NameColor
            Distance.Visible = true
        else
            ESPObject.Drawings.Distance.Visible = false
        end
        
        if self.Settings.ShowTracer then
            local Tracer = ESPObject.Drawings.Tracer
            Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
            Tracer.To = Vector2.new(vector.X, vector.Y)
            Tracer.Color = self.Settings.TracerColor
            Tracer.Visible = true
        else
            ESPObject.Drawings.Tracer.Visible = false
        end
    end
end

function PlayerESP:Enable()
    self.Enabled = true
    
    for _, player in pairs(Players:GetPlayers()) do
        self:CreateESP(player)
    end
    
    self.Connections.PlayerAdded = Players.PlayerAdded:Connect(function(player)
        self:CreateESP(player)
    end)
    
    self.Connections.PlayerRemoving = Players.PlayerRemoving:Connect(function(player)
        self:RemoveESP(player)
    end)
    
    self.Connections.RenderStepped = RunService.RenderStepped:Connect(function()
        self:UpdateESP()
    end)
end

function PlayerESP:Disable()
    self.Enabled = false
    
    for _, connection in pairs(self.Connections) do
        connection:Disconnect()
    end
    self.Connections = {}
    
    for player, _ in pairs(self.ESPObjects) do
        self:RemoveESP(player)
    end
end

return PlayerESP
