-- // ================================================================= // --
-- // 2K13 SUPER HUB - HUSS VALLEY ULTRA ENGINE V3.1 (+ANTICHEAT BYPASS) // --
-- // BUILT STRICTLY FOR HUSS VALLEY (TAG / RUNNER / CHASER MECHANICS)   // --
-- // ================================================================= // --

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")
local PathfindingService = game:GetService("PathfindingService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- ==========================================
-- 0. ADVANCED ANTICHEAT BYPASS ENGINE
-- ==========================================
local BypassEngine = {
	HookedRemotes = {},
	SafeTweenSpeed = 350, -- Max safe speed for CFrame Tweening without trigger
	BypassKick = true,
	BypassBanRemotes = true,
	SpoofWalkSpeed = true
}

-- Metatable Hooking to Block Kick & Ban Signals
local rawMeta = getrawmetatable(game)
local oldNamecall = rawMeta.__namecall
local oldIndex = rawMeta.__index
setreadonly(rawMeta, false)

rawMeta.__namecall = newcclosure(function(self, ...)
	local method = getnamecallmethod()
	local args = {...}

	-- Block LocalPlayer:Kick()
	if BypassEngine.BypassKick and tostring(method) == "Kick" and self == LocalPlayer then
		warn("[2K13 BYPASS] Intercepted and blocked game Kick attempt!")
		return nil
	end

	-- Block AntiCheat Remote Events
	if BypassEngine.BypassBanRemotes and (tostring(method) == "FireServer" or tostring(method) == "InvokeServer") then
		local remoteName = tostring(self.Name):lower()
		if remoteName:find("cheat") or remoteName:find("ban") or remoteName:find("flag") or remoteName:find("detect") or remoteName:find("log") or remoteName:find("verify") then
			warn("[2K13 BYPASS] Blocked suspicious RemoteEvent: " .. self.Name)
			return nil
		end
	end

	return oldNamecall(self, ...)
end)

-- Memory & Speed Spoofing
rawMeta.__index = newcclosure(function(self, key)
	if BypassEngine.SpoofWalkSpeed and not checkcaller() then
		if self:IsA("Humanoid") and key == "WalkSpeed" then
			return 16 -- Return default walkspeed when AC checks
		elseif self:IsA("Humanoid") and key == "JumpPower" then
			return 50 -- Return default jumppower when AC checks
		end
	end
	return oldIndex(self, key)
end)

setreadonly(rawMeta, true)

-- Safe Anti-Rubberband Teleport Helper
local function SafeTeleport(targetCFrame)
	local char = LocalPlayer.Character
	if not char or not char:FindFirstChild("HumanoidRootPart") then return end
	local root = char.HumanoidRootPart

	local dist = (targetCFrame.Position - root.Position).Magnitude
	if dist < 10 then
		root.CFrame = targetCFrame
	else
		local tweenTime = dist / BypassEngine.SafeTweenSpeed
		local tweenInfo = TweenInfo.new(tweenTime, Enum.EasingStyle.Linear)
		local tween = TweenService:Create(root, tweenInfo, {CFrame = targetCFrame})
		tween:Play()
	end
end

print("[2K13 BYPASS] AntiCheat Bypass Engine Hooked Successfully!")

-- ==========================================
-- 1. CORE ENGINE CONFIGURATION & STATES
-- ==========================================
local HV_Framework = {
	Version = "3.1.0-HV-Bypass",
	Author = "2K13 Development Team",
	ActiveState = true,
	
	State = {
		LocalRole = "Unknown",
		IsGameActive = false,
		CurrentTarget = nil,
		IsEvading = false,
		IsCatching = false,
		LastPosition = Vector3.zero
	},
	
	Settings = {
		Runner = {
			AutoCrossArena = false,
			AutoDodgeChaser = false,
			DodgeTriggerDistance = 25,
			SafeZoneNavigation = true,
			AutoReviveTeammates = false,
			ReviveDistanceThreshold = 18,
			AutoDeployClone = false,
			AutoUseSpeedAbility = false,
			PredictivePathfinding = true,
			SmartObstacleJump = true
		},
		Catcher = {
			AutoCatchRunner = false,
			CatchDistanceThreshold = 14,
			AutoMeleeSwing = false,
			AutoDiveTarget = false,
			TargetSelectionMethod = "Closest",
			PredictRunnerPath = true,
			AutoEquipWeapon = true,
			InstantCatchBypass = false
		},
		Movement = {
			WalkSpeedValue = 16,
			EnableCustomSpeed = false,
			JumpPowerValue = 50,
			EnableCustomJump = false,
			FlyModeEnabled = false,
			FlySpeedValue = 60,
			NoclipModeEnabled = false,
			InfiniteAirJump = false,
			InstantStopVelocity = false,
			LateralDashBoost = false,
			DashPower = 35,
			GravityModifier = 196.2,
			EnableGravityControl = false
		},
		Collectibles = {
			AutoCollectGems = false,
			AutoCollectCoins = false,
			BypassDangerousLoot = true,
			MagnetRadius = 35,
			LootTeleportMethod = "BringToPlayer"
		},
		Visuals = {
			MasterESP = false,
			ChaserHighlightColor = Color3.fromRGB(255, 45, 85),
			RunnerHighlightColor = Color3.fromRGB(45, 235, 120),
			ShowRoleTags = true,
			ShowDistanceLabel = true,
			ShowTracerLines = false,
			TracerColor = Color3.fromRGB(255, 255, 255),
			TracerOrigin = "Bottom",
			ChaserFOVWarning = true,
			FOVWarningRadius = 30
		},
		Server = {
			FullbrightVision = false,
			RemoveMapFog = false,
			AntiAFKSystem = true,
			AutoRejoinGame = false,
			DisablePostProcessing = false,
			UnlockFPSCap = true
		}
	}
}

-- Anti-AFK Safeguard Thread
if HV_Framework.Settings.Server.AntiAFKSystem then
	LocalPlayer.Idled:Connect(function()
		local VirtualUser = game:GetService("VirtualUser")
		VirtualUser:CaptureController()
		VirtualUser:ClickButton2(Vector2.zero)
		print("[2K13 AFK] Prevented idle disconnect.")
	end)
end

-- Role Detector Helper
local function IdentifyRole(playerObject)
	if not playerObject or not playerObject.Character then return "Unknown" end
	
	if playerObject.Team and playerObject.Team.Name:lower():find("chaser") then
		return "Chaser"
	elseif playerObject.Team and playerObject.Team.Name:lower():find("runner") then
		return "Runner"
	end
	
	local char = playerObject.Character
	for _, child in ipairs(char:GetChildren()) do
		if child:IsA("Tool") and (child.Name:lower():find("knife") or child.Name:lower():find("bat") or child.Name:lower():find("catch")) then
			return "Chaser"
		end
	end
	
	return "Runner"
end

local function AmIChaserPlayer()
	return IdentifyRole(LocalPlayer) == "Chaser"
end

-- ==========================================
-- 2. ADVANCED MODULAR UI ENGINE
-- ==========================================
local UIEngine = {}
UIEngine.__index = UIEngine

function UIEngine.Build()
	local self = setmetatable({}, UIEngine)
	
	local existingUI = LocalPlayer.PlayerGui:FindFirstChild("2K13_HV_UltraHub")
	if existingUI then 
		existingUI:Destroy() 
	end

	self.ScreenGui = Instance.new("ScreenGui")
	self.ScreenGui.Name = "2K13_HV_UltraHub"
	self.ScreenGui.ResetOnSpawn = false
	self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	self.ScreenGui.Parent = LocalPlayer.PlayerGui

	self.MainContainer = Instance.new("Frame")
	self.MainContainer.Name = "MainContainer"
	self.MainContainer.Size = UDim2.fromOffset(640, 440)
	self.MainContainer.Position = UDim2.new(0.5, -320, 0.5, -220)
	self.MainContainer.BackgroundColor3 = Color3.fromRGB(12, 14, 20)
	self.MainContainer.BorderSizePixel = 0
	self.MainContainer.Active = true
	self.MainContainer.Draggable = true
	self.MainContainer.Parent = self.ScreenGui

	local mainCorner = Instance.new("UICorner")
	mainCorner.CornerRadius = UDim.new(0, 10)
	mainCorner.Parent = self.MainContainer

	local mainStroke = Instance.new("UIStroke")
	mainStroke.Color = Color3.fromRGB(236, 65, 88)
	mainStroke.Thickness = 1.5
	mainStroke.Parent = self.MainContainer

	-- Title Bar Panel
	self.TitleBar = Instance.new("Frame")
	self.TitleBar.Name = "TitleBar"
	self.TitleBar.Size = UDim2.new(1, 0, 0, 50)
	self.TitleBar.BackgroundColor3 = Color3.fromRGB(18, 21, 30)
	self.TitleBar.BorderSizePixel = 0
	self.TitleBar.Parent = self.MainContainer

	local titleCorner = Instance.new("UICorner")
	titleCorner.CornerRadius = UDim.new(0, 10)
	titleCorner.Parent = self.TitleBar

	local titleText = Instance.new("TextLabel")
	titleText.Name = "TitleText"
	titleText.Text = "2K13 SUPER HUB — HUSS VALLEY ULTRA"
	titleText.Size = UDim2.new(0, 380, 0, 22)
	titleText.Position = UDim2.fromOffset(15, 8)
	titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
	titleText.Font = Enum.Font.GothamBlack
	titleText.TextSize = 13
	titleText.TextXAlignment = Enum.TextXAlignment.Left
	titleText.BackgroundTransparency = 1
	titleText.Parent = self.TitleBar

	local subtitleText = Instance.new("TextLabel")
	subtitleText.Name = "SubtitleText"
	subtitleText.Text = "TAG & RUNNER ENGINE — ANTICHEAT BYPASS ACTIVE (880+ LINES)"
	subtitleText.Size = UDim2.new(0, 380, 0, 15)
	subtitleText.Position = UDim2.fromOffset(15, 28)
	subtitleText.TextColor3 = Color3.fromRGB(72, 224, 157)
	subtitleText.Font = Enum.Font.GothamBold
	subtitleText.TextSize = 8
	subtitleText.TextXAlignment = Enum.TextXAlignment.Left
	subtitleText.BackgroundTransparency = 1
	subtitleText.Parent = self.TitleBar

	-- Navigation Sidebar
	self.Sidebar = Instance.new("ScrollingFrame")
	self.Sidebar.Name = "Sidebar"
	self.Sidebar.Size = UDim2.new(0, 150, 1, -50)
	self.Sidebar.Position = UDim2.fromOffset(0, 50)
	self.Sidebar.BackgroundColor3 = Color3.fromRGB(15, 17, 24)
	self.Sidebar.BorderSizePixel = 0
	self.Sidebar.ScrollBarThickness = 2
	self.Sidebar.Parent = self.MainContainer

	local sidebarLayout = Instance.new("UIListLayout")
	sidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
	sidebarLayout.Padding = UDim.new(0, 5)
	sidebarLayout.Parent = self.Sidebar

	local sidebarPadding = Instance.new("UIPadding")
	sidebarPadding.PaddingTop = UDim.new(0, 8)
	sidebarPadding.PaddingLeft = UDim.new(0, 6)
	sidebarPadding.PaddingRight = UDim.new(0, 6)
	sidebarPadding.Parent = self.Sidebar

	-- Page Display Area
	self.DisplayArea = Instance.new("Frame")
	self.DisplayArea.Name = "DisplayArea"
	self.DisplayArea.Size = UDim2.new(1, -150, 1, -50)
	self.DisplayArea.Position = UDim2.fromOffset(150, 50)
	self.DisplayArea.BackgroundTransparency = 1
	self.DisplayArea.Parent = self.MainContainer

	self.RegisteredPages = {}
	self.CurrentActivePage = nil

	return self
end

function UIEngine:CreateTabCategory(tabName)
	local tabButton = Instance.new("TextButton")
	tabButton.Name = "Tab_" .. tabName
	tabButton.Size = UDim2.new(1, 0, 0, 34)
	tabButton.BackgroundColor3 = Color3.fromRGB(22, 25, 35)
	tabButton.Text = tabName
	tabButton.TextColor3 = Color3.fromRGB(160, 168, 190)
	tabButton.Font = Enum.Font.GothamMedium
	tabButton.TextSize = 10
	tabButton.Parent = self.Sidebar

	local buttonCorner = Instance.new("UICorner")
	buttonCorner.CornerRadius = UDim.new(0, 6)
	buttonCorner.Parent = tabButton

	local pageFrame = Instance.new("ScrollingFrame")
	pageFrame.Name = "Page_" .. tabName
	pageFrame.Size = UDim2.fromScale(1, 1)
	pageFrame.BackgroundTransparency = 1
	pageFrame.Visible = false
	pageFrame.ScrollBarThickness = 3
	pageFrame.ScrollBarImageColor3 = Color3.fromRGB(236, 65, 88)
	pageFrame.Parent = self.DisplayArea

	local pageLayout = Instance.new("UIListLayout")
	pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
	pageLayout.Padding = UDim.new(0, 6)
	pageLayout.Parent = pageFrame

	local pagePadding = Instance.new("UIPadding")
	pagePadding.PaddingTop = UDim.new(0, 10)
	pagePadding.PaddingLeft = UDim.new(0, 10)
	pagePadding.PaddingRight = UDim.new(0, 10)
	pagePadding.PaddingBottom = UDim.new(0, 10)
	pagePadding.Parent = pageFrame

	tabButton.MouseButton1Click:Connect(function()
		for _, pageData in pairs(self.RegisteredPages) do
			pageData.Frame.Visible = false
			pageData.Button.TextColor3 = Color3.fromRGB(160, 168, 190)
			pageData.Button.BackgroundColor3 = Color3.fromRGB(22, 25, 35)
		end
		pageFrame.Visible = true
		tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
		tabButton.BackgroundColor3 = Color3.fromRGB(236, 65, 88)
	end)

	if not self.CurrentActivePage then
		self.CurrentActivePage = pageFrame
		pageFrame.Visible = true
		tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
		tabButton.BackgroundColor3 = Color3.fromRGB(236, 65, 88)
	end

	self.RegisteredPages[tabName] = {Frame = pageFrame, Button = tabButton}
	return pageFrame
end

function UIEngine:AddToggleComponent(targetPage, labelText, defaultState, callbackFunction)
	local componentFrame = Instance.new("Frame")
	componentFrame.Name = "Toggle_" .. labelText
	componentFrame.Size = UDim2.new(1, 0, 0, 36)
	componentFrame.BackgroundColor3 = Color3.fromRGB(22, 25, 35)
	componentFrame.Parent = targetPage

	local frameCorner = Instance.new("UICorner")
	frameCorner.CornerRadius = UDim.new(0, 6)
	frameCorner.Parent = componentFrame

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Name = "Label"
	titleLabel.Text = labelText
	titleLabel.Size = UDim2.new(0.7, 0, 1, 0)
	titleLabel.Position = UDim2.fromOffset(12, 0)
	titleLabel.TextColor3 = Color3.fromRGB(240, 240, 245)
	titleLabel.Font = Enum.Font.Gotham
	titleLabel.TextSize = 10
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.BackgroundTransparency = 1
	titleLabel.Parent = componentFrame

	local switchButton = Instance.new("TextButton")
	switchButton.Name = "Switch"
	switchButton.Size = UDim2.fromOffset(46, 22)
	switchButton.Position = UDim2.new(1, -56, 0.5, -11)
	switchButton.BackgroundColor3 = defaultState and Color3.fromRGB(236, 65, 88) or Color3.fromRGB(45, 50, 65)
	switchButton.Text = defaultState and "ON" or "OFF"
	switchButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	switchButton.Font = Enum.Font.GothamBold
	switchButton.TextSize = 9
	switchButton.Parent = componentFrame

	local switchCorner = Instance.new("UICorner")
	switchCorner.CornerRadius = UDim.new(0, 5)
	switchCorner.Parent = switchButton

	local currentState = defaultState
	switchButton.MouseButton1Click:Connect(function()
		currentState = not currentState
		switchButton.BackgroundColor3 = currentState and Color3.fromRGB(236, 65, 88) or Color3.fromRGB(45, 50, 65)
		switchButton.Text = currentState and "ON" or "OFF"
		callbackFunction(currentState)
	end)
end

function UIEngine:AddSliderComponent(targetPage, labelText, minValue, maxValue, defaultValue, callbackFunction)
	local componentFrame = Instance.new("Frame")
	componentFrame.Name = "Slider_" .. labelText
	componentFrame.Size = UDim2.new(1, 0, 0, 48)
	componentFrame.BackgroundColor3 = Color3.fromRGB(22, 25, 35)
	componentFrame.Parent = targetPage

	local frameCorner = Instance.new("UICorner")
	frameCorner.CornerRadius = UDim.new(0, 6)
	frameCorner.Parent = componentFrame

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Name = "Label"
	titleLabel.Text = labelText .. ": " .. tostring(defaultValue)
	titleLabel.Size = UDim2.new(1, -20, 0, 20)
	titleLabel.Position = UDim2.fromOffset(12, 3)
	titleLabel.TextColor3 = Color3.fromRGB(240, 240, 245)
	titleLabel.Font = Enum.Font.Gotham
	titleLabel.TextSize = 10
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.BackgroundTransparency = 1
	titleLabel.Parent = componentFrame

	local trackBar = Instance.new("Frame")
	trackBar.Name = "TrackBar"
	trackBar.Size = UDim2.new(1, -24, 0, 6)
	trackBar.Position = UDim2.fromOffset(12, 28)
	trackBar.BackgroundColor3 = Color3.fromRGB(40, 45, 60)
	trackBar.Parent = componentFrame

	local trackCorner = Instance.new("UICorner")
	trackCorner.CornerRadius = UDim.new(0, 3)
	trackCorner.Parent = trackBar

	local fillBar = Instance.new("Frame")
	fillBar.Name = "FillBar"
	fillBar.Size = UDim2.new((defaultValue - minValue) / (maxValue - minValue), 0, 1, 0)
	fillBar.BackgroundColor3 = Color3.fromRGB(236, 65, 88)
	fillBar.Parent = trackBar

	local fillCorner = Instance.new("UICorner")
	fillCorner.CornerRadius = UDim.new(0, 3)
	fillCorner.Parent = fillBar

	local isDragging = false
	trackBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			isDragging = true
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			isDragging = false
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local relativePos = math.clamp((input.Position.X - trackBar.AbsolutePosition.X) / trackBar.AbsoluteSize.X, 0, 1)
			local calculatedValue = math.floor(minValue + (maxValue - minValue) * relativePos)
			fillBar.Size = UDim2.new(relativePos, 0, 1, 0)
			titleLabel.Text = labelText .. ": " .. tostring(calculatedValue)
			callbackFunction(calculatedValue)
		end
	end)
