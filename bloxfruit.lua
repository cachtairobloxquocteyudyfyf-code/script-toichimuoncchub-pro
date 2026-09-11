-- =====================================================================
-- AIMBOT PLAYER HUB - V2.0 (English Version)
-- =====================================================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

-- Feature States
local AimbotEnabled = false
local FollowEnabled = false
local EspEnabled = false
local FlyEnabled = false
local SuperJumpEnabled = false
local NoclipEnabled = false
local TargetPlayer = nil

local FlySpeed = 50
local WalkSpeedVal = 16

local FlyBodyVel, FlyBodyGyro
local ESPList = {}
local TargetCircle = nil

-- Remove old UI if exists
if LocalPlayer.PlayerGui:FindFirstChild("AimbotPlayerHub") then
    LocalPlayer.PlayerGui.AimbotPlayerHub:Destroy()
end

-- Main ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AimbotPlayerHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 320, 0, 560)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -280)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(70, 70, 70)
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

-- DragBar Header
local DragBar = Instance.new("Frame")
DragBar.Name = "DragBar"
DragBar.Size = UDim2.new(1, 0, 0, 45)
DragBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
DragBar.BorderSizePixel = 0
DragBar.Parent = MainFrame

local DragCorner = Instance.new("UICorner")
DragCorner.CornerRadius = UDim.new(0, 10)
DragCorner.Parent = DragBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -80, 1, 0)
TitleLabel.Position = UDim2.new(0, 15, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "PLAYER HUB | FPS: 60"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 13
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = DragBar

-- Close Button (X)
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 32, 0, 32)
CloseButton.Position = UDim2.new(1, -38, 0.5, -16)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 12
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = DragBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseButton

CloseButton.MouseButton1Click:Connect(function()
    if TargetCircle then pcall(function() TargetCircle:Remove() end) end
    ScreenGui:Destroy()
end)

-- Scrolling Container
local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -20, 1, -60)
Scroll.Position = UDim2.new(0, 10, 0, 50)
Scroll.BackgroundTransparency = 1
Scroll.BorderSizePixel = 0
Scroll.CanvasSize = UDim2.new(0, 0, 0, 1020)
Scroll.ScrollBarThickness = 4
Scroll.Parent = MainFrame

local UIList = Instance.new("UIListLayout")
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Padding = UDim.new(0, 8)
UIList.Parent = Scroll

-- Mobile & PC Draggable Logic
local dragging, dragInput, dragStart, startPos
DragBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

local function createButton(text, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 36)
    btn.BackgroundColor3 = color or Color3.fromRGB(45, 45, 45)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamSemibold
    btn.Parent = Scroll
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    return btn
end

-- =====================================================================
-- MANUAL TARGET NAME TEXTBOX & DROPDOWN LIST
-- =====================================================================
local TargetInputLabel = Instance.new("TextLabel")
TargetInputLabel.Size = UDim2.new(1, 0, 0, 22)
TargetInputLabel.BackgroundTransparency = 1
TargetInputLabel.Text = "Type Player Name or Select Below:"
TargetInputLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
TargetInputLabel.TextSize = 12
TargetInputLabel.Font = Enum.Font.GothamBold
TargetInputLabel.TextXAlignment = Enum.TextXAlignment.Left
TargetInputLabel.Parent = Scroll

local NameInputBox = Instance.new("TextBox")
NameInputBox.Size = UDim2.new(1, 0, 0, 36)
NameInputBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
NameInputBox.PlaceholderText = "Type exact/partial name here..."
NameInputBox.Text = ""
NameInputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
NameInputBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
NameInputBox.TextSize = 13
NameInputBox.Font = Enum.Font.Gotham
NameInputBox.Parent = Scroll

local NameInputCorner = Instance.new("UICorner")
NameInputCorner.CornerRadius = UDim.new(0, 6)
NameInputCorner.Parent = NameInputBox

NameInputBox:GetPropertyChangedSignal("Text"):Connect(function()
    local searchStr = string.lower(NameInputBox.Text)
    if searchStr == "" then return end
    
    local found = nil
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            if string.find(string.lower(p.Name), searchStr) or string.find(string.lower(p.DisplayName), searchStr) then
                found = p
                break
            end
        end
    end
    
    if found then
        TargetPlayer = found
        TargetInputLabel.Text = "Target Found: " .. found.Name
    else
        TargetInputLabel.Text = "Searching..."
    end
end)

