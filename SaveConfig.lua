local Data = {}
local DataFunctions = {}
local Http = game:GetService("HttpService")

function Data.new(folderName, data)
    if not isfolder(folderName) then
        makefolder(folderName)
    end

    local savedData

    if isfile(folderName .. "/Settings.json") then
        local success, result = pcall(function()
            return Http:JSONDecode(readfile(folderName .. "/Settings.json"))
        end)

        if success then
            savedData = result
        end
    end

    if not savedData then
        savedData = data
    else
        for i, v in pairs(data) do
            if not savedData[i] then
                savedData[i] = v
            end
        end
    end

    return setmetatable({
        Data = savedData,
        FolderName = folderName
    }, {
        __index = DataFunctions
    })
end

function DataFunctions:Set(name, value)
    local success, errorMsg = pcall(function()
        self.Data[name] = value
        writefile(self.FolderName .. "/Settings.json", Http:JSONEncode(self.Data))
    end)

    if not success then
        warn("Error while setting value:", errorMsg)
    end
end

function DataFunctions:Get(name)
    local success, result = pcall(function()
        return self.Data[name]
    end)

    if success then
        return result
    else
        warn("Error while getting value:", result)
        return nil
    end
end

return Data