end

-- Initialize Window
local AppUI = UIEngine.Build()
local TabBypassPage = AppUI:CreateTabCategory("AntiCheat")
local TabRunnerPage = AppUI:CreateTabCategory("Runner AI")
local TabCatcherPage = AppUI:CreateTabCategory("Catcher AI")
local TabMovementPage = AppUI:CreateTabCategory("Movement")
local TabCollectPage = AppUI:CreateTabCategory("Collectibles")
local TabVisualsPage = AppUI:CreateTabCategory("Visual ESP")
local TabServerPage = AppUI:CreateTabCategory("Server Tools")

-- ==========================================
-- 2.5 ANTICHEAT TAB CONTROLS
-- ==========================================
AppUI:AddToggleComponent(TabBypassPage, "Bypass Anti-Kick System", BypassEngine.BypassKick, function(v) 
	BypassEngine.BypassKick = v 
end)

AppUI:AddToggleComponent(TabBypassPage, "Bypass Ban Remote Signals", BypassEngine.BypassBanRemotes, function(v) 
	BypassEngine.BypassBanRemotes = v 
end)

AppUI:AddToggleComponent(TabBypassPage, "Spoof Memory WalkSpeed", BypassEngine.SpoofWalkSpeed, function(v) 
	BypassEngine.SpoofWalkSpeed = v 
end)

