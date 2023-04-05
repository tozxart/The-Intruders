function findSelectedNPCs(player)
    local enemyNPCs = game:GetService("Workspace").EnemyNPCs
    local unloadedNPCs = game:GetService("ReplicatedStorage")["Unloaded_NPCs"]
    local foundNPCs = {}

    local function getCurrentMap()
        return Settings.CurrentMap
    end

    local function getCurrentNPCs()
        return Settings.CurrentNPCS
    end

    local currentPlayerWorld = getCurrentWorld(player)

    local playerWorldSelected = false
    for _, mapName in ipairs(getCurrentMap()) do
        if mapName == currentPlayerWorld then
            playerWorldSelected = true
            break
        end
    end
    local playerTeleported = false

    if playerWorldSelected then
        local mapFolder = enemyNPCs:FindFirstChild(currentPlayerWorld)
        if mapFolder then
            local bossPriorityNPCs = { "RaidBoss", "Night Boss" }
            for _, npcName in ipairs(bossPriorityNPCs) do
                for _, npc in ipairs(mapFolder:GetChildren()) do
                    if npc.Name == npcName and #npc:GetChildren() > 0 then
                        table.insert(foundNPCs, { map = mapFolder.Name, npc = npc })
                        playerTeleported = true
                    end
                end
            end

            for _, npcName in ipairs(getCurrentNPCs()) do
                if not (npcName == "RaidBoss" or npcName == "Night Boss") then
                    for _, npc in ipairs(mapFolder:GetChildren()) do
                        if npc.Name == npcName and #npc:GetChildren() > 0 then
                            table.insert(foundNPCs, { map = mapFolder.Name, npc = npc })
                        end
                    end
                end
            end
        end
    else
        teleportToDestinationWorld(getCurrentMap()[1])
        playerTeleported = true
    end


    for _, npcName in ipairs(getCurrentNPCs()) do
        if npcName == "RaidBoss" or npcName == "Night Boss" then
            for _, mapName in ipairs(getCurrentMap()) do
                if mapName ~= currentPlayerWorld then
                    local mapFolder = unloadedNPCs:FindFirstChild(mapName)
                    if mapFolder then
                        local targetNPC = mapFolder:FindFirstChild(npcName)
                        if targetNPC and #targetNPC:GetChildren() > 0 then
                            if not playerTeleported then
                                teleportToDestinationWorld(mapName)
                                playerTeleported = true
                            end
                            table.insert(foundNPCs, { map = mapFolder.Name, npc = targetNPC })
                        end
                    end
                end
            end
        end
    end

    return foundNPCs
end

local currentNPC = nil

local function farmSelectedNPCs()
    -- Define the main function for farming NPCs

    local function farmNPC(npc)
        -- Define the function for farming a single NPC

        if not Rayfield.Flags.Toggle1.CurrentValue then
            -- Check if the toggle is currently set to true
            -- If not, return and stop farming
            return
        end

        if currentNPC == nil then
            -- If this is the first NPC being farmed, set currentNPC to npc
            currentNPC = npc
        elseif currentNPC ~= npc then
            -- If currentNPC doesn't match npc, return and stop farming
            return
        end

        -- Check if the NPC has children, and if not, return and stop farming
        if #npc:GetChildren() == 0 then
            return
        end

        -- Check if the NPC has a HumanoidRootPart
        local humanoidRootPart = npc:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            -- Calculate the distance between the player and the NPC
            local keepDistance = 10
            local distanceToTarget = (character.HumanoidRootPart.Position - humanoidRootPart.Position).Magnitude

            -- If the distance is greater than 10 units, move the player's HumanoidRootPart closer
            if distanceToTarget > keepDistance then
                local targetPosition = humanoidRootPart.Position +
                    (character.HumanoidRootPart.Position - humanoidRootPart.Position).Unit * keepDistance
                character.HumanoidRootPart.CFrame = CFrame.new(targetPosition)

                -- Wait until the player is within 10 units of the NPC
                repeat
                    wait(0.1)
                    if not Rayfield.Flags.Toggle1.CurrentValue then
                        return
                    end
                    distanceToTarget = (character.HumanoidRootPart.Position - humanoidRootPart.Position).Magnitude
                until distanceToTarget <= keepDistance
            end

            -- Check if the NPC has an Info folder
            local infoFolder = npc:FindFirstChild("Info")
            if infoFolder then
                local currentHealth = infoFolder:FindFirstChild("CurrentHealth")
                if currentHealth then
                    -- Wait until the NPC's health reaches 0 or it is destroyed
                    repeat
                        wait(0.1)
                        if not Rayfield.Flags.Toggle1.CurrentValue then
                            return
                        end
                        distanceToTarget = (character.HumanoidRootPart.Position - humanoidRootPart.Position).Magnitude
                        if distanceToTarget > keepDistance then
                            local targetPosition = humanoidRootPart.Position +
                                (character.HumanoidRootPart.Position - humanoidRootPart.Position).Unit * keepDistance
                            character.HumanoidRootPart.CFrame = CFrame.new(targetPosition)
                            repeat
                                wait(0.1)
                                if not Rayfield.Flags.Toggle1.CurrentValue then
                                    return
                                end
                                distanceToTarget = (character.HumanoidRootPart.Position - humanoidRootPart.Position)
                                    .Magnitude
                            until distanceToTarget <= keepDistance
                        end
                    until currentHealth.Value == 0 or #npc:GetChildren() == 0

                    -- Collect any coins dropped by the NPC
                    local coinsFolder = game:GetService("Workspace").Coins

                    local function collectCoins(coin)
                        if coin:IsA("MeshPart") then
                            character.HumanoidRootPart.CFrame = coin.CFrame
                            wait(1)
                            game:GetService("ReplicatedStorage").Remotes.spawnCoins.collectCoins:FireServer(coin.Name)
                            coin:Destroy()
                        end
                    end

                    for _, coin in ipairs(coinsFolder:GetChildren()) do
                        collectCoins(coin)
                    end

                    wait(1)
                end
            end

            currentNPC = nil
        end
    end

    local function farmAllNPCs()
        -- Define the function for finding and farming all the selected NPCs

        local foundNPCs = findSelectedNPCs(player)
        local currentPlayerWorld = getCurrentWorld(player)

        for _, npcData in ipairs(foundNPCs) do
            local mapFolder = game:GetService("Workspace").EnemyNPCs:FindFirstChild(currentPlayerWorld)
            if mapFolder then
                local npcType = mapFolder:FindFirstChild(npcData.npc.Name)
                if npcType then
                    for _, npc in ipairs(npcType:GetChildren()) do
                        if #npc:GetChildren() > 0 then
                            -- Create a new thread to farm the NPC
                            spawn(function()
                                farmNPC(npc)

                                -- Wait until the NPC is destroyed or the toggle is set to false
                                while Rayfield.Flags.Toggle1.CurrentValue and #npc:GetChildren() > 0 do
                                    wait(0.5)
                                end
                            end)
                        end
                    end
                end
            end
        end
    end

    -- Continuously farm all selected NPCs while the toggle is set to true
    while Rayfield.Flags.Toggle1.CurrentValue do
        farmAllNPCs()
        wait(0.5)
    end
end

-- Start the farming process in a separate coroutine
coroutine.resume(
    coroutine.create(
        function()
            while task.wait() do
                if Rayfield.Flags.Toggle1.CurrentValue then
                    farmSelectedNPCs()
                end
            end
        end
    )
)
