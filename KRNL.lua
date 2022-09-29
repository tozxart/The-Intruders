local p = {
    "Accelerator",
    "Akaza",
    "Alice",
    "All Might",
    "Artoria",
    "Asta",
    "Astolfo Summer Character",
    "AsunaCharacter",
    "Attack Titan",
    "Bakugo",
    "Broly",
    "Deku",
    "Diablo",
    "Emiya Archer",
    "Esper",
    "Eugeo",
    "Gear 5 Luffy",
    "Genos",
    "Gilgamesh",
    "Gojo",
    "Goku",
    "Gray",
    "Hinata",
    "Ice Queen Esdeath",
    "Ichigo",
    "Infinity Gojo",
    "Itadori",
    "KanekiCharacter",
    "Katakuri (Summer) Character",
    "Katakuri",
    "Killua",
    "KiritoCharacter",
    "Kokushibo",
    "Lancer",
    "Levi",
    "Luffy",
    "Megumin (Halloween)",
    "Megumin",
    "MilimCharacter (Valentine)",
    "MisakaCharacter",
    "Naruto (Kurama Mode)",
    "Naofumi",
    "Naruto Six Paths",
    "Naruto",
    "Natsu",
    "Nezuko (New Year)",
    "Obito",
    "Priestess",
    "PriestessCharacter (Shrine)",
    "RengokuCharacter",
    "Rimuru",
    "RimuruDemonLord",
    "Rukia",
    "Ryuko",
    "Saber Alter Character",
    "Sakura",
    "Sasuke",
    "Shadow Accelerator",
    "Shadow Attack Titan",
    "Shadow Esdeath",
    "Shadow Infinity Gojo",
    "Shadow Rimuru",
    "Shadow Yoriichi",
    "Shanks",
    "Shinra",
    "Sukuna",
    "Sung Jin Woo",
    "Tanjiro",
    "Todoroki",
    "TogaCharacter (Halloween)",
    "Uzui",
    "Winter Spirit Emilia",
    "Yoriichi",
    "Zenitsu",
    "Zoro (Summer)",
    "Zoro"
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
    
