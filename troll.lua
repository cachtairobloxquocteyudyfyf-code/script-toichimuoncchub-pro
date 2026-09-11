-- =====================================================================
-- TROLL PLAYER HUB - TOICHIMUONCC ULTIMATE FIXED VERSION (ENGLISH)
-- =====================================================================
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Initialize configuration variables using getgenv to store global state
getgenv().LoopDistance = 4
getgenv().FlySpeed = 50
getgenv().CustomWalkSpeed = 16
getgenv().CustomJumpPower = 50
getgenv().RainbowActive = false

-- Clean up old GUI if reloaded to prevent duplicate screens
if CoreGui:FindFirstChild("TrollPlayerHubGui") then
    CoreGui.TrollPlayerHubGui:Destroy()
end

-- Create Main GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TrollPlayerHubGui"
ScreenGui.Parent = CoreGui

-- Circular TROLL button to open/close menu (Draggable on mobile screens)
local OpenBtn = Instance.new("TextButton")
OpenBtn.Size = UDim2.new(0, 50, 0, 50)
OpenBtn.Position = UDim2.new(0.02, 0, 0.25, 0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
OpenBtn.Text = "TROLL"
OpenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenBtn.TextSize, OpenBtn.Font = 10, Enum.Font.SourceSansBold
OpenBtn.Active = true
OpenBtn.Draggable = true
OpenBtn.Parent = ScreenGui

local OpenCorner = Instance.new("UICorner")
OpenCorner.CornerRadius = UDim.new(0, 25)
OpenCorner.Parent = OpenBtn

-- Main Menu Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 310, 0, 420)
MainFrame.Position = UDim2.new(0.15, 0, 0.15, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

OpenBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Hub Title & Owner Name Label
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 0, 35)
TitleLabel.Position = UDim2.new(0, 0, 0, 15)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "TROLL PLAYER HUB"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize, TitleLabel.Font = 14, Enum.Font.SourceSansBold
TitleLabel.Parent = MainFrame

local OwnerLabel = Instance.new("TextLabel")
OwnerLabel.Size = UDim2.new(1, 0, 0, 20)
OwnerLabel.Position = UDim2.new(0, 0, 0, 40)
OwnerLabel.BackgroundTransparency = 1
OwnerLabel.Text = "(owner name roblox toichimuoncc)"
OwnerLabel.TextColor3 = Color3.fromRGB(160, 160, 160)
OwnerLabel.TextSize, OwnerLabel.Font = 10, Enum.Font.SourceSansItalic
OwnerLabel.Parent = MainFrame

-- Helper function to create configuration text boxes smoothly
local function CreateTextBox(placeholder, yPos, callback)
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0.9, 0, 0, 35)
    box.Position = UDim2.new(0.05, 0, yPos, 0)
    box.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    box.PlaceholderText = placeholder
    box.Text = ""
    box.TextColor3 = Color3.fromRGB(255, 255, 255)
    box.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    box.TextSize, box.Font = 10, Enum.Font.SourceSansBold
    box.Parent = MainFrame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = box

    box.FocusLost:Connect(function()
        callback(box.Text)
    end)
end

CreateTextBox("Loop Distance (Default: 4)...", 0.22, function(val)
    local num = tonumber(val)
    if num then getgenv().LoopDistance = num end
end)

CreateTextBox("Fly Speed (Default: 50)...", 0.33, function(val)
    local num = tonumber(val)
    if num then getgenv().FlySpeed = num end
end)

CreateTextBox("Set WalkSpeed...", 0.44, function(val)
    local num = tonumber(val)
    if num then
        getgenv().CustomWalkSpeed = num
        pcall(function()
            LocalPlayer.Character.Humanoid.WalkSpeed = num
        end)
    end
end)

CreateTextBox("Set JumpPower...", 0.55, function(val)
    local num = tonumber(val)
    if num then
        getgenv().CustomJumpPower = num
        pcall(function()
            LocalPlayer.Character.Humanoid.JumpPower = num
        end)
    end
end)

-- Toggle Button for Rainbow Effect
local RainbowBtn = Instance.new("TextButton")
RainbowBtn.Size = UDim2.new(0.9, 0, 0, 40)
RainbowBtn.Position = UDim2.new(0.05, 0, 0.67, 0)
RainbowBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
RainbowBtn.Text = "RAINBOW EFFECT: OFF"
RainbowBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RainbowBtn.TextSize, RainbowBtn.Font = 11, Enum.Font.SourceSansBold
RainbowBtn.Parent = MainFrame

local RainbowCorner = Instance.new("UICorner")
RainbowCorner.CornerRadius = UDim.new(0, 6)
RainbowCorner.Parent = RainbowBtn

RainbowBtn.MouseButton1Click:Connect(function()
    getgenv().RainbowActive = not getgenv().RainbowActive
    if getgenv().RainbowActive then
        RainbowBtn.Text = "RAINBOW EFFECT: ON"
        RainbowBtn.TextColor3 = Color3.fromRGB(0, 255, 128)
    else
        RainbowBtn.Text = "RAINBOW EFFECT: OFF"
        RainbowBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
end)

-- Status panel for activity notifications
local StatusBox = Instance.new("TextLabel")
StatusBox.Size = UDim2.new(0.9, 0, 0, 60)
StatusBox.Position = UDim2.new(0.05, 0, 0.81, 0)
StatusBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
StatusBox.Text = "Status: Troll Player Hub loaded successfully!"
StatusBox.TextColor3 = Color3.fromRGB(0, 255, 128)
StatusBox.TextSize = 10
StatusBox.Font = Enum.Font.SourceSansBold
StatusBox.TextWrapped = true
StatusBox.Parent = MainFrame

local StatusCorner = Instance.new("UICorner")
StatusCorner.CornerRadius = UDim.new(0, 6)
StatusCorner.Parent = StatusBox

-- Optimized background loop for character parameters and color effects
task.spawn(function()
    while true do
        task.wait(0.1)
        pcall(function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") then
                local humanoid = char.Humanoid
                if humanoid.WalkSpeed ~= getgenv().CustomWalkSpeed then
                    humanoid.WalkSpeed = getgenv().CustomWalkSpeed
                end
                if humanoid.JumpPower ~= getgenv().CustomJumpPower then
                    humanoid.JumpPower = getgenv().CustomJumpPower
                end
            end

            if getgenv().RainbowActive and char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.Color = Color3.fromHSV(tick() % 5 / 5, 1, 1)
                    end
                end
            end
        end)
    end
end)
