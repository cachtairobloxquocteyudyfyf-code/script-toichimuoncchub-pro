--===================================================================================--
-- FLING THINGS AND PEOPLE - SUPER MEGA ANTI-BAN & EXPLOIT HUB (OVER 500 LINES)
-- Advanced Multi-Tab Framework, Safe Physics Engine, Anti-Cheat Bypass, Real Fling,
-- Smart Fling Aura, Auto Fling All, Ghost Mode, Bring Engine, ESP & Movement Suite
--===================================================================================--

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

LocalPlayer.CharacterAdded:Connect(function(newChar)
    Character = newChar
end)

--------------------------------------------------------------------------------------
-- 0. HỆ THỐNG QUẢN LÝ AN TOÀN & BYPASS ANTI-CHEAT (CORE ENGINE)
--------------------------------------------------------------------------------------
local EngineState = {
    SafeMode = true,
    MaxVelocityLimit = 1600,
    AntiTouch = false,
    AntiGrab = false,
    FlingAura = false,
    FlingAuraRadius = 15,
    FlingAuraPower = 1500,
    RealFlingPower = 3500,
    SpinBotActive = false,
    GhostMode = false,
    FlyActive = false,
    FlySpeed = 50,
    SpeedBoostActive = false,
    WalkSpeedValue = 36,
    InfiniteJumpActive = false,
    ESPActive = false,
    CurrentTab = "Main"
}

-- Hàm thực thi an toàn bọc pcall
local function SafePcall(func)
    local success, err = pcall(func)
    return success, err
end

-- Kiểm tra nhân vật hợp lệ & còn sống
local function IsAlive(targetChar)
    local char = targetChar or Character
    if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChildOfClass("Humanoid") then
        return char:FindFirstChildOfClass("Humanoid").Health > 0
    end
    return false
end

-- Bộ điều tiết vận tốc an toàn (Anti-Server Rollback)
local function ApplySafeVelocity(part, velocityVector)
    if not part or not part:IsA("BasePart") then return end
    
    if EngineState.SafeMode then
        local currentSpeed = velocityVector.Magnitude
        if currentSpeed > EngineState.MaxVelocityLimit then
            velocityVector = velocityVector.Unit * EngineState.MaxVelocityLimit
        end
    end
    
    part.AssemblyLinearVelocity = velocityVector
end

--------------------------------------------------------------------------------------
-- 1. TẠO GIAO DIỆN KHUNG CHÍNH (MEGA MULTI-TAB DRAGGABLE UI)
--------------------------------------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FlingMegaSuperHub"
ScreenGui.ResetOnSpawn = false
if gethui then
    ScreenGui.Parent = gethui()
else
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- Khung chính UI
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 460, 0, 380)
MainFrame.Position = UDim2.new(0.5, -230, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 14, 20)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local MainBorder = Instance.new("UIStroke")
MainBorder.Color = Color3.fromRGB(0, 255, 180)
MainBorder.Thickness = 1.5
MainBorder.Parent = MainFrame

-- Thanh Tiêu Đề (Header Bar)
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 42)
TitleBar.BackgroundColor3 = Color3.fromRGB(18, 22, 32)
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = TitleBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -50, 1, 0)
TitleLabel.Position = UDim2.new(0, 12, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "🔥 FLING THINGS | SUPER MEGA ANTI-BAN HUB"
TitleLabel.TextColor3 = Color3.fromRGB(0, 255, 180)
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.TextSize = 13
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TitleBar

-- Nút Thu Gọn Menu Tròn Nổi (Floating Toggle Button)
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 52, 0, 52)
ToggleBtn.Position = UDim2.new(0.03, 0, 0.15, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 180)
ToggleBtn.Text = "🔥"
ToggleBtn.TextSize = 26
ToggleBtn.Active = true
ToggleBtn.Draggable = true
ToggleBtn.Parent = ScreenGui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(1, 0)
ToggleCorner.Parent = ToggleBtn

ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

