-- Custom Advanced GUI Library for Roblox
-- Created as a superior alternative to Rayfield with enhanced features

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local Library = {}
Library.__index = Library

-- Configuration and styling
local CONFIG = {
    Themes = {
        Dark = {
            Background = Color3.fromRGB(25, 25, 35),
            Secondary = Color3.fromRGB(35, 35, 50),
            Accent = Color3.fromRGB(75, 150, 255),
            Text = Color3.fromRGB(255, 255, 255),
            TextSecondary = Color3.fromRGB(180, 180, 180),
            Success = Color3.fromRGB(50, 200, 50),
            Warning = Color3.fromRGB(255, 200, 50),
            Error = Color3.fromRGB(255, 75, 75)
        },
        Light = {
            Background = Color3.fromRGB(245, 245, 250),
            Secondary = Color3.fromRGB(255, 255, 255),
            Accent = Color3.fromRGB(75, 150, 255),
            Text = Color3.fromRGB(25, 25, 35),
            TextSecondary = Color3.fromRGB(100, 100, 120),
            Success = Color3.fromRGB(50, 200, 50),
            Warning = Color3.fromRGB(255, 150, 50),
            Error = Color3.fromRGB(255, 75, 75)
        }
    },
    Animations = {
        Speed = 0.3,
        Style = Enum.EasingStyle.Quart,
        Direction = Enum.EasingDirection.Out
    }
}

-- Utility functions
local function CreateTween(object, properties, duration)
    duration = duration or CONFIG.Animations.Speed
    local tweenInfo = TweenInfo.new(duration, CONFIG.Animations.Style, CONFIG.Animations.Direction)
    return TweenService:Create(object, tweenInfo, properties)
end

local function CreateCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = parent
    return corner
end

