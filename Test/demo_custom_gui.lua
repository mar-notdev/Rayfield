-- Demo Script for Custom GUI Library
-- Showcasing all features and components

-- Load the custom GUI library (combine all parts)
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

-- Include the library code directly for demo
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

-- Simple demo implementation
function Library.new(config)
    local self = setmetatable({}, Library)
    
    self.Config = config or {}
    self.Theme = CONFIG.Themes[self.Config.Theme or "Dark"]
    self.Windows = {}
    self.Notifications = {}
    
    -- Create main ScreenGui
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "CustomGUILibrary"
    self.ScreenGui.Parent = CoreGui
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.ScreenGui.ResetOnSpawn = false
    
    return self
end

function Library:CreateWindow(config)
    local window = {}
    window.Library = self
    
    -- Create a simple demo window
    window.Frame = Instance.new("Frame")
    window.Frame.Name = "DemoWindow"
    window.Frame.Size = UDim2.new(0, 500, 0, 350)
    window.Frame.Position = UDim2.new(0.5, -250, 0.5, -175)
    window.Frame.BackgroundColor3 = self.Theme.Background
    window.Frame.BorderSizePixel = 0
    window.Frame.Parent = self.ScreenGui
    
    CreateCorner(window.Frame, 12)
    CreateStroke(window.Frame, self.Theme.Accent, 2)
    
    -- Title bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.BackgroundColor3 = self.Theme.Accent
    titleBar.BorderSizePixel = 0
    titleBar.Parent = window.Frame
    
    CreateCorner(titleBar, 12)
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -50, 1, 0)
    title.Position = UDim2.new(0, 15, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = config.Name or "Custom GUI Demo"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 16
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = titleBar
    
    -- Content area
    window.Content = Instance.new("ScrollingFrame")
    window.Content.Name = "Content"
    window.Content.Size = UDim2.new(1, -20, 1, -60)
    window.Content.Position = UDim2.new(0, 10, 0, 50)
    window.Content.BackgroundTransparency = 1
    window.Content.BorderSizePixel = 0
    window.Content.ScrollBarThickness = 6
    window.Content.Parent = window.Frame
    
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 10)
    layout.Parent = window.Content
    
    -- Simple tab system
    window.Tabs = {}
    
    function window:CreateTab(name)
        local tab = {}
        tab.Window = self
        tab.Content = self.Content
        tab.Elements = {}
        
        -- Create section header
        local section = Instance.new("Frame")
        section.Name = name .. "Section"
        section.Size = UDim2.new(1, 0, 0, 35)
        section.BackgroundColor3 = self.Library.Theme.Secondary
        section.BorderSizePixel = 0
        section.Parent = self.Content
        
        CreateCorner(section, 8)
        
        local sectionTitle = Instance.new("TextLabel")
        sectionTitle.Size = UDim2.new(1, -20, 1, 0)
        sectionTitle.Position = UDim2.new(0, 15, 0, 0)
        sectionTitle.BackgroundTransparency = 1
        sectionTitle.Text = name
        sectionTitle.TextColor3 = self.Library.Theme.Text
        sectionTitle.TextSize = 16
        sectionTitle.Font = Enum.Font.GothamBold
        sectionTitle.TextXAlignment = Enum.TextXAlignment.Left
        sectionTitle.Parent = section
        
        -- Button creation function
        function tab:CreateButton(config)
            local button = Instance.new("TextButton")
            button.Name = config.Name .. "Button"
            button.Size = UDim2.new(1, 0, 0, 40)
            button.BackgroundColor3 = self.Window.Library.Theme.Accent
            button.Text = config.Name
            button.TextColor3 = Color3.fromRGB(255, 255, 255)
            button.TextSize = 14
            button.Font = Enum.Font.GothamMedium
            button.BorderSizePixel = 0
            button.Parent = self.Content
            
            CreateCorner(button, 8)
            
            button.MouseButton1Click:Connect(function()
                CreateTween(button, {Size = UDim2.new(1, -4, 0, 38)}, 0.1):Play()
                wait(0.1)
                CreateTween(button, {Size = UDim2.new(1, 0, 0, 40)}, 0.1):Play()
                
                if config.Callback then
                    pcall(config.Callback)
                end
            end)
            
            table.insert(self.Elements, button)
            return button
        end
        
        -- Toggle creation function
        function tab:CreateToggle(config)
            local toggle = {}
            toggle.Value = config.Default or false
            
            local frame = Instance.new("Frame")
            frame.Name = config.Name .. "Toggle"
            frame.Size = UDim2.new(1, 0, 0, 45)
            frame.BackgroundColor3 = self.Window.Library.Theme.Secondary
            frame.BorderSizePixel = 0
            frame.Parent = self.Content
            
            CreateCorner(frame, 8)
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -70, 1, 0)
            label.Position = UDim2.new(0, 15, 0, 0)
            label.BackgroundTransparency = 1
            label.Text = config.Name
            label.TextColor3 = self.Window.Library.Theme.Text
            label.TextSize = 14
            label.Font = Enum.Font.GothamMedium
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = frame
            
            local toggleButton = Instance.new("TextButton")
            toggleButton.Size = UDim2.new(0, 50, 0, 25)
            toggleButton.Position = UDim2.new(1, -60, 0.5, -12.5)
            toggleButton.BackgroundColor3 = toggle.Value and self.Window.Library.Theme.Success or Color3.fromRGB(60, 60, 60)
            toggleButton.Text = ""
            toggleButton.BorderSizePixel = 0
            toggleButton.Parent = frame
            
            CreateCorner(toggleButton, 12)
            
            local indicator = Instance.new("Frame")
            indicator.Size = UDim2.new(0, 21, 0, 21)
            indicator.Position = UDim2.new(0, toggle.Value and 27 or 2, 0, 2)
            indicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            indicator.BorderSizePixel = 0
            indicator.Parent = toggleButton
            
            CreateCorner(indicator, 10)
            
            function toggle:Set(value)
                self.Value = value
                CreateTween(toggleButton, {
                    BackgroundColor3 = value and self.Window.Library.Theme.Success or Color3.fromRGB(60, 60, 60)
                }):Play()
                CreateTween(indicator, {
                    Position = UDim2.new(0, value and 27 or 2, 0, 2)
                }):Play()
                
                if config.Callback then
                    pcall(config.Callback, value)
                end
            end
            
            toggleButton.MouseButton1Click:Connect(function()
                toggle:Set(not toggle.Value)
            end)
            
            table.insert(self.Elements, toggle)
            return toggle
        end
        
        table.insert(self.Tabs, tab)
        return tab
    end
    
    table.insert(self.Windows, window)
    return window