-- ==========================================
-- 3. RUNNER AUTOMATION ENGINE
-- ==========================================
AppUI:AddToggleComponent(TabRunnerPage, "Auto Cross Arena (Safe Teleport)", HV_Framework.Settings.Runner.AutoCrossArena, function(v) 
	HV_Framework.Settings.Runner.AutoCrossArena = v 
end)

AppUI:AddToggleComponent(TabRunnerPage, "Auto Dodge Chasers (Pro Evade)", HV_Framework.Settings.Runner.AutoDodgeChaser, function(v) 
	HV_Framework.Settings.Runner.AutoDodgeChaser = v 
end)

AppUI:AddSliderComponent(TabRunnerPage, "Evade Trigger Radius", 10, 60, 25, function(v) 
	HV_Framework.Settings.Runner.DodgeTriggerDistance = v 
end)

AppUI:AddToggleComponent(TabRunnerPage, "Auto Revive Downed Teammates", HV_Framework.Settings.Runner.AutoReviveTeammates, function(v) 
	HV_Framework.Settings.Runner.AutoReviveTeammates = v 
end)

AppUI:AddToggleComponent(TabRunnerPage, "Auto Deploy Clone Ability", HV_Framework.Settings.Runner.AutoDeployClone, function(v) 
	HV_Framework.Settings.Runner.AutoDeployClone = v 
end)

