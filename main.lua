-- =======================================================
-- PINATHUB - AELOE TRIPLE EXECUTION (WINDUI)
-- Auto Parry for Blade Ball | Mobile/Desktop Friendly
-- =======================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local VirtualUser = game:GetService("VirtualUser")
local Player = Players.LocalPlayer
local UIS = UserInputService

-- =======================================================
-- ANTI AFK
-- =======================================================
Player.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- =======================================================
-- SETTINGS
-- =======================================================
local Settings = {
    MasterEnabled = true,
    NoVisualCircle = false,
    AggressiveEnabled = true,
    AggressiveDelay = 5,
    AggressiveDistance = 0.3,
    AggressiveClashDistance = 16,
    PrecisionEnabled = true,
    PrecisionDelay = 10,
    PrecisionPrediction = 0.18,
    PrecisionClashDistance = 20,
    ReactiveEnabled = true,
    ReactiveDelay = 8,
    ReactiveTimeWindow = 0.15,
    ReactiveClashDistance = 24,
    ReactiveSpeedBoost = 1.3,
    EmergencyRadius = 6,
    AntiSpamWindow = 0.02,
}

-- =======================================================
-- LOCAL PLAYER SETTINGS
-- =======================================================
local LocalSettings = {
    SpeedEnabled = false,
    SpeedValue = 50,
    WalkspeedValue = 50,
    OriginalWalkspeed = nil,
}

-- =======================================================
-- INFINITE JUMP VARIABLE
-- =======================================================
local InfiniteJumpEnabled = false

-- =======================================================
-- NOTIFICATION SYSTEM
-- =======================================================
local notifHolder = Instance.new("ScreenGui")
notifHolder.Name = "PinatHubNotifications"
notifHolder.ResetOnSpawn = false
notifHolder.Parent = Player:WaitForChild("PlayerGui")

local notifFrame = Instance.new("Frame")
notifFrame.Name = "NotificationHolder"
notifFrame.Size = UDim2.new(0, 350, 1, -20)
notifFrame.Position = UDim2.new(1, -370, 0, 10)
notifFrame.BackgroundTransparency = 1
notifFrame.Parent = notifHolder

local notifList = Instance.new("UIListLayout")
notifList.Name = "NotifList"
notifList.Padding = UDim.new(0, 8)
notifList.HorizontalAlignment = Enum.HorizontalAlignment.Right
notifList.VerticalAlignment = Enum.VerticalAlignment.Top
notifList.SortOrder = Enum.SortOrder.LayoutOrder
notifList.Parent = notifFrame

local function ShowNotification(title, message, duration)
    duration = duration or 3
    
    local notif = Instance.new("Frame")
    notif.Name = "Notification"
    notif.Size = UDim2.new(0, 330, 0, 70)
    notif.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    notif.BackgroundTransparency = 1
    notif.BorderSizePixel = 0
    notif.ClipsDescendants = true
    notif.Parent = notifFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = notif
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(80, 80, 90)
    stroke.Thickness = 1
    stroke.Transparency = 0.5
    stroke.Parent = notif
    
    local accent = Instance.new("Frame")
    accent.Name = "Accent"
    accent.Size = UDim2.new(0, 4, 1, 0)
    accent.BackgroundColor3 = Color3.fromRGB(180, 0, 255)
    accent.BorderSizePixel = 0
    accent.Parent = notif
    
    local accentCorner = Instance.new("UICorner")
    accentCorner.CornerRadius = UDim.new(0, 4)
    accentCorner.Parent = accent
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(1, -20, 0, 20)
    titleLabel.Position = UDim2.new(0, 14, 0, 10)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 16
    titleLabel.Parent = notif
    
    local messageLabel = Instance.new("TextLabel")
    messageLabel.Name = "Message"
    messageLabel.Size = UDim2.new(1, -20, 0, 18)
    messageLabel.Position = UDim2.new(0, 14, 0, 32)
    messageLabel.BackgroundTransparency = 1
    messageLabel.Text = message
    messageLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    messageLabel.TextXAlignment = Enum.TextXAlignment.Left
    messageLabel.Font = Enum.Font.Gotham
    messageLabel.TextSize = 14
    messageLabel.Parent = notif
    
    local progressBg = Instance.new("Frame")
    progressBg.Name = "ProgressBg"
    progressBg.Size = UDim2.new(1, -20, 0, 3)
    progressBg.Position = UDim2.new(0, 10, 1, -8)
    progressBg.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    progressBg.BorderSizePixel = 0
    progressBg.Parent = notif
    
    local progressCorner = Instance.new("UICorner")
    progressCorner.CornerRadius = UDim.new(1, 0)
    progressCorner.Parent = progressBg
    
    local progress = Instance.new("Frame")
    progress.Name = "Progress"
    progress.Size = UDim2.new(1, 0, 1, 0)
    progress.BackgroundColor3 = Color3.fromRGB(180, 0, 255)
    progress.BorderSizePixel = 0
    progress.Parent = progressBg
    
    local progressCorner2 = Instance.new("UICorner")
    progressCorner2.CornerRadius = UDim.new(1, 0)
    progressCorner2.Parent = progress
    
    notif.Position = UDim2.new(1, 50, 0, 0)
    
    local fadeIn = TweenService:Create(notif, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Position = UDim2.new(1, -340, 0, 0),
        BackgroundTransparency = 0
    })
    
    local fadeOut = TweenService:Create(notif, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Position = UDim2.new(1, 50, 0, 0),
        BackgroundTransparency = 1
    })
    
    local progressTween = TweenService:Create(progress, TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 1, 0)
    })
    
    fadeIn:Play()
    progressTween:Play()
    
    task.delay(duration, function()
        if notif and notif.Parent then
            fadeOut:Play()
            task.wait(0.3)
            pcall(function() notif:Destroy() end)
        end
    end)
    
    return notif
