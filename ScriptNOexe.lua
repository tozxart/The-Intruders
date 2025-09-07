repeat
    wait()
until game:IsLoaded()

local scriptBaseUrl = "https://api.luarmor.net/files/v3/loaders/"

local games = {
    ADS = {
        gameID = 2655311011,
        scriptUrl = scriptBaseUrl .. "f73ed5dc49f93300c997a7a12f01e9e9.lua",
    },
    aNIMElEGACY = {
        gameID = 4844706238,
        scriptUrl = scriptBaseUrl .. "f73ed5dc49f93300c997a7a12f01e9e9.lua",
    },
    PunshWallSimulator = {
        gameID = 4498728505,
        scriptUrl = scriptBaseUrl .. "",
    },
    ACS = {
        gameID = 4280746206,
        scriptUrl = scriptBaseUrl .. "f73ed5dc49f93300c997a7a12f01e9e9.lua",
    },
    WFS = {
        gameID = 3262314006,
        scriptUrl = scriptBaseUrl .. "f73ed5dc49f93300c997a7a12f01e9e9.lua",
    },
    AnimeEternal = {
        gameID = 7882829745,
        scriptUrl = scriptBaseUrl .. "5212ff08f0e1899fb90de6c023445d2e.lua",
    },
    RebirthChampionsUltimate = {
        gameID = 7178032757,
        scriptUrl = scriptBaseUrl .. "f73ed5dc49f93300c997a7a12f01e9e9.lua",
    },
}



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
