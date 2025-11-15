repeat
    task.wait()
until game:IsLoaded()

local scriptBaseUrl = "https://api.luarmor.net/files/v3/loaders/"

local games = {
    ADS = {
        gameID = 2655311011,
        scriptId = "0885acfb60c80ac6e04770c09539ad42",
    },
    aNIMElEGACY = {
        gameID = 4844706238,
        scriptId = "f9d578c5fa3ab0eae7a4796dc656a730",
    },
    PunshWallSimulator = {
        gameID = 4498728505,
        scriptId = "",
    },
    ACS = {
        gameID = 4280746206,
        scriptId = "f9d578c5fa3ab0eae7a4796dc656a730",
    },
    WFS = {
        gameID = 3262314006,
        scriptId = "0885acfb60c80ac6e04770c09539ad42",
    },
    AnimeEternal = {
        gameID = 7882829745,
        scriptId = "f9d578c5fa3ab0eae7a4796dc656a730",
    },
    RebirthChampionsUltimate = {
        gameID = 7178032757,
        scriptId = "0885acfb60c80ac6e04770c09539ad42",
    },
    AnimeCrusaders = {
        gameID = 7660436108,
        scriptId = "f9d578c5fa3ab0eae7a4796dc656a730",
    },
    WeakLegacy2 = {
        gameID = 18337464872,
        scriptId = "f9d578c5fa3ab0eae7a4796dc656a730",
    },
    AnimeLastStand = {
        gameID = 4509896324,
        scriptId = "0885acfb60c80ac6e04770c09539ad42",
    },
}



local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local playerDisplayName = LocalPlayer.DisplayName
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local keyAcquireUrl = "https://ads.luarmor.net/get_key?for=The_Intruders-qlBBzVWKOUcV"

local RayfieldLibrary = loadstring(game:HttpGet(
    'https://raw.githubusercontent.com/tozxart/The-Intruders/main/Notify.lua'))()

local UDim2 = UDim2
local Enum = Enum
local TweenInfo = TweenInfo
local getgenv = getgenv
local writefile = writefile
local readfile = readfile
local isfile = isfile
local setclipboard = setclipboard
local syn = syn
local gethui = gethui
local get_hidden_gui = get_hidden_gui
local is_sirhurt_closure = is_sirhurt_closure

local function getScriptIdForCurrentGame()
    local currentPlaceId = game.PlaceId
    local currentUniverseId = game.GameId
    for name, data in pairs(games) do
        if data.gameID == currentPlaceId or data.gameID == currentUniverseId or data.placeId == currentPlaceId or data.universeId == currentUniverseId then
            return data.scriptId, name
        end
    end
    return nil, nil
end

local function checkScriptKey()
    if getgenv and getgenv() then
        return getgenv().script_key or script_key
    end
    return script_key
end

local function loadLuarmorLibrary()
    local success, api = pcall(function()
        return loadstring(game:HttpGet("https://sdkapi-public.luarmor.net/library.lua"))()
    end)
    if success and type(api) == "table" then
        return api
    end
    warn("Failed to load Luarmor library: " .. tostring(api))
    return nil
end

local function validateLuarmorKey(key, api)
    if not api or not key or key == "" then
        return false, "Invalid key or API not loaded", nil
    end
    local status = api.check_key(key)
    if not status then
        return false, "Failed to check key", nil
    end
    local isValid = status.code == "KEY_VALID"
    return isValid, status.message or "Unknown error", status
end

local function ParentObject(Gui)
    local success, failure = pcall(function()
        if get_hidden_gui or gethui then
            local hiddenUI = get_hidden_gui or gethui
            Gui.Parent = hiddenUI()
        elseif (not is_sirhurt_closure) and (syn and syn.protect_gui) then
            syn.protect_gui(Gui)
            Gui.Parent = CoreGui
        elseif CoreGui then
            Gui.Parent = CoreGui
        end
    end)
    if not success and failure then
        Gui.Parent = LocalPlayer:FindFirstChildWhichIsA("PlayerGui")
    end
end

local function AddDraggingFunctionality(DragPoint, Main)
    pcall(function()
        local Dragging, DragInput, MousePos, FramePos = false, false, false, false
        DragPoint.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                Dragging = true
                MousePos = Input.Position
                FramePos = Main.Position
                Input.Changed:Connect(function()
                    if Input.UserInputState == Enum.UserInputState.End then
                        Dragging = false
                    end
                end)
            end
        end)
        DragPoint.InputChanged:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseMovement then
                DragInput = Input
            end
        end)
        UserInputService.InputChanged:Connect(function(Input)
            if Input == DragInput and Dragging then
                local Delta = Input.Position - MousePos
                TweenService:Create(
                    Main,
                    TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                    {
                        Position = UDim2.new(FramePos.X.Scale, FramePos.X.Offset + Delta.X, FramePos.Y.Scale,
                            FramePos.Y.Offset + Delta.Y)
                    }
                ):Play()
            end
        end)
    end)
end

