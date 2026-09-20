-- =====================================================================
-- TOICHIMUONCC SLASHER HUB (WITHOUT AUTO HIT)
-- =====================================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- Create GUI Menu (Highest ZIndex for Mobile Touch)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ToichimuonccSlasherHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999999
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 240, 0, 440)
Frame.Position = UDim2.new(0.5, -120, 0.3, 0)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.ZIndex = 10
Frame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -40, 0, 35)
Title.Position = UDim2.new(0, 8, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "toichimuoncc slasher hub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 12
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 11
Title.Parent = Frame

-- Minimize / Expand Button (- / +)
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 30, 0, 30)
ToggleBtn.Position = UDim2.new(1, -35, 0, 3)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
ToggleBtn.Text = "-"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 16
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.ZIndex = 12
ToggleBtn.Parent = Frame

local isOpen = true
ToggleBtn.MouseButton1Click:Connect(function()
    isOpen = not isOpen
    for _, child in ipairs(Frame:GetChildren()) do
        if child ~= Title and child ~= ToggleBtn then
            child.Visible = isOpen
        end
    end
    Frame.Size = isOpen and UDim2.new(0, 240, 0, 440) or UDim2.new(0, 240, 0, 35)
    ToggleBtn.Text = isOpen and "-" or "+"
end)

-- Feature States
local walkSpeedActive = false
local autoSurvivalActive = false
local autoEquipActive = false
local noclipActive = false
local espWeaponActive = false
local espPlayerActive = false

-- Function to create fully responsive mobile toggle buttons
local function createButton(name, posY, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -16, 0, 35)
    btn.Position = UDim2.new(0, 8, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
    btn.Text = name .. ": OFF"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamBold
    btn.ZIndex = 15
    btn.AutoButtonColor = true
    btn.Parent = Frame

    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        if state then
            btn.Text = name .. ": ON"
            btn.BackgroundColor3 = Color3.fromRGB(0, 170, 85)
        else
            btn.Text = name .. ": OFF"
            btn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
        end
        callback(state)
    end)
    return btn
end

createButton("WalkSpeed (26)", 40, function(state) walkSpeedActive = state end)
createButton("Auto Survival (<30HP)", 80, function(state) autoSurvivalActive = state end)
createButton("Auto Equip Weapon", 120, function(state) autoEquipActive = state end)
createButton("Noclip (Anti-Teleport)", 160, function(state) noclipActive = state end)
createButton("ESP Weapons / Items", 200, function(state) espWeaponActive = state end)
createButton("ESP Player", 240, function(state) espPlayerActive = state end)

-- Info Label
local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, -16, 0, 140)
infoLabel.Position = UDim2.new(0, 8, 0, 285)
infoLabel.BackgroundTransparency = 1
infoLabel.Text = "Status: Anti-teleport noclip and fixed text added. UI optimized for mobile screens."
infoLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
infoLabel.TextSize = 10
infoLabel.TextWrapped = true
infoLabel.Font = Enum.Font.Gotham
infoLabel.ZIndex = 11
infoLabel.Parent = Frame

-- --- 1. WALKSPEED 26 ---
RunService.Heartbeat:Connect(function()
    pcall(function()
        local char = LocalPlayer.Character
        if not char or not char:FindFirstChild("Humanoid") then return end
        if walkSpeedActive then
            char.Humanoid.WalkSpeed = 26
        else
            if not autoSurvivalActive then
                char.Humanoid.WalkSpeed = 16
            end
        end
    end)
end)

-- --- 2. AUTO SURVIVAL (<30HP) ---
RunService.Heartbeat:Connect(function()
    pcall(function()
        local char = LocalPlayer.Character
        if not char or not char:FindFirstChild("Humanoid") then return end
        local humanoid = char.Humanoid
        local healthPercent = (humanoid.Health / humanoid.MaxHealth) * 100

        if autoSurvivalActive and healthPercent <= 30 then
            humanoid.WalkSpeed = 26
        elseif not walkSpeedActive and not autoSurvivalActive then
            humanoid.WalkSpeed = 16
        end
    end)
end)

-- --- 3. AUTO EQUIP WEAPON ---
RunService.Heartbeat:Connect(function()
    pcall(function()
        if not autoEquipActive then return end
        local char = LocalPlayer.Character
        local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
        
        if char and backpack and not char:FindFirstChildOfClass("Tool") then
            for _, item in ipairs(backpack:GetChildren()) do
                if item:IsA("Tool") then
                    local name = item.Name:lower()
                    if name:find("gun") or name:find("knife") or name:find("bat") or name:find("weapon") or name:find("pencil") or name:find("machete") then
                        item.Parent = char
                        break
                    end
                end
            end
        end
    end)
end)

-- --- 4. NOCLIP (ANTI-CHEAT BYPASS) ---
RunService.Stepped:Connect(function()
    pcall(function()
        if not noclipActive then return end
        local char = LocalPlayer.Character
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end)
end)

-- --- 5. ESP WEAPONS / ITEMS ---
RunService.RenderStepped:Connect(function()
    pcall(function()
        for _, obj in ipairs(Workspace:GetDescendants()) do
            local targetModel = nil
            if obj:IsA("Tool") then
                targetModel = obj
            elseif obj:IsA("Model") and (obj:FindFirstChildOfClass("ProximityPrompt") or obj:FindFirstChild("Handle")) then
                local name = obj.Name:lower()
                if name:find("bat") or name:find("knife") or name:find("gun") or name:find("weapon") or name:find("machete") or name:find("pencil") or name:find("bandage") or name:find("item") then
                    targetModel = obj
                end
            end

            if targetModel then
                local hl = targetModel:FindFirstChild("WeaponESP_Highlight")
                if espWeaponActive then
                    if not hl then
                        hl = Instance.new("Highlight")
                        hl.Name = "WeaponESP_Highlight"
                        hl.Adornee = targetModel
                        hl.FillColor = Color3.fromRGB(255, 255, 0)
                        hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                        hl.FillTransparency = 0.4
                        hl.Parent = targetModel
                    end
                else
                    if hl then
                        hl:Destroy()
                    end
                end
            end
        end
    end)
end)

-- --- 6. ESP PLAYER ---
RunService.RenderStepped:Connect(function()
    pcall(function()
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local obj = p.Character
                local hl = obj:FindFirstChild("PlayerESP_Highlight")
                if espPlayerActive then
                    if not hl then
                        hl = Instance.new("Highlight")
                        hl.Name = "PlayerESP_Highlight"
                        hl.Adornee = obj
                        hl.FillColor = Color3.fromRGB(0, 150, 255)
                        hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                        hl.FillTransparency = 0.4
                        hl.Parent = obj
                    end
                else
                    if hl then
                        hl:Destroy()
                    end
                end
            end
        end
    end)
end)

print("toichimuoncc slasher hub Loaded Successfully!")
