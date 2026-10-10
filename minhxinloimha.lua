-- ========================================================
-- 2K13
-- ========================================================
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Camera = workspace.CurrentCamera

pcall(function()
    if PlayerGui:FindFirstChild("2K13Hub") then
        PlayerGui["2K13Hub"]:Destroy()
    end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "2K13Hub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 320, 0, 520)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -260)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainFrame.BackgroundTransparency = 0
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false 
MainFrame.Parent = ScreenGui

local MainStroke = Instance.new("UIStroke") MainStroke.Color = Color3.fromRGB(0, 255, 150) MainStroke.Thickness = 2 MainStroke.Parent = MainFrame
local MainCorner = Instance.new("UICorner") MainCorner.CornerRadius = UDim.new(0, 12) MainCorner.Parent = MainFrame

-- Nút mở Menu
local OpenBtn = Instance.new("TextButton")
OpenBtn.Size = UDim2.new(0, 55, 0, 55)
OpenBtn.Position = UDim2.new(0, 20, 0, 150)
OpenBtn.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
OpenBtn.BackgroundTransparency = 0
OpenBtn.Text = "2K13"
OpenBtn.TextColor3 = Color3.fromRGB(0, 255, 150)
OpenBtn.TextSize, OpenBtn.Font = 12, Enum.Font.GothamBold
OpenBtn.Visible = true
OpenBtn.Parent = ScreenGui

local OpenCorner = Instance.new("UICorner") OpenCorner.CornerRadius = UDim.new(0, 10) OpenCorner.Parent = OpenBtn
local OpenStroke = Instance.new("UIStroke") OpenStroke.Color = Color3.fromRGB(0, 255, 150) OpenStroke.Thickness = 2 OpenStroke.Parent = OpenBtn

local btnDragging, btnDragStart, btnStartPos
OpenBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        btnDragging = true btnDragStart = input.Position btnStartPos = OpenBtn.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if btnDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - btnDragStart
        OpenBtn.Position = UDim2.new(btnStartPos.X.Scale, btnStartPos.X.Offset + delta.X, btnStartPos.Y.Scale, btnStartPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then btnDragging = false end
end)

local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 35)
TitleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TitleBar.BackgroundTransparency = 0
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame
local TCorner = Instance.new("UICorner") TCorner.CornerRadius = UDim.new(0, 12) TCorner.Parent = TitleBar

-- Tiêu đề chỉ đúng chữ 2K13
local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(1, -40, 1, 0)
TitleText.Position = UDim2.new(0, 10, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "⚡ 2K13"
TitleText.TextColor3 = Color3.fromRGB(0, 255, 150)
TitleText.TextSize = 13
TitleText.Font = Enum.Font.GothamBold
TitleText.Parent = TitleBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 26, 0, 26)
CloseBtn.Position = UDim2.new(1, -30, 0, 4)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
CloseBtn.TextSize, CloseBtn.Font = 13, Enum.Font.GothamBold
CloseBtn.Parent = TitleBar

CloseBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false OpenBtn.Visible = true end)
OpenBtn.MouseButton1Click:Connect(function() MainFrame.Visible = true OpenBtn.Visible = false end)

local mainDragging, mainDragStart, mainStartPos
TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        mainDragging = true mainDragStart = input.Position mainStartPos = MainFrame.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if mainDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - mainDragStart
        MainFrame.Position = UDim2.new(mainStartPos.X.Scale, mainStartPos.X.Offset + delta.X, mainStartPos.Y.Scale, mainStartPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then mainDragging = false end
end)

local InfoBox = Instance.new("Frame")
InfoBox.Size = UDim2.new(1, -16, 0, 44)
InfoBox.Position = UDim2.new(0, 8, 0, 42)
InfoBox.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
InfoBox.BorderSizePixel = 0
InfoBox.Parent = MainFrame
Instance.new("UICorner", InfoBox).CornerRadius = UDim.new(0, 6)

