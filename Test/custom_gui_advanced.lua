-- Advanced GUI Components (Part 3)
-- Input, Dropdown, Keybind, ColorPicker, and Notification System

-- Input Class
local Input = {}
Input.__index = Input

function Tab:CreateInput(config)
    local input = setmetatable({}, Input)
    
    input.Tab = self
    input.Config = config or {}
    input.Value = config.Default or ""
    input.Callback = config.Callback or function() end
    
    -- Input frame
    input.Frame = Instance.new("Frame")
    input.Frame.Name = (config.Name or "Input") .. "Input"
    input.Frame.Size = UDim2.new(1, 0, 0, config.Description and 65 or 55)
    input.Frame.BackgroundColor3 = self.Window.Library.Theme.Secondary
    input.Frame.BorderSizePixel = 0
    input.Frame.Parent = self.Content
    
    CreateCorner(input.Frame, 8)
    
    -- Input label
    input.Label = Instance.new("TextLabel")
    input.Label.Name = "Label"
    input.Label.Size = UDim2.new(1, -15, 0, 20)
    input.Label.Position = UDim2.new(0, 15, 0, 8)
    input.Label.BackgroundTransparency = 1
    input.Label.Text = config.Name or "Input"
    input.Label.TextColor3 = self.Window.Library.Theme.Text
    input.Label.TextSize = 14
    input.Label.Font = Enum.Font.GothamMedium
    input.Label.TextXAlignment = Enum.TextXAlignment.Left
    input.Label.Parent = input.Frame
    
    -- Input box
    input.Box = Instance.new("TextBox")
    input.Box.Name = "InputBox"
    input.Box.Size = UDim2.new(1, -30, 0, 25)
    input.Box.Position = UDim2.new(0, 15, 0, 25)
    input.Box.BackgroundColor3 = self.Window.Library.Theme.Background
    input.Box.Text = input.Value
    input.Box.PlaceholderText = config.Placeholder or "Enter text..."
    input.Box.TextColor3 = self.Window.Library.Theme.Text
    input.Box.PlaceholderColor3 = self.Window.Library.Theme.TextSecondary
    input.Box.TextSize = 13
    input.Box.Font = Enum.Font.Gotham
    input.Box.BorderSizePixel = 0
    input.Box.ClearTextOnFocus = false
    input.Box.Parent = input.Frame
    
    CreateCorner(input.Box, 6)
    CreateStroke(input.Box, Color3.fromRGB(60, 60, 60), 1)
    
    -- Description (if provided)
    if config.Description then
        input.Description = Instance.new("TextLabel")
        input.Description.Name = "Description"
        input.Description.Size = UDim2.new(1, -30, 0, 12)
        input.Description.Position = UDim2.new(0, 15, 1, -15)
        input.Description.BackgroundTransparency = 1
        input.Description.Text = config.Description
        input.Description.TextColor3 = self.Window.Library.Theme.TextSecondary
        input.Description.TextSize = 11
        input.Description.Font = Enum.Font.Gotham
        input.Description.TextXAlignment = Enum.TextXAlignment.Left
        input.Description.Parent = input.Frame
    end
    
    -- Input functionality
    function input:Set(text)
        self.Value = tostring(text)
        self.Box.Text = self.Value
        pcall(self.Callback, self.Value)
    end
    
    input.Box.FocusLost:Connect(function(enterPressed)
        if enterPressed or not config.EnterOnly then
            input:Set(input.Box.Text)
        end
    end)
    
    -- Focus effects
    input.Box.Focused:Connect(function()
        CreateTween(input.Box:FindFirstChild("UIStroke"), {Color = self.Window.Library.Theme.Accent}):Play()
    end)
    
    input.Box.FocusLost:Connect(function()
        CreateTween(input.Box:FindFirstChild("UIStroke"), {Color = Color3.fromRGB(60, 60, 60)}):Play()
    end)
    
    table.insert(self.Elements, input)
    return input
end

-- Dropdown Class
local Dropdown = {}
Dropdown.__index = Dropdown