end

-- =======================================================
-- LOGO LAUNCHER
-- =======================================================
local logoGui = Instance.new("ScreenGui")
logoGui.Name = "PinatHubLogo"
logoGui.ResetOnSpawn = false
logoGui.Parent = Player:WaitForChild("PlayerGui", 5)

local logoButton = Instance.new("ImageButton")
logoButton.Name = "LogoButton"
logoButton.Size = UDim2.new(0, 60, 0, 60)
logoButton.Position = UDim2.new(0.5, -30, 0.5, -30)
logoButton.BackgroundTransparency = 1
logoButton.Image = "rbxassetid://118264723961739"
logoButton.ImageColor3 = Color3.fromRGB(180, 0, 255)
logoButton.ScaleType = Enum.ScaleType.Fit
logoButton.Parent = logoGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(1, 0)
uiCorner.Parent = logoButton

-- Animasi kecil
local hoverTween = TweenService:Create(logoButton, TweenInfo.new(0.2), {Size = UDim2.new(0, 70, 0, 70)})
local unhoverTween = TweenService:Create(logoButton, TweenInfo.new(0.2), {Size = UDim2.new(0, 60, 0, 60)})

logoButton.MouseEnter:Connect(function()
    hoverTween:Play()
end)

logoButton.MouseLeave:Connect(function()
    unhoverTween:Play()
end)

-- Fitur drag
local dragging = false
local dragInput, dragStart, startPos

logoButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = logoButton.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

logoButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        logoButton.Position = newPos
    end
end)

-- =======================================================
-- LOAD WINDUI
-- =======================================================
local WindUI = (function()
    local success, result = pcall(function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua", true))()
    end)
    return success and result or nil
end)()

if not WindUI then 
    ShowNotification("Error", "Failed to load WindUI Library", 5)
    return 
end

-- =======================================================
-- CREATE CUSTOM WINDOW
-- =======================================================
local Window = WindUI:CreateWindow({
    Title = "PinatHub",
    Author = "pinathub",
    Folder = "PinatHub",
    NewElements = true,
    OpenButton = {
        Enabled = false
    },
    Topbar = { Height = 44, ButtonsType = "Default" }
})

Window:Tag({ Title = "@viunze on tiktok", Icon = "star", Color = Color3.fromHex("#BA00FF"), Border = true })

-- Fungsi untuk buka/tutup via logo
local guiVisible = true
logoButton.MouseButton1Click:Connect(function()
    guiVisible = not guiVisible
    if Window then
        pcall(function()
            if guiVisible then
                Window:Open()
            else
                Window:Minimize()
            end
        end)
    end
end)

-- =======================================================
-- CREATE TABS
-- =======================================================
local MainTab = Window:Tab({ Title = "Auto Parry", Icon = "sword" })
local LocalPlayerTab = Window:Tab({ Title = "Local Player", Icon = "user" })
local SettingsTab = Window:Tab({ Title = "Settings", Icon = "settings" })
local CommunityTab = Window:Tab({ Title = "Community", Icon = "users" })