end

-- Notification system
function Library:Notify(config)
    local notification = Instance.new("Frame")
    notification.Name = "Notification"
    notification.Size = UDim2.new(0, 0, 0, 0)
    notification.Position = UDim2.new(1, 10, 1, -80)
    notification.BackgroundColor3 = self.Theme.Secondary
    notification.BorderSizePixel = 0
    notification.Parent = self.ScreenGui
    notification.ZIndex = 100
    
    CreateCorner(notification, 8)
    CreateStroke(notification, config.Type == "success" and self.Theme.Success or 
                              config.Type == "error" and self.Theme.Error or 
                              self.Theme.Accent, 2)
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -30, 0, 20)
    title.Position = UDim2.new(0, 15, 0, 10)
    title.BackgroundTransparency = 1
    title.Text = config.Title or "Notification"
    title.TextColor3 = self.Theme.Text
    title.TextSize = 14
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = notification
    
    if config.Content then
        local content = Instance.new("TextLabel")
        content.Size = UDim2.new(1, -30, 0, 16)
        content.Position = UDim2.new(0, 15, 0, 28)
        content.BackgroundTransparency = 1
        content.Text = config.Content
        content.TextColor3 = self.Theme.TextSecondary
        content.TextSize = 12
        content.Font = Enum.Font.Gotham
        content.TextXAlignment = Enum.TextXAlignment.Left
        content.Parent = notification
    end
    
    -- Animate in
    CreateTween(notification, {
        Size = UDim2.new(0, 300, 0, config.Content and 50 or 35),
        Position = UDim2.new(1, -310, 1, -80)
    }, 0.3):Play()
    
    -- Auto-close
    task.spawn(function()
        task.wait(config.Duration or 3)
        CreateTween(notification, {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(1, 10, 1, -80)
        }, 0.3):Play()
        task.wait(0.3)
        notification:Destroy()
    end)
end

-- Initialize the demo
local library = Library.new({
    Theme = "Dark"
})

local window = library:CreateWindow({
    Name = "🚀 Advanced Custom GUI Demo"
})

-- Player Controls Tab
local playerTab = window:CreateTab("👤 Player Controls")

