local NPCESP = {}
NPCESP.Enabled = false
NPCESP.Connections = {}
NPCESP.ESPObjects = {}

NPCESP.Settings = {
    ShowBox = true,
    ShowName = true,
    ShowHealth = true,
    ShowDistance = true,
    BoxColor = Color3.fromRGB(255, 100, 100),
    NameColor = Color3.fromRGB(255, 100, 100),
    HealthBarColor = Color3.fromRGB(255, 0, 0),
    BoxThickness = 1,
}

local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

function NPCESP:CreateESP(npc)
    if self.ESPObjects[npc] then return end
    
    local ESPObject = {
        NPC = npc,
        Drawings = {}
    }
    
    local Box = Drawing.new("Square")
    Box.Visible = false
    Box.Color = self.Settings.BoxColor
    Box.Thickness = self.Settings.BoxThickness
    Box.Transparency = 1
    Box.Filled = false
    ESPObject.Drawings.Box = Box
    
    local Name = Drawing.new("Text")
    Name.Visible = false
    Name.Color = self.Settings.NameColor
    Name.Size = 16
    Name.Center = true
    Name.Outline = true
    Name.Text = npc.Name
    ESPObject.Drawings.Name = Name
    
    local HealthText = Drawing.new("Text")
    HealthText.Visible = false
    HealthText.Color = Color3.fromRGB(255, 0, 0)
    HealthText.Size = 14
    HealthText.Center = true
    HealthText.Outline = true
    ESPObject.Drawings.HealthText = HealthText
    
    local Distance = Drawing.new("Text")
    Distance.Visible = false
    Distance.Color = self.Settings.NameColor
    Distance.Size = 14
    Distance.Center = true
    Distance.Outline = true
    ESPObject.Drawings.Distance = Distance
    
    self.ESPObjects[npc] = ESPObject
end

function NPCESP:RemoveESP(npc)
    local ESPObject = self.ESPObjects[npc]
    if not ESPObject then return end
    
    for _, drawing in pairs(ESPObject.Drawings) do
        drawing:Remove()
    end
    
    self.ESPObjects[npc] = nil
end

function NPCESP:UpdateESP()
    if not self.Enabled then return end
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    
    for npc, ESPObject in pairs(self.ESPObjects) do
        if not npc or not npc.Parent then
            for _, drawing in pairs(ESPObject.Drawings) do
                drawing.Visible = false
            end
            continue
        end
        
        local humanoidRootPart = npc:FindFirstChild("HumanoidRootPart")
        local humanoid = npc:FindFirstChildOfClass("Humanoid")
        
        if not humanoidRootPart or not humanoid or humanoid.Health <= 0 then
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
        
        local head = npc:FindFirstChild("Head")
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
            Name.Text = npc.Name
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
                HealthText.Color = Color3.fromRGB(255, 0, 0)
            elseif healthPercent > 50 then
                HealthText.Color = Color3.fromRGB(255, 100, 0)
            elseif healthPercent > 25 then
                HealthText.Color = Color3.fromRGB(255, 150, 0)
            else
                HealthText.Color = Color3.fromRGB(255, 200, 0)
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
    end
end

function NPCESP:ScanNPCs()
    local NPCFolder = workspace:FindFirstChild("NPCs")
    if NPCFolder then
        for _, npc in pairs(NPCFolder:GetChildren()) do
            if npc:IsA("Model") and npc:FindFirstChildOfClass("Humanoid") then
                self:CreateESP(npc)
            end
        end
    end
    
    for _, obj in pairs(workspace:GetChildren()) do
        if obj:IsA("Model") and obj:FindFirstChildOfClass("Humanoid") then
            local isPlayer = Players:GetPlayerFromCharacter(obj)
            if not isPlayer then
                self:CreateESP(obj)
            end
        end
    end
end

function NPCESP:Enable()
    self.Enabled = true
    
    self:ScanNPCs()
    
    self.Connections.ChildAdded = workspace.ChildAdded:Connect(function(child)
        if child:IsA("Model") and child:FindFirstChildOfClass("Humanoid") then
            local isPlayer = Players:GetPlayerFromCharacter(child)
            if not isPlayer then
                task.wait(0.1)
                self:CreateESP(child)
            end
        end
    end)
    
    local NPCFolder = workspace:FindFirstChild("NPCs")
    if NPCFolder then
        self.Connections.NPCFolderChildAdded = NPCFolder.ChildAdded:Connect(function(child)
            if child:IsA("Model") and child:FindFirstChildOfClass("Humanoid") then
                task.wait(0.1)
                self:CreateESP(child)
            end
        end)
    end
    
    self.Connections.RenderStepped = RunService.RenderStepped:Connect(function()
        self:UpdateESP()
    end)
    
    self.Connections.RescanLoop = task.spawn(function()
        while self.Enabled do
            task.wait(5)
            self:ScanNPCs()
        end
    end)
end

function NPCESP:Disable()
    self.Enabled = false
    
    for name, connection in pairs(self.Connections) do
        if name == "RescanLoop" then
            task.cancel(connection)
        else
            connection:Disconnect()
        end
    end
    self.Connections = {}
    
    for npc, _ in pairs(self.ESPObjects) do
        self:RemoveESP(npc)
    end
end

return NPCESP