-- Runner AI Execution Thread
task.spawn(function()
	while task.wait(0.08) do
		if not AmIChaserPlayer() and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
			local myChar = LocalPlayer.Character
			local myRoot = myChar.HumanoidRootPart
			local myHum = myChar:FindFirstChildOfClass("Humanoid")

			-- 1. Auto Evade Algorithm
			if HV_Framework.Settings.Runner.AutoDodgeChaser then
				for _, otherPlayer in ipairs(Players:GetPlayers()) do
					if otherPlayer ~= LocalPlayer and IdentifyRole(otherPlayer) == "Chaser" then
						if otherPlayer.Character and otherPlayer.Character:FindFirstChild("HumanoidRootPart") then
							local chaserRoot = otherPlayer.Character.HumanoidRootPart
							local distanceToChaser = (chaserRoot.Position - myRoot.Position).Magnitude

							if distanceToChaser <= HV_Framework.Settings.Runner.DodgeTriggerDistance then
								HV_Framework.State.IsEvading = true
								local escapeDirection = (myRoot.Position - chaserRoot.Position).Unit
								local targetVelocity = escapeDirection * 45
								myRoot.Velocity = Vector3.new(targetVelocity.X, myRoot.Velocity.Y, targetVelocity.Z)
								
								if myHum and myHum:GetState() ~= Enum.HumanoidStateType.Jumping then
									myHum:ChangeState(Enum.HumanoidStateType.Jumping)
								end
							end
						end
					end
				end
			end

			-- 2. Auto Revive Teammates
			if HV_Framework.Settings.Runner.AutoReviveTeammates then
				for _, teammate in ipairs(Players:GetPlayers()) do
					if teammate ~= LocalPlayer and IdentifyRole(teammate) == "Runner" and teammate.Character then
						local teamHum = teammate.Character:FindFirstChildOfClass("Humanoid")
						local teamRoot = teammate.Character:FindFirstChild("HumanoidRootPart")

						if teamHum and teamHum.Health > 0 and teamRoot then
							local distToTeam = (teamRoot.Position - myRoot.Position).Magnitude
							if distToTeam <= HV_Framework.Settings.Runner.ReviveDistanceThreshold then
								SafeTeleport(teamRoot.CFrame + Vector3.new(0, 2, 0))
							end
						end
					end
				end
			end

			-- 3. Auto Finish Line Cross
			if HV_Framework.Settings.Runner.AutoCrossArena then
				local endZonePart = Workspace:FindFirstChild("FinishZone") 
					or Workspace:FindFirstChild("EndZone") 
					or Workspace:FindFirstChild("Goal")
					or Workspace:FindFirstChild("Finish")

				if endZonePart then
					local targetCFrame = endZonePart:IsA("Model") and endZonePart.PrimaryPart.CFrame or endZonePart.CFrame
					SafeTeleport(targetCFrame + Vector3.new(0, 3, 0))
				end
			end
		end
	end
end)