local function FadeOutGuiTree(Main, duration)
    local fadeDuration = duration or 0.45
    local info = TweenInfo.new(fadeDuration, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    local function safeTween(obj, props)
        pcall(function()
            TweenService:Create(obj, info, props):Play()
        end)
    end
    for _, obj in ipairs(Main:GetDescendants()) do
        if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
            safeTween(obj, { TextTransparency = 1 })
        end
        if obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
            safeTween(obj, { ImageTransparency = 1 })
        end
        if obj:IsA("Frame") or obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") or obj:IsA("ImageLabel") or obj:IsA("ImageButton") or obj:IsA("ScrollingFrame") then
            safeTween(obj, { BackgroundTransparency = 1 })
        end
    end
    safeTween(Main, { BackgroundTransparency = 1 })
    task.wait(fadeDuration + 0.05)
end

local playerId = LocalPlayer.UserId
local keyFileName = tostring(playerId) .. "Mykey.txt"

local WARNING_COOLDOWN_SECONDS = 24 * 60 * 60
local warningCooldownFileName = tostring(playerId) .. "_UNCWarningCooldown.txt"

local function getUnixTimestamp()
    local success, result = pcall(function()
        return DateTime.now().UnixTimestamp
    end)
    if success and type(result) == "number" then
        return result
    end

    local altSuccess, altResult = pcall(os.time)
    if altSuccess and type(altResult) == "number" then
        return altResult
    end

    return 0
end

local function loadWarningCooldown()
    if isfile(warningCooldownFileName) then
        local contents = readfile(warningCooldownFileName)
        local timestamp = tonumber(contents)
        if timestamp then
            return timestamp
        end
    end
    return nil
end

local function saveWarningCooldown(timestamp)
    local value = timestamp or getUnixTimestamp()
    writefile(warningCooldownFileName, tostring(value))
end

local function isWarningCooldownActive()
    local lastDismiss = loadWarningCooldown()
    if not lastDismiss then
        return false
    end
    local now = getUnixTimestamp()
    return (now - lastDismiss) < WARNING_COOLDOWN_SECONDS
end

local function saveKey(key)
    writefile(keyFileName, key)
end

local function loadSavedKey()
    if isfile(keyFileName) then
        return readfile(keyFileName)
    else
        writefile(keyFileName, "")
        return ""
    end
end

local SELECTED_SCRIPT_ID = nil

local function executeProtectedScript(api, scriptId)
    local idToUse = scriptId or (api and api.script_id) or SELECTED_SCRIPT_ID
    if not idToUse or idToUse == "" then
        RayfieldLibrary:Notify({ Title = "Unsupported Game", Content = "No script configured for this game.", Duration = 7 })
        return
    end

    -- Ensure script_key is set before loading script (required by Luarmor)
    local currentKey = checkScriptKey()
    if not currentKey or currentKey == "" then
        RayfieldLibrary:Notify({ Title = "Error!", Content = "Script key not set. Please enter a valid key.", Duration = 7 })
        return
    end

    local ok, err = pcall(function()
        api.load_script()
    end)
    if not ok then
        warn("api.load_script failed, falling back to direct loader: " .. tostring(err))
        local loaderUrl = scriptBaseUrl .. idToUse .. ".lua"
        local success, loaded = pcall(function()
            return loadstring(game:HttpGet(loaderUrl))
        end)
        if success and loaded then
            loaded()
        else
            warn("Failed to load and execute loader for script_id: " .. tostring(idToUse))
        end
    end
end

local function runUNCTest()
    local passes, fails = 0, 0
    local running = 0

    local function getGlobal(path)
        local value = getfenv(0)
        while value ~= nil and path ~= "" do
            local name, nextValue = string.match(path, "^([^.]+)%.?(.*)$")
            value = value[name]
            path = nextValue
        end
        return value
    end

    local function test(name, callback)
        running = running + 1
        task.spawn(function()
            if not callback then
                -- Skip test
            elseif not getGlobal(name) then
                fails = fails + 1
            else
                local success = pcall(callback)
                if success then
                    passes = passes + 1
                else
                    fails = fails + 1
                end
            end
            running = running - 1
        end)
    end

    -- Quick UNC tests (safe tests only)
    test("cloneref", function()
        local part = Instance.new("Part")
        local clone = cloneref(part)
        assert(part ~= clone)
    end)

    test("checkcaller", function()
        assert(checkcaller())
    end)

    test("iscclosure", function()
        assert(iscclosure(print) == true)
    end)

    test("newcclosure", function()
        local function testFunc() return true end
        local testC = newcclosure(testFunc)
        assert(iscclosure(testC))
    end)

    test("getrawmetatable", function()
        local metatable = { __metatable = "Locked!" }
        local object = setmetatable({}, metatable)
        assert(getrawmetatable(object) == metatable)
    end)

    test("setreadonly", function()
        local tbl = {}
        table.freeze(tbl)
        setreadonly(tbl, false)
        tbl.test = true
        assert(tbl.test == true)
    end)

    test("getgenv", function()
        getgenv().__UNC_TEST = true
        assert(__UNC_TEST == true)
        getgenv().__UNC_TEST = nil
    end)

    test("readfile", function()
        assert(type(readfile) == "function")
    end)

    test("writefile", function()
        assert(type(writefile) == "function")
    end)

    test("request", function()
        assert(type(request) == "function" or type(http_request) == "function")
    end)

    -- Wait for all tests to complete (max 2 seconds)
    local timeout = 0
    repeat
        task.wait(0.1)
        timeout = timeout + 0.1
    until running == 0 or timeout > 2

    local rate = 0
    if (passes + fails) > 0 then
        rate = math.round(passes / (passes + fails) * 100)
    end

    -- FOR TESTING
    -- return 80
    return rate
end

local spawnKeyUIInstance

local function createUNCWarningUI(uncScore, onContinue, options)
    options = options or {}
    local onManualDismiss = options.onManualDismiss
    local WarningGui = Instance.new("ScreenGui")
    WarningGui.Name = "UNCWarningGui"
    WarningGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    WarningGui.ResetOnSpawn = false
    WarningGui.IgnoreGuiInset = true
    WarningGui.DisplayOrder = options.displayOrder or 220

    -- Blur background
    local BlurEffect = Instance.new("Frame")
    BlurEffect.Name = "BlurBackground"
    BlurEffect.Size = UDim2.new(1, 0, 1, 0)
    BlurEffect.Position = UDim2.new(0, 0, 0, 0)
    BlurEffect.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    BlurEffect.BackgroundTransparency = options.dimBackground == false and 1 or 0.55
    BlurEffect.BorderSizePixel = 0
    BlurEffect.Active = false
    BlurEffect.Parent = WarningGui

    -- Main container
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    MainFrame.Position = options.position or UDim2.new(0.23, 0, 0.5, 0)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    MainFrame.BorderSizePixel = 0
    MainFrame.ZIndex = 10
    MainFrame.Parent = BlurEffect

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 16)
    MainCorner.Parent = MainFrame

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Color3.fromRGB(255, 100, 100)
    MainStroke.Thickness = 2
    MainStroke.Transparency = 0
    MainStroke.Parent = MainFrame

    -- Gradient effect
    local Gradient = Instance.new("UIGradient")
    Gradient.Color = ColorSequence.new {
        ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 40)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 30))
    }
    Gradient.Rotation = 45
    Gradient.Parent = MainFrame

    -- Warning Icon
    local IconFrame = Instance.new("Frame")
    IconFrame.Name = "IconFrame"
    IconFrame.Size = UDim2.new(0, 80, 0, 80)
    IconFrame.Position = UDim2.new(0.5, 0, 0, 30)
    IconFrame.AnchorPoint = Vector2.new(0.5, 0)
    IconFrame.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
    IconFrame.BorderSizePixel = 0
    IconFrame.Parent = MainFrame

    local IconCorner = Instance.new("UICorner")
    IconCorner.CornerRadius = UDim.new(1, 0)
    IconCorner.Parent = IconFrame

    local WarningIcon = Instance.new("TextLabel")
    WarningIcon.Size = UDim2.new(1, 0, 1, 0)
    WarningIcon.BackgroundTransparency = 1
    WarningIcon.Text = "⚠️"
    WarningIcon.TextSize = 42
    WarningIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
    WarningIcon.Font = Enum.Font.GothamBold
    WarningIcon.Parent = IconFrame

    -- Title
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, -40, 0, 40)
    Title.Position = UDim2.new(0, 20, 0, 130)
    Title.BackgroundTransparency = 1
    Title.Text = "EXECUTOR WARNING"
    Title.TextSize = 24
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Center
    Title.Parent = MainFrame

    -- UNC Score Display
    local ScoreFrame = Instance.new("Frame")
    ScoreFrame.Name = "ScoreFrame"
    ScoreFrame.Size = UDim2.new(0, 200, 0, 60)
    ScoreFrame.Position = UDim2.new(0.5, 0, 0, 180)
    ScoreFrame.AnchorPoint = Vector2.new(0.5, 0)
    ScoreFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    ScoreFrame.BorderSizePixel = 0
    ScoreFrame.Parent = MainFrame

    local ScoreCorner = Instance.new("UICorner")
    ScoreCorner.CornerRadius = UDim.new(0, 12)
    ScoreCorner.Parent = ScoreFrame

    local ScoreLabel = Instance.new("TextLabel")
    ScoreLabel.Size = UDim2.new(1, 0, 0, 30)
    ScoreLabel.Position = UDim2.new(0, 0, 0, 5)
    ScoreLabel.BackgroundTransparency = 1
    ScoreLabel.Text = "UNC SCORE"
    ScoreLabel.TextSize = 14
    ScoreLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    ScoreLabel.Font = Enum.Font.GothamMedium
    ScoreLabel.Parent = ScoreFrame

    local ScoreValue = Instance.new("TextLabel")
    ScoreValue.Size = UDim2.new(1, 0, 0, 30)
    ScoreValue.Position = UDim2.new(0, 0, 0, 25)
    ScoreValue.BackgroundTransparency = 1
    ScoreValue.Text = uncScore .. "%"
    ScoreValue.TextSize = 28
    ScoreValue.TextColor3 = Color3.fromRGB(255, 100, 100)
    ScoreValue.Font = Enum.Font.GothamBold
    ScoreValue.Parent = ScoreFrame

    -- Description
    local Description = Instance.new("TextLabel")
    Description.Name = "Description"
    Description.Size = UDim2.new(1, -60, 0, 80)
    Description.Position = UDim2.new(0, 30, 0, 260)
    Description.BackgroundTransparency = 1
    Description.Text =
    "Your executor compatibility is below the recommended 97%.\n\nScript features may not work properly. Please consider upgrading to a better executor with 100% UNC compatibility."
    Description.TextSize = 14
    Description.TextColor3 = Color3.fromRGB(200, 200, 200)
    Description.Font = Enum.Font.Gotham
    Description.TextWrapped = true
    Description.TextXAlignment = Enum.TextXAlignment.Center
    Description.TextYAlignment = Enum.TextYAlignment.Top
    Description.Parent = MainFrame

    -- Info box
    local InfoBox = Instance.new("Frame")
    InfoBox.Name = "InfoBox"
    InfoBox.Size = UDim2.new(1, -60, 0, 60)
    InfoBox.Position = UDim2.new(0, 30, 0, 360)
    InfoBox.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    InfoBox.BorderSizePixel = 0
    InfoBox.Parent = MainFrame

    local InfoCorner = Instance.new("UICorner")
    InfoCorner.CornerRadius = UDim.new(0, 10)
    InfoCorner.Parent = InfoBox

    local InfoText = Instance.new("TextLabel")
    InfoText.Size = UDim2.new(1, -20, 1, 0)
    InfoText.Position = UDim2.new(0, 10, 0, 0)
    InfoText.BackgroundTransparency = 1
    InfoText.Text = "💡 Get free executors with 100% UNC at weao.xyz"
    InfoText.TextSize = 13
    InfoText.TextColor3 = Color3.fromRGB(150, 200, 255)
    InfoText.Font = Enum.Font.GothamMedium
    InfoText.TextWrapped = true
    InfoText.TextXAlignment = Enum.TextXAlignment.Left
    InfoText.Parent = InfoBox

    -- Buttons Container
    local ButtonsFrame = Instance.new("Frame")
    ButtonsFrame.Name = "ButtonsFrame"
    ButtonsFrame.Size = UDim2.new(1, -60, 0, 50)
    ButtonsFrame.Position = UDim2.new(0, 30, 0, 440)
    ButtonsFrame.BackgroundTransparency = 1
    ButtonsFrame.Parent = MainFrame

    -- Timer Display (Floating, Top-Left Corner with Icon)
    local TimerFrame = Instance.new("Frame")
    TimerFrame.Name = "TimerFrame"
    TimerFrame.AnchorPoint = Vector2.new(0, 0)
    TimerFrame.Size = UDim2.new(0, 220, 0, 45)
    TimerFrame.Position = UDim2.new(0, 32, 0, 32)
    TimerFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 40)
    TimerFrame.BackgroundTransparency = 0.05
    TimerFrame.BorderSizePixel = 0
    TimerFrame.ZIndex = 500
    TimerFrame.Parent = WarningGui

    local TimerCorner = Instance.new("UICorner")
    TimerCorner.CornerRadius = UDim.new(0, 10)
    TimerCorner.Parent = TimerFrame

    local TimerStroke = Instance.new("UIStroke")
    TimerStroke.Color = Color3.fromRGB(120, 160, 255)
    TimerStroke.Thickness = 1
    TimerStroke.Transparency = 0.45
    TimerStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    TimerStroke.Parent = TimerFrame

    -- Timer Icon (Circular Clock Design)
    local TimerIconFrame = Instance.new("Frame")
    TimerIconFrame.Name = "TimerIconFrame"
    TimerIconFrame.Size = UDim2.new(0, 28, 0, 28)
    TimerIconFrame.Position = UDim2.new(0, 10, 0.5, -14)
    TimerIconFrame.BackgroundColor3 = Color3.fromRGB(120, 160, 255)
    TimerIconFrame.BackgroundTransparency = 0.2
    TimerIconFrame.BorderSizePixel = 0
    TimerIconFrame.ZIndex = 501
    TimerIconFrame.Parent = TimerFrame

    local IconCircle = Instance.new("UICorner")
    IconCircle.CornerRadius = UDim.new(1, 0)
    IconCircle.Parent = TimerIconFrame

    local IconStroke = Instance.new("UIStroke")
    IconStroke.Color = Color3.fromRGB(200, 220, 255)
    IconStroke.Thickness = 2
    IconStroke.Transparency = 0
    IconStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    IconStroke.Parent = TimerIconFrame

    -- Clock hands
    local ClockHand1 = Instance.new("Frame")
    ClockHand1.Name = "ClockHand1"
    ClockHand1.Size = UDim2.new(0, 2, 0, 8)
    ClockHand1.Position = UDim2.new(0.5, -1, 0.5, -8)
    ClockHand1.BackgroundColor3 = Color3.fromRGB(200, 220, 255)
    ClockHand1.BorderSizePixel = 0
    ClockHand1.ZIndex = 502
    ClockHand1.Parent = TimerIconFrame

    local ClockHand2 = Instance.new("Frame")
    ClockHand2.Name = "ClockHand2"
    ClockHand2.Size = UDim2.new(0, 2, 0, 6)
    ClockHand2.Position = UDim2.new(0.5, -1, 0.5, 0)
    ClockHand2.BackgroundColor3 = Color3.fromRGB(200, 220, 255)
    ClockHand2.BorderSizePixel = 0
    ClockHand2.ZIndex = 502
    ClockHand2.Parent = TimerIconFrame

    local TimerLabel = Instance.new("TextLabel")
    TimerLabel.Name = "TimerLabel"
    TimerLabel.Size = UDim2.new(1, -50, 1, 0)
    TimerLabel.Position = UDim2.new(0, 45, 0, 0)
    TimerLabel.BackgroundTransparency = 1
    TimerLabel.Text = "Auto closing in 30s"
    TimerLabel.TextSize = 14
    TimerLabel.TextColor3 = Color3.fromRGB(200, 220, 255)
    TimerLabel.Font = Enum.Font.GothamBold
    TimerLabel.TextXAlignment = Enum.TextXAlignment.Left
    TimerLabel.TextYAlignment = Enum.TextYAlignment.Center
    TimerLabel.ZIndex = 501
    TimerLabel.Parent = TimerFrame

    -- Copy Link Button
    local CopyButton = Instance.new("TextButton")
    CopyButton.Name = "CopyButton"
    CopyButton.Size = UDim2.new(0.48, 0, 1, 0)
    CopyButton.Position = UDim2.new(0, 0, 0, 0)
    CopyButton.BackgroundColor3 = Color3.fromRGB(80, 120, 255)
    CopyButton.BorderSizePixel = 0
    CopyButton.Text = "📋 Copy Link"
    CopyButton.TextSize = 16
    CopyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CopyButton.Font = Enum.Font.GothamBold
    CopyButton.AutoButtonColor = false
    CopyButton.Parent = ButtonsFrame

    local CopyCorner = Instance.new("UICorner")
    CopyCorner.CornerRadius = UDim.new(0, 10)
    CopyCorner.Parent = CopyButton

    -- Continue Button
    local ContinueButton = Instance.new("TextButton")
    ContinueButton.Name = "ContinueButton"
    ContinueButton.Size = UDim2.new(0.48, 0, 1, 0)
    ContinueButton.Position = UDim2.new(0.52, 0, 0, 0)
    ContinueButton.BackgroundColor3 = Color3.fromRGB(100, 100, 110)
    ContinueButton.BorderSizePixel = 0
    ContinueButton.Text = "Continue Anyway"
    ContinueButton.TextSize = 16
    ContinueButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ContinueButton.Font = Enum.Font.GothamBold
    ContinueButton.AutoButtonColor = false
    ContinueButton.Parent = ButtonsFrame

    local ContinueCorner = Instance.new("UICorner")
    ContinueCorner.CornerRadius = UDim.new(0, 10)
    ContinueCorner.Parent = ContinueButton

    -- Button hover effects
    CopyButton.MouseEnter:Connect(function()
        TweenService:Create(CopyButton, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(100, 140, 255) }):Play()
    end)
    CopyButton.MouseLeave:Connect(function()
        TweenService:Create(CopyButton, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(80, 120, 255) }):Play()
    end)

    ContinueButton.MouseEnter:Connect(function()
        TweenService:Create(ContinueButton, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(120, 120, 130) })
            :Play()
    end)
    ContinueButton.MouseLeave:Connect(function()
        TweenService:Create(ContinueButton, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(100, 100, 110) })
            :Play()
    end)

    -- Button actions
    local dismissed = false

    CopyButton.Activated:Connect(function()
        setclipboard("https://weao.xyz/")
        CopyButton.Text = "✅ Link Copied!"
        task.wait(2)
        if not dismissed then
            CopyButton.Text = "📋 Copy Link"
        end
    end)

    local function dismissWarning(shouldRecord)
        if dismissed then return end
        dismissed = true
        if shouldRecord and onManualDismiss then
            pcall(onManualDismiss)
        end
        pcall(function()
            TweenService:Create(TimerFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                { BackgroundTransparency = 1 }):Play()
            TweenService:Create(TimerLabel, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                { TextTransparency = 1 }):Play()
            TweenService:Create(TimerIconFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                { BackgroundTransparency = 1 }):Play()
            TweenService:Create(IconStroke, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                { Transparency = 1 }):Play()
            TweenService:Create(ClockHand1, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                { BackgroundTransparency = 1 }):Play()
            TweenService:Create(ClockHand2, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                { BackgroundTransparency = 1 }):Play()
            TweenService:Create(TimerStroke, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                { Transparency = 1 }):Play()
        end)
        FadeOutGuiTree(MainFrame, 0.3)
        task.wait(0.35)
        pcall(function()
            TimerFrame:Destroy()
        end)
        WarningGui:Destroy()
        if onContinue then
            onContinue()
        end
    end

    ContinueButton.Activated:Connect(function()
        dismissWarning(true)
    end)

    -- Auto-dismiss timer (30 seconds)
    task.spawn(function()
        local remaining = 30
        while remaining >= 0 do
            if dismissed then break end

            TimerLabel.Text = "Auto closing in " .. remaining .. "s"

            if remaining <= 10 then
                TimerLabel.TextColor3 = Color3.fromRGB(255, 120, 120)
                TimerIconFrame.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
                IconStroke.Color = Color3.fromRGB(255, 120, 120)
                ClockHand1.BackgroundColor3 = Color3.fromRGB(255, 120, 120)
                ClockHand2.BackgroundColor3 = Color3.fromRGB(255, 120, 120)
                TimerStroke.Color = Color3.fromRGB(255, 100, 100)
                TimerFrame.BackgroundColor3 = Color3.fromRGB(40, 28, 32)
            elseif remaining <= 20 then
                TimerLabel.TextColor3 = Color3.fromRGB(255, 200, 120)
                TimerIconFrame.BackgroundColor3 = Color3.fromRGB(255, 170, 110)
                IconStroke.Color = Color3.fromRGB(255, 200, 120)
                ClockHand1.BackgroundColor3 = Color3.fromRGB(255, 200, 120)
                ClockHand2.BackgroundColor3 = Color3.fromRGB(255, 200, 120)
                TimerStroke.Color = Color3.fromRGB(255, 170, 110)
                TimerFrame.BackgroundColor3 = Color3.fromRGB(36, 30, 38)
            else
                TimerLabel.TextColor3 = Color3.fromRGB(200, 220, 255)
                TimerIconFrame.BackgroundColor3 = Color3.fromRGB(120, 160, 255)
                IconStroke.Color = Color3.fromRGB(200, 220, 255)
                ClockHand1.BackgroundColor3 = Color3.fromRGB(200, 220, 255)
                ClockHand2.BackgroundColor3 = Color3.fromRGB(200, 220, 255)
                TimerStroke.Color = Color3.fromRGB(120, 160, 255)
                TimerFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 40)
            end

            task.wait(1)
            remaining = remaining - 1
        end

        if not dismissed then
            dismissWarning(false)
        end
    end)

    -- Parent and animate
    ParentObject(WarningGui)
    AddDraggingFunctionality(MainFrame, MainFrame)

    -- Animate entrance
    TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        { Size = UDim2.new(0, 500, 0, 520) }):Play()

    -- Pulse animation for warning icon
    task.spawn(function()
        while WarningGui.Parent do
            TweenService:Create(IconFrame, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
                { BackgroundColor3 = Color3.fromRGB(255, 120, 120) }):Play()
            task.wait(1)
            TweenService:Create(IconFrame, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
                { BackgroundColor3 = Color3.fromRGB(255, 100, 100) }):Play()
            task.wait(1)
        end
    end)

    return WarningGui
