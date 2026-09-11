-- TROLL PLAYER HUB - TARGET FLING, ANTIFLING & UTILITIES (ENGLISH)
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

if CoreGui:FindFirstChild("TrollPlayerHubGui") then
    CoreGui.TrollPlayerHubGui:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TrollPlayerHubGui"
ScreenGui.Parent = CoreGui

-- Open/Close Button (Draggable)
local OpenBtn = Instance.new("TextButton")
OpenBtn.Size = UDim2.new(0, 50, 0, 50)
OpenBtn.Position = UDim2.new(0.02, 0, 0.25, 0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
OpenBtn.Text = "TROLL"
OpenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenBtn.TextSize = 10
OpenBtn.Font = Enum.Font.SourceSansBold
OpenBtn.Parent = ScreenGui

local OpenCorner = Instance.new("UICorner")
OpenCorner.CornerRadius = UDim.new(0, 25)
OpenCorner.Parent = OpenBtn

-- Main Menu Frame (Draggable)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 310, 0, 500)
MainFrame.Position = UDim2.new(0.15, 0, 0.15, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

OpenBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Make Window Draggable on Mobile/PC
local function makeDraggable(frame)
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

makeDraggable(MainFrame)
makeDraggable(OpenBtn)

-- Title Label
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 0, 35)
TitleLabel.Position = UDim2.new(0, 0, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "TROLL PLAYER HUB"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 14
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.Parent = MainFrame

local OwnerLabel = Instance.new("TextLabel")
OwnerLabel.Size = UDim2.new(1, 0, 0, 20)
OwnerLabel.Position = UDim2.new(0, 0, 0, 35)
OwnerLabel.BackgroundTransparency = 1
OwnerLabel.Text = "(owner: toichimuonc)"
OwnerLabel.TextColor3 = Color3.fromRGB(160, 160, 160)
OwnerLabel.TextSize = 10
OwnerLabel.Font = Enum.Font.SourceSansItalic
OwnerLabel.Parent = MainFrame

-- Scrolling Content Frame
local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -20, 1, -75)
Scroll.Position = UDim2.new(0, 10, 0, 60)
Scroll.BackgroundTransparency = 1
Scroll.CanvasSize = UDim2.new(0, 0, 0, 650)
Scroll.ScrollBarThickness = 4
Scroll.Parent = MainFrame

local UIList = Instance.new("UIListLayout")
UIList.Padding = UDim.new(0, 8)
UIList.Parent = Scroll

-- Target Player Name Variable
local targetPlayerName = ""

-- Target Player TextBox
local TargetBox = Instance.new("TextBox")
TargetBox.Size = UDim2.new(1, 0, 0, 35)
TargetBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
TargetBox.PlaceholderText = "Enter target player name..."
TargetBox.Text = ""
TargetBox.TextColor3 = Color3.fromRGB(255, 255, 255)
TargetBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
TargetBox.TextSize = 12
TargetBox.Font = Enum.Font.SourceSansBold
TargetBox.Parent = Scroll

local BoxCorner = Instance.new("UICorner")
BoxCorner.CornerRadius = UDim.new(0, 6)
BoxCorner.Parent = TargetBox

TargetBox.FocusLost:Connect(function()
    targetPlayerName = TargetBox.Text
end)

-- Find Player Function
local function getTargetPlayer()
    if targetPlayerName == "" then return nil end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            if p.Name:lower():sub(1, #targetPlayerName) == targetPlayerName:lower() or 
               (p.DisplayName and p.DisplayName:lower():sub(1, #targetPlayerName) == targetPlayerName:lower()) then
                return p
            end
        end
    end
    return nil
end

-- Button Creator Helper
local function createButton(name, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 12
    btn.Font = Enum.Font.SourceSansBold
    btn.Parent = Scroll
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    btn.MouseButton1Click:Connect(callback)
end

-- 1. God Mode
createButton("God Mode", function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChildOfClass("Humanoid") then
        char:FindFirstChildOfClass("Humanoid").MaxHealth = math.huge
        char:FindFirstChildOfClass("Humanoid").Health = math.huge
    end
end)

-- 2. Target Fling (Auto Teleport to target player then fling them)
createButton("Fling Target Player", function()
    local targetP = getTargetPlayer()
    if targetP and targetP.Character and targetP.Character:FindFirstChild("HumanoidRootPart") then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local hrp = char.HumanoidRootPart
            local targetHrp = targetP.Character.HumanoidRootPart
            
            -- Auto Teleport to target first
            hrp.CFrame = targetHrp.CFrame + Vector3.new(0, 2, 0)
            task.wait(0.1)
            
            -- Fling logic
            local bv = Instance.new("BodyVelocity")
            bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bv.Velocity = Vector3.new(90000, 90000, 90000)
            bv.Parent = hrp
            
            local bg = Instance.new("BodyAngularVelocity")
            bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            bg.AngularVelocity = Vector3.new(90000, 90000, 90000)
            bg.Parent = hrp
            
            task.wait(0.6)
            bv:Destroy()
            bg:Destroy()
        end
    end
end)

-- 3. Anti-Fling (Chống bị fling)
local antiFlingConn = nil
createButton("Toggle Anti-Fling", function()
    if antiFlingConn then
        antiFlingConn:Disconnect()
        antiFlingConn = nil
        print("Anti-Fling Disabled")
    else
        antiFlingConn = RunService.Stepped:Connect(function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local hrp = char.HumanoidRootPart
                hrp.Velocity = Vector3.new(0, 0, 0)
                hrp.RotVelocity = Vector3.new(0, 0, 0)
            end
        end)
        print("Anti-Fling Enabled")
    end
end)

-- 4. Teleport to Target Player
createButton("Teleport to Target", function()
    local targetP = getTargetPlayer()
    if targetP and targetP.Character and targetP.Character:FindFirstChild("HumanoidRootPart") then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = targetP.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
        end
    end
end)

-- 5. Follow Target Player Smoothly
local following = false
local followConn = nil
createButton("Toggle Follow Target", function()
    if following then
        following = false
        if followConn then followConn:Disconnect() end
    else
        following = true
        followConn = RunService.RenderStepped:Connect(function()
            if not following then return end
            local targetP = getTargetPlayer()
            if targetP and targetP.Character and targetP.Character:FindFirstChild("HumanoidRootPart") then
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = targetP.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, 4)
                end
            end
        end)
    end
end)

-- 6. Super Speed
createButton("Super Speed", function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChildOfClass("Humanoid") then
        char:FindFirstChildOfClass("Humanoid").WalkSpeed = 100
    end
end)

-- 7. Super Jump
createButton("Super Jump", function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChildOfClass("Humanoid") then
        char:FindFirstChildOfClass("Humanoid").UseJumpPower = true
        char:FindFirstChildOfClass("Humanoid").JumpPower = 200
    end
end)

-- 8. Noclip
local noclipConn = nil
createButton("Toggle Noclip", function()
    if noclipConn then
        noclipConn:Disconnect()
        noclipConn = nil
    else
        noclipConn = RunService.Stepped:Connect(function()
            local char = LocalPlayer.Character
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        part.CanCollide = false
                    end
                end
            end
        end)
    end
end)

-- 9. Reset Character
createButton("Reset Character", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Health = 0
    end
end)

