-- Custom GUI Elements Library (Part 2)
-- Advanced UI Components for the Custom GUI Library

-- Section Class
local Section = {}
Section.__index = Section

function Tab:CreateSection(name)
    local section = setmetatable({}, Section)
    
    section.Tab = self
    section.Name = name
    section.Elements = {}
    
    -- Section frame
    section.Frame = Instance.new("Frame")
    section.Frame.Name = name .. "Section"
    section.Frame.Size = UDim2.new(1, 0, 0, 35)
    section.Frame.BackgroundColor3 = self.Window.Library.Theme.Secondary
    section.Frame.BorderSizePixel = 0
    section.Frame.Parent = self.Content
    
    CreateCorner(section.Frame, 8)
    
    -- Section title
    section.Title = Instance.new("TextLabel")
    section.Title.Name = "Title"
    section.Title.Size = UDim2.new(1, -20, 1, 0)
    section.Title.Position = UDim2.new(0, 15, 0, 0)
    section.Title.BackgroundTransparency = 1
    section.Title.Text = name
    section.Title.TextColor3 = self.Window.Library.Theme.Text
    section.Title.TextSize = 16
    section.Title.Font = Enum.Font.GothamBold
    section.Title.TextXAlignment = Enum.TextXAlignment.Left
    section.Title.Parent = section.Frame
    
    -- Auto-resize content
    local function updateContentSize()
        local totalHeight = 0
        for _, child in ipairs(self.Content:GetChildren()) do
            if child:IsA("GuiObject") and child.Visible then
                totalHeight = totalHeight + child.Size.Y.Offset + 10
            end
        end
        self.Content.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
    end
    
    self.Content.ChildAdded:Connect(updateContentSize)
    self.Content.ChildRemoved:Connect(updateContentSize)
    
    table.insert(self.Elements, section)
    return section
end

-- Button Class
local Button = {}
Button.__index = Button

function Tab:CreateButton(config)
    local button = setmetatable({}, Button)
    
    button.Tab = self
    button.Config = config or {}
    button.Callback = config.Callback or function() end
    
    -- Button frame
    button.Frame = Instance.new("TextButton")
    button.Frame.Name = (config.Name or "Button") .. "Button"
    button.Frame.Size = UDim2.new(1, 0, 0, 45)
    button.Frame.BackgroundColor3 = self.Window.Library.Theme.Accent
    button.Frame.Text = ""
    button.Frame.BorderSizePixel = 0
    button.Frame.Parent = self.Content
    
    CreateCorner(button.Frame, 8)
    CreateStroke(button.Frame, self.Window.Library.Theme.Accent, 1)
    
    -- Button icon (if provided)
    if config.Icon then
        button.Icon = Instance.new("ImageLabel")
        button.Icon.Name = "Icon"
        button.Icon.Size = UDim2.new(0, 24, 0, 24)
        button.Icon.Position = UDim2.new(0, 15, 0.5, -12)
        button.Icon.BackgroundTransparency = 1
        button.Icon.Image = "rbxassetid://" .. tostring(config.Icon)
        button.Icon.ImageColor3 = Color3.fromRGB(255, 255, 255)
        button.Icon.Parent = button.Frame
    end
    
    -- Button text
    button.Label = Instance.new("TextLabel")
    button.Label.Name = "Label"
    button.Label.Size = UDim2.new(1, config.Icon and -50 or -30, 1, 0)
    button.Label.Position = UDim2.new(0, config.Icon and 45 or 15, 0, 0)
    button.Label.BackgroundTransparency = 1
    button.Label.Text = config.Name or "Button"
    button.Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Label.TextSize = 14
    button.Label.Font = Enum.Font.GothamMedium
    button.Label.TextXAlignment = Enum.TextXAlignment.Left
    button.Label.Parent = button.Frame
    
    -- Click effect
    button.Frame.MouseButton1Click:Connect(function()
        -- Visual feedback
        CreateTween(button.Frame, {Size = UDim2.new(1, -4, 0, 43)}, 0.1):Play()
        wait(0.1)
        CreateTween(button.Frame, {Size = UDim2.new(1, 0, 0, 45)}, 0.1):Play()
        
        -- Execute callback
        pcall(button.Callback)
    end)
    
    -- Hover effects
    button.Frame.MouseEnter:Connect(function()
        CreateTween(button.Frame, {
            BackgroundColor3 = Color3.fromRGB(
                math.min(255, self.Window.Library.Theme.Accent.R * 255 * 1.2),
                math.min(255, self.Window.Library.Theme.Accent.G * 255 * 1.2),
                math.min(255, self.Window.Library.Theme.Accent.B * 255 * 1.2)
            )
        }):Play()
    end)
    
    button.Frame.MouseLeave:Connect(function()
        CreateTween(button.Frame, {BackgroundColor3 = self.Window.Library.Theme.Accent}):Play()
    end)
    
    table.insert(self.Elements, button)
    return button
end

-- Toggle Class
local Toggle = {}
Toggle.__index = Toggle