NameInputBox.FocusLost:Connect(function()
    local searchStr = string.lower(NameInputBox.Text)
    if searchStr == "" then return end
    
    local found = nil
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            if string.find(string.lower(p.Name), searchStr) or string.find(string.lower(p.DisplayName), searchStr) then
                found = p
                break
            end
        end
    end
    
    if found then
        TargetPlayer = found
        TargetInputLabel.Text = "Target Selected: " .. found.Name
    else
        TargetInputLabel.Text = "Player not found! Try again:"
    end
end)

local PlayerScrollList = Instance.new("ScrollingFrame")
PlayerScrollList.Size = UDim2.new(1, 0, 0, 110)
PlayerScrollList.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
PlayerScrollList.BorderSizePixel = 0
PlayerScrollList.CanvasSize = UDim2.new(0, 0, 0, 0)
PlayerScrollList.ScrollBarThickness = 4
PlayerScrollList.Parent = Scroll

local DropdownCorner = Instance.new("UICorner")
DropdownCorner.CornerRadius = UDim.new(0, 6)
DropdownCorner.Parent = PlayerScrollList

local PlayerUIList = Instance.new("UIListLayout")
PlayerUIList.SortOrder = Enum.SortOrder.LayoutOrder
PlayerUIList.Padding = UDim.new(0, 4)
PlayerUIList.Parent = PlayerScrollList