local NameLabel = Instance.new("TextLabel")
NameLabel.Size = UDim2.new(0.5, -4, 0, 20)
NameLabel.Position = UDim2.new(0, 6, 0, 2)
NameLabel.BackgroundTransparency = 1
NameLabel.Text = "👤 " .. LocalPlayer.Name
NameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
NameLabel.TextSize, NameLabel.Font = 10, Enum.Font.GothamBold
NameLabel.TextXAlignment = Enum.TextXAlignment.Left
NameLabel.Parent = InfoBox

local IdLabel = Instance.new("TextLabel")
IdLabel.Size = UDim2.new(0.5, -4, 0, 20)
IdLabel.Position = UDim2.new(0.5, 0, 0, 2)
IdLabel.BackgroundTransparency = 1
IdLabel.Text = "🆔 ID: " .. tostring(LocalPlayer.UserId)
IdLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
IdLabel.TextSize, IdLabel.Font = 10, Enum.Font.GothamBold
IdLabel.TextXAlignment = Enum.TextXAlignment.Left
IdLabel.Parent = InfoBox

local ScriptTimeLabel = Instance.new("TextLabel")
ScriptTimeLabel.Size = UDim2.new(1, -12, 0, 18)
ScriptTimeLabel.Position = UDim2.new(0, 6, 0, 22)
ScriptTimeLabel.BackgroundTransparency = 1
ScriptTimeLabel.Text = "⏱️ Script Used: 00:00:00"
ScriptTimeLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
ScriptTimeLabel.TextSize, ScriptTimeLabel.Font = 10, Enum.Font.GothamBold
ScriptTimeLabel.TextXAlignment = Enum.TextXAlignment.Left
ScriptTimeLabel.Parent = InfoBox

local PlayerSelectBox = Instance.new("Frame")
PlayerSelectBox.Size = UDim2.new(1, -16, 0, 50)
PlayerSelectBox.Position = UDim2.new(0, 8, 0, 92)
PlayerSelectBox.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
PlayerSelectBox.BorderSizePixel = 0
PlayerSelectBox.Parent = MainFrame
Instance.new("UICorner", PlayerSelectBox).CornerRadius = UDim.new(0, 6)

local AvatarImg = Instance.new("ImageLabel")
AvatarImg.Size = UDim2.new(0, 40, 0, 40)
AvatarImg.Position = UDim2.new(0, 5, 0, 5)
AvatarImg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
AvatarImg.Image = "rbxassetid://0"
AvatarImg.Parent = PlayerSelectBox
Instance.new("UICorner", AvatarImg).CornerRadius = UDim.new(1, 0)

local TargetBox = Instance.new("TextBox")
TargetBox.Size = UDim2.new(1, -55, 0, 40)
TargetBox.Position = UDim2.new(0, 50, 0, 5)
TargetBox.BackgroundTransparency = 1
TargetBox.PlaceholderText = "🔍 Gõ tên Player để Tween bám..."
TargetBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
TargetBox.Text = ""
TargetBox.TextColor3 = Color3.fromRGB(0, 255, 150)
TargetBox.TextSize, TargetBox.Font = 10, Enum.Font.GothamBold
TargetBox.TextXAlignment = Enum.TextXAlignment.Left
TargetBox.Parent = PlayerSelectBox

local function createBtn(txt, clr, pos, sz)
    local b = Instance.new("TextButton")
    b.Size = sz b.Position = pos b.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    b.Text = txt b.TextColor3 = clr b.Font = Enum.Font.GothamBold b.TextSize = 10 b.Parent = MainFrame
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    return b
end