end

local function showKeyInputUI(luarmorApi)
    -- Run UNC test before showing UI (wrapped in pcall for safety)
    local uncScore = 100 -- Default to 100% if test fails
    pcall(function()
        uncScore = runUNCTest()
    end)

    local keyUI = spawnKeyUIInstance and spawnKeyUIInstance(luarmorApi)
    local cooldownActive = isWarningCooldownActive()
    if keyUI then
        pcall(function()
            keyUI.DisplayOrder = 210
            if keyUI.Main then
                keyUI.Main.Visible = true
            end
        end)
    end

    -- Show warning UI if UNC score is below 97%
    if uncScore < 97 then
        if cooldownActive then
            return
        end
        createUNCWarningUI(uncScore, function()
            if keyUI and keyUI.Parent and keyUI.Main then
                TweenService:Create(keyUI.Main, TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                    { BackgroundTransparency = 0 }):Play()
            elseif not keyUI or not keyUI.Parent then
                keyUI = spawnKeyUIInstance and spawnKeyUIInstance(luarmorApi)
            end
        end, {
            keyUI = keyUI,
            dimBackground = false,
            displayOrder = 220,
            position = UDim2.new(0.23, 0, 0.5, 0),
            onManualDismiss = function()
                saveWarningCooldown()
            end,
        })
        return
    end

    -- UNC is good, key UI already visible