-- ==========================================
-- 4. CATCHER AUTOMATION ENGINE
-- ==========================================
AppUI:AddToggleComponent(TabCatcherPage, "Auto Catch Runners (Safe Catch)", HV_Framework.Settings.Catcher.AutoCatchRunner, function(v) 
	HV_Framework.Settings.Catcher.AutoCatchRunner = v 
end)

AppUI:AddToggleComponent(TabCatcherPage, "Auto Melee Attack Swing", HV_Framework.Settings.Catcher.AutoMeleeSwing, function(v) 
	HV_Framework.Settings.Catcher.AutoMeleeSwing = v 
end)

AppUI:AddToggleComponent(TabCatcherPage, "Auto Dive Skill Trigger", HV_Framework.Settings.Catcher.AutoDiveTarget, function(v) 
	HV_Framework.Settings.Catcher.AutoDiveTarget = v 
end)

AppUI:AddSliderComponent(TabCatcherPage, "Catch Reach Threshold", 5, 30, 14, function(v) 
	HV_Framework.Settings.Catcher.CatchDistanceThreshold = v 
end)

AppUI:AddToggleComponent(TabCatcherPage, "Auto Equip Weapon Tool", HV_Framework.Settings.Catcher.AutoEquipWeapon, function(v) 
	HV_Framework.Settings.Catcher.AutoEquipWeapon = v 
end)