-- =======================================================
-- MAIN TAB - AUTO PARRY
-- =======================================================

-- Master Control Section
local MasterSection = MainTab:Section({ Title = "Master Control" })

MasterSection:Toggle({
    Title = "Auto Parry",
    Desc = "Enable all 3 parry modes simultaneously",
    Value = true,
    Callback = function(value)
        Settings.MasterEnabled = value
        ShowNotification("Master Control", value and "Triple Execution ON" or "Triple Execution OFF", 2)
    end
})

MainTab:Space()

-- 3 Mode Toggles Section
local ModeSection = MainTab:Section({ Title = "3 Mode Execution" })

ModeSection:Toggle({
    Title = "🔴 AGGRESSIVE MODE",
    Desc = "5ms response | Parry at very close range | Emergency parry",
    Value = true,
    Callback = function(value)
        Settings.AggressiveEnabled = value
        ShowNotification("Aggressive Mode", value and "Enabled" or "Disabled", 2)
    end
})

ModeSection:Toggle({
    Title = "🔵 PRECISION MODE",
    Desc = "10ms + Ball position prediction | High accuracy",
    Value = true,
    Callback = function(value)
        Settings.PrecisionEnabled = value
        ShowNotification("Precision Mode", value and "Enabled" or "Disabled", 2)
    end
})

ModeSection:Toggle({
    Title = "🟢 REACTIVE MODE",
    Desc = "8ms + Time-based prediction | Fast and adaptive",
    Value = true,
    Callback = function(value)
        Settings.ReactiveEnabled = value
        ShowNotification("Reactive Mode", value and "Enabled" or "Disabled", 2)
    end
})

MainTab:Space()

-- Mode Explanations Section
local ExplanationGroup = MainTab:Group({ Title = "Mode Explanations" })

ExplanationGroup:Paragraph({
    Title = "🔴 AGGRESSIVE MODE",
    Desc = "Response: 5ms\nParry distance: Very close range (0.3 studs)\nBest for: Emergency situations, close-range balls"
})

ExplanationGroup:Space()

ExplanationGroup:Paragraph({
    Title = "🔵 PRECISION MODE",
    Desc = "Response: 10ms + prediction\nUses future position prediction\nBest for: Accurate parry, predicting ball trajectory"
})

ExplanationGroup:Space()

ExplanationGroup:Paragraph({
    Title = "🟢 REACTIVE MODE",
    Desc = "Response: 8ms + time-based\nReacts based on time to hit\nBest for: Fast balls, adaptive response"
})

MainTab:Space()

-- Important Note
local NoteGroup = MainTab:Group({ Title = "Important Note" })

NoteGroup:Paragraph({
    Title = "If auto parry is delayed or misses",
    Desc = "It's YOUR NETWORK issue!\nBlade Ball requires stable internet connection\nRecommended ping: below 100ms"
})

-- =======================================================
-- LOCAL PLAYER TAB
-- =======================================================

-- Speed Section
local SpeedSection = LocalPlayerTab:Section({ Title = "Speed" })

SpeedSection:Toggle({
    Title = "Speed",
    Desc = "Increase character walkspeed",
    Value = false,
    Callback = function(value)
        LocalSettings.SpeedEnabled = value
        local char = Player.Character
        if char and char:FindFirstChild("Humanoid") then
            local humanoid = char.Humanoid
            if value then
                LocalSettings.OriginalWalkspeed = humanoid.WalkSpeed
                humanoid.WalkSpeed = LocalSettings.WalkspeedValue
                ShowNotification("Speed", "Enabled - Speed: " .. LocalSettings.WalkspeedValue, 2)
            else
                humanoid.WalkSpeed = LocalSettings.OriginalWalkspeed or 16
                ShowNotification("Speed", "Disabled", 2)
            end
        end
    end
})

SpeedSection:Slider({
    Title = "Speed Value",
    Desc = "Set walkspeed (16-200)",
    IsTooltip = true,
    IsTextbox = true,
    Step = 1,
    Value = {
        Min = 16,
        Max = 200,
        Default = 50,
    },
    Callback = function(value)
        LocalSettings.WalkspeedValue = value
        if LocalSettings.SpeedEnabled then
            local char = Player.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid.WalkSpeed = value
            end
        end
    end,
})

LocalPlayerTab:Space()

-- Jump Section
local JumpSection = LocalPlayerTab:Section({ Title = "Jump" })

