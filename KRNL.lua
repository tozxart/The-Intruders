_G.Settings = {
    CustomDifficulty = "Easy", -- "Nightmare"-"Hard"-"Easy"
    Hardcore = true,
    FriendsOnly = true,
    custommapselect = "Titan Dimension"
}


            task.spawn(
                function()
                    while task.wait(1) do
                        wait()
                        local Y = math.random(1, #p)
                        local Z = p[Y]
                        game:GetService("ReplicatedStorage").RemoteFunctions.MainRemoteFunction:InvokeServer(
                            "TeleportToShadowRaid",
                            Z
                        )
                    end
                end
            )

            task.spawn(
                function()
                    while task.wait(3) do
                        game:GetService("ReplicatedStorage").RemoteFunctions.MainRemoteFunction:InvokeServer(
                            "CreateRoom",
                            {
                                ["Difficulty"] = "Easy",
                                ["FriendsOnly"] = true,
                                ["MapName"] = _G.Settings.Raidselectmap,
                                ["Hardcore"] = false
                            }
                        )
                        game:GetService("ReplicatedStorage").RemoteFunctions.MainRemoteFunction:InvokeServer(
                            "TeleportPlayers"
                        )
                    end
                end
            )
            task.spawn(
                function()
                    while task.wait(10) do
                        game:GetService("ReplicatedStorage").RemoteFunctions.MainRemoteFunction:InvokeServer(
                            "CreateRoom",
                            {
                                ["Difficulty"] = _G.Settings.CustomDifficulty,
                                ["FriendsOnly"] = _G.Settings.FriendsOnly,
                                ["MapName"] = _G.Settings.custommapselect,
                                ["Hardcore"] = _G.Settings.Hardcore
                            }
                        )
                        game:GetService("ReplicatedStorage").RemoteFunctions.MainRemoteFunction:InvokeServer(
                            "TeleportPlayers"
                        )
                    end
                end
            )
    