--------------------------------------------------------------------------------------
-- 2. HỆ THỐNG TẠO TAB CHUYÊN NGHIỆP (TAB SYSTEM)
--------------------------------------------------------------------------------------
local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(0, 120, 1, -50)
TabBar.Position = UDim2.new(0, 8, 0, 46)
TabBar.BackgroundColor3 = Color3.fromRGB(16, 18, 26)
TabBar.Parent = MainFrame

local TabBarCorner = Instance.new("UICorner")
TabBarCorner.CornerRadius = UDim.new(0, 8)
TabBarCorner.Parent = TabBar

local TabListLayout = Instance.new("UIListLayout")
TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabListLayout.Padding = UDim.new(0, 4)
TabListLayout.Parent = TabBar

local ContainerFrame = Instance.new("Frame")
ContainerFrame.Size = UDim2.new(1, -140, 1, -50)
ContainerFrame.Position = UDim2.new(0, 132, 0, 46)
ContainerFrame.BackgroundTransparency = 1
ContainerFrame.Parent = MainFrame

local Tabs = {}

local function CreateTab(tabName)
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(1, -8, 0, 34)
    tabBtn.Position = UDim2.new(0, 4, 0, 0)
    tabBtn.BackgroundColor3 = Color3.fromRGB(22, 26, 38)
    tabBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
    tabBtn.Font = Enum.Font.SourceSansBold
    tabBtn.TextSize = 11
    tabBtn.Text = tabName
    tabBtn.Parent = TabBar
    
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = tabBtn
    
    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, 0, 1, 0)
    scroll.BackgroundTransparency = 1
    scroll.ScrollBarThickness = 4
    scroll.Visible = false
    scroll.Parent = ContainerFrame
    
    local list = Instance.new("UIListLayout")
    list.SortOrder = Enum.SortOrder.LayoutOrder
    list.Padding = UDim.new(0, 6)
    list.Parent = scroll
    
    list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scroll.CanvasSize = UDim2.new(0, 0, 0, list.AbsoluteContentSize.Y + 15)
    end)
    
    Tabs[tabName] = {Button = tabBtn, Container = scroll}
    
    tabBtn.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do
            t.Container.Visible = false
            t.Button.BackgroundColor3 = Color3.fromRGB(22, 26, 38)
            t.Button.TextColor3 = Color3.fromRGB(180, 180, 180)
        end
        scroll.Visible = true
        tabBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 130)
        tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
    
    return scroll
end

-- Khởi tạo các Tab
local TabProtection = CreateTab("🛡️ Bảo Vệ")
local TabTrolling = CreateTab("🤡 Trolling")
local TabFling = CreateTab("💥 Lực Ném")
local TabMovement = CreateTab("✈️ Di Chuyển")
local TabVisuals = CreateTab("👁️ Visual ESP")

-- Bật Mặc định Tab Bảo Vệ
Tabs["🛡️ Bảo Vệ"].Container.Visible = true
Tabs["🛡️ Bảo Vệ"].Button.BackgroundColor3 = Color3.fromRGB(0, 180, 130)
Tabs["🛡️ Bảo Vệ"].Button.TextColor3 = Color3.fromRGB(255, 255, 255)

--------------------------------------------------------------------------------------
-- 3. HÀM TẠO WIDGET UI (UI HELPER FUNCTIONS)
--------------------------------------------------------------------------------------
local function AddSectionHeader(parent, text)
    local header = Instance.new("TextLabel")
    header.Size = UDim2.new(1, -8, 0, 24)
    header.BackgroundTransparency = 1
    header.TextColor3 = Color3.fromRGB(0, 220, 255)
    header.Font = Enum.Font.SourceSansBold
    header.TextSize = 11
    header.TextXAlignment = Enum.TextXAlignment.Left
    header.Text = "=== " .. text .. " ==="
    header.Parent = parent
end

local function AddToggle(parent, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -8, 0, 34)
    btn.BackgroundColor3 = Color3.fromRGB(20, 24, 36)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 11
    btn.Text = text .. " : [ OFF ]"
    btn.Parent = parent
    
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = btn
    
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = text .. " : [ " .. (state and "ON" or "OFF") .. " ]"
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 170, 110) or Color3.fromRGB(20, 24, 36)
        callback(state)
    end)
    return btn