JumpSection:Toggle({
    Title = "Infinite Jump",
    Desc = "Enable unlimited jumps",
    Value = false,
    Callback = function(value)
        InfiniteJumpEnabled = value
        if value then
            ShowNotification("Infinite Jump", "Enabled", 2)
        else
            ShowNotification("Infinite Jump", "Disabled", 2)
        end
    end
})

-- =======================================================
-- INFINITE JUMP HANDLER (NEW)
-- =======================================================
game:GetService("UserInputService").JumpRequest:Connect(function()
    if InfiniteJumpEnabled then
        local char = game.Players.LocalPlayer.Character
        if char then
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end
end)

-- =======================================================
-- CHARACTER RESPAWN HANDLER
-- =======================================================
Player.CharacterAdded:Connect(function(character)
    task.wait(0.5)
    
    -- Handle speed
    if LocalSettings.SpeedEnabled then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            LocalSettings.OriginalWalkspeed = humanoid.WalkSpeed
            humanoid.WalkSpeed = LocalSettings.WalkspeedValue
        end
    end
end)

-- Initial setup untuk speed
if LocalSettings.SpeedEnabled then
    local char = Player.Character
    if char then
        local humanoid = char:FindFirstChild("Humanoid")
        if humanoid then
            LocalSettings.OriginalWalkspeed = humanoid.WalkSpeed
            humanoid.WalkSpeed = LocalSettings.WalkspeedValue
        end
    end
end

-- =======================================================
-- SETTINGS TAB
-- =======================================================

-- Visual Settings
local VisualSection = SettingsTab:Section({ Title = "Visual Settings" })

VisualSection:Toggle({
    Title = "No Visual Circle",
    Desc = "Disable visual circle for better performance",
    Value = false,
    Callback = function(value)
        Settings.NoVisualCircle = value
        if visualCircle then
            visualCircle.Visible = not Settings.NoVisualCircle
        end
        ShowNotification("Visual Settings", value and "Visual Circle OFF" or "Visual Circle ON", 2)
    end
})

SettingsTab:Space()

-- Delay Settings
local DelaySection = SettingsTab:Section({ Title = "Delay Settings (Response Time)" })

DelaySection:Slider({
    Title = "Aggressive Delay",
    Desc = "Response time for aggressive mode (ms)",
    IsTooltip = true,
    IsTextbox = true,
    Step = 1,
    Value = {
        Min = 3,
        Max = 20,
        Default = 5,
    },
    Callback = function(value)
        Settings.AggressiveDelay = value
    end,
})

DelaySection:Slider({
    Title = "Precision Delay",
    Desc = "Response time for precision mode (ms)",
    IsTooltip = true,
    IsTextbox = true,
    Step = 1,
    Value = {
        Min = 5,
        Max = 30,
        Default = 10,
    },
    Callback = function(value)
        Settings.PrecisionDelay = value
    end,
})

DelaySection:Slider({
    Title = "Reactive Delay",
    Desc = "Response time for reactive mode (ms)",
    IsTooltip = true,
    IsTextbox = true,
    Step = 1,
    Value = {
        Min = 4,
        Max = 25,
        Default = 8,
    },
    Callback = function(value)
        Settings.ReactiveDelay = value
    end,
})

SettingsTab:Space()

-- Distance Settings
local DistanceSection = SettingsTab:Section({ Title = "Distance Settings" })

DistanceSection:Slider({
    Title = "Emergency Radius",
    Desc = "Emergency parry distance (studs)",
    IsTooltip = true,
    IsTextbox = true,
    Step = 1,
    Value = {
        Min = 3,
        Max = 15,
        Default = 6,
    },
    Callback = function(value)
        Settings.EmergencyRadius = value
    end,
})

DistanceSection:Slider({
    Title = "Aggressive Clash Distance",
    Desc = "Clash distance for aggressive mode",
    IsTooltip = true,
    IsTextbox = true,
    Step = 1,
    Value = {
        Min = 10,
        Max = 25,
        Default = 16,
    },
    Callback = function(value)
        Settings.AggressiveClashDistance = value
    end,
})

DistanceSection:Slider({
    Title = "Precision Clash Distance",
    Desc = "Clash distance for precision mode",
    IsTooltip = true,
    IsTextbox = true,
    Step = 1,
    Value = {
        Min = 15,
        Max = 30,
        Default = 20,
    },
    Callback = function(value)
        Settings.PrecisionClashDistance = value
    end,
})