function Tab:CreateDropdown(config)
    local dropdown = setmetatable({}, Dropdown)
    
    dropdown.Tab = self
    dropdown.Config = config or {}
    dropdown.Options = config.Options or {}
    dropdown.Value = config.Default or (dropdown.Options[1] or "None")
    dropdown.Open = false
    dropdown.Callback = config.Callback or function() end
    
    -- Dropdown frame
    dropdown.Frame = Instance.new("Frame")
    dropdown.Frame.Name = (config.Name or "Dropdown") .. "Dropdown"
    dropdown.Frame.Size = UDim2.new(1, 0, 0, 55)
    dropdown.Frame.BackgroundColor3 = self.Window.Library.Theme.Secondary
    dropdown.Frame.BorderSizePixel = 0
    dropdown.Frame.Parent = self.Content
    
    CreateCorner(dropdown.Frame, 8)
    
    -- Dropdown label
    dropdown.Label = Instance.new("TextLabel")
    dropdown.Label.Name = "Label"
    dropdown.Label.Size = UDim2.new(1, -15, 0, 20)
    dropdown.Label.Position = UDim2.new(0, 15, 0, 8)
    dropdown.Label.BackgroundTransparency = 1
    dropdown.Label.Text = config.Name or "Dropdown"
    dropdown.Label.TextColor3 = self.Window.Library.Theme.Text
    dropdown.Label.TextSize = 14
    dropdown.Label.Font = Enum.Font.GothamMedium
    dropdown.Label.TextXAlignment = Enum.TextXAlignment.Left
    dropdown.Label.Parent = dropdown.Frame
    
    -- Dropdown button
    dropdown.Button = Instance.new("TextButton")
    dropdown.Button.Name = "DropdownButton"
    dropdown.Button.Size = UDim2.new(1, -30, 0, 25)
    dropdown.Button.Position = UDim2.new(0, 15, 0, 25)
    dropdown.Button.BackgroundColor3 = self.Window.Library.Theme.Background
    dropdown.Button.Text = ""
    dropdown.Button.BorderSizePixel = 0
    dropdown.Button.Parent = dropdown.Frame
    
    CreateCorner(dropdown.Button, 6)
    CreateStroke(dropdown.Button, Color3.fromRGB(60, 60, 60), 1)
    
    -- Selected value text
    dropdown.ValueLabel = Instance.new("TextLabel")
    dropdown.ValueLabel.Name = "ValueLabel"
    dropdown.ValueLabel.Size = UDim2.new(1, -35, 1, 0)
    dropdown.ValueLabel.Position = UDim2.new(0, 10, 0, 0)
    dropdown.ValueLabel.BackgroundTransparency = 1
    dropdown.ValueLabel.Text = dropdown.Value
    dropdown.ValueLabel.TextColor3 = self.Window.Library.Theme.Text
    dropdown.ValueLabel.TextSize = 13
    dropdown.ValueLabel.Font = Enum.Font.Gotham
    dropdown.ValueLabel.TextXAlignment = Enum.TextXAlignment.Left
    dropdown.ValueLabel.Parent = dropdown.Button
    
    -- Dropdown arrow
    dropdown.Arrow = Instance.new("TextLabel")
    dropdown.Arrow.Name = "Arrow"
    dropdown.Arrow.Size = UDim2.new(0, 20, 1, 0)
    dropdown.Arrow.Position = UDim2.new(1, -25, 0, 0)
    dropdown.Arrow.BackgroundTransparency = 1
    dropdown.Arrow.Text = "▼"
    dropdown.Arrow.TextColor3 = self.Window.Library.Theme.TextSecondary
    dropdown.Arrow.TextSize = 12
    dropdown.Arrow.Font = Enum.Font.Gotham
    dropdown.Arrow.TextXAlignment = Enum.TextXAlignment.Center
    dropdown.Arrow.Parent = dropdown.Button
    
    -- Options container
    dropdown.OptionsFrame = Instance.new("Frame")
    dropdown.OptionsFrame.Name = "OptionsFrame"
    dropdown.OptionsFrame.Size = UDim2.new(1, -30, 0, 0)
    dropdown.OptionsFrame.Position = UDim2.new(0, 15, 1, 5)
    dropdown.OptionsFrame.BackgroundColor3 = self.Window.Library.Theme.Background
    dropdown.OptionsFrame.BorderSizePixel = 0
    dropdown.OptionsFrame.Visible = false
    dropdown.OptionsFrame.Parent = dropdown.Frame
    dropdown.OptionsFrame.ZIndex = 10
    
    CreateCorner(dropdown.OptionsFrame, 6)
    CreateStroke(dropdown.OptionsFrame, self.Window.Library.Theme.Accent, 1)
    
    local optionsLayout = Instance.new("UIListLayout")
    optionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    optionsLayout.Padding = UDim.new(0, 2)
    optionsLayout.Parent = dropdown.OptionsFrame
    
    -- Create option buttons
    dropdown.OptionButtons = {}
    
    function dropdown:UpdateOptions()
        -- Clear existing options
        for _, button in pairs(self.OptionButtons) do
            button:Destroy()
        end
        self.OptionButtons = {}
        
        -- Create new options
        for i, option in ipairs(self.Options) do
            local optionButton = Instance.new("TextButton")
            optionButton.Name = "Option" .. i
            optionButton.Size = UDim2.new(1, 0, 0, 30)
            optionButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            optionButton.BackgroundTransparency = 1
            optionButton.Text = option
            optionButton.TextColor3 = self.Tab.Window.Library.Theme.Text
            optionButton.TextSize = 13
            optionButton.Font = Enum.Font.Gotham
            optionButton.BorderSizePixel = 0
            optionButton.Parent = self.OptionsFrame
            
            optionButton.MouseButton1Click:Connect(function()
                self:Set(option)
                self:Close()
            end)
            
            optionButton.MouseEnter:Connect(function()
                CreateTween(optionButton, {BackgroundTransparency = 0.9}):Play()
            end)
            
            optionButton.MouseLeave:Connect(function()
                CreateTween(optionButton, {BackgroundTransparency = 1}):Play()
            end)
            
            table.insert(self.OptionButtons, optionButton)
        end
        
        self.OptionsFrame.Size = UDim2.new(1, -30, 0, #self.Options * 32)
    end
    
    function dropdown:Set(value)
        self.Value = value
        self.ValueLabel.Text = value
        pcall(self.Callback, value)
    end
    
    function dropdown:Open()
        self.Open = true
        self.OptionsFrame.Visible = true
        CreateTween(self.OptionsFrame, {
            Size = UDim2.new(1, -30, 0, #self.Options * 32)
        }, 0.2):Play()
        CreateTween(self.Arrow, {Rotation = 180}):Play()
        
        -- Expand dropdown frame
        CreateTween(self.Frame, {
            Size = UDim2.new(1, 0, 0, 60 + (#self.Options * 32))
        }, 0.2):Play()
    end
    
    function dropdown:Close()
        self.Open = false
        CreateTween(self.OptionsFrame, {
            Size = UDim2.new(1, -30, 0, 0)
        }, 0.2):Play()
        CreateTween(self.Arrow, {Rotation = 0}):Play()
        
        wait(0.2)
        if not self.Open then
            self.OptionsFrame.Visible = false
            CreateTween(self.Frame, {
                Size = UDim2.new(1, 0, 0, 55)
            }, 0.2):Play()
        end
    end
    
    dropdown.Button.MouseButton1Click:Connect(function()
        if dropdown.Open then
            dropdown:Close()
        else
            dropdown:Open()
        end
    end)
    
    dropdown:UpdateOptions()
    
    table.insert(self.Elements, dropdown)
    return dropdown
end

-- Notification System
function Library:Notify(config)
    local notification = {}
    
    -- Notification frame
    notification.Frame = Instance.new("Frame")
    notification.Frame.Name = "Notification"
    notification.Frame.Size = UDim2.new(0, 0, 0, 0)
    notification.Frame.Position = UDim2.new(1, 10, 1, -80)
    notification.Frame.BackgroundColor3 = self.Theme.Secondary
    notification.Frame.BorderSizePixel = 0
    notification.Frame.Parent = self.ScreenGui
    notification.Frame.ZIndex = 100
    
    CreateCorner(notification.Frame, 8)
    CreateStroke(notification.Frame, config.Type == "error" and self.Theme.Error or 
                                   config.Type == "warning" and self.Theme.Warning or 
                                   config.Type == "success" and self.Theme.Success or 
                                   self.Theme.Accent, 2)
    
    -- Notification icon
    if config.Icon then
        notification.Icon = Instance.new("ImageLabel")
        notification.Icon.Name = "Icon"
        notification.Icon.Size = UDim2.new(0, 24, 0, 24)
        notification.Icon.Position = UDim2.new(0, 15, 0, 15)
        notification.Icon.BackgroundTransparency = 1
        notification.Icon.Image = "rbxassetid://" .. tostring(config.Icon)
        notification.Icon.ImageColor3 = config.Type == "error" and self.Theme.Error or 
                                       config.Type == "warning" and self.Theme.Warning or 
                                       config.Type == "success" and self.Theme.Success or 
                                       self.Theme.Accent
        notification.Icon.Parent = notification.Frame
    end
    
    -- Notification title
    notification.Title = Instance.new("TextLabel")
    notification.Title.Name = "Title"
    notification.Title.Size = UDim2.new(1, config.Icon and -50 or -30, 0, 20)
    notification.Title.Position = UDim2.new(0, config.Icon and 45 or 15, 0, 10)
    notification.Title.BackgroundTransparency = 1
    notification.Title.Text = config.Title or "Notification"
    notification.Title.TextColor3 = self.Theme.Text
    notification.Title.TextSize = 14
    notification.Title.Font = Enum.Font.GothamBold
    notification.Title.TextXAlignment = Enum.TextXAlignment.Left
    notification.Title.Parent = notification.Frame
    
    -- Notification content
    if config.Content then
        notification.Content = Instance.new("TextLabel")
        notification.Content.Name = "Content"
        notification.Content.Size = UDim2.new(1, config.Icon and -50 or -30, 0, 16)
        notification.Content.Position = UDim2.new(0, config.Icon and 45 or 15, 0, 28)
        notification.Content.BackgroundTransparency = 1
        notification.Content.Text = config.Content
        notification.Content.TextColor3 = self.Theme.TextSecondary
        notification.Content.TextSize = 12
        notification.Content.Font = Enum.Font.Gotham
        notification.Content.TextXAlignment = Enum.TextXAlignment.Left
        notification.Content.TextWrapped = true
        notification.Content.Parent = notification.Frame
    end
    
    -- Close button
    notification.CloseButton = Instance.new("TextButton")
    notification.CloseButton.Name = "CloseButton"
    notification.CloseButton.Size = UDim2.new(0, 20, 0, 20)
    notification.CloseButton.Position = UDim2.new(1, -25, 0, 5)
    notification.CloseButton.BackgroundTransparency = 1
    notification.CloseButton.Text = "×"
    notification.CloseButton.TextColor3 = self.Theme.TextSecondary
    notification.CloseButton.TextSize = 16
    notification.CloseButton.Font = Enum.Font.GothamBold
    notification.CloseButton.Parent = notification.Frame
    
    -- Animation in
    local targetSize = UDim2.new(0, 350, 0, config.Content and 55 or 40)
    CreateTween(notification.Frame, {
        Size = targetSize,
        Position = UDim2.new(1, -360, 1, -80)
    }, 0.3):Play()
    
    -- Auto-close timer
    local duration = config.Duration or 5
    local closeTimer = task.wait(duration)
    
    local function closeNotification()
        CreateTween(notification.Frame, {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(1, 10, 1, -80)
        }, 0.3):Play()
        
        task.wait(0.3)
        notification.Frame:Destroy()
        
        -- Remove from notifications list
        for i, notif in ipairs(self.Notifications) do
            if notif == notification then
                table.remove(self.Notifications, i)
                break
            end
        end
    end
    
    notification.CloseButton.MouseButton1Click:Connect(closeNotification)
    
    -- Auto-close
    task.spawn(function()
        task.wait(duration)
        closeNotification()
    end)
    
    table.insert(self.Notifications, notification)
    return notification
end

-- Return the extended library
return {
    Input = Input,
    Dropdown = Dropdown
}
