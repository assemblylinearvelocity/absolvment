local PlayerRenderer = {}
PlayerRenderer.__index = PlayerRenderer

local Camera = workspace.CurrentCamera

function PlayerRenderer.new(player)
    local self = setmetatable({}, PlayerRenderer)
    
    self.player = player
    self.drawings = {}
    
    self.drawings.box = Drawing.new("Square")
    self.drawings.box.Visible = false
    self.drawings.box.Thickness = 1
    self.drawings.box.Filled = false
    self.drawings.box.Color = Color3.fromRGB(255, 255, 255)
    self.drawings.box.Transparency = 1
    
    self.drawings.name = Drawing.new("Text")
    self.drawings.name.Visible = false
    self.drawings.name.Center = true
    self.drawings.name.Outline = true
    self.drawings.name.Size = 13
    self.drawings.name.Color = Color3.fromRGB(255, 255, 255)
    
    self.drawings.health = Drawing.new("Text")
    self.drawings.health.Visible = false
    self.drawings.health.Center = true
    self.drawings.health.Outline = true
    self.drawings.health.Size = 13
    self.drawings.health.Color = Color3.fromRGB(0, 255, 0)
    
    self.drawings.distance = Drawing.new("Text")
    self.drawings.distance.Visible = false
    self.drawings.distance.Center = true
    self.drawings.distance.Outline = true
    self.drawings.distance.Size = 13
    self.drawings.distance.Color = Color3.fromRGB(255, 255, 255)
    
    return self
end

function PlayerRenderer:Update(showBox, showHealth, showName, showDistance)
    if not self.player or not self.player.Parent then
        self:Hide()
        return
    end
    
    local character = self.player.Character
    if not character then
        self:Hide()
        return
    end
    
    local hrp = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    
    if not hrp or not humanoid or humanoid.Health <= 0 then
        self:Hide()
        return
    end
    
    local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
    if not onScreen then
        self:Hide()
        return
    end
    
    local head = character:FindFirstChild("Head")
    if not head then
        self:Hide()
        return
    end
    
    local headPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
    local legPos = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
    
    local height = math.abs(headPos.Y - legPos.Y)
    local width = height / 2
    
    if showBox then
        self.drawings.box.Size = Vector2.new(width, height)
        self.drawings.box.Position = Vector2.new(pos.X - width / 2, pos.Y - height / 2)
        self.drawings.box.Visible = true
    else
        self.drawings.box.Visible = false
    end
    
    if showName then
        self.drawings.name.Text = self.player.Name
        self.drawings.name.Position = Vector2.new(pos.X, pos.Y - height / 2 - 15)
        self.drawings.name.Visible = true
    else
        self.drawings.name.Visible = false
    end
    
    if showHealth then
        local hp = math.floor(humanoid.Health)
        local maxHp = math.floor(humanoid.MaxHealth)
        local percent = math.floor((hp / maxHp) * 100)
        
        self.drawings.health.Text = string.format("%d HP", hp)
        self.drawings.health.Position = Vector2.new(pos.X, pos.Y + height / 2 + 2)
        
        if percent > 75 then
            self.drawings.health.Color = Color3.fromRGB(0, 255, 0)
        elseif percent > 50 then
            self.drawings.health.Color = Color3.fromRGB(255, 255, 0)
        elseif percent > 25 then
            self.drawings.health.Color = Color3.fromRGB(255, 165, 0)
        else
            self.drawings.health.Color = Color3.fromRGB(255, 0, 0)
        end
        
        self.drawings.health.Visible = true
    else
        self.drawings.health.Visible = false
    end
    
    if showDistance then
        local localChar = game.Players.LocalPlayer.Character
        if localChar and localChar:FindFirstChild("HumanoidRootPart") then
            local dist = (localChar.HumanoidRootPart.Position - hrp.Position).Magnitude
            self.drawings.distance.Text = string.format("[%d]", math.floor(dist))
            self.drawings.distance.Position = Vector2.new(pos.X, pos.Y + height / 2 + 15)
            self.drawings.distance.Visible = true
        else
            self.drawings.distance.Visible = false
        end
    else
        self.drawings.distance.Visible = false
    end
end

function PlayerRenderer:Hide()
    for _, drawing in pairs(self.drawings) do
        drawing.Visible = false
    end
end

function PlayerRenderer:Destroy()
    for _, drawing in pairs(self.drawings) do
        drawing:Remove()
    end
    self.drawings = {}
end

return PlayerRenderer