DistanceSection:Slider({
    Title = "Reactive Clash Distance",
    Desc = "Clash distance for reactive mode",
    IsTooltip = true,
    IsTextbox = true,
    Step = 1,
    Value = {
        Min = 18,
        Max = 35,
        Default = 24,
    },
    Callback = function(value)
        Settings.ReactiveClashDistance = value
    end,
})

SettingsTab:Space()

-- Reset Section
local ResetSection = SettingsTab:Section({ Title = "Reset Settings" })

ResetSection:Button({
    Title = "Reset to Default",
    Desc = "Reset all settings to default values",
    Callback = function()
        Settings.AggressiveDelay = 5
        Settings.PrecisionDelay = 10
        Settings.ReactiveDelay = 8
        Settings.EmergencyRadius = 6
        Settings.AggressiveClashDistance = 16
        Settings.PrecisionClashDistance = 20
        Settings.ReactiveClashDistance = 24
        Settings.NoVisualCircle = false
        
        ShowNotification("Settings", "All settings reset to default!", 2)
    end
})

-- =======================================================
-- COMMUNITY TAB
-- =======================================================
local WhatsAppSection = CommunityTab:Section({ Title = "WhatsApp Group" })

WhatsAppSection:Button({
    Title = "Join WhatsApp Group",
    Desc = "Click to copy WhatsApp group link",
    Callback = function()
        if setclipboard then
            setclipboard("https://chat.whatsapp.com/I8hG44FLgrRAwQcS3lvEft")
            ShowNotification("Success", "WhatsApp link copied to clipboard!", 3)
        else
            ShowNotification("Error", "Clipboard not supported!", 2)
        end
    end
})

CommunityTab:Space()

local DiscordSection = CommunityTab:Section({ Title = "Discord Server" })

DiscordSection:Button({
    Title = "Join Discord Server",
    Desc = "Click to copy Discord server link",
    Callback = function()
        if setclipboard then
            setclipboard("https://discord.gg/eDbaHKEf7G")
            ShowNotification("Success", "Discord link copied to clipboard!", 3)
        else
            ShowNotification("Error", "Clipboard not supported!", 2)
        end
    end
})

CommunityTab:Space()

-- Credits Section
local CreditSection = CommunityTab:Section({ Title = "Credits" })

CreditSection:Paragraph({
    Title = "PinatHub",
    Desc = "Blade Ball Auto Parry Script\nVersion 3.0\nCreated by @viunze"
})

-- =======================================================
-- CORE LOGIC (AELOE TRIPLE EXECUTION)
-- =======================================================
local lastAggressiveClick = 0
local lastPrecisionClick = 0
local lastReactiveClick = 0
local lastBallHit = nil
local BallsFolder = workspace:FindFirstChild("Balls") or workspace:WaitForChild("Balls", 3)

-- Visual circle
local visualCircle = nil
local visualMesh = nil

local function setupVisualCircle()
    if visualCircle then visualCircle:Destroy() end
    if Settings.NoVisualCircle then return end
    
    visualCircle = Instance.new("Part")
    visualCircle.Name = "PinatHubCircle"
    visualCircle.Parent = workspace
    visualCircle.Anchored = true
    visualCircle.CanCollide = false
    visualCircle.Transparency = 0.2
    visualCircle.Material = Enum.Material.Neon
    visualMesh = Instance.new("SpecialMesh")
    visualMesh.MeshId = "rbxassetid://3270017"
    visualMesh.Parent = visualCircle
end

setupVisualCircle()

-- Fast ball detection
local cachedBall = nil
local lastBallCheck = 0

local function getBall()
    if not BallsFolder then return nil end
    
    local now = tick()
    if now - lastBallCheck < 0.033 then
        return cachedBall
    end
    lastBallCheck = now
    
    local children = BallsFolder:GetChildren()
    for i = 1, #children do
        local v = children[i]
        if v:GetAttribute("realBall") == true then
            cachedBall = v
            return v
        end
    end
    
    local fastestBall = nil
    local highestVel = 0
    for i = 1, #children do
        local v = children[i]
        if v:IsA("BasePart") then
            local vel = v.AssemblyLinearVelocity.Magnitude
            if vel > highestVel and vel > 10 then
                highestVel = vel
                fastestBall = v
            end
        end
    end
    
    cachedBall = fastestBall
    return fastestBall
end

local function isTargeted()
    local char = Player.Character
    if not char then return false end
    if char:GetAttribute("Targeted") == true then return true end
    if char:FindFirstChild("Highlight") ~= nil then return true end
    return false
end

local function sendClick()
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
end

