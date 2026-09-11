-- =====================================================================
-- AIMBOT PLAYER HUB - V1.5 (Smart Switch Aimbot, 360 Full Fly, English)
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
MainFrame.Size = UDim2.new(0, 320, 0, 500)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -250)
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
DragBar.Size = UDim2.new(1, 0, 0, 40)
DragBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
DragBar.BorderSizePixel = 0
DragBar.Parent = MainFrame

local DragCorner = Instance.new("UICorner")
DragCorner.CornerRadius = UDim.new(0, 10)
DragCorner.Parent = DragBar

local FixBottom = Instance.new("Frame")
FixBottom.Size = UDim2.new(1, 0, 0, 10)
FixBottom.Position = UDim2.new(0, 0, 1, -10)
FixBottom.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
FixBottom.BorderSizePixel = 0
FixBottom.Parent = DragBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -110, 1, 0)
TitleLabel.Position = UDim2.new(0, 15, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "PLAYER HUB | FPS: 60"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 13
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = DragBar

-- Toggle UI Button (-) inside Header
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
MinimizeButton.Position = UDim2.new(1, -70, 0.5, -15)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
MinimizeButton.Text = "-"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.TextSize = 14
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.Parent = DragBar

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 6)
MinCorner.Parent = MinimizeButton

-- Close Button (X) inside Header
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0.5, -15)
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
Scroll.Size = UDim2.new(1, -20, 1, -55)
Scroll.Position = UDim2.new(0, 10, 0, 45)
Scroll.BackgroundTransparency = 1
Scroll.BorderSizePixel = 0
Scroll.CanvasSize = UDim2.new(0, 0, 0, 750)
Scroll.ScrollBarThickness = 4
Scroll.Parent = MainFrame

local UIList = Instance.new("UIListLayout")
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Padding = UDim.new(0, 8)
UIList.Parent = Scroll