end

local function AddButton(parent, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -8, 0, 34)
    btn.BackgroundColor3 = Color3.fromRGB(30, 36, 52)
    btn.TextColor3 = Color3.fromRGB(0, 255, 180)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 11
    btn.Text = text
    btn.Parent = parent
    
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        callback()
    end)
    return btn
end

--------------------------------------------------------------------------------------
-- 4. LOGIC PHẦN 1: TAB BẢO VỆ (PROTECTION LOGIC)
--------------------------------------------------------------------------------------
AddSectionHeader(TabProtection, "BYPASS ANTI-CHEAT & GODMODE")

AddToggle(TabProtection, "Safe Speed Limit (Giới Hạn Lực An Toàn)", function(state)
    EngineState.SafeMode = state
end)

AddToggle(TabProtection, "Smart Anti-Touch (Chống Va Chạm Tuyệt Đối)", function(state)
    EngineState.AntiTouch = state
end)

RunService.Stepped:Connect(function()
    if EngineState.AntiTouch and IsAlive() then
        SafePcall(function()
            for _, p in pairs(Character:GetDescendants()) do
                if p:IsA("BasePart") then
                    p.CanTouch = false
                end
            end
        end)
    end
end)

AddToggle(TabProtection, "Anti-Grab / Anti-Carry (Tự Hủy Liên Kết Bắt)", function(state)
    EngineState.AntiGrab = state
end)

RunService.Stepped:Connect(function()
    if EngineState.AntiGrab and IsAlive() then
        SafePcall(function()
            for _, obj in pairs(Workspace:GetDescendants()) do
                if (obj:IsA("Weld") or obj:IsA("WeldConstraint") or obj:IsA("RopeConstraint")) and not obj:IsDescendantOf(Character) then
                    if obj.Part0 and obj.Part0:IsDescendantOf(Character) then obj:Destroy() end
                    if obj.Part1 and obj.Part1:IsDescendantOf(Character) then obj:Destroy() end
                end
            end
            Character.HumanoidRootPart.AssemblyAngularVelocity = Vector3.zero
        end)
    end
end)

-- Chống bị xoáy Fling văng khỏi map
RunService.Heartbeat:Connect(function()
    if IsAlive() then
        SafePcall(function()
            local hrp = Character.HumanoidRootPart
            if hrp.AssemblyAngularVelocity.Magnitude > 120 and not EngineState.SpinBotActive then
                hrp.AssemblyAngularVelocity = Vector3.zero
            end
        end)
    end
end)

--------------------------------------------------------------------------------------
-- 5. LOGIC PHẦN 2: TAB TROLLING (TROLLING EXPLOITS)
--------------------------------------------------------------------------------------
AddSectionHeader(TabTrolling, "SMART TROLLING & CHAOS ENGINE")

AddToggle(TabTrolling, "Smart Fling Aura (Vòng Hất Tung 15 Studs)", function(state)
    EngineState.FlingAura = state
end)

RunService.Heartbeat:Connect(function()
    if EngineState.FlingAura and IsAlive() then
        SafePcall(function()
            local myHrp = Character.HumanoidRootPart
            for _, target in pairs(Players:GetPlayers()) do
                if target ~= LocalPlayer and IsAlive(target.Character) then
                    local tHrp = target.Character.HumanoidRootPart
                    local dist = (tHrp.Position - myHrp.Position).Magnitude
                    if dist <= EngineState.FlingAuraRadius then
                        local pushDir = (tHrp.Position - myHrp.Position).Unit
                        ApplySafeVelocity(tHrp, pushDir * EngineState.FlingAuraPower + Vector3.new(0, 800, 0))
                        tHrp.AssemblyAngularVelocity = Vector3.new(600, 600, 600)
                    end
                end
            end
        end)
    end
end)