-- Main loop
local hue = 0
RunService.Heartbeat:Connect(function()
    if not Settings.MasterEnabled then
        if visualCircle then 
            pcall(function() visualCircle.Transparency = 1 end)
        end
        return
    end
    
    local char = Player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local ball = getBall()
    
    if not (root and ball) then
        if visualCircle then 
            pcall(function() visualCircle.Transparency = 1 end)
        end
        return
    end
    
    local ballPos = ball.Position
    local playerPos = root.Position
    local velocity = ball.AssemblyLinearVelocity
    local speed = velocity.Magnitude
    local distance = (playerPos - ballPos).Magnitude
    local targeted = isTargeted()
    local now = tick()
    
    local futurePos = ballPos + (velocity * Settings.PrecisionPrediction)
    local precisionDistance = (playerPos - futurePos).Magnitude
    local timeToHit = distance / math.max(speed, 0.1)
    
    -- Visual update
    if visualCircle and not Settings.NoVisualCircle then
        pcall(function()
            visualCircle.CFrame = root.CFrame * CFrame.new(0, -2.8, 0) * CFrame.Angles(math.rad(90), 0, 0)
            local size = math.clamp(distance * 0.55, 4, 50)
            if visualMesh then
                visualMesh.Scale = visualMesh.Scale:Lerp(Vector3.new(size, size, 0.3), 0.5)
            end
            
            hue = (hue + 0.02) % 1
            if targeted then
                if distance < 15 then
                    visualCircle.Color = Color3.fromRGB(255, 50, 50)
                    visualCircle.Transparency = 0.05
                elseif distance < 25 then
                    visualCircle.Color = Color3.fromRGB(255, 200, 50)
                    visualCircle.Transparency = 0.1
                else
                    visualCircle.Color = Color3.fromHSV(hue, 1, 1)
                    visualCircle.Transparency = 0.2
                end
            else
                visualCircle.Color = Color3.fromRGB(100, 200, 255)
                visualCircle.Transparency = 0.4
            end
        end)
    end
    
    local lastClickAny = math.max(lastAggressiveClick, lastPrecisionClick, lastReactiveClick)
    local isSpamming = (now - lastClickAny) < Settings.AntiSpamWindow
    
    -- Convert ms to seconds for delay
    local aggressiveDelaySec = Settings.AggressiveDelay / 1000
    local precisionDelaySec = Settings.PrecisionDelay / 1000
    local reactiveDelaySec = Settings.ReactiveDelay / 1000
    
    -- Aggressive Mode
    if Settings.AggressiveEnabled and targeted and not isSpamming then
        local shouldParry = distance <= Settings.AggressiveClashDistance 
            or distance <= Settings.EmergencyRadius 
            or distance <= Settings.AggressiveDistance
        
        if shouldParry and (now - lastAggressiveClick) >= aggressiveDelaySec then
            lastAggressiveClick = now
            sendClick()
        end
    end
    
    -- Precision Mode
    if Settings.PrecisionEnabled and targeted and not isSpamming then
        local shouldParry = distance <= Settings.PrecisionClashDistance 
            or precisionDistance <= 2.5 
            or (speed > 0 and timeToHit <= 0.1)
        
        if shouldParry and (now - lastPrecisionClick) >= precisionDelaySec and lastBallHit ~= ball then
            lastPrecisionClick = now
            lastBallHit = ball
            sendClick()
        end
    end
    
    -- Reactive Mode
    if Settings.ReactiveEnabled and targeted and not isSpamming then
        local boost = (speed > 150) and Settings.ReactiveSpeedBoost or 1
        local shouldParry = distance <= Settings.ReactiveClashDistance 
            or timeToHit <= (Settings.ReactiveTimeWindow * boost)
            or distance <= Settings.EmergencyRadius + 2
        
        if shouldParry and (now - lastReactiveClick) >= reactiveDelaySec then
            lastReactiveClick = now
            sendClick()
        end
    end
end)

-- Reset on character respawn
Player.CharacterAdded:Connect(function()
    lastBallHit = nil
    lastAggressiveClick = 0
    lastPrecisionClick = 0
    lastReactiveClick = 0
    task.wait(1)
    setupVisualCircle()
end)

-- =======================================================
-- INITIAL NOTIFICATION
-- =======================================================
task.wait(1)
ShowNotification("PinatHub", 
    "Loaded", 5)

-- =======================================================
-- PRINT STATUS
-- =======================================================
print("PinatHub Loaded")