function Tab:CreateToggle(config)
    local toggle = setmetatable({}, Toggle)
    
    toggle.Tab = self
    toggle.Config = config or {}
    toggle.Value = config.Default or false
    toggle.Callback = config.Callback or function() end
    
    -- Toggle frame
    toggle.Frame = Instance.new("Frame")
    toggle.Frame.Name = (config.Name or "Toggle") .. "Toggle"
    toggle.Frame.Size = UDim2.new(1, 0, 0, 45)
    toggle.Frame.BackgroundColor3 = self.Window.Library.Theme.Secondary
    toggle.Frame.BorderSizePixel = 0
    toggle.Frame.Parent = self.Content
    
    CreateCorner(toggle.Frame, 8)
    
    -- Toggle button
    toggle.Button = Instance.new("TextButton")
    toggle.Button.Name = "ToggleButton"
    toggle.Button.Size = UDim2.new(0, 50, 0, 25)
    toggle.Button.Position = UDim2.new(1, -65, 0.5, -12.5)
    toggle.Button.BackgroundColor3 = toggle.Value and self.Window.Library.Theme.Success or Color3.fromRGB(60, 60, 60)
    toggle.Button.Text = ""
    toggle.Button.BorderSizePixel = 0
    toggle.Button.Parent = toggle.Frame
    
    CreateCorner(toggle.Button, 12)
    
    -- Toggle indicator
    toggle.Indicator = Instance.new("Frame")
    toggle.Indicator.Name = "Indicator"
    toggle.Indicator.Size = UDim2.new(0, 21, 0, 21)
    toggle.Indicator.Position = UDim2.new(0, toggle.Value and 27 or 2, 0, 2)
    toggle.Indicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    toggle.Indicator.BorderSizePixel = 0
    toggle.Indicator.Parent = toggle.Button
    
    CreateCorner(toggle.Indicator, 10)
    
    -- Toggle label
    toggle.Label = Instance.new("TextLabel")
    toggle.Label.Name = "Label"
    toggle.Label.Size = UDim2.new(1, -80, 1, 0)
    toggle.Label.Position = UDim2.new(0, 15, 0, 0)
    toggle.Label.BackgroundTransparency = 1
    toggle.Label.Text = config.Name or "Toggle"
    toggle.Label.TextColor3 = self.Window.Library.Theme.Text
    toggle.Label.TextSize = 14
    toggle.Label.Font = Enum.Font.GothamMedium
    toggle.Label.TextXAlignment = Enum.TextXAlignment.Left
    toggle.Label.Parent = toggle.Frame
    
    -- Toggle description (if provided)
    if config.Description then
        toggle.Description = Instance.new("TextLabel")
        toggle.Description.Name = "Description"
        toggle.Description.Size = UDim2.new(1, -80, 0, 12)
        toggle.Description.Position = UDim2.new(0, 15, 1, -15)
        toggle.Description.BackgroundTransparency = 1
        toggle.Description.Text = config.Description
        toggle.Description.TextColor3 = self.Window.Library.Theme.TextSecondary
        toggle.Description.TextSize = 11
        toggle.Description.Font = Enum.Font.Gotham
        toggle.Description.TextXAlignment = Enum.TextXAlignment.Left
        toggle.Description.Parent = toggle.Frame
        
        toggle.Frame.Size = UDim2.new(1, 0, 0, 55)
    end
    
    -- Toggle functionality
    function toggle:Set(value)
        self.Value = value
        
        CreateTween(self.Button, {
            BackgroundColor3 = value and self.Tab.Window.Library.Theme.Success or Color3.fromRGB(60, 60, 60)
        }):Play()
        
        CreateTween(self.Indicator, {
            Position = UDim2.new(0, value and 27 or 2, 0, 2)
        }):Play()
        
        pcall(self.Callback, value)
    end
    
    toggle.Button.MouseButton1Click:Connect(function()
        toggle:Set(not toggle.Value)
    end)
    
    table.insert(self.Elements, toggle)
    return toggle
end

-- Slider Class
local Slider = {}
Slider.__index = Slider