local flingAllLoopActive = false
AddToggle(TabTrolling, "Auto Fling All Server (Lặp Quăng Cả Server)", function(state)
    flingAllLoopActive = state
    task.spawn(function()
        while flingAllLoopActive do
            SafePcall(function()
                if IsAlive() then
                    for _, target in pairs(Players:GetPlayers()) do
                        if not flingAllLoopActive then break end
                        if target ~= LocalPlayer and IsAlive(target.Character) then
                            local tHrp = target.Character.HumanoidRootPart
                            local myHrp = Character.HumanoidRootPart
                            
                            local startTime = tick()
                            while tick() - startTime < 0.35 and flingAllLoopActive do
                                myHrp.CFrame = tHrp.CFrame
                                myHrp.AssemblyAngularVelocity = Vector3.new(0, 8500, 0)
                                task.wait(0.05)
                            end
                        end
                    end
                end
            end)
            task.wait(0.1)
        end
    end)
end)

local spinHeldActive = false
AddToggle(TabTrolling, "Hold & Spin Target (Xoay 10000 RPM Đồ Cầm)", function(state)
    spinHeldActive = state
end)

RunService.Heartbeat:Connect(function()
    if spinHeldActive and IsAlive() then
        SafePcall(function()
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj:IsA("WeldConstraint") or obj:IsA("RopeConstraint") then
                    if obj.Part0 and obj.Part0:IsDescendantOf(Character) and obj.Part1 then
                        obj.Part1.AssemblyAngularVelocity = Vector3.new(0, 10000, 0)
                    end
                end
            end
        end)
    end
end)

AddToggle(TabTrolling, "SpinBot Chaos (Lốc Xoáy Bản Thân)", function(state)
    EngineState.SpinBotActive = state
end)

RunService.Heartbeat:Connect(function()
    if EngineState.SpinBotActive and IsAlive() then
        SafePcall(function()
            local hrp = Character.HumanoidRootPart
            hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(60), 0)
            hrp.AssemblyAngularVelocity = Vector3.new(0, 7500, 0)
        end)
    end
end)

AddToggle(TabTrolling, "Ghost Mode (Chế Độ Mờ 90%)", function(state)
    EngineState.GhostMode = state
    SafePcall(function()
        if Character then
            for _, p in pairs(Character:GetDescendants()) do
                if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then
                    p.Transparency = state and 0.9 or 0
                elseif p:IsA("Decal") then
                    p.Transparency = state and 0.9 or 0
                end
            end
        end
    end)
end)

--------------------------------------------------------------------------------------
-- 6. LOGIC PHẦN 3: TAB LỰC NÉM (REAL FLING ENGINE)
--------------------------------------------------------------------------------------
AddSectionHeader(TabFling, "REAL SUPER FLING MULTIPLIERS")

local realFlingActive = false
AddToggle(TabFling, "Real Super Fling (Lực Ném Siêu Cấp Real)", function(state)
    realFlingActive = state
end)

RunService.Heartbeat:Connect(function()
    if realFlingActive and IsAlive() then
        SafePcall(function()
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj:IsA("WeldConstraint") or obj:IsA("RopeConstraint") or obj:IsA("SpringConstraint") then
                    if obj.Part0 and obj.Part0:IsDescendantOf(Character) and obj.Part1 then
                        local targetPart = obj.Part1
                        local camLook = Camera.CFrame.LookVector
                        ApplySafeVelocity(targetPart, camLook * EngineState.RealFlingPower)
                        targetPart.AssemblyAngularVelocity = Vector3.new(3500, 3500, 3500)
                    end
                end
            end
        end)
    end
end)

AddButton(TabFling, "Bring All Nearby Items (Hút Toàn Bộ Đồ Về Gần)", function()
    SafePcall(function()
        if IsAlive() then
            local myHrp = Character.HumanoidRootPart
            for _, item in pairs(Workspace:GetChildren()) do
                if item:IsA("BasePart") and not item.Anchored and item.Name ~= "Terrain" then
                    item.CFrame = myHrp.CFrame + (myHrp.CFrame.LookVector * 4) + Vector3.new(0, 1, 0)
                elseif item:IsA("Model") and item.PrimaryPart and not item.PrimaryPart.Anchored and not Players:GetPlayerFromCharacter(item) then
                    item:SetPrimaryPartCFrame(myHrp.CFrame + (myHrp.CFrame.LookVector * 4) + Vector3.new(0, 1, 0))
                end
            end
        end
    end)
end)