end

local function setupKeyUI(KeyUI, luarmorApi)
    local KeyMain = KeyUI.Main
    KeyMain.Title.Text = "The Intruders - Key Required"
    KeyMain.Subtitle.Text = "Enter your Luarmor key"
    KeyMain.NoteMessage.Text =
    "Join our discord for support discord.com/invite/vfkD5VCRKU\nTired of the key system? Get the paid script in our Discord."
    pcall(function()
        KeyMain.NoteMessage.TextWrapped = true
        KeyMain.NoteMessage.TextYAlignment = Enum.TextYAlignment.Top
        KeyMain.NoteMessage.AutomaticSize = Enum.AutomaticSize.Y
    end)

    AddDraggingFunctionality(KeyMain, KeyMain)

    KeyMain.Size = UDim2.new(0, 467, 0, 175)
    KeyMain.BackgroundTransparency = 1
    TweenService:Create(KeyMain, TweenInfo.new(0.6, Enum.EasingStyle.Quint), { BackgroundTransparency = 0 }):Play()
    TweenService:Create(KeyMain, TweenInfo.new(0.6, Enum.EasingStyle.Quint), { Size = UDim2.new(0, 500, 0, 187) }):Play()

    local InputBox = KeyMain.Input.InputBox
    local HidenInput = KeyMain.Input.HidenInput
    local function updateHiddenMaskText()
        local text = InputBox.Text or ""
        HidenInput.Text = string.rep("•", #text)
    end
    InputBox:GetPropertyChangedSignal("Text"):Connect(updateHiddenMaskText)
    updateHiddenMaskText()
    HidenInput.TextTransparency = 0
    InputBox.TextTransparency = 1

    local CopyBut = KeyMain.Copy
    CopyBut.Text = "Get Key"
    CopyBut.Activated:Connect(function()
        setclipboard(keyAcquireUrl)
        RayfieldLibrary:Notify({ Title = "Key Link Copied!", Content = "Visit the link to get your key.", Duration = 7 })
    end)

    local CheckBut = KeyMain.Check
    CheckBut.Text = "Verify Key"

    local function verifyKey()
        local inputKey = KeyUI.Main.Input.InputBox.Text
        if not inputKey or inputKey == "" then
            RayfieldLibrary:Notify({ Title = "Error!", Content = "Please enter a key first.", Duration = 5 })
            return
        end

        -- Validate the key BEFORE saving
        local isValid, message, status = validateLuarmorKey(inputKey, luarmorApi)

        if isValid and status and status.code == "KEY_VALID" then
            -- Only save and proceed if key is valid
            saveKey(inputKey)
            if getgenv and getgenv() then
                getgenv().script_key = inputKey
            end
            script_key = inputKey

            RayfieldLibrary:Notify({
                Title = "Success!",
                Content = "Key verified and saved successfully! Welcome " ..
                    playerDisplayName,
                Duration = 7
            })

            FadeOutGuiTree(KeyMain, 0.5)
            KeyUI:Destroy()
            executeProtectedScript(luarmorApi, luarmorApi.script_id)
            return
        end

        -- Handle different error codes
        if status and status.code then
            if status.code == "KEY_HWID_LOCKED" then
                RayfieldLibrary:Notify({
                    Title = "HWID Locked",
                    Content = "Key linked to a different HWID. Please reset it using our bot.",
                    Duration = 7
                })
            elseif status.code == "KEY_INCORRECT" then
                RayfieldLibrary:Notify({
                    Title = "Invalid Key",
                    Content = "Key is wrong or deleted!",
                    Duration = 7
                })
            elseif status.code == "KEY_EXPIRED" then
                RayfieldLibrary:Notify({
                    Title = "Key Expired",
                    Content = "This key has expired and can no longer be used.",
                    Duration = 7
                })
            elseif status.code == "KEY_BANNED" then
                RayfieldLibrary:Notify({
                    Title = "Key Banned",
                    Content = "This key has been blacklisted and can not be used.",
                    Duration = 7
                })
            elseif status.code == "KEY_INVALID" then
                RayfieldLibrary:Notify({
                    Title = "Invalid Format",
                    Content = "Key format is invalid. Please check your key.",
                    Duration = 7
                })
            else
                local errorMsg = message or ("Failed to validate key. Error: " .. (status.code or "Unknown"))
                RayfieldLibrary:Notify({
                    Title = "Key Error",
                    Content = errorMsg,
                    Duration = 7
                })
            end
        else
            RayfieldLibrary:Notify({
                Title = "Validation Failed",
                Content = message or "Failed to validate key. Please try again.",
                Duration = 7
            })
        end
        -- Don't proceed if key is invalid
    end
    CheckBut.Activated:Connect(verifyKey)
    KeyUI.Main.Input.InputBox.FocusLost:Connect(function(EnterPressed)
        if EnterPressed and #KeyUI.Main.Input.InputBox.Text > 0 then
            verifyKey()
        end
    end)
    local Hidden = true
    KeyMain.HideP.MouseButton1Click:Connect(function()
        Hidden = not Hidden
        if Hidden then
            updateHiddenMaskText()
            TweenService:Create(KeyMain.Input.HidenInput, TweenInfo.new(0.5, Enum.EasingStyle.Quint),
                { TextTransparency = 0 }):Play()
            TweenService:Create(KeyMain.Input.InputBox, TweenInfo.new(0.5, Enum.EasingStyle.Quint),
                { TextTransparency = 1 }):Play()
        else
            TweenService:Create(KeyMain.Input.HidenInput, TweenInfo.new(0.5, Enum.EasingStyle.Quint),
                { TextTransparency = 1 }):Play()
            TweenService:Create(KeyMain.Input.InputBox, TweenInfo.new(0.5, Enum.EasingStyle.Quint),
                { TextTransparency = 0 }):Play()
        end
    end)
    KeyMain.Hide.MouseButton1Click:Connect(function()
        FadeOutGuiTree(KeyMain, 0.5)
        KeyUI:Destroy()
    end)
end

spawnKeyUIInstance = function(luarmorApi)
    local KeyUI = game:GetObjects("rbxassetid://14681919890")[1]
    if not KeyUI then
        return nil
    end

    KeyUI.Enabled = true
    KeyUI.ResetOnSpawn = false

    pcall(function()
        if getgenv and getgenv() and getgenv().KeyUI then
            getgenv().KeyUI:Destroy()
        end
    end)

    if getgenv and getgenv() then
        getgenv().KeyUI = KeyUI
    end

    ParentObject(KeyUI)

    pcall(function()
        KeyUI.DisplayOrder = 210
        if KeyUI.Main then
            KeyUI.Main.Visible = true
        end
    end)

    setupKeyUI(KeyUI, luarmorApi)

    return KeyUI
end

local function clearInvalidKey()
    -- Clear invalid key from storage
    writefile(keyFileName, "")
    if getgenv and getgenv() then
        getgenv().script_key = nil
    end
    script_key = nil
end

local function initializeKeySystem(api)
    -- Check if user has already set script_key
    local existingKey = checkScriptKey()
    if existingKey and existingKey ~= "" then
        -- Validate the existing key before using it
        local isValid, message, status = validateLuarmorKey(existingKey, api)
        if isValid and status and status.code == "KEY_VALID" then
            -- Key is valid, proceed
            saveKey(existingKey)
            if getgenv and getgenv() then
                getgenv().script_key = existingKey
            end
            script_key = existingKey
            RayfieldLibrary:Notify({
                Title = "Key Found!",
                Content = "Using existing script key. Welcome " ..
                    playerDisplayName,
                Duration = 5
            })
            executeProtectedScript(api, api.script_id)
            return true
        else
            -- Existing key is invalid, clear it
            clearInvalidKey()
            RayfieldLibrary:Notify({
                Title = "Key Invalid",
                Content = "Existing key is invalid or expired. Please enter a new key.",
                Duration = 7
            })
        end
    end

    -- Check for saved key in file
    local savedKey = loadSavedKey()
    if savedKey and savedKey ~= "" then
        -- Validate the saved key before using it
        local isValid, message, status = validateLuarmorKey(savedKey, api)
        if isValid and status and status.code == "KEY_VALID" then
            -- Key is valid, proceed
            saveKey(savedKey)
            if getgenv and getgenv() then
                getgenv().script_key = savedKey
            end
            script_key = savedKey
            RayfieldLibrary:Notify({ Title = "Auto-Login!", Content = "Using saved key. Welcome " .. playerDisplayName, Duration = 5 })
            executeProtectedScript(api, api.script_id)
            return true
        else
            -- Saved key is invalid, clear it
            clearInvalidKey()
            if status and status.code then
                if status.code == "KEY_EXPIRED" then
                    RayfieldLibrary:Notify({
                        Title = "Saved Key Expired",
                        Content = "Your saved key has expired. Please enter a new key.",
                        Duration = 7
                    })
                elseif status.code == "KEY_HWID_LOCKED" then
                    RayfieldLibrary:Notify({
                        Title = "HWID Locked",
                        Content = "Your saved key is locked to a different HWID. Please enter a new key or reset it.",
                        Duration = 7
                    })
                else
                    RayfieldLibrary:Notify({
                        Title = "Saved Key Invalid",
                        Content = "Your saved key is no longer valid. Please enter a new key.",
                        Duration = 7
                    })
                end
            else
                RayfieldLibrary:Notify({
                    Title = "Key Validation Failed",
                    Content = "Failed to validate saved key. Please enter a new key.",
                    Duration = 7
                })
            end
        end
    end

    -- Only show GUI if no valid key is found
    showKeyInputUI(api)
    return false
end

local function main()
    local scriptId, gameName = getScriptIdForCurrentGame()
    if not scriptId then
        RayfieldLibrary:Notify({ Title = "Unsupported Game", Content = "This game is not supported.", Duration = 7 })
        return
    end
    if scriptId == "" then
        RayfieldLibrary:Notify({ Title = "Missing Loader", Content = "No script_id configured for this game.", Duration = 7 })
        return
    end
    local api = loadLuarmorLibrary()
    if not api then
        RayfieldLibrary:Notify({ Title = "Error!", Content = "Failed to load Luarmor API. Please try again later.", Duration = 7 })
        return
    end
    api.script_id = scriptId
    SELECTED_SCRIPT_ID = scriptId
    initializeKeySystem(api)
end

main()