local TweenToggleBtn = createBtn("🎯 [OFF] Tween Follow", Color3.fromRGB(255,80,80), UDim2.new(0,8,0,148), UDim2.new(0,147,0,32))
local ResetPlayerTargetBtn = createBtn("🔄 Clear / Load Player", Color3.fromRGB(0,200,255), UDim2.new(0,165,0,148), UDim2.new(0,147,0,32))
local SaveBtn = createBtn("💾 Save Position", Color3.fromRGB(255,255,255), UDim2.new(0,8,0,186), UDim2.new(0,147,0,32))
local TpBtn = createBtn("⚡ Teleport Once", Color3.fromRGB(255,255,255), UDim2.new(0,165,0,186), UDim2.new(0,147,0,32))
local AutoTpBtn = createBtn("🔄 Auto TP Loop", Color3.fromRGB(255,80,80), UDim2.new(0,8,0,224), UDim2.new(0,147,0,32))
local AutoWalkBtn = createBtn("🚶 Auto Walk", Color3.fromRGB(255,80,80), UDim2.new(0,165,0,224), UDim2.new(0,147,0,32))
local FlyBtn = createBtn("🕊️ [OFF] Fly V3", Color3.fromRGB(255,80,80), UDim2.new(0,8,0,262), UDim2.new(0,147,0,32))
local NoclipBtn = createBtn("👻 [OFF] Noclip", Color3.fromRGB(255,80,80), UDim2.new(0,165,0,262), UDim2.new(0,147,0,32))

local EspBtn = createBtn("👁️ [OFF] ESP Player", Color3.fromRGB(255,80,80), UDim2.new(0,8,0,300), UDim2.new(0,147,0,32))
local FullbrightBtn = createBtn("💡 [OFF] Fullbright", Color3.fromRGB(255,80,80), UDim2.new(0,165,0,300), UDim2.new(0,147,0,32))

local SpeedBox = Instance.new("TextBox")
SpeedBox.Size = UDim2.new(0, 147, 0, 32)
SpeedBox.Position = UDim2.new(0, 8, 0, 338)
SpeedBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
SpeedBox.PlaceholderText = "⚡ WalkSpeed (16-100)..."
SpeedBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
SpeedBox.Text = ""
SpeedBox.TextColor3 = Color3.fromRGB(0, 255, 150)
SpeedBox.TextSize, SpeedBox.Font = 10, Enum.Font.GothamBold
SpeedBox.Parent = MainFrame
Instance.new("UICorner", SpeedBox).CornerRadius = UDim.new(0, 6)

local AntiAfkBtn = createBtn("🛡️ Anti-AFK [ON]", Color3.fromRGB(255,255,255), UDim2.new(0,165,0,338), UDim2.new(0,147,0,32))
AntiAfkBtn.BackgroundColor3 = Color3.fromRGB(0,160,90)

local ResetCharBtn = createBtn("💀 Reset Character", Color3.fromRGB(255,255,255), UDim2.new(0,8,0,376), UDim2.new(1,-16,0,32))
ResetCharBtn.BackgroundColor3 = Color3.fromRGB(180,40,40)

local StatusLbl = Instance.new("TextLabel")
StatusLbl.Size = UDim2.new(1, -16, 0, 24)
StatusLbl.Position = UDim2.new(0, 8, 0, 414)
StatusLbl.BackgroundTransparency = 1
StatusLbl.Text = "Trạng thái: 2K13 đã sẵn sàng!"
StatusLbl.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusLbl.TextSize, StatusLbl.Font = 10, Enum.Font.GothamBold
StatusLbl.Parent = MainFrame

-- === LOGIC HỆ THỐNG ===
local savedCFrame, currentTargetPlayer = nil, nil
local isTweenRunning, isAutoTpRunning, isNoclipRunning, isAutoWalkRunning, isFlying, isEspRunning, isFullbrightRunning = false, false, false, false, false, false, false
local tweenConnection, autoTpConnection, noclipConnection, autoWalkConnection, flyConnection, espConnection, speedConnection
local flySpeed, bodyVelocity, bodyGyro = 50, nil, nil
local espDrawings = {}

local oldBrightness = Lighting.Brightness
local oldClockTime = Lighting.ClockTime
local oldFogEnd = Lighting.FogEnd
local oldGlobalShadows = Lighting.GlobalShadows

local scriptStartTime = tick()
task.spawn(function()
    while true do
        pcall(function()
            local elapsed = math.floor(tick() - scriptStartTime)
            ScriptTimeLabel.Text = string.format("⏱️ Script Used: %02d:%02d:%02d", math.floor(elapsed/3600), math.floor((elapsed%3600)/60), elapsed%60)
        end)
        task.wait(1)
    end
end)

