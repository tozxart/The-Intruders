	-- Dropdown
    function Tab:CreateDropdown(DropdownSettings)
        local Dropdown = Elements.Template.Dropdown:Clone()
        local SearchBar = Dropdown.List["-SearchBar"]
        local Required = 1
        --local Debounce = false
        DropdownSettings.Items = {
            Selected = {Default = DropdownSettings.Selected or nil}
        }
        DropdownSettings.Locked = false
        local Multi = DropdownSettings.MultiSelection or false
        if string.find(DropdownSettings.Name,"closed") then
            Dropdown.Name = "Dropdown"
        else
            Dropdown.Name = DropdownSettings.Name
        end
        Dropdown.Title.Text = DropdownSettings.Name
        Dropdown.Visible = true
        Tab.Elements[DropdownSettings.Name] = {
            type = 'dropdown',
            section = DropdownSettings.SectionParent,
            element = Dropdown
        }
        if DropdownSettings.SectionParent then
            Dropdown.Parent = DropdownSettings.SectionParent.Holder
        else
            Dropdown.Parent = TabPage
        end

        Dropdown.List.Visible = false
        Dropdown.BackgroundTransparency = 1
        Dropdown.UIStroke.Transparency = 1
        Dropdown.Title.TextTransparency = 1

        Dropdown.Size = UDim2.new(0,465, 0, 44)




        for _, ununusedoption in ipairs(Dropdown.List:GetChildren()) do
            if ununusedoption.ClassName == "Frame" and ununusedoption.Name ~= 'PlaceHolder' and ununusedoption.Name ~= "-SearchBar" then
                ununusedoption:Destroy()
            end
        end

        Dropdown.Toggle.Rotation = 180

        local function RefreshSelected()
            if #DropdownSettings.Items.Selected > 1 then
                local NT = {}
                for _,kj in ipairs(DropdownSettings.Items.Selected) do
                    NT[#NT+1] = kj.Option.Name
                end
                Dropdown.Selected.Text = table.concat(NT, ", ")
            elseif DropdownSettings.Items.Selected[1] then
                Dropdown.Selected.Text = DropdownSettings.Items.Selected[1].Option.Name
            else
                Dropdown.Selected.Text = "Select an option"
            end
        end

        Dropdown.Interact.MouseButton1Click:Connect(function()
            if DropdownSettings.Locked then return end

            wait(0.1)

            if Debounce then return end
            if Dropdown.List.Visible then
                Debounce = true
                for _, DropdownOpt in ipairs(Dropdown.List:GetChildren()) do
                    if DropdownOpt.ClassName == "Frame" and DropdownOpt.Name ~= 'PlaceHolder' and DropdownOpt~= SearchBar then

                    end
                end

                wait(0.35)
                Dropdown.List.Visible = false
                Debounce = false
            else
                Dropdown.List.Visible = true

                for _, DropdownOpt in ipairs(Dropdown.List:GetChildren()) do
                    if DropdownOpt.ClassName == "Frame" and DropdownOpt.Name ~= 'PlaceHolder' and DropdownOpt ~= SearchBar then
         
                    end
                end
            end
        end)

        Dropdown.List['-SearchBar'].Input:GetPropertyChangedSignal('Text'):Connect(function()
            local InputText=string.upper(Dropdown.List['-SearchBar'].Input.Text)
            for _,item in ipairs(Dropdown.List:GetChildren()) do
                if item:IsA('Frame') and item.Name ~= 'Template' and item ~= SearchBar and item.Name ~= 'PlaceHolder' then
                    if InputText=="" or InputText==" "or string.find(string.upper(item.Name),InputText)~=nil then

                    else

                    end
                end
            end
        end)
        Dropdown.MouseEnter:Connect(function()
            if not Dropdown.List.Visible then
            end
        end)
        Dropdown.MouseLeave:Connect(function()
        end)
        local function Error(text)
            Dropdown.Title.Text = text
            wait(0.5)
            Dropdown.Title.Text = DropdownSettings.Name
        end

        local function AddOption(Option,Selecteds)
            local DropdownOption = Elements.Template.Dropdown.List.Template:Clone()
            DropdownOption:GetPropertyChangedSignal('BackgroundTransparency'):Connect(function()
                if DropdownOption.BackgroundTransparency == 1 then
                    DropdownOption.Visible = false
                else
                    DropdownOption.Visible = true
                end
            end)
            DropdownSettings.Items[Option] = {
                Option = DropdownOption,
                Selected = false
            }
            print(DropdownSettings.Items)
            local OptionInTable = DropdownSettings.Items[Option]
            DropdownOption.Name = Option.Name or Option
            DropdownOption.Title.Text = Option.Name or Option
            DropdownOption.Parent = Dropdown.List
            DropdownOption.Visible = true
            local IsSelected = OptionInTable.Selected
            if Selecteds and #Selecteds > 0 then
                if typeof(Selecteds) == 'string' then
                    Selecteds = {Selecteds}
                end
                for index,Selected in pairs(Selecteds) do
                    if Selected == Option.Name or Selected == Option then
                        IsSelected = true
                        OptionInTable.Selected = true
                        table.insert(DropdownSettings.Items.Selected,OptionInTable)
                        DropdownSettings.Items.Selected[table.find(DropdownSettings.Items.Selected,OptionInTable)].Selected = true
                    end
                end
                RefreshSelected()
            end

            if IsSelected then
                DropdownOption.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            end

            if Dropdown.Visible then
                DropdownOption.BackgroundTransparency = 0
                DropdownOption.UIStroke.Transparency = 0
                DropdownOption.Title.TextTransparency = 0
            else
                DropdownOption.BackgroundTransparency = 1
                DropdownOption.UIStroke.Transparency = 1
                DropdownOption.Title.TextTransparency = 1
            end

            DropdownOption.Interact.ZIndex = 50
            DropdownOption.Interact.MouseButton1Click:Connect(function()
                if DropdownSettings.Locked then return end
                if OptionInTable.Selected then
                    OptionInTable.Selected = false
                    table.remove(DropdownSettings.Items.Selected,table.find(DropdownSettings.Items.Selected,OptionInTable))
                    RefreshSelected()
                    SaveConfiguration()
                    return
                end
                if not Multi and DropdownSettings.Items.Selected[1] then
                    DropdownSettings.Items.Selected[1].Selected = false
                end
                if not (Multi) then
                    DropdownSettings.Items.Selected = {OptionInTable}
                    Dropdown.Selected.Text = Option.Name or Option
                else
                    table.insert(DropdownSettings.Items.Selected,OptionInTable)
                    RefreshSelected()
                end
                
                local Success, Response = pcall(function()
                    DropdownSettings.Callback(Option)
                end)
                if not Success then
                    Error('Callback Error')
                    print("Rayfield | "..DropdownSettings.Name.." Callback Error " ..tostring(Response))
                end
                
                OptionInTable.Selected = true
                
                if not (Multi) then
                    for _,op in ipairs(DropdownSettings.Items.Selected) do
                    end
                end
                Debounce = true
                wait(0.2)
                wait(0.1)
                if not Multi then
                    for _, DropdownOpt in ipairs(Dropdown.List:GetChildren()) do
                        if DropdownOpt.ClassName == "Frame" and DropdownOpt ~= Dropdown.List.PlaceHolder and DropdownOpt ~= SearchBar then
                        end
                    end
                    wait(0.35)
                    Dropdown.List.Visible = false
                    
                end
                Debounce = false
                SaveConfiguration()
            end)
        end
        local function AddOptions(Options,Selected)
            if typeof(Options) == 'table' then
                for _, Option in ipairs(Options) do
                    AddOption(Option,Selected)
                end
            else
                AddOption(Options,Selected)
            end
            if Settings.ConfigurationSaving then
                if Settings.ConfigurationSaving.Enabled and DropdownSettings.Flag then
                    RayfieldLibrary.Flags[DropdownSettings.Flag] = DropdownSettings
                end
            end
        end
        function DropdownSettings:Add(Items,Selected)
            AddOptions(Items,Selected)
        end
        
        AddOptions(DropdownSettings.Options,DropdownSettings.CurrentOption)
        
        --fix
        function DropdownSettings:Set(NewOption)
        for _,Option in ipairs(DropdownSettings.Items) do
         local DropdownOption = Option.Option
         Option.Selected = false
         if Dropdown.Visible then
         DropdownOption.BackgroundTransparency = 0
         DropdownOption.UIStroke.Transparency = 0
         DropdownOption.Title.TextTransparency = 0
         else
         DropdownOption.BackgroundTransparency = 1
         DropdownOption.UIStroke.Transparency = 1
         DropdownOption.Title.TextTransparency = 1
         end

        end
            if typeof(NewOption) ~= 'table' then
                DropdownSettings.Items.Selected = {NewOption}
                NewOption = {NewOption}
            end
            local Confirmed = {}
            for _,o in pairs(NewOption) do
                local Success, Response = pcall(function()
                    DropdownSettings.Callback(NewOption)
                 end)
                if not Success then
                    Dropdown.Title.Text = "Callback Error"
                    print("Rayfield | "..DropdownSettings.Name.." Callback Error " ..tostring(Response))
                    wait(0.5)
                    Dropdown.Title.Text = DropdownSettings.Name
                end
                if DropdownSettings.Items[o] then
                DropdownSettings.Items[o].Selected = true
                Confirmed[o] = o
                    local DropdownOption =  DropdownSettings.Items[o].Option
                    DropdownOption.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                    
                    if Dropdown.Visible then
                        DropdownOption.BackgroundTransparency = 0
                        DropdownOption.UIStroke.Transparency = 0
                        DropdownOption.Title.TextTransparency = 0
                    else
                        DropdownOption.BackgroundTransparency = 1
                        DropdownOption.UIStroke.Transparency = 1
                        DropdownOption.Title.TextTransparency = 1
                    end
                    
                end
            end
            DropdownSettings.Items.Selected = Confirmed
            RefreshSelected()
            --Dropdown.Selected.Text = NewText
        end
        function DropdownSettings:Error(text)
            Error(text)
        end
        function DropdownSettings:Refresh(NewOptions,Selecteds)
            DropdownSettings.Items = {}
            DropdownSettings.Items.Selected = {}
            for _, option in ipairs(Dropdown.List:GetChildren()) do
                if option.ClassName == "Frame" and option ~= SearchBar and option ~= Dropdown.List.PlaceHolder then
                    option:Destroy()
                end
            end
            AddOptions(NewOptions,Selecteds)
        end
        function DropdownSettings:Remove(Item)
            if Item ~= Dropdown.List.PlaceHolder and Item ~= SearchBar then
                if DropdownSettings.Items[Item] then
                    DropdownSettings.Items[Item].Option:Destroy()
                    table.remove(DropdownSettings.Items,table.find(DropdownSettings.Items,Item))
                else
                    Error('Option not found.')
                end
            else
                SearchBar:Destroy()
                Error("why you trynna remove the searchbar? FINE")
            end
            if Dropdown.Selected.Text == Item then
                Dropdown.Selected.Text = ''
            end
        end

        function DropdownSettings:Destroy()
            Dropdown:Destroy()
        end
        function DropdownSettings:Lock(Reason)
            if DropdownSettings.Locked then return end
            DropdownSettings.Locked = true
            Debounce = true
            for _, DropdownOpt in ipairs(Dropdown.List:GetChildren()) do
                if DropdownOpt.ClassName == "Frame" and DropdownOpt.Name ~= 'PlaceHolder' and DropdownOpt.Name ~= "-SearchBar" then
                end
            end
            wait(0.35)
            Dropdown.List.Visible = false
            Debounce = false
            Dropdown.Lock.Reason.Text = Reason or 'Locked'
            wait(0.2)
            if not DropdownSettings.Locked then return end --no icon bug
            TweenService:Create(Dropdown.Lock.Reason.Icon,TweenInfo.new(0.4,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{ImageTransparency = 0}):Play()
        end
        function DropdownSettings:Unlock()
            if not DropdownSettings.Locked then return end
            DropdownSettings.Locked = false
            wait(0.2)
            TweenService:Create(Dropdown.Lock.Reason.Icon,TweenInfo.new(0.4,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{ImageTransparency = 1}):Play()
            if DropdownSettings.Locked then return end --no icon bug
            TweenService:Create(Dropdown.Lock,TweenInfo.new(0.4,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{BackgroundTransparency = 1}):Play()
            TweenService:Create(Dropdown.Lock.Reason,TweenInfo.new(0.4,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{TextTransparency = 1}):Play()
        end
        function DropdownSettings:Visible(bool)
            Dropdown.Visible = bool
        end
        return DropdownSettings
    end