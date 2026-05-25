local ESP = {}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local renderers = {}
local connections = {}
local PlayerRenderer = nil

local function tryAddPlayer(player)
    if player == LocalPlayer then return end
    if renderers[player] then return end
    
    renderers[player] = PlayerRenderer.new(player)
end

local function tryRemovePlayer(player)
    if renderers[player] then
        renderers[player]:Destroy()
        renderers[player] = nil
    end
end

function ESP:Init(renderer)
    PlayerRenderer = renderer
    
    for _, player in ipairs(Players:GetPlayers()) do
        tryAddPlayer(player)
    end
    
    table.insert(connections, Players.PlayerAdded:Connect(tryAddPlayer))
    table.insert(connections, Players.PlayerRemoving:Connect(tryRemovePlayer))
    
    table.insert(connections, RunService.RenderStepped:Connect(function()
        local showBox = Toggles.PlayerESPBox and Toggles.PlayerESPBox.Value or false
        local showHealth = Toggles.PlayerESPHealth and Toggles.PlayerESPHealth.Value or false
        local showName = Toggles.PlayerESPName and Toggles.PlayerESPName.Value or false
        local showDistance = Toggles.PlayerESPDistance and Toggles.PlayerESPDistance.Value or false
        
        for player, renderer in pairs(renderers) do
            renderer:Update(showBox, showHealth, showName, showDistance)
        end
    end))
end

function ESP:Unload()
    for _, c in ipairs(connections) do c:Disconnect() end
    connections = {}
    
    for _, r in pairs(renderers) do r:Destroy() end
    renderers = {}
end

return ESP