LocalPlayer.Idled:Connect(function()
    pcall(function()
        VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        task.wait(1) VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    end)
end)

SpeedBox.FocusLost:Connect(function()
    pcall(function()
        local num = tonumber(SpeedBox.Text)
        if num then
            if num < 16 then num = 16 end
            if num > 100 then num = 100 end
            SpeedBox.Text = tostring(num)
            
            if speedConnection then speedConnection:Disconnect() end
            speedConnection = RunService.RenderStepped:Connect(function()
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
                    LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = num
                end
            end)
            StatusLbl.Text = "Trạng thái: Đã chỉnh Tốc độ = " .. tostring(num) .. " ⚡"
            StatusLbl.TextColor3 = Color3.fromRGB(0, 255, 150)
        end
    end)
end)

FullbrightBtn.MouseButton1Click:Connect(function()
    isFullbrightRunning = not isFullbrightRunning
    if isFullbrightRunning then
        FullbrightBtn.Text = "💡 [ON] Fullbright"
        FullbrightBtn.TextColor3 = Color3.fromRGB(0, 255, 150)
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
        StatusLbl.Text = "Trạng thái: Đã bật Fullbright 💡"
        StatusLbl.TextColor3 = Color3.fromRGB(0, 255, 150)
    else
        FullbrightBtn.Text = "💡 [OFF] Fullbright"
        FullbrightBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
        Lighting.Brightness = oldBrightness
        Lighting.ClockTime = oldClockTime
        Lighting.FogEnd = oldFogEnd
        Lighting.GlobalShadows = oldGlobalShadows
        StatusLbl.Text = "Trạng thái: Đã tắt Fullbright."
        StatusLbl.TextColor3 = Color3.fromRGB(200, 200, 200)
    end
end)

EspBtn.MouseButton1Click:Connect(function()
    isEspRunning = not isEspRunning
    if isEspRunning then
        EspBtn.Text = "👁️ [ON] ESP Player"
        EspBtn.TextColor3 = Color3.fromRGB(0, 255, 150)
        StatusLbl.Text = "Trạng thái: Đã bật ESP Player 👁️"
        StatusLbl.TextColor3 = Color3.fromRGB(0, 255, 150)

        espConnection = RunService.RenderStepped:Connect(function()
            pcall(function()
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        local hrp = p.Character.HumanoidRootPart
                        local hum = p.Character:FindFirstChildOfClass("Humanoid")
                        local vector, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                        
                        if not espDrawings[p] then
                            local text = Drawing.new("Text")
                            text.Visible = false text.Center = true text.Outline = true text.Font = 2 text.Size = 14 text.Color = Color3.fromRGB(0, 255, 150)
                            espDrawings[p] = text
                        end
                        
                        local txtObj = espDrawings[p]
                        if onScreen and hum and hum.Health > 0 then
                            local myHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                            local dist = myHrp and math.floor((hrp.Position - myHrp.Position).Magnitude) or 0
                            txtObj.Text = string.format("%s [%d m]", p.Name, dist)
                            txtObj.Position = Vector2.new(vector.X, vector.Y - 25)
                            txtObj.Visible = true
                        else
                            txtObj.Visible = false
                        end
                    elseif espDrawings[p] then
                        espDrawings[p].Visible = false
                    end
                end
            end)
        end)
    else
        EspBtn.Text = "👁️ [OFF] ESP Player"
        EspBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
        StatusLbl.Text = "Trạng thái: Đã tắt ESP Player."
        StatusLbl.TextColor3 = Color3.fromRGB(200, 200, 200)

        if espConnection then espConnection:Disconnect() espConnection = nil end
        for _, txt in pairs(espDrawings) do pcall(function() txt:Remove() end) end
        espDrawings = {}
    end
end)

ResetCharBtn.MouseButton1Click:Connect(function()
    pcall(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Health = 0
            StatusLbl.Text = "Trạng thái: Đã Reset! 💀" StatusLbl.TextColor3 = Color3.fromRGB(255, 80, 80)
        end
    end)
end)

