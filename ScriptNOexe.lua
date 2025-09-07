repeat
    task.wait()
until game:IsLoaded()







local scriptBaseUrl = "https://api.luarmor.net/files/v3/loaders/"

local games = {
    ADS = {
        gameID = 2655311011,
        scriptId = "f73ed5dc49f93300c997a7a12f01e9e9",
    },
    aNIMElEGACY = {
        gameID = 4844706238,
        scriptId = "f73ed5dc49f93300c997a7a12f01e9e9",
    },
    PunshWallSimulator = {
        gameID = 4498728505,
        scriptId = "",
    },
    ACS = {
        gameID = 4280746206,
        scriptId = "f73ed5dc49f93300c997a7a12f01e9e9",
    },
    WFS = {
        gameID = 3262314006,
        scriptId = "f73ed5dc49f93300c997a7a12f01e9e9",
    },
    AnimeEternal = {
        gameID = 7882829745,
        scriptId = "5212ff08f0e1899fb90de6c023445d2e",
    },
    RebirthChampionsUltimate = {
        gameID = 7178032757,
        scriptId = "f73ed5dc49f93300c997a7a12f01e9e9",
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
    return (getgenv and getgenv().script_key) or _G.script_key or script_key
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
        return false, "Invalid key or API not loaded"
    end
    local status = api.check_key(key)
    return status and status.code == "KEY_VALID", (status and status.message) or "Unknown error", status
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

local function showKeyInputUI(luarmorApi)
    local KeyUI = game:GetObjects("rbxassetid://14681919890")[1]
    KeyUI.Enabled = true
    pcall(function()
        if _G.KeyUI then _G.KeyUI:Destroy() end
    end)
    _G.KeyUI = KeyUI
    ParentObject(KeyUI)

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
        local isValid, message = validateLuarmorKey(inputKey, luarmorApi)
        if isValid then
            saveKey(inputKey)
            if getgenv then getgenv().script_key = inputKey end
            _G.script_key = inputKey
            script_key = inputKey
            RayfieldLibrary:Notify({
                Title = "Success!",
                Content = "Key verified successfully! Welcome " ..
                    playerDisplayName,
                Duration = 7
            })
            FadeOutGuiTree(KeyMain, 0.5)
            KeyUI:Destroy()
            executeProtectedScript(luarmorApi, luarmorApi.script_id)
        else
            RayfieldLibrary:Notify({ Title = "Invalid Key!", Content = message or "Please check your key and try again.", Duration = 7 })
            KeyUI.Main.Input.InputBox.Text = ""
            TweenService:Create(KeyMain, TweenInfo.new(0.4, Enum.EasingStyle.Elastic),
                { Position = UDim2.new(0.495, 0, 0.5, 0) }):Play()
            task.wait(0.1)
            TweenService:Create(KeyMain, TweenInfo.new(0.4, Enum.EasingStyle.Elastic),
                { Position = UDim2.new(0.505, 0, 0.5, 0) }):Play()
            task.wait(0.1)
            TweenService:Create(KeyMain, TweenInfo.new(0.4, Enum.EasingStyle.Quint),
                { Position = UDim2.new(0.5, 0, 0.5, 0) }):Play()
        end
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

local function initializeKeySystem(api)
    local existingKey = checkScriptKey()
    if existingKey and existingKey ~= "" then
        local isValid = select(1, validateLuarmorKey(existingKey, api))
        if isValid then
            if getgenv then getgenv().script_key = existingKey end
            _G.script_key = existingKey
            script_key = existingKey
            RayfieldLibrary:Notify({ Title = "Welcome Back!", Content = "Your key is valid. Access granted.", Duration = 5 })
            executeProtectedScript(api, api.script_id)
            return true
        else
            RayfieldLibrary:Notify({ Title = "Key Issue", Content = "Your existing key is not valid.", Duration = 7 })
        end
    end
    local savedKey = loadSavedKey()
    if savedKey and savedKey ~= "" then
        local isValid = select(1, validateLuarmorKey(savedKey, api))
        if isValid then
            if getgenv then getgenv().script_key = savedKey end
            _G.script_key = savedKey
            script_key = savedKey
            RayfieldLibrary:Notify({ Title = "Auto-Login Success!", Content = "Logged in with saved key.", Duration = 5 })
            executeProtectedScript(api, api.script_id)
            return true
        end
    end
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