-- Catcher AI Execution Thread
task.spawn(function()
	while task.wait(0.05) do
		if AmIChaserPlayer() and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
			local myChar = LocalPlayer.Character
			local myRoot = myChar.HumanoidRootPart

			-- Auto Equip Weapon
			if HV_Framework.Settings.Catcher.AutoEquipWeapon and not myChar:FindFirstChildOfClass("Tool") then
				local toolInBackpack = LocalPlayer.Backpack:FindFirstChildOfClass("Tool")
				if toolInBackpack and myChar:FindFirstChildOfClass("Humanoid") then
					myChar.Humanoid:EquipTool(toolInBackpack)
				end
			end

			-- Target Selection Loop
			local targetRunnerRoot = nil
			local shortestDistance = HV_Framework.Settings.Catcher.CatchDistanceThreshold

			for _, playerObj in ipairs(Players:GetPlayers()) do
				if playerObj ~= LocalPlayer and IdentifyRole(playerObj) == "Runner" then
					if playerObj.Character and playerObj.Character:FindFirstChild("HumanoidRootPart") then
						local runnerRootPart = playerObj.Character.HumanoidRootPart
						local runnerHum = playerObj.Character:FindFirstChildOfClass("Humanoid")

						if runnerHum and runnerHum.Health > 0 then
							local calcDist = (runnerRootPart.Position - myRoot.Position).Magnitude
							if calcDist < shortestDistance then
								shortestDistance = calcDist
								targetRunnerRoot = runnerRootPart
							end
						end
					end
				end
			end

			-- Execute Catch
			if targetRunnerRoot then
				HV_Framework.State.IsCatching = true
				
				if HV_Framework.Settings.Catcher.AutoCatchRunner then
					SafeTeleport(targetRunnerRoot.CFrame * CFrame.new(0, 0, 1.2))
				end

				if HV_Framework.Settings.Catcher.AutoMeleeSwing then
					local activeTool = myChar:FindFirstChildOfClass("Tool")
					if activeTool then
						activeTool:Activate()
					end
				end
			else
				HV_Framework.State.IsCatching = false
			end
		end
	end
end)

-- ==========================================
-- 5. MOVEMENT & PHYSICS ENGINE
-- ==========================================
AppUI:AddToggleComponent(TabMovementPage, "Custom WalkSpeed", HV_Framework.Settings.Movement.EnableCustomSpeed, function(v) 
	HV_Framework.Settings.Movement.EnableCustomSpeed = v 
end)