local function CreateStroke(parent, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Color3.fromRGB(255, 255, 255)
    stroke.Thickness = thickness or 1
    stroke.Transparency = 0.8
    stroke.Parent = parent
    return stroke
end

local function CreateGradient(parent, colors, rotation)
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new(colors or {Color3.fromRGB(255, 255, 255), Color3.fromRGB(200, 200, 200)})
    gradient.Rotation = rotation or 0
    gradient.Parent = parent
    return gradient
end

-- Main Library Constructor
function Library.new(config)
    local self = setmetatable({}, Library)
    
    self.Config = config or {}
    self.Theme = CONFIG.Themes[self.Config.Theme or "Dark"]
    self.Windows = {}
    self.Notifications = {}
    self.Keybinds = {}
    self.Flags = {}
    
    -- Create main ScreenGui
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "CustomGUILibrary"
    self.ScreenGui.Parent = CoreGui
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.ScreenGui.ResetOnSpawn = false
    
    return self
end

-- Window Class
local Window = {}
Window.__index = Window

function Library:CreateWindow(config)
    local window = setmetatable({}, Window)
    
    window.Library = self
    window.Config = config or {}
    window.Tabs = {}
    window.CurrentTab = nil
    window.Visible = true
    window.Dragging = false
    
    -- Main window frame
    window.Frame = Instance.new("Frame")
    window.Frame.Name = "MainWindow"
    window.Frame.Size = UDim2.new(0, 600, 0, 400)
    window.Frame.Position = UDim2.new(0.5, -300, 0.5, -200)
    window.Frame.BackgroundColor3 = self.Theme.Background
    window.Frame.BorderSizePixel = 0
    window.Frame.Parent = self.ScreenGui
    
    CreateCorner(window.Frame, 12)
    CreateStroke(window.Frame, self.Theme.Accent, 2)
    
    -- Add drop shadow effect
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, 20, 1, 20)
    shadow.Position = UDim2.new(0, -10, 0, -10)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxasset://textures/ui/Controls/DropShadow.png"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.5
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(12, 12, 256-12, 256-12)
    shadow.ZIndex = window.Frame.ZIndex - 1
    shadow.Parent = window.Frame
    
    -- Title bar
    window.TitleBar = Instance.new("Frame")
    window.TitleBar.Name = "TitleBar"
    window.TitleBar.Size = UDim2.new(1, 0, 0, 40)
    window.TitleBar.Position = UDim2.new(0, 0, 0, 0)
    window.TitleBar.BackgroundColor3 = self.Theme.Secondary
    window.TitleBar.BorderSizePixel = 0
    window.TitleBar.Parent = window.Frame
    
    CreateCorner(window.TitleBar, 12)
    CreateGradient(window.TitleBar, {self.Theme.Accent, Color3.fromRGB(self.Theme.Accent.R * 255 * 0.8, self.Theme.Accent.G * 255 * 0.8, self.Theme.Accent.B * 255 * 0.8)}, 45)
    
    -- Title text
    window.Title = Instance.new("TextLabel")
    window.Title.Name = "Title"
    window.Title.Size = UDim2.new(1, -100, 1, 0)
    window.Title.Position = UDim2.new(0, 15, 0, 0)
    window.Title.BackgroundTransparency = 1
    window.Title.Text = config.Name or "Custom GUI"
    window.Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    window.Title.TextSize = 18
    window.Title.Font = Enum.Font.GothamBold
    window.Title.TextXAlignment = Enum.TextXAlignment.Left
    window.Title.Parent = window.TitleBar
    
    -- Close button
    window.CloseButton = Instance.new("TextButton")
    window.CloseButton.Name = "CloseButton"
    window.CloseButton.Size = UDim2.new(0, 30, 0, 30)
    window.CloseButton.Position = UDim2.new(1, -35, 0, 5)
    window.CloseButton.BackgroundColor3 = Color3.fromRGB(255, 75, 75)
    window.CloseButton.Text = "×"
    window.CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    window.CloseButton.TextSize = 20
    window.CloseButton.Font = Enum.Font.GothamBold
    window.CloseButton.BorderSizePixel = 0
    window.CloseButton.Parent = window.TitleBar
    
    CreateCorner(window.CloseButton, 6)
    
    -- Minimize button
    window.MinimizeButton = Instance.new("TextButton")
    window.MinimizeButton.Name = "MinimizeButton"
    window.MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
    window.MinimizeButton.Position = UDim2.new(1, -70, 0, 5)
    window.MinimizeButton.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
    window.MinimizeButton.Text = "−"
    window.MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    window.MinimizeButton.TextSize = 20
    window.MinimizeButton.Font = Enum.Font.GothamBold
    window.MinimizeButton.BorderSizePixel = 0
    window.MinimizeButton.Parent = window.TitleBar
    
    CreateCorner(window.MinimizeButton, 6)
    
    -- Tab container
    window.TabContainer = Instance.new("Frame")
    window.TabContainer.Name = "TabContainer"
    window.TabContainer.Size = UDim2.new(0, 150, 1, -40)
    window.TabContainer.Position = UDim2.new(0, 0, 0, 40)
    window.TabContainer.BackgroundColor3 = self.Theme.Secondary
    window.TabContainer.BorderSizePixel = 0
    window.TabContainer.Parent = window.Frame
    
    -- Tab list
    window.TabList = Instance.new("ScrollingFrame")
    window.TabList.Name = "TabList"
    window.TabList.Size = UDim2.new(1, 0, 1, 0)
    window.TabList.Position = UDim2.new(0, 0, 0, 0)
    window.TabList.BackgroundTransparency = 1
    window.TabList.BorderSizePixel = 0
    window.TabList.ScrollBarThickness = 0
    window.TabList.Parent = window.TabContainer
    
    local tabListLayout = Instance.new("UIListLayout")
    tabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabListLayout.Padding = UDim.new(0, 5)
    tabListLayout.Parent = window.TabList
    
    -- Content area
    window.ContentArea = Instance.new("Frame")
    window.ContentArea.Name = "ContentArea"
    window.ContentArea.Size = UDim2.new(1, -150, 1, -40)
    window.ContentArea.Position = UDim2.new(0, 150, 0, 40)
    window.ContentArea.BackgroundColor3 = self.Theme.Background
    window.ContentArea.BorderSizePixel = 0
    window.ContentArea.Parent = window.Frame
    
    -- Make window draggable
    local function onDragStart(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            window.Dragging = true
            local startPos = input.Position
            local startFramePos = window.Frame.Position
            
            local dragConnection
            dragConnection = UserInputService.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement and window.Dragging then
                    local delta = input.Position - startPos
                    window.Frame.Position = UDim2.new(
                        startFramePos.X.Scale,
                        startFramePos.X.Offset + delta.X,
                        startFramePos.Y.Scale,
                        startFramePos.Y.Offset + delta.Y
                    )
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    window.Dragging = false
                    dragConnection:Disconnect()
                end
            end)
        end
    end
    
    window.TitleBar.InputBegan:Connect(onDragStart)
    
    -- Close button functionality
    window.CloseButton.MouseButton1Click:Connect(function()
        window:Destroy()
    end)
    
    -- Minimize button functionality
    window.MinimizeButton.MouseButton1Click:Connect(function()
        window:Toggle()
    end)
    
    -- Add button hover effects
    window.CloseButton.MouseEnter:Connect(function()
        CreateTween(window.CloseButton, {BackgroundColor3 = Color3.fromRGB(255, 100, 100)}):Play()
    end)
    
    window.CloseButton.MouseLeave:Connect(function()
        CreateTween(window.CloseButton, {BackgroundColor3 = Color3.fromRGB(255, 75, 75)}):Play()
    end)
    
    window.MinimizeButton.MouseEnter:Connect(function()
        CreateTween(window.MinimizeButton, {BackgroundColor3 = Color3.fromRGB(255, 220, 75)}):Play()
    end)
    
    window.MinimizeButton.MouseLeave:Connect(function()
        CreateTween(window.MinimizeButton, {BackgroundColor3 = Color3.fromRGB(255, 200, 50)}):Play()
    end)
    
    table.insert(self.Windows, window)
    return window
end