local function refreshPlayerList()
    for _, child in ipairs(PlayerScrollList:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local pBtn = Instance.new("TextButton")
            pBtn.Size = UDim2.new(1, -4, 0, 30)
            pBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            pBtn.Text = " • " .. p.Name .. " (" .. p.DisplayName .. ")"
            pBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            pBtn.TextSize = 12
            pBtn.Font = Enum.Font.Gotham
            pBtn.TextXAlignment = Enum.TextXAlignment.Left
            pBtn.Parent = PlayerScrollList
            
            local pCorner = Instance.new("UICorner")
            pCorner.CornerRadius = UDim.new(0, 4)
            pCorner.Parent = pBtn
            
            pBtn.MouseButton1Click:Connect(function()
                TargetPlayer = p
                NameInputBox.Text = p.Name
                TargetInputLabel.Text = "Target Selected: " .. p.Name
            end)
        end
    end
    PlayerScrollList.CanvasSize = UDim2.new(0, 0, 0, PlayerUIList.AbsoluteContentSize.Y + 10)
end

refreshPlayerList()
Players.PlayerAdded:Connect(refreshPlayerList)
Players.PlayerRemoving:Connect(function(p)
    if p == TargetPlayer then
        TargetPlayer = nil
        TargetInputLabel.Text = "Target Left! Type name or select:"
        FollowEnabled = false
    end
    refreshPlayerList()
end)

local BtnResetTarget = createButton("Reset Target Player", Color3.fromRGB(140, 70, 40))
BtnResetTarget.MouseButton1Click:Connect(function()
    TargetPlayer = nil
    NameInputBox.Text = ""
    TargetInputLabel.Text = "Type Player Name or Select Below:"
    FollowEnabled = false
end)

-- Feature Action Buttons
local BtnAimbot = createButton("Aimbot: OFF [None]", Color3.fromRGB(50, 120, 50))
local BtnFollow = createButton("Follow Target (Speed 190): OFF", Color3.fromRGB(50, 120, 50))
local BtnEsp = createButton("ESP Player: OFF", Color3.fromRGB(50, 120, 50))
local BtnFly = createButton("Fly 360° (Static/No Drift): OFF", Color3.fromRGB(50, 120, 50))
local BtnSuperJump = createButton("Super Jump: OFF", Color3.fromRGB(50, 120, 50))
local BtnNoclip = createButton("Noclip: OFF", Color3.fromRGB(50, 120, 50))

-- WalkSpeed Input Box
local SpeedBox = Instance.new("TextBox")
SpeedBox.Size = UDim2.new(1, 0, 0, 36)
SpeedBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
SpeedBox.PlaceholderText = "WalkSpeed (16 - 100 max)..."
SpeedBox.Text = ""
SpeedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
SpeedBox.TextSize = 13
SpeedBox.Font = Enum.Font.Gotham
SpeedBox.Parent = Scroll

local SpeedCorner = Instance.new("UICorner")
SpeedCorner.CornerRadius = UDim.new(0, 6)
SpeedCorner.Parent = SpeedBox

SpeedBox.FocusLost:Connect(function()
    local val = tonumber(SpeedBox.Text)
    if val then
        if val < 16 then val = 16 end
        if val > 100 then val = 100 end
        WalkSpeedVal = val
        SpeedBox.Text = tostring(val)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = WalkSpeedVal
        end
    end
end)

-- Fly Speed Input Box
local FlySpeedBox = Instance.new("TextBox")
FlySpeedBox.Size = UDim2.new(1, 0, 0, 36)
FlySpeedBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
FlySpeedBox.PlaceholderText = "Fly Speed (-190 to 190)..."
FlySpeedBox.Text = "50"
FlySpeedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
FlySpeedBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
FlySpeedBox.TextSize = 13
FlySpeedBox.Font = Enum.Font.Gotham
FlySpeedBox.Parent = Scroll

local FlySpeedCorner = Instance.new("UICorner")
FlySpeedCorner.CornerRadius = UDim.new(0, 6)
FlySpeedCorner.Parent = FlySpeedBox

FlySpeedBox.FocusLost:Connect(function()
    local val = tonumber(FlySpeedBox.Text)
    if val then
        if val < -190 then val = -190 end
        if val > 190 then val = 190 end
        FlySpeed = val
        FlySpeedBox.Text = tostring(val)
    end
end)

-- =====================================================================
-- LOGIC & AUTO FPS
-- =====================================================================

pcall(function()
    TargetCircle = Drawing.new("Circle")
    TargetCircle.Visible = false
    TargetCircle.Radius = 35
    TargetCircle.Color = Color3.fromRGB(255, 0, 0)
    TargetCircle.Thickness = 2
    TargetCircle.Filled = false
    TargetCircle.NumSides = 30
end)

-- Auto FPS Tracker
local frameCount = 0
local lastTick = tick()
RunService.RenderStepped:Connect(function()
    frameCount = frameCount + 1
    local currentTick = tick()
    if currentTick - lastTick >= 1 then
        local fps = math.floor(frameCount / (currentTick - lastTick))
        TitleLabel.Text = "PLAYER HUB | FPS: " .. tostring(fps)
        frameCount = 0
        lastTick = currentTick
    end
end)

-- 1. Aimbot Logic
BtnAimbot.MouseButton1Click:Connect(function()
    AimbotEnabled = not AimbotEnabled
    if AimbotEnabled then
        local targetName = TargetPlayer and TargetPlayer.Name or "None"
        BtnAimbot.Text = "Aimbot: ON [" .. targetName .. "]"
        BtnAimbot.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
    else
        BtnAimbot.Text = "Aimbot: OFF [None]"
        BtnAimbot.BackgroundColor3 = Color3.fromRGB(50, 120, 50)
    end
end)

RunService.RenderStepped:Connect(function()
    if AimbotEnabled and TargetPlayer and TargetPlayer.Character then
        local targetPart = TargetPlayer.Character:FindFirstChild("Head") or TargetPlayer.Character:FindFirstChild("HumanoidRootPart")
        if targetPart then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPart.Position)
            local targetName = TargetPlayer.Name
            BtnAimbot.Text = "Aimbot: ON [" .. targetName .. "]"
        end
    elseif AimbotEnabled and not TargetPlayer then
        BtnAimbot.Text = "Aimbot: ON [No Target]"
    end
end)

-- 2. Follow Target Logic (Speed 190)
BtnFollow.MouseButton1Click:Connect(function()
    FollowEnabled = not FollowEnabled
    if FollowEnabled then
        BtnFollow.Text = "Follow Target (Speed 190): ON"
        BtnFollow.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
    else
        BtnFollow.Text = "Follow Target (Speed 190): OFF"
        BtnFollow.BackgroundColor3 = Color3.fromRGB(50, 120, 50)
    end
end)

RunService.RenderStepped:Connect(function()
    if FollowEnabled and TargetPlayer and TargetPlayer.Character then
        local tHRP = TargetPlayer.Character:FindFirstChild("HumanoidRootPart")
        local myChar = LocalPlayer.Character
        if tHRP and myChar and myChar:FindFirstChild("HumanoidRootPart") then
            local myHRP = myChar.HumanoidRootPart
            local targetPos = tHRP.Position + Vector3.new(0, 3, 0)
            myHRP.CFrame = myHRP.CFrame:Lerp(CFrame.new(targetPos, tHRP.Position), 0.25)
        end
    end
end)