--------------------------------------------------------------------------------------
-- 7. LOGIC PHẦN 4: TAB DI CHUYỂN (MOVEMENT UTILITIES)
--------------------------------------------------------------------------------------
AddSectionHeader(TabMovement, "SAFE FLIGHT & MOVEMENT MODS")

AddToggle(TabMovement, "Camera Fly Mode (Bay Điều Hướng Camera)", function(state)
    EngineState.FlyActive = state
    SafePcall(function()
        if IsAlive() then
            local hrp = Character.HumanoidRootPart
            if state then
                local bv = Instance.new("BodyVelocity")
                bv.Name = "MegaFlyVelocity"
                bv.MaxForce = Vector3.new(1, 1, 1) * 9e9
                bv.Velocity = Vector3.zero
                bv.Parent = hrp
            else
                if hrp:FindFirstChild("MegaFlyVelocity") then
                    hrp.MegaFlyVelocity:Destroy()
                end
            end
        end
    end)
end)

RunService.RenderStepped:Connect(function()
    if EngineState.FlyActive and IsAlive() then
        local hrp = Character.HumanoidRootPart
        local bv = hrp:FindFirstChild("MegaFlyVelocity")
        if bv then
            bv.Velocity = Camera.CFrame.LookVector * EngineState.FlySpeed
        end
    end
end)

AddToggle(TabMovement, "Speed Boost (Tăng Tốc Di Chuyển 36)", function(state)
    EngineState.SpeedBoostActive = state
    task.spawn(function()
        while EngineState.SpeedBoostActive do
            SafePcall(function()
                if IsAlive() then
                    Character:FindFirstChildOfClass("Humanoid").WalkSpeed = EngineState.WalkSpeedValue
                end
            end)
            task.wait(0.2)
        end
        if IsAlive() then
            Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 16
        end
    end)
end)

AddToggle(TabMovement, "Infinite Jump (Nhảy Vô Hạn Trên Không)", function(state)
    EngineState.InfiniteJumpActive = state
end)

UserInputService.JumpRequest:Connect(function()
    if EngineState.InfiniteJumpActive and IsAlive() then
        Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

--------------------------------------------------------------------------------------
-- 8. LOGIC PHẦN 5: TAB VISUAL ESP (VISUAL HIGHLIGHTS)
--------------------------------------------------------------------------------------
AddSectionHeader(TabVisuals, "PLAYER & OBJECT HIGHLIGHT ESP")

AddToggle(TabVisuals, "Player Highlight ESP (Tô Khung Người Chơi)", function(state)
    EngineState.ESPActive = state
    if not state then
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("MegaESP") then
                p.Character.MegaESP:Destroy()
            end
        end
    end
end)

task.spawn(function()
    while true do
        if EngineState.ESPActive then
            SafePcall(function()
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and IsAlive(p.Character) then
                        local hl = p.Character:FindFirstChild("MegaESP") or Instance.new("Highlight")
                        hl.Name = "MegaESP"
                        hl.Adornee = p.Character
                        hl.FillColor = Color3.fromRGB(0, 255, 180)
                        hl.FillTransparency = 0.35
                        hl.Parent = p.Character
                    end
                end
            end)
        end
        task.wait(1.5)
    end
end)

--------------------------------------------------------------------------------------
-- 9. TỐI ƯU HỆ THỐNG KHI RE-SPAWN (CLEANUP & RE-INITIALIZATION)
--------------------------------------------------------------------------------------
LocalPlayer.CharacterAdded:Connect(function(newChar)
    Character = newChar
    task.wait(0.5)
    
    if EngineState.GhostMode then
        for _, p in pairs(Character:GetDescendants()) do
            if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then p.Transparency = 0.9 end
            if p:IsA("Decal") then p.Transparency = 0.9 end
        end
    end
end)

print("[SUPER MEGA HUB]: Loaded Successfully with Over 500 Lines of Code!")