function Tab:CreateSlider(config)
    local slider = setmetatable({}, Slider)
    
    slider.Tab = self
    slider.Config = config or {}
    slider.Min = config.Min or 0
    slider.Max = config.Max or 100
    slider.Value = config.Default or slider.Min
    slider.Increment = config.Increment or 1
    slider.Callback = config.Callback or function() end
    slider.Dragging = false
    
    -- Slider frame
    slider.Frame = Instance.new("Frame")
    slider.Frame.Name = (config.Name or "Slider") .. "Slider"
    slider.Frame.Size = UDim2.new(1, 0, 0, config.Description and 65 or 55)
    slider.Frame.BackgroundColor3 = self.Window.Library.Theme.Secondary
    slider.Frame.BorderSizePixel = 0
    slider.Frame.Parent = self.Content
    
    CreateCorner(slider.Frame, 8)
    
    -- Slider label
    slider.Label = Instance.new("TextLabel")
    slider.Label.Name = "Label"
    slider.Label.Size = UDim2.new(0.7, 0, 0, 20)
    slider.Label.Position = UDim2.new(0, 15, 0, 10)
    slider.Label.BackgroundTransparency = 1
    slider.Label.Text = config.Name or "Slider"
    slider.Label.TextColor3 = self.Window.Library.Theme.Text
    slider.Label.TextSize = 14
    slider.Label.Font = Enum.Font.GothamMedium
    slider.Label.TextXAlignment = Enum.TextXAlignment.Left
    slider.Label.Parent = slider.Frame
    
    -- Value display
    slider.ValueLabel = Instance.new("TextLabel")
    slider.ValueLabel.Name = "ValueLabel"
    slider.ValueLabel.Size = UDim2.new(0.3, -15, 0, 20)
    slider.ValueLabel.Position = UDim2.new(0.7, 0, 0, 10)
    slider.ValueLabel.BackgroundTransparency = 1
    slider.ValueLabel.Text = tostring(slider.Value)
    slider.ValueLabel.TextColor3 = self.Window.Library.Theme.Accent
    slider.ValueLabel.TextSize = 14
    slider.ValueLabel.Font = Enum.Font.GothamBold
    slider.ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    slider.ValueLabel.Parent = slider.Frame
    
    -- Slider track
    slider.Track = Instance.new("Frame")
    slider.Track.Name = "Track"
    slider.Track.Size = UDim2.new(1, -30, 0, 6)
    slider.Track.Position = UDim2.new(0, 15, 0, 35)
    slider.Track.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    slider.Track.BorderSizePixel = 0
    slider.Track.Parent = slider.Frame
    
    CreateCorner(slider.Track, 3)
    
    -- Slider fill
    slider.Fill = Instance.new("Frame")
    slider.Fill.Name = "Fill"
    slider.Fill.Size = UDim2.new((slider.Value - slider.Min) / (slider.Max - slider.Min), 0, 1, 0)
    slider.Fill.Position = UDim2.new(0, 0, 0, 0)
    slider.Fill.BackgroundColor3 = self.Window.Library.Theme.Accent
    slider.Fill.BorderSizePixel = 0
    slider.Fill.Parent = slider.Track
    
    CreateCorner(slider.Fill, 3)
    
    -- Slider thumb
    slider.Thumb = Instance.new("Frame")
    slider.Thumb.Name = "Thumb"
    slider.Thumb.Size = UDim2.new(0, 16, 0, 16)
    slider.Thumb.Position = UDim2.new((slider.Value - slider.Min) / (slider.Max - slider.Min), -8, 0, -5)
    slider.Thumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    slider.Thumb.BorderSizePixel = 0
    slider.Thumb.Parent = slider.Track
    
    CreateCorner(slider.Thumb, 8)
    CreateStroke(slider.Thumb, self.Window.Library.Theme.Accent, 2)
    
    -- Description (if provided)
    if config.Description then
        slider.Description = Instance.new("TextLabel")
        slider.Description.Name = "Description"
        slider.Description.Size = UDim2.new(1, -30, 0, 12)
        slider.Description.Position = UDim2.new(0, 15, 1, -15)
        slider.Description.BackgroundTransparency = 1
        slider.Description.Text = config.Description
        slider.Description.TextColor3 = self.Window.Library.Theme.TextSecondary
        slider.Description.TextSize = 11
        slider.Description.Font = Enum.Font.Gotham
        slider.Description.TextXAlignment = Enum.TextXAlignment.Left
        slider.Description.Parent = slider.Frame
    end
    
    -- Slider functionality
    function slider:Set(value)
        value = math.clamp(value, self.Min, self.Max)
        value = math.floor((value / self.Increment) + 0.5) * self.Increment
        self.Value = value
        
        local percentage = (value - self.Min) / (self.Max - self.Min)
        
        CreateTween(self.Fill, {Size = UDim2.new(percentage, 0, 1, 0)}):Play()
        CreateTween(self.Thumb, {Position = UDim2.new(percentage, -8, 0, -5)}):Play()
        
        self.ValueLabel.Text = tostring(value) .. (self.Config.Suffix or "")
        
        pcall(self.Callback, value)
    end
    
    -- Mouse input handling
    local function onInput(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            slider.Dragging = true
            
            local function update()
                local mouse = Players.LocalPlayer:GetMouse()
                local trackPos = slider.Track.AbsolutePosition
                local trackSize = slider.Track.AbsoluteSize
                local relativePos = math.clamp((mouse.X - trackPos.X) / trackSize.X, 0, 1)
                local value = slider.Min + ((slider.Max - slider.Min) * relativePos)
                slider:Set(value)
            end
            
            local dragConnection
            dragConnection = UserInputService.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement and slider.Dragging then
                    update()
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    slider.Dragging = false
                    dragConnection:Disconnect()
                end
            end)
            
            update()
        end
    end
    
    slider.Track.InputBegan:Connect(onInput)
    slider.Thumb.InputBegan:Connect(onInput)
    
    table.insert(self.Elements, slider)
    return slider
end

-- Continue with more elements...
return {
    Section = Section,
    Button = Button,
    Toggle = Toggle,
    Slider = Slider
}