-- 3. ESP Logic
local function addESP(player)
    if player == LocalPlayer then return end
    local function createBox()
        if ESPList[player] then
            pcall(function() ESPList[player]:Remove() end)
            ESPList[player] = nil
        end
        local bg = Drawing.new("Text")
        bg.Visible = false
        bg.Center = true
        bg.Outline = true
        bg.Font = 2
        bg.Size = 16
        bg.Color = Color3.fromRGB(255, 255, 255)
        ESPList[player] = bg
    end
    createBox()
end

for _, p in ipairs(Players:GetPlayers()) do addESP(p) end
Players.PlayerAdded:Connect(addESP)
Players.PlayerRemoving:Connect(function(player)
    if ESPList[player] then
        pcall(function() ESPList[player]:Remove() end)
        ESPList[player] = nil
    end
end)

BtnEsp.MouseButton1Click:Connect(function()
    EspEnabled = not EspEnabled
    if EspEnabled then
        BtnEsp.Text = "ESP Player: ON"
        BtnEsp.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
    else
        BtnEsp.Text = "ESP Player: OFF"
        BtnEsp.BackgroundColor3 = Color3.fromRGB(50, 120, 50)
        for _, bg in pairs(ESPList) do bg.Visible = false end
        if TargetCircle then TargetCircle.Visible = false end
    end
end)

RunService.RenderStepped:Connect(function()
    if EspEnabled then
        for player, bg in pairs(ESPList) do
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
                local hrp = player.Character.HumanoidRootPart
                local vector, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                if onScreen then
                    if player == TargetPlayer then
                        bg.Text = "[★ TARGET] " .. player.Name
                        bg.Color = Color3.fromRGB(255, 50, 50)
                    else
                        bg.Text = player.Name
                        bg.Color = Color3.fromRGB(255, 255, 255)
                    end
                    bg.Position = Vector2.new(vector.X, vector.Y - 25)
                    bg.Visible = true
                else
                    bg.Visible = false
                end
            else
                bg.Visible = false
            end
        end

        if TargetCircle and TargetPlayer and TargetPlayer.Character and TargetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local tHRP = TargetPlayer.Character.HumanoidRootPart
            local vector, onScreen = Camera:WorldToViewportPoint(tHRP.Position)
            if onScreen then
                TargetCircle.Position = Vector2.new(vector.X, vector.Y)
                TargetCircle.Visible = true
            else
                TargetCircle.Visible = false
            end
        else
            if TargetCircle then TargetCircle.Visible = false end
        end
    end
end)

-- 4. Fly 360° Logic
local controlKeys = {W = 0, S = 0, A = 0, D = 0, Space = 0, Shift = 0}

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.W then controlKeys.W = 1 end
    if input.KeyCode == Enum.KeyCode.S then controlKeys.S = -1 end
    if input.KeyCode == Enum.KeyCode.A then controlKeys.A = -1 end
    if input.KeyCode == Enum.KeyCode.D then controlKeys.D = 1 end
    if input.KeyCode == Enum.KeyCode.Space then controlKeys.Space = 1 end
    if input.KeyCode == Enum.KeyCode.LeftShift then controlKeys.Shift = -1 end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.W then controlKeys.W = 0 end
    if input.KeyCode == Enum.KeyCode.S then controlKeys.S = 0 end
    if input.KeyCode == Enum.KeyCode.A then controlKeys.A = 0 end
    if input.KeyCode == Enum.KeyCode.D then controlKeys.D = 0 end
    if input.KeyCode == Enum.KeyCode.Space then controlKeys.Space = 0 end
    if input.KeyCode == Enum.KeyCode.LeftShift then controlKeys.Shift = 0 end
end)

BtnFly.MouseButton1Click:Connect(function()
    FlyEnabled = not FlyEnabled
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart
    
    if FlyEnabled then
        BtnFly.Text = "Fly 360°: ON"
        BtnFly.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
        
        FlyBodyVel = Instance.new("BodyVelocity")
        FlyBodyVel.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        FlyBodyVel.Velocity = Vector3.new(0, 0, 0)
        FlyBodyVel.Parent = hrp
        
        FlyBodyGyro = Instance.new("BodyGyro")
        FlyBodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        FlyBodyGyro.CFrame = Camera.CFrame
        FlyBodyGyro.Parent = hrp
        
        task.spawn(function()
            while Fly