playerTab:CreateButton({
    Name = "💨 Teleport to Spawn",
    Callback = function()
        local player = Players.LocalPlayer
        if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = CFrame.new(0, 10, 0)
            library:Notify({
                Title = "Teleport",
                Content = "Successfully teleported to spawn!",
                Type = "success",
                Duration = 2
            })
        end
    end
})

local speedToggle = playerTab:CreateToggle({
    Name = "⚡ Speed Boost",
    Default = false,
    Callback = function(value)
        local player = Players.LocalPlayer
        if player and player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = value and 50 or 16
            library:Notify({
                Title = "Speed Boost",
                Content = value and "Speed boost enabled!" or "Speed boost disabled!",
                Type = "success",
                Duration = 1.5
            })
        end
    end
})

playerTab:CreateToggle({
    Name = "🦘 Jump Boost",
    Default = false,
    Callback = function(value)
        local player = Players.LocalPlayer
        if player and player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.JumpPower = value and 100 or 50
            library:Notify({
                Title = "Jump Boost",
                Content = value and "Jump boost enabled!" or "Jump boost disabled!",
                Type = "success",
                Duration = 1.5
            })
        end
    end
})

-- Visual Features Tab
local visualTab = window:CreateTab("👁️ Visual Features")

visualTab:CreateToggle({
    Name = "🔍 Player ESP",
    Default = false,
    Callback = function(value)
        if value then
            -- Simple ESP implementation
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= Players.LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
                    local billboard = Instance.new("BillboardGui")
                    billboard.Name = "ESP_" .. player.Name
                    billboard.Parent = player.Character.Head
                    billboard.Size = UDim2.new(0, 100, 0, 50)
                    billboard.StudsOffset = Vector3.new(0, 3, 0)
                    billboard.AlwaysOnTop = true
                    
                    local frame = Instance.new("Frame")
                    frame.Parent = billboard
                    frame.Size = UDim2.new(1, 0, 1, 0)
                    frame.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
                    frame.BackgroundTransparency = 0.5
                    CreateCorner(frame, 8)
                    
                    local label = Instance.new("TextLabel")
                    label.Parent = frame
                    label.Size = UDim2.new(1, 0, 1, 0)
                    label.BackgroundTransparency = 1
                    label.Text = player.Name
                    label.TextColor3 = Color3.fromRGB(255, 255, 255)
                    label.TextScaled = true
                    label.Font = Enum.Font.GothamBold
                end
            end
            library:Notify({
                Title = "ESP",
                Content = "Player ESP enabled!",
                Type = "success"
            })
        else
            -- Remove ESP
            for _, player in pairs(Players:GetPlayers()) do
                if player.Character and player.Character:FindFirstChild("Head") then
                    local esp = player.Character.Head:FindFirstChild("ESP_" .. player.Name)
                    if esp then esp:Destroy() end
                end
            end
            library:Notify({
                Title = "ESP",
                Content = "Player ESP disabled!",
                Type = "success"
            })
        end
    end
})

-- Utility Tab
local utilityTab = window:CreateTab("🔧 Utilities")

utilityTab:CreateButton({
    Name = "🌟 Show Success Notification",
    Callback = function()
        library:Notify({
            Title = "Success!",
            Content = "This is a success notification with custom styling.",
            Type = "success",
            Duration = 3
        })
    end
})

utilityTab:CreateButton({
    Name = "⚠️ Show Warning Notification",
    Callback = function()
        library:Notify({
            Title = "Warning!",
            Content = "This is a warning notification.",
            Type = "warning",
            Duration = 3
        })
    end
})

utilityTab:CreateButton({
    Name = "❌ Show Error Notification",
    Callback = function()
        library:Notify({
            Title = "Error!",
            Content = "This is an error notification.",
            Type = "error",
            Duration = 3
        })
    end
})

utilityTab:CreateButton({
    Name = "🎨 Change Theme Demo",
    Callback = function()
        -- Toggle between themes
        local currentTheme = library.Theme == CONFIG.Themes.Dark and "Light" or "Dark"
        library.Theme = CONFIG.Themes[currentTheme]
        
        library:Notify({
            Title = "Theme Changed",
            Content = "Switched to " .. currentTheme .. " theme!",
            Type = "success"
        })
    end
})

-- Welcome notification
library:Notify({
    Title = "🎉 Welcome!",
    Content = "Custom GUI Library loaded successfully! Try out all the features.",
    Type = "success",
    Duration = 4
})

print("🚀 Advanced Custom GUI Library Demo loaded!")
print("✨ Features: Modern design, smooth animations, notifications, and more!")