TargetBox:GetPropertyChangedSignal("Text"):Connect(function()
    pcall(function()
        local textName = string.lower(TargetBox.Text)
        if textName == "" then AvatarImg.Image = "rbxassetid://0" currentTargetPlayer = nil return end
        local found = nil
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and (string.find(string.lower(p.Name), textName) or string.find(string.lower(p.DisplayName), textName)) then found = p break end
        end
        if found then
            currentTargetPlayer = found
            AvatarImg.Image = Players:GetUserThumbnailAsync(found.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
            StatusLbl.Text = "Đã chọn: " .. found.Name .. " ✅" StatusLbl.TextColor3 = Color3.fromRGB(0, 255, 150)
        else AvatarImg.Image = "rbxassetid://0" currentTargetPlayer = nil end
    end)
end)

ResetPlayerTargetBtn.MouseButton1Click:Connect(function()
    pcall(function()
        TargetBox.Text = "" AvatarImg.Image = "rbxassetid://0" currentTargetPlayer = nil
        if isTweenRunning then isTweenRunning = false TweenToggleBtn.Text = "🎯 [OFF] Tween Follow" TweenToggleBtn.TextColor3 = Color3.fromRGB(255, 80, 80) if tweenConnection then tweenConnection:Disconnect() tweenConnection = nil end end
        StatusLbl.Text = "Trạng thái: Đã làm mới! 🔄" StatusLbl.TextColor3 = Color3.fromRGB(0, 200, 255)
    end)
end)

FlyBtn.MouseButton1Click:Connect(function()
    isFlying = not isFlying
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart
    if isFlying then
        FlyBtn.Text = "🕊️ [ON] Fly V3" FlyBtn.TextColor3 = Color3.fromRGB(0, 255, 150) StatusLbl.Text = "Trạng thái: Đang bay... 🕊️" StatusLbl.TextColor3 = Color3.fromRGB(0, 255, 150)
        bodyVelocity = Instance.new("BodyVelocity") bodyVelocity.MaxForce = Vector3.new(1,1,1)*1000000 bodyVelocity.Velocity = Vector3.new(0,0,0) bodyVelocity.Parent = hrp
        bodyGyro = Instance.new("BodyGyro") bodyGyro.MaxTorque = Vector3.new(1,1,1)*1000000 bodyGyro.CFrame = hrp.CFrame bodyGyro.Parent = hrp
        flyConnection = RunService.RenderStepped:Connect(function()
            pcall(function()
                local cam = workspace.CurrentCamera local hum = char:FindFirstChildOfClass("Humanoid")
                if hum and bodyVelocity and bodyGyro then
                    bodyGyro.CFrame = cam.CFrame local md = hum.MoveDirection
                    bodyVelocity.Velocity = (cam.CFrame.LookVector * md.Z * -flySpeed) + (cam.CFrame.RightVector * md.X * flySpeed)
                end
            end)
        end)
    else
        FlyBtn.Text = "🕊️ [OFF] Fly V3" FlyBtn.TextColor3 = Color3.fromRGB(255, 80, 80) StatusLbl.Text = "Trạng thái: Tắt Fly." StatusLbl.TextColor3 = Color3.fromRGB(200, 200, 200)
        if flyConnection then flyConnection:Disconnect() flyConnection = nil end
        if bodyVelocity then bodyVelocity:Destroy() end if bodyGyro then bodyGyro:Destroy() end
    end
end)

TweenToggleBtn.MouseButton1Click:Connect(function()
    if not currentTargetPlayer then StatusLbl.Text = "Trạng thái: Chưa chọn Player! ⚠️" StatusLbl.TextColor3 = Color3.fromRGB(255, 200, 0) return end
    isTweenRunning = not isTweenRunning
    if isTweenRunning then
        TweenToggleBtn.Text = "🎯 [ON] Tween Follow" TweenToggleBtn.TextColor3 = Color3.fromRGB
