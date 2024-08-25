-- repeat
--     wait()
-- until game:IsLoaded()
--  game.Players.LocalPlayer:Kick(
--             "To access the script, please join our Discord server and get the paid version: discord.com/invite/vfkD5VCRKU.")
local scriptBaseUrl = "https://api.luarmor.net/files/v3/loaders/"

local games = {
    ADS = {
        gameID = 2655311011,
        scriptUrl = scriptBaseUrl .. "3085347d1de0fd8b9daa753704439861.lua",
    },
    aNIMElEGACY = {
        gameID = 4844706238,
        scriptUrl = scriptBaseUrl .. "297f5364acdb60ae4484561bb1edfdb4.lua",
    },
    PunshWallSimulator = {
        gameID = 4498728505,
        scriptUrl = scriptBaseUrl .. "",
    },
    ACS = {
        gameID = 4280746206,
        scriptUrl = scriptBaseUrl .. "f45402e68e94c2a10cb6a357b30147b0.lua",
    },
    WFS = {
        gameID = 3262314006,
        scriptUrl = scriptBaseUrl .. "9cda036a209316df8e62d5e19b7ebb7e.lua",
    },
}

local TurtleNotifications = loadstring(game:HttpGet("https://raw.githubusercontent.com/Turtle-Brand/Turtle-Notifications/main/source.lua"))()

local NotificationLibrary = TurtleNotifications.new(false, 2)

NotificationLibrary:QueueNotification(20, "Update Link!", "Get your free key here: https://go.click.ly/Jxeyd. For more info, join our Discord!", "Cancel-Copy", {
    Cancel = function()
        print("User chose to ignore the notification.")
    end,
    Copy = function()
        print("User clicked to copy the free key link.")
        setclipboard("https://go.click.ly/Jxeyd")
        print("Free key link copied to clipboard.")
    end
})
NotificationLibrary:SetNotificationDelay(20)


for gameName, gameData in pairs(games) do
    if gameData.gameID == game.GameId then
        local success, result = pcall(function()
            return loadstring(game:HttpGet(gameData.scriptUrl))
        end)
        
        if success then
            result()
        else
            warn("Failed to load and execute script for " .. gameName)
        end
        
        break
    end
end