-- Minimize/Open Logic
local isMinimized = false
MinimizeButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        MainFrame:TweenSize(UDim2.new(0, 320, 0, 40), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
        Scroll.Visible = false
        MinimizeButton.Text = "+"
    else
        MainFrame:TweenSize(UDim2.new(0, 320, 0, 500), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
        Scroll.Visible = true
        MinimizeButton.Text = "-"
    end
end)

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

-- Standard UI Button Creator
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

-- Target Input Box & Reset Button
local TargetBox = Instance.new("TextBox")
TargetBox.Size = UDim2.new(1, 0, 0, 36)
TargetBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
TargetBox.PlaceholderText = "Enter target player name..."
TargetBox.Text = ""
TargetBox.TextColor3 = Color3.fromRGB(255, 255, 255)
TargetBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
TargetBox.TextSize = 13
TargetBox.Font = Enum.Font.Gotham
TargetBox.Parent = Scroll

local TargetCorner = Instance.new("UICorner")
TargetCorner.CornerRadius = UDim.new(0, 6)
TargetCorner.Parent = TargetBox

local BtnResetTarget = createButton("Reset Target Player", Color3.fromRGB(140, 70, 40))

local function updateTarget(nameInput)
    if nameInput == "" then
        TargetPlayer = nil
        TargetBox.Text = ""
        return
    end
    nameInput = nameInput:lower()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and (p.Name:lower():sub(1, #nameInput) == nameInput or p.DisplayName:lower():sub(1, #nameInput) == nameInput) then
            TargetPlayer = p
            TargetBox.Text = p.Name
            break
        end
    end
end

TargetBox.FocusLost:Connect(function()
    updateTarget(TargetBox.Text)
end)

BtnResetTarget.MouseButton1Click:Connect(function()
    TargetPlayer = nil
    TargetBox.Text = ""
    TargetBox.PlaceholderText = "Target reset! Enter new name..."
    FollowEnabled = false
end)

Players.PlayerRemoving:Connect(function(player)
    if player == TargetPlayer then
        TargetPlayer = nil
        TargetBox.Text = ""
        TargetBox.PlaceholderText = "Target left game! Enter new name..."
        FollowEnabled = false
    end
end)

-- Feature Action Buttons
local BtnAimbot = createButton("Aimbot Player: OFF", Color3.fromRGB(50, 120, 50))
local BtnFollow = createButton("Follow Target: OFF", Color3.fromRGB(50, 120, 50))
local BtnEsp = createButton("ESP Player: OFF", Color3.fromRGB(50, 120, 50))
local BtnFly = createButton("Fly 360° (Max 190): OFF", Color3.fromRGB(50, 120, 50))
local BtnSuperJump = createButton("Super Jump: OFF", Color3.fromRGB(50, 120, 50))
local BtnNoclip = createButton("Noclip: OFF", Color3.fromRGB(50, 120, 50))

-- WalkSpeed Input Box (16 to 100 max)
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

-- Fly Speed Input Box (-190 to 190)
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

-- 1. Aimbot Player Logic
BtnAimbot.MouseButton1Click:Connect(function()
    AimbotEnabled = not AimbotEnabled
    if AimbotEnabled then
        BtnAimbot.Text = "Aimbot Player: ON"
        BtnAimbot.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
    else
        BtnAimbot.Text = "Aimbot Player: OFF"
        BtnAimbot.BackgroundColor3 = Color3.fromRGB(50, 120, 50)
    end
end)

RunService.RenderStepped:Connect(function()
    if AimbotEnabled and TargetPlayer and TargetPlayer.Character then
        local targetPart = TargetPlayer.Character:FindFirstChild("Head") or TargetPlayer.Character:FindFirstChild("HumanoidRootPart")
        if targetPart then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPart.Position)
        end
    end
end)

-- 2. Follow Target Logic
BtnFollow.MouseButton1Click:Connect(function()
    FollowEnabled = not FollowEnabled
    if FollowEnabled then
        BtnFollow.Text = "Follow Target: ON"
        BtnFollow.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
    else
        BtnFollow.Text = "Follow Target: OFF"
        BtnFollow.BackgroundColor3 = Color3.fromRGB(50, 120, 50)
    end
end)

RunService.RenderStepped:Connect(function()
    if FollowEnabled and TargetPlayer and TargetPlayer.Character then
        local tHRP = TargetPlayer.Character:FindFirstChild("HumanoidRootPart")
        local myChar = LocalPlayer.Character
        if tHRP and myChar and myChar:FindFirstChild("HumanoidRootPart") and myChar:FindFirstChild("Humanoid") then
            local myHumanoid = myChar.Humanoid
            myHumanoid:MoveTo(tHRP.Position + Vector3.new(0, 0, 3))
        end
    end
end)

-- 3. ESP Player Logic
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

for _, p in ipairs(Players:GetPlayers()) do
    addESP(p)
end
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
        for _, bg in pairs(ESPList) do
            bg.Visible = false
        end
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
            while FlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") do
                FlyBodyGyro.CFrame = Camera.CFrame
                
                local moveDir = Vector3.new(
                    controlKeys.A + controlKeys.D,
                    controlKeys.Space + controlKeys.Shift,
                    controlKeys.W + controlKeys.S
                )
                
                if moveDir.Magnitude > 0 then
                    local lookVec = Camera.CFrame.LookVector
                    local rightVec = Camera.CFrame.RightVector
                    local targetVel = (lookVec * moveDir.Z + rightVec * moveDir.X + Vector3.new(0, moveDir.Y, 0)) * FlySpeed
                    FlyBodyVel.Velocity = targetVel
                else
                    FlyBodyVel.Velocity = Vector3.new(0, 0.1, 0)
                end
                task.wait()
            end
        end)
    else
        BtnFly.Text = "Fly 360° (Max 190): OFF"
        BtnFly.BackgroundColor3 = Color3.fromRGB(50, 120, 50)
        if FlyBodyVel then FlyBodyVel:Destroy() end
        if FlyBodyGyro then FlyBodyGyro:Destroy() end
    end
end)

-- 5. Super Jump Logic
BtnSuperJump.MouseButton1Click:Connect(function()
    SuperJumpEnabled = not SuperJumpEnabled
    if SuperJumpEnabled then
        BtnSuperJump.Text = "Super Jump: ON"
        BtnSuperJump.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
        task.spawn(function()
            while SuperJumpEnabled and LocalPlayer.Character do
                local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum.UseJumpPower = true
                    hum.JumpPower = 350
                end
                task.wait(0.5)
            end
        end)
    else
        BtnSuperJump.Text = "Super Jump: OFF"
        BtnSuperJump.BackgroundColor3 = Color3.fromRGB(50, 120, 50)
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.JumpPower = 50
        end
    end
end)

-- 6. Noclip Logic
BtnNoclip.MouseButton1Click:Connect(function()
    NoclipEnabled = not NoclipEnabled
    if NoclipEnabled then
        BtnNoclip.Text = "Noclip: ON"
        BtnNoclip.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
        task.spawn(function()
            while NoclipEnabled and LocalPlayer.Character do
                for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
                task.wait(0.1)
            end
        end)
    else
        BtnNoclip.Text = "Noclip: OFF"
        BtnNoclip.BackgroundColor3 = Color3.fromRGB(50, 120, 50)
    end
end)

-- Maintain WalkSpeed on Character Respawn
LocalPlayer.CharacterAdded:Connect(function(newChar)
    local hum = newChar:WaitForChild("Humanoid", 5)
    if hum then
        hum.WalkSpeed = WalkSpeedVal
    end
end)