function Window:Toggle()
    self.Visible = not self.Visible
    if self.Visible then
        self.Frame.Visible = true
        CreateTween(self.Frame, {Size = UDim2.new(0, 600, 0, 400)}, 0.3):Play()
    else
        CreateTween(self.Frame, {Size = UDim2.new(0, 600, 0, 40)}, 0.3):Play()
        wait(0.3)
        if not self.Visible then
            self.ContentArea.Visible = false
        end
    end
end

function Window:Destroy()
    CreateTween(self.Frame, {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    }, 0.3):Play()
    
    wait(0.3)
    self.Frame:Destroy()
    
    for i, window in ipairs(self.Library.Windows) do
        if window == self then
            table.remove(self.Library.Windows, i)
            break
        end
    end
end

-- Tab Class
local Tab = {}
Tab.__index = Tab

function Window:CreateTab(name, icon)
    local tab = setmetatable({}, Tab)
    
    tab.Window = self
    tab.Name = name
    tab.Icon = icon
    tab.Elements = {}
    tab.Active = false
    
    -- Tab button
    tab.Button = Instance.new("TextButton")
    tab.Button.Name = name .. "Tab"
    tab.Button.Size = UDim2.new(1, -10, 0, 40)
    tab.Button.Position = UDim2.new(0, 5, 0, 0)
    tab.Button.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
    tab.Button.Text = ""
    tab.Button.BorderSizePixel = 0
    tab.Button.Parent = self.TabList
    
    CreateCorner(tab.Button, 8)
    
    -- Tab icon (if provided)
    if icon then
        tab.IconLabel = Instance.new("ImageLabel")
        tab.IconLabel.Name = "Icon"
        tab.IconLabel.Size = UDim2.new(0, 20, 0, 20)
        tab.IconLabel.Position = UDim2.new(0, 10, 0, 10)
        tab.IconLabel.BackgroundTransparency = 1
        tab.IconLabel.Image = "rbxassetid://" .. tostring(icon)
        tab.IconLabel.ImageColor3 = self.Library.Theme.TextSecondary
        tab.IconLabel.Parent = tab.Button
    end
    
    -- Tab text
    tab.Label = Instance.new("TextLabel")
    tab.Label.Name = "Label"
    tab.Label.Size = UDim2.new(1, icon and -40 or -20, 1, 0)
    tab.Label.Position = UDim2.new(0, icon and 35 or 10, 0, 0)
    tab.Label.BackgroundTransparency = 1
    tab.Label.Text = name
    tab.Label.TextColor3 = self.Library.Theme.TextSecondary
    tab.Label.TextSize = 14
    tab.Label.Font = Enum.Font.Gotham
    tab.Label.TextXAlignment = Enum.TextXAlignment.Left
    tab.Label.Parent = tab.Button
    
    -- Tab content frame
    tab.Content = Instance.new("ScrollingFrame")
    tab.Content.Name = name .. "Content"
    tab.Content.Size = UDim2.new(1, -20, 1, -20)
    tab.Content.Position = UDim2.new(0, 10, 0, 10)
    tab.Content.BackgroundTransparency = 1
    tab.Content.BorderSizePixel = 0
    tab.Content.ScrollBarThickness = 6
    tab.Content.ScrollBarImageColor3 = self.Library.Theme.Accent
    tab.Content.Visible = false
    tab.Content.Parent = self.ContentArea
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Padding = UDim.new(0, 10)
    contentLayout.Parent = tab.Content
    
    -- Tab button click
    tab.Button.MouseButton1Click:Connect(function()
        self:SetActiveTab(tab)
    end)
    
    -- Hover effects
    tab.Button.MouseEnter:Connect(function()
        if not tab.Active then
            CreateTween(tab.Button, {BackgroundColor3 = Color3.fromRGB(55, 55, 75)}):Play()
        end
    end)
    
    tab.Button.MouseLeave:Connect(function()
        if not tab.Active then
            CreateTween(tab.Button, {BackgroundColor3 = Color3.fromRGB(45, 45, 60)}):Play()
        end
    end)
    
    table.insert(self.Tabs, tab)
    
    if #self.Tabs == 1 then
        self:SetActiveTab(tab)
    end
    
    return tab
end

function Window:SetActiveTab(tab)
    for _, t in ipairs(self.Tabs) do
        t.Active = false
        t.Content.Visible = false
        CreateTween(t.Button, {BackgroundColor3 = Color3.fromRGB(45, 45, 60)}):Play()
        CreateTween(t.Label, {TextColor3 = self.Library.Theme.TextSecondary}):Play()
        if t.IconLabel then
            CreateTween(t.IconLabel, {ImageColor3 = self.Library.Theme.TextSecondary}):Play()
        end
    end
    
    tab.Active = true
    tab.Content.Visible = true
    self.CurrentTab = tab
    CreateTween(tab.Button, {BackgroundColor3 = self.Library.Theme.Accent}):Play()
    CreateTween(tab.Label, {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
    if tab.IconLabel then
        CreateTween(tab.IconLabel, {ImageColor3 = Color3.fromRGB(255, 255, 255)}):Play()
    end
end

-- Continue in the next part due to length...
return Library