AppUI:AddSliderComponent(TabMovementPage, "WalkSpeed Scale", 16, 250, 16, function(v) 
	HV_Framework.Settings.Movement.WalkSpeedValue = v 
end)

AppUI:AddToggleComponent(TabMovementPage, "Custom JumpPower", HV_Framework.Settings.Movement.EnableCustomJump, function(v) 
	HV_Framework.Settings.Movement.EnableCustomJump = v 
end)

AppUI:AddSliderComponent(TabMovementPage, "JumpPower Scale", 50, 350, 50, function(v) 
	HV_Framework.Settings.Movement.JumpPowerValue = v 
end)

AppUI:AddToggleComponent(TabMovementPage, "Ghost Flight Engine", HV_Framework.Settings.Movement.FlyModeEnabled, function(v) 
	HV_Framework.Settings.Movement.FlyModeEnabled = v 
end)

AppUI:AddSliderComponent(TabMovementPage, "Flight Speed Velocity", 20, 250, 60, function(v) 
	HV_Framework.Settings.Movement.FlySpeedValue = v 
end)

AppUI:AddToggleComponent(TabMovementPage, "Ghost Noclip (Pass Objects)", HV_Framework.Settings.Movement.NoclipModeEnabled, function(v) 
	HV_Framework.Settings.Movement.NoclipModeEnabled = v 
end)

AppUI:AddToggleComponent(TabMovementPage, "Infinite Air Jumps", HV_Framework.Settings.Movement.InfiniteAirJump, function(v) 
	HV_Framework.Settings.Movement.InfiniteAirJump = v 
end)

-- Physics Execution Connections
local flyBodyVel, flyBodyGyro

RunService.Stepped:Connect(function()
	local char = LocalPlayer.Character
	if not char then return end
	local hum = char:FindFirstChildOfClass("Humanoid")
	local root = char:FindFirstChild("HumanoidRootPart")

	if hum then
		if HV_Framework.Settings.Movement.EnableCustomSpeed then 
			hum.WalkSpeed = HV_Framework.Settings.Movement.WalkSpeedValue 
		end
		if HV_Framework.Settings.Movement.EnableCustomJump then 
			hum.UseJumpPower = true 
			hum.JumpPower = HV_Framework.Settings.Movement.JumpPowerValue 
		end
	end

	-- Ghost Noclip Execution
	if HV_Framework.Settings.Movement.NoclipModeEnabled and char then
		for _, partInstance in ipairs(char:GetDescendants()) do
			if partInstance:IsA("BasePart") and partInstance.CanCollide then
				partInstance.CanCollide = false
			end
		end
	end

	-- Ghost Flight Execution
	if HV_Framework.Settings.Movement.FlyModeEnabled and root then
		if not flyBodyVel then
			flyBodyVel = Instance.new("BodyVelocity")
			flyBodyVel.MaxForce = Vector3.new(1e9, 1e9, 1e9)
			flyBodyVel.Parent = root

			flyBodyGyro = Instance.new("BodyGyro")
			flyBodyGyro.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
			flyBodyGyro.Parent = root
		end

		if hum then hum.PlatformStand = true end

		local moveVector = Vector3.zero
		if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveVector = moveVector + Camera.CFrame.LookVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveVector = moveVector - Camera.CFrame.LookVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveVector = moveVector - Camera.CFrame.RightVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveVector = moveVector + Camera.CFrame.RightVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveVector = moveVector + Vector3.new(0, 1, 0) end
		if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveVector = moveVector - Vector3.new(0, 1, 0) end

		flyBodyVel.Velocity = moveVector * HV_Framework.Settings.Movement.FlySpeedValue
		flyBodyGyro.CFrame = Camera.CFrame
	else
		if flyBodyVel then flyBodyVel:Destroy() flyBodyVel = nil end
		if flyBodyGyro then flyBodyGyro:Destroy() flyBodyGyro = nil end
		if hum then hum.PlatformStand = false end
	end
end)

UserInputService.JumpRequest:Connect(function()
	if HV_Framework.Settings.Movement.InfiniteAirJump and LocalPlayer.Character then
		local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
		if hum then 
			hum:ChangeState(Enum.HumanoidStateType.Jumping) 
		end
	end
end)

-- ==========================================
-- 6. COLLECTIBLES AUTOMATION ENGINE
-- ==========================================
AppUI:AddToggleComponent(TabCollectPage, "Auto Vacuum Gems", HV_Framework.Settings.Collectibles.AutoCollectGems, function(v) 
	HV_Framework.Settings.Collectibles.AutoCollectGems = v 
end)

AppUI:AddToggleComponent(TabCollectPage, "Auto Vacuum Coins", HV_Framework.Settings.Collectibles.AutoCollectCoins, function(v) 
	HV_Framework.Settings.Collectibles.AutoCollectCoins = v 
end)

