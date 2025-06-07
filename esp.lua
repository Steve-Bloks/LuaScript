getgenv().cachedESP = {}
function createESP(player)
    local espitems = {}
    if Drawing then
        espitems.box = Drawing.new("Square")
        espitems.box.Thickness = 1
        espitems.box.Filled = false
        espitems.box.Color = Color3.new(255,0,0)
        espitems.box.Visible = false
        espitems.box.ZIndex = 2
        espitems.boxl = Drawing.new("Square")
        espitems.boxl.Thickness = 2
        espitems.boxl.Filled = false
        espitems.boxl.Color = Color3.new(0,0,0)
        espitems.boxl.Visible = false
        espitems.boxl.ZIndex = 1
        espitems.healthbar = Drawing.new("Square")
        espitems.healthbar.Thickness = 1
        espitems.healthbar.Filled = true
        espitems.healthbar.Color = Color3.new(0,255,0)
        espitems.healthbar.Visible = false
        espitems.healthbar.ZIndex = 2
        espitems.healthbarl = Drawing.new("Square")
        espitems.healthbarl.Thickness = 2
        espitems.healthbarl.Filled = true
        espitems.healthbarl.Color = Color3.new(0,0,0)
        espitems.healthbarl.Visible = false
        espitems.healthbarl.ZIndex = 1
        espitems.name = Drawing.new("Text")
        espitems.name.Size = 14
        espitems.name.Center = true
        espitems.name.Outline = true
        espitems.name.Color = Color3.fromRGB(255, 255, 255)
        espitems.name.Visible = false
        espitems.name.ZIndex = 2
        espitems.distance = Drawing.new("Text")
        espitems.distance.Size = 14
        espitems.distance.Center = true
        espitems.distance.Outline = true
        espitems.distance.Color = Color3.fromRGB(255, 255, 255)
        espitems.distance.Visible = false
        espitems.distance.ZIndex = 2
    end
    cachedESP[player] = espitems
end

function removeESP(player)
    if rawget(cachedESP, player) then
        for _, drawing in next, cachedESP[player] do
            drawing:Remove();
        end
        cachedESP[player] = nil;
    end
end

local function wtvp(...) 
    local a, b = workspace.CurrentCamera.WorldToViewportPoint(workspace.CurrentCamera, ...)
    return Vector2.new(a.X, a.Y), b, a.Z 
end

function updateESP(player, esp)
    local char = game.Players:FindFirstChild(player) and game.Players:FindFirstChild(player).Character
    if char then
        local cframe = char:GetModelCFrame()
        local position, visible, depth = wtvp(cframe.Position)
        esp.box.Visible = visible
        esp.boxl.Visible = visible
        esp.healthbar.Visible = visible
        esp.healthbarl.Visible = visible
        esp.name.Visible = visible
        esp.distance.Visible = visible
        if cframe and visible then
            local sf = 1 / (depth * math.tan(math.rad(game.Workspace.Camera.FieldOfView / 2)) * 2) * 1000
            local w, h = round2(4 * sf, 5 * sf)
            local x, y = round2(position.X, position.Y)
            esp.box.Size = Vector2.new(w,h)
            esp.box.Position = Vector2.new(round2(x - w / 2, y - h / 2))
            esp.box.Color = game.Players:FindFirstChild(player).TeamColor.Color or Color3.new(1,1,1)
            esp.boxl.Size = esp.box.Size
            esp.boxl.Position = esp.box.Position
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                local hp = hum.Health / hum.MaxHealth
                esp.healthbar.Size = Vector2.new(2, h * hp)
                esp.healthbar.Position = Vector2.new(round2(x - w / 2 - 8, y - h / 2 + h  * (1 - hp)))
                esp.healthbarl.Size = Vector2.new(4, h)
                esp.healthbarl.Position = Vector2.new(round2(x - w / 2 - 8, y - h / 2))
            end
            esp.name.Text = game.Players:FindFirstChild(player).DisplayName..` (@{game.Players:FindFirstChild(player).Name})`
            esp.name.Position = Vector2.new(x, y - h / 2 - 24)
            esp.distance.Text = tostring(round2(depth)).." studs"
            esp.distance.Position = Vector2.new(x, y + h / 2 + 16)
        end
    else
        esp.box.Visible = false
        esp.boxl.Visible = false
        esp.healthbar.Visible = false
        esp.healthbarl.Visible = false
        esp.name.Visible = false
        esp.distance.Visible = false
    end
end