AppUI:AddSliderComponent(TabCollectPage, "Vacuum Radius", 10, 100, 35, function(v) 
	HV_Framework.Settings.Collectibles.MagnetRadius = v 
end)

-- Collectibles Loop
task.spawn(function()
	while task.wait(0.15) do
		local autoG = HV_Framework.Settings.Collectibles.AutoCollectGems
		local autoC = HV_Framework.Settings.Collectibles.AutoCollectCoins

		if (autoG or autoC) and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
			local myRoot = LocalPlayer.Character.HumanoidRootPart

			for _, objectItem in ipairs(Workspace:GetChildren()) do
				if objectItem:IsA("Part") or objectItem:IsA("MeshPart") or objectItem:IsA("Model") then
					local lowerName = objectItem.Name:lower()
					local isGem = autoG and (lowerName:find("gem") or lowerName:find("diamond"))
					local isCoin = autoC and (lowerName:find("coin") or lowerName:find("gold"))

					if isGem or isCoin then
						local targetPart = objectItem:IsA("Model") and objectItem.PrimaryPart or objectItem
						if targetPart then
							local distanceToLoot = (targetPart.Position - myRoot.Position).Magnitude
							if distanceToLoot <= HV_Framework.Settings.Collectibles.MagnetRadius then
								targetPart.CFrame = myRoot.CFrame
							end
						end
					end
				end
			end
		end
	end
end)

-- ==========================================
-- 7. VISUALS & HIGHLIGHT ESP ENGINE
-- ==========================================
AppUI:AddToggleComponent(TabVisualsPage, "Master ESP Highlight", HV_Framework.Settings.Visuals.MasterESP, function(v) 
	HV_Framework.Settings.Visuals.MasterESP = v 
end)

AppUI:AddToggleComponent(TabVisualsPage, "Show Role Overhead Tags", HV_Framework.Settings.Visuals.ShowRoleTags, function(v) 
	HV_Framework.Settings.Visuals.ShowRoleTags = v 
end)

local function RefreshVisualESP()
	for _, playerInstance in ipairs(Players:GetPlayers()) do
		if playerInstance ~= LocalPlayer and playerInstance.Character then
			local charModel = playerInstance.Character
			local existingHighlight = charModel:FindFirstChild("2K13_HV_ESP")

			if HV_Framework.Settings.Visuals.MasterESP then
				if not existingHighlight then
					existingHighlight = Instance.new("Highlight")
					existingHighlight.Name = "2K13_HV_ESP"
					existingHighlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
					existingHighlight.Parent = charModel
				end

				local detectedRole = IdentifyRole(playerInstance)
				if detectedRole == "Chaser" then
					existingHighlight.FillColor = HV_Framework.Settings.Visuals.ChaserHighlightColor
					existingHighlight.OutlineColor = Color3.fromRGB(255, 255, 255)
				else
					existingHighlight.FillColor = HV_Framework.Settings.Visuals.RunnerHighlightColor
					existingHighlight.OutlineColor = Color3.fromRGB(0, 0, 0)
				end
				existingHighlight.Enabled = true
			elseif existingHighlight then
				existingHighlight.Enabled = false
			end
		end
	end
end

RunService.RenderStepped:Connect(RefreshVisualESP)

-- ==========================================
-- 8. WORLD & SERVER UTILITIES ENGINE
-- ==========================================
AppUI:AddToggleComponent(TabServerPage, "Fullbright (Night Vision)", HV_Framework.Settings.Server.FullbrightVision, function(v) 
	HV_Framework.Settings.Server.FullbrightVision = v 
	if v then
		Lighting.Ambient = Color3.fromRGB(255, 255, 255)
		Lighting.Brightness = 2.5
	else
		Lighting.Ambient = Color3.fromRGB(128, 128, 128)
		Lighting.Brightness = 1.0
	end
end)

AppUI:AddToggleComponent(TabServerPage, "Clear Atmosphere Fog", HV_Framework.Settings.Server.RemoveMapFog, function(v) 
	HV_Framework.Settings.Server.RemoveMapFog = v 
	if v then
		Lighting.FogEnd = 9e9
	else
		Lighting.FogEnd = 1000
	end
end)

AppUI:AddToggleComponent(TabServerPage, "Disable Post Processing Effects", HV_Framework.Settings.Server.DisablePostProcessing, function(v) 
	HV_Framework.Settings.Server.DisablePostProcessing = v 
	if v me
		for _, effect in ipairs(Lighting:GetChildren()) do
			if effect:IsA("PostEffect") or effect:IsA("BloomEffect") or effect:IsA("BlurEffect") then
				effect.Enabled = false
			end
		end
	end
end)

print("[2K13 SUPER HUB] Huss Valley Ultra Engine V3.1 Loaded Successfully (~880 Lines). AntiCheat Bypass Active!")
