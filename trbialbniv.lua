-- Fluent UI Library v1.0
local Fluent = {}
Fluent.Version = "1.0.0"
Fluent.Unloaded = false

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Utility functions
local function Create(class, props)
    local instance = Instance.new(class)
    for prop, value in pairs(props) do
        if prop == "Parent" then
            instance.Parent = value
        else
            local success, err = pcall(function()
                instance[prop] = value
            end)
            if not success then
                warn("Failed to set property", prop, "on", class, ":", err)
            end
        end
    end
    return instance
end

local function Tween(object, props, duration, style, direction)
    local tweenInfo = TweenInfo.new(duration or 0.2, style or Enum.EasingStyle.Quad, direction or Enum.EasingDirection.Out)
    local tween = TweenService:Create(object, tweenInfo, props)
    tween:Play()
    return tween
end

-- Theme management
Fluent.Themes = {
    Dark = {
        Background = Color3.fromRGB(32, 34, 37),
        Foreground = Color3.fromRGB(255, 255, 255),
        Primary = Color3.fromRGB(0, 120, 215),
        Secondary = Color3.fromRGB(40, 42, 45),
        Accent = Color3.fromRGB(0, 90, 158),
        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(200, 200, 200),
        Border = Color3.fromRGB(60, 62, 65),
    },
    Light = {
        Background = Color3.fromRGB(242, 242, 242),
        Foreground = Color3.fromRGB(0, 0, 0),
        Primary = Color3.fromRGB(0, 120, 215),
        Secondary = Color3.fromRGB(255, 255, 255),
        Accent = Color3.fromRGB(0, 90, 158),
        Text = Color3.fromRGB(0, 0, 0),
        SubText = Color3.fromRGB(80, 80, 80),
        Border = Color3.fromRGB(220, 220, 220),
    }
}

Fluent.CurrentTheme = "Dark"
Fluent.Options = {}

function Fluent:SetTheme(themeName)
    if not self.Themes[themeName] then
        warn("Theme '"..themeName.."' does not exist")
        return
    end
    self.CurrentTheme = themeName
end

-- Notification system
function Fluent:Notify(options)
    options = options or {}
    local title = options.Title or "Notification"
    local content = options.Content or ""
    local subContent = options.SubContent or ""
    local duration = options.Duration or 5
    
    local notificationFrame = Create("Frame", {
        Name = "Notification",
        BackgroundColor3 = self.Themes[self.CurrentTheme].Secondary,
        BorderColor3 = self.Themes[self.CurrentTheme].Border,
        BorderSizePixel = 1,
        Position = UDim2.new(1, 10, 1, -50),
        Size = UDim2.new(0, 300, 0, 100),
        AnchorPoint = Vector2.new(1, 1),
        Parent = LocalPlayer:WaitForChild("PlayerGui")
    })
    
    local titleLabel = Create("TextLabel", {
        Name = "Title",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 10),
        Size = UDim2.new(1, -20, 0, 20),
        Font = Enum.Font.GothamSemibold,
        Text = title,
        TextColor3 = self.Themes[self.CurrentTheme].Text,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = notificationFrame
    })
    
    local contentLabel = Create("TextLabel", {
        Name = "Content",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 35),
        Size = UDim2.new(1, -20, 0, 40),
        Font = Enum.Font.Gotham,
        Text = content,
        TextColor3 = self.Themes[self.CurrentTheme].Text,
        TextSize = 14,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = notificationFrame
    })
    
    if subContent ~= "" then
        contentLabel.Size = UDim2.new(1, -20, 0, 25)
        
        local subContentLabel = Create("TextLabel", {
            Name = "SubContent",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 10, 0, 65),
            Size = UDim2.new(1, -20, 0, 20),
            Font = Enum.Font.Gotham,
            Text = subContent,
            TextColor3 = self.Themes[self.CurrentTheme].SubText,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = notificationFrame
        })
    end
    
    Tween(notificationFrame, {Position = UDim2.new(1, -10, 1, -50)}, 0.3)
    
    if duration then
        task.delay(duration, function()
            Tween(notificationFrame, {Position = UDim2.new(1, 10, 1, -50)}, 0.3).Completed:Wait()
            notificationFrame:Destroy()
        end)
    end
end

-- Window creation
function Fluent:CreateWindow(options)
    options = options or {}
    local window = {}
    window.Title = options.Title or "Fluent UI"
    window.SubTitle = options.SubTitle or ""
    window.Size = options.Size or UDim2.fromOffset(580, 460)
    window.Acrylic = options.Acrylic or false
    window.Theme = options.Theme or "Dark"
    window.MinimizeKey = options.MinimizeKey or Enum.KeyCode.RightControl
    
    -- Create main UI container
    local screenGui = Create("ScreenGui", {
        Name = "FluentUI",
        ResetOnSpawn = false,
        Parent = LocalPlayer:WaitForChild("PlayerGui")
    })
    
    local mainFrame = Create("Frame", {
        Name = "MainWindow",
        BackgroundColor3 = self.Themes[window.Theme].Background,
        BorderColor3 = self.Themes[window.Theme].Border,
        BorderSizePixel = 1,
        Position = UDim2.new(0.5, -window.Size.X.Offset/2, 0.5, -window.Size.Y.Offset/2),
        Size = window.Size,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Parent = screenGui
    })
    
    -- Title bar
    local titleBar = Create("Frame", {
        Name = "TitleBar",
        BackgroundColor3 = self.Themes[window.Theme].Primary,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 30),
        Parent = mainFrame
    })
    
    local titleLabel = Create("TextLabel", {
        Name = "Title",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 0),
        Size = UDim2.new(1, -20, 1, 0),
        Font = Enum.Font.GothamSemibold,
        Text = window.Title,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = titleBar
    })
    
    local subtitleLabel = Create("TextLabel", {
        Name = "SubTitle",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 15),
        Size = UDim2.new(1, -20, 1, -15),
        Font = Enum.Font.Gotham,
        Text = window.SubTitle,
        TextColor3 = Color3.fromRGB(200, 200, 200),
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = titleBar
    })
    
    -- Close button
    local closeButton = Create("TextButton", {
        Name = "CloseButton",
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -30, 0, 0),
        Size = UDim2.new(0, 30, 0, 30),
        Font = Enum.Font.GothamSemibold,
        Text = "×",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 18,
        Parent = titleBar
    })
    
    closeButton.MouseButton1Click:Connect(function()
        screenGui:Destroy()
        Fluent.Unloaded = true
    end)
    
    -- Tab container
    local tabContainer = Create("Frame", {
        Name = "TabContainer",
        BackgroundColor3 = self.Themes[window.Theme].Secondary,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, 30),
        Size = UDim2.new(0, options.TabWidth or 160, 1, -30),
        Parent = mainFrame
    })
    
    local tabButtons = Create("ScrollingFrame", {
        Name = "TabButtons",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(1, 0, 1, 0),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 3,
        Parent = tabContainer
    })
    
    local tabContent = Create("Frame", {
        Name = "TabContent",
        BackgroundColor3 = self.Themes[window.Theme].Background,
        BorderSizePixel = 0,
        Position = UDim2.new(0, options.TabWidth or 160, 0, 30),
        Size = UDim2.new(1, -(options.TabWidth or 160), 1, -30),
        Parent = mainFrame
    })
    
    local contentScrolling = Create("ScrollingFrame", {
        Name = "ContentScrolling",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 10, 0, 10),
        Size = UDim2.new(1, -20, 1, -20),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 3,
        Parent = tabContent
    })
    
    local uiListLayout = Create("UIListLayout", {
        Name = "UIListLayout",
        Padding = UDim.new(0, 5),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = contentScrolling
    })
    
    -- Dragging functionality
    local dragging
    local dragInput
    local dragStart
    local startPos
    
    local function updateInput(input)
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    titleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            updateInput(input)
        end
    end)
    
    -- Window methods
    function window:AddTab(options)
        options = options or {}
        local tab = {}
        tab.Title = options.Title or "Tab"
        tab.Icon = options.Icon or ""
        
        local tabButton = Create("TextButton", {
            Name = "TabButton_"..tab.Title,
            BackgroundColor3 = self.Themes[window.Theme].Secondary,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 0, 40),
            Font = Enum.Font.Gotham,
            Text = tab.Title,
            TextColor3 = self.Themes[window.Theme].Text,
            TextSize = 14,
            Parent = tabButtons
        })
        
        local tabContentFrame = Create("Frame", {
            Name = "TabContent_"..tab.Title,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Visible = false,
            Parent = contentScrolling
        })
        
        local tabContentLayout = Create("UIListLayout", {
            Name = "UIListLayout",
            Padding = UDim.new(0, 10),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = tabContentFrame
        })
        
        -- Select first tab by default
        if #tabButtons:GetChildren() == 1 then
            tabButton.BackgroundColor3 = self.Themes[window.Theme].Accent
            tabContentFrame.Visible = true
        end
        
        tabButton.MouseButton1Click:Connect(function()
            -- Hide all tab contents
            for _, child in ipairs(contentScrolling:GetChildren()) do
                if child:IsA("Frame") and child.Name:match("TabContent_") then
                    child.Visible = false
                end
            end
            
            -- Reset all tab button colors
            for _, child in ipairs(tabButtons:GetChildren()) do
                if child:IsA("TextButton") and child.Name:match("TabButton_") then
                    child.BackgroundColor3 = self.Themes[window.Theme].Secondary
                end
            end
            
            -- Show selected tab content and highlight button
            tabContentFrame.Visible = true
            tabButton.BackgroundColor3 = self.Themes[window.Theme].Accent
        end)
        
        -- Update tab buttons container size
        tabButtons.CanvasSize = UDim2.new(0, 0, 0, #tabButtons:GetChildren() * 40)
        
        -- Tab methods
        function tab:AddParagraph(options)
            options = options or {}
            local paragraph = {}
            paragraph.Title = options.Title or ""
            paragraph.Content = options.Content or ""
            
            local paragraphFrame = Create("Frame", {
                Name = "Paragraph",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 0),
                LayoutOrder = #tabContentFrame:GetChildren(),
                Parent = tabContentFrame
            })
            
            local titleLabel
            if paragraph.Title ~= "" then
                titleLabel = Create("TextLabel", {
                    Name = "Title",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0, 0),
                    Size = UDim2.new(1, 0, 0, 20),
                    Font = Enum.Font.GothamSemibold,
                    Text = paragraph.Title,
                    TextColor3 = self.Themes[window.Theme].Text,
                    TextSize = 16,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = paragraphFrame
                })
            end
            
            local contentLabel = Create("TextLabel", {
                Name = "Content",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 0, 0, paragraph.Title ~= "" and 25 or 0),
                Size = UDim2.new(1, 0, 0, 0),
                Font = Enum.Font.Gotham,
                Text = paragraph.Content,
                TextColor3 = self.Themes[window.Theme].SubText,
                TextSize = 14,
                TextWrapped = true,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = paragraphFrame
            })
            
            -- Auto-size the content label
            local function updateSize()
                local textBounds = contentLabel.TextBounds
                contentLabel.Size = UDim2.new(1, 0, 0, textBounds.Y)
                
                local totalHeight = contentLabel.Size.Y.Offset
                if titleLabel then
                    totalHeight = totalHeight + titleLabel.Size.Y.Offset + 5
                end
                
                paragraphFrame.Size = UDim2.new(1, 0, 0, totalHeight)
            end
            
            contentLabel:GetPropertyChangedSignal("Text"):Connect(updateSize)
            contentLabel:GetPropertyChangedSignal("TextBounds"):Connect(updateSize)
            updateSize()
            
            return paragraph
        end
        
        function tab:AddButton(options)
            options = options or {}
            local button = {}
            button.Title = options.Title or "Button"
            button.Description = options.Description or ""
            button.Callback = options.Callback or function() end
            
            local buttonFrame = Create("Frame", {
                Name = "Button",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 0),
                LayoutOrder = #tabContentFrame:GetChildren(),
                Parent = tabContentFrame
            })
            
            local buttonElement = Create("TextButton", {
                Name = "ButtonElement",
                BackgroundColor3 = self.Themes[window.Theme].Secondary,
                BorderColor3 = self.Themes[window.Theme].Border,
                BorderSizePixel = 1,
                Position = UDim2.new(0, 0, 0, 0),
                Size = UDim2.new(1, 0, 0, 40),
                Font = Enum.Font.Gotham,
                Text = "",
                TextColor3 = self.Themes[window.Theme].Text,
                TextSize = 14,
                Parent = buttonFrame
            })
            
            local titleLabel = Create("TextLabel", {
                Name = "Title",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 5),
                Size = UDim2.new(1, -20, 0, 20),
                Font = Enum.Font.GothamSemibold,
                Text = button.Title,
                TextColor3 = self.Themes[window.Theme].Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = buttonElement
            })
            
            local descLabel
            if button.Description ~= "" then
                descLabel = Create("TextLabel", {
                    Name = "Description",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 10, 0, 20),
                    Size = UDim2.new(1, -20, 0, 15),
                    Font = Enum.Font.Gotham,
                    Text = button.Description,
                    TextColor3 = self.Themes[window.Theme].SubText,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = buttonElement
                })
            end
            
            -- Hover effects
            buttonElement.MouseEnter:Connect(function()
                Tween(buttonElement, {BackgroundColor3 = self.Themes[window.Theme].Accent}, 0.2)
            end)
            
            buttonElement.MouseLeave:Connect(function()
                Tween(buttonElement, {BackgroundColor3 = self.Themes[window.Theme].Secondary}, 0.2)
            end)
            
            -- Click handler
            buttonElement.MouseButton1Click:Connect(function()
                button.Callback()
            end)
            
            -- Auto-size the frame
            buttonFrame.Size = UDim2.new(1, 0, 0, buttonElement.Size.Y.Offset)
            
            return button
        end
        
        function tab:AddToggle(id, options)
            options = options or {}
            local toggle = {}
            toggle.Title = options.Title or "Toggle"
            toggle.Default = options.Default or false
            toggle.Callback = options.Callback or function() end
            
            -- Store in options
            Fluent.Options[id] = {Value = toggle.Default, Type = "Toggle"}
            
            local toggleFrame = Create("Frame", {
                Name = "Toggle",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 0),
                LayoutOrder = #tabContentFrame:GetChildren(),
                Parent = tabContentFrame
            })
            
            local titleLabel = Create("TextLabel", {
                Name = "Title",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 0, 0, 0),
                Size = UDim2.new(1, -50, 0, 20),
                Font = Enum.Font.Gotham,
                Text = toggle.Title,
                TextColor3 = self.Themes[window.Theme].Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = toggleFrame
            })
            
            local toggleElement = Create("Frame", {
                Name = "ToggleElement",
                BackgroundColor3 = toggle.Default and self.Themes[window.Theme].Primary or self.Themes[window.Theme].Secondary,
                BorderColor3 = self.Themes[window.Theme].Border,
                BorderSizePixel = 1,
                Position = UDim2.new(1, -40, 0, 0),
                Size = UDim2.new(0, 40, 0, 20),
                Parent = toggleFrame
            })
            
            local toggleKnob = Create("Frame", {
                Name = "ToggleKnob",
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BorderSizePixel = 0,
                Position = UDim2.new(0, toggle.Default and 20 or 0, 0, 0),
                Size = UDim2.new(0, 20, 1, 0),
                Parent = toggleElement
            })
            
            local function updateToggle(value)
                Fluent.Options[id].Value = value
                if value then
                    Tween(toggleElement, {BackgroundColor3 = self.Themes[window.Theme].Primary}, 0.2)
                    Tween(toggleKnob, {Position = UDim2.new(0, 20, 0, 0)}, 0.2)
                else
                    Tween(toggleElement, {BackgroundColor3 = self.Themes[window.Theme].Secondary}, 0.2)
                    Tween(toggleKnob, {Position = UDim2.new(0, 0, 0, 0)}, 0.2)
                end
                toggle.Callback(value)
            end
            
            toggleElement.MouseButton1Click:Connect(function()
                local newValue = not Fluent.Options[id].Value
                updateToggle(newValue)
            end)
            
            -- Auto-size the frame
            toggleFrame.Size = UDim2.new(1, 0, 0, titleLabel.Size.Y.Offset)
            
            -- Toggle methods
            function toggle:SetValue(value)
                updateToggle(value)
            end
            
            function toggle:OnChanged(callback)
                toggle.Callback = callback
            end
            
            return toggle
        end
        
        function tab:AddSlider(id, options)
            options = options or {}
            local slider = {}
            slider.Title = options.Title or "Slider"
            slider.Description = options.Description or ""
            slider.Default = options.Default or 50
            slider.Min = options.Min or 0
            slider.Max = options.Max or 100
            slider.Rounding = options.Rounding or 0
            slider.Callback = options.Callback or function() end
            
            -- Store in options
            Fluent.Options[id] = {Value = slider.Default, Type = "Slider"}
            
            local sliderFrame = Create("Frame", {
                Name = "Slider",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 0),
                LayoutOrder = #tabContentFrame:GetChildren(),
                Parent = tabContentFrame
            })
            
            local titleLabel = Create("TextLabel", {
                Name = "Title",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 0, 0, 0),
                Size = UDim2.new(1, 0, 0, 20),
                Font = Enum.Font.Gotham,
                Text = slider.Title,
                TextColor3 = self.Themes[window.Theme].Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = sliderFrame
            })
            
            local descLabel
            if slider.Description ~= "" then
                descLabel = Create("TextLabel", {
                    Name = "Description",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0, 20),
                    Size = UDim2.new(1, 0, 0, 15),
                    Font = Enum.Font.Gotham,
                    Text = slider.Description,
                    TextColor3 = self.Themes[window.Theme].SubText,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = sliderFrame
                })
            end
            
            local sliderTrack = Create("Frame", {
                Name = "SliderTrack",
                BackgroundColor3 = self.Themes[window.Theme].Secondary,
                BorderColor3 = self.Themes[window.Theme].Border,
                BorderSizePixel = 1,
                Position = UDim2.new(0, 0, 0, slider.Description ~= "" and 40 or 25),
                Size = UDim2.new(1, 0, 0, 5),
                Parent = sliderFrame
            })
            
            local sliderFill = Create("Frame", {
                Name = "SliderFill",
                BackgroundColor3 = self.Themes[window.Theme].Primary,
                BorderSizePixel = 0,
                Size = UDim2.new((slider.Default - slider.Min) / (slider.Max - slider.Min), 0, 1, 0),
                Parent = sliderTrack
            })
            
            local sliderKnob = Create("Frame", {
                Name = "SliderKnob",
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BorderColor3 = self.Themes[window.Theme].Border,
                BorderSizePixel = 1,
                Position = UDim2.new((slider.Default - slider.Min) / (slider.Max - slider.Min), -5, 0.5, -5),
                Size = UDim2.new(0, 10, 0, 10),
                AnchorPoint = Vector2.new(0, 0.5),
                Parent = sliderTrack
            })
            
            local valueLabel = Create("TextLabel", {
                Name = "Value",
                BackgroundTransparency = 1,
                Position = UDim2.new(1, 5, 0, slider.Description ~= "" and 40 or 25),
                Size = UDim2.new(0, 50, 0, 20),
                Font = Enum.Font.Gotham,
                Text = tostring(slider.Default),
                TextColor3 = self.Themes[window.Theme].Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Right,
                Parent = sliderFrame
            })
            
            local dragging = false
            
            local function updateSlider(value)
                value = math.clamp(value, slider.Min, slider.Max)
                if slider.Rounding > 0 then
                    value = math.floor(value * (10 ^ slider.Rounding) + 0.5) / (10 ^ slider.Rounding)
                end
                
                Fluent.Options[id].Value = value
                local percent = (value - slider.Min) / (slider.Max - slider.Min)
                sliderFill.Size = UDim2.new(percent, 0, 1, 0)
                sliderKnob.Position = UDim2.new(percent, -5, 0.5, -5)
                valueLabel.Text = tostring(value)
                slider.Callback(value)
            end
            
            sliderTrack.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    local percent = (input.Position.X - sliderTrack.AbsolutePosition.X) / sliderTrack.AbsoluteSize.X
                    local value = slider.Min + (slider.Max - slider.Min) * percent
                    updateSlider(value)
                end
            end)
            
            sliderTrack.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local percent = (input.Position.X - sliderTrack.AbsolutePosition.X) / sliderTrack.AbsoluteSize.X
                    local value = slider.Min + (slider.Max - slider.Min) * math.clamp(percent, 0, 1)
                    updateSlider(value)
                end
            end)
            
            -- Auto-size the frame
            local height = titleLabel.Size.Y.Offset + sliderTrack.Size.Y.Offset + 5
            if descLabel then
                height = height + descLabel.Size.Y.Offset + 5
            end
            sliderFrame.Size = UDim2.new(1, 0, 0, height)
            
            -- Slider methods
            function slider:SetValue(value)
                updateSlider(value)
            end
            
            function slider:OnChanged(callback)
                slider.Callback = callback
            end
            
            return slider
        end
        
        function tab:AddDropdown(id, options)
            options = options or {}
            local dropdown = {}
            dropdown.Title = options.Title or "Dropdown"
            dropdown.Values = options.Values or {}
            dropdown.Multi = options.Multi or false
            dropdown.Default = options.Default or (dropdown.Multi and {} or 1)
            dropdown.Callback = options.Callback or function() end
            
            -- Store in options
            if dropdown.Multi then
                local defaultValues = {}
                for _, value in pairs(dropdown.Default) do
                    defaultValues[value] = true
                end
                Fluent.Options[id] = {Value = defaultValues, Type = "MultiDropdown"}
            else
                Fluent.Options[id] = {Value = dropdown.Default, Type = "Dropdown"}
            end
            
            local dropdownFrame = Create("Frame", {
                Name = "Dropdown",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 0),
                LayoutOrder = #tabContentFrame:GetChildren(),
                Parent = tabContentFrame
            })
            
            local titleLabel = Create("TextLabel", {
                Name = "Title",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 0, 0, 0),
                Size = UDim2.new(1, 0, 0, 20),
                Font = Enum.Font.Gotham,
                Text = dropdown.Title,
                TextColor3 = self.Themes[window.Theme].Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = dropdownFrame
            })
            
            local dropdownButton = Create("TextButton", {
                Name = "DropdownButton",
                BackgroundColor3 = self.Themes[window.Theme].Secondary,
                BorderColor3 = self.Themes[window.Theme].Border,
                BorderSizePixel = 1,
                Position = UDim2.new(0, 0, 0, 25),
                Size = UDim2.new(1, 0, 0, 30),
                Font = Enum.Font.Gotham,
                Text = "",
                TextColor3 = self.Themes[window.Theme].Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = dropdownFrame
            })
            
            local dropdownText = Create("TextLabel", {
                Name = "DropdownText",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 0),
                Size = UDim2.new(1, -30, 1, 0),
                Font = Enum.Font.Gotham,
                Text = dropdown.Multi and "Select..." or tostring(dropdown.Values[dropdown.Default] or "Select..."),
                TextColor3 = self.Themes[window.Theme].Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = dropdownButton
            })
            
            local dropdownIcon = Create("TextLabel", {
                Name = "DropdownIcon",
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -20, 0, 0),
                Size = UDim2.new(0, 20, 1, 0),
                Font = Enum.Font.Gotham,
                Text = "▼",
                TextColor3 = self.Themes[window.Theme].Text,
                TextSize = 14,
                Parent = dropdownButton
            })
            
            local dropdownList = Create("ScrollingFrame", {
                Name = "DropdownList",
                BackgroundColor3 = self.Themes[window.Theme].Secondary,
                BorderColor3 = self.Themes[window.Theme].Border,
                BorderSizePixel = 1,
                Position = UDim2.new(0, 0, 0, 60),
                Size = UDim2.new(1, 0, 0, 0),
                CanvasSize = UDim2.new(0, 0, 0, 0),
                ScrollBarThickness = 3,
                Visible = false,
                Parent = dropdownFrame
            })
            
            local listLayout = Create("UIListLayout", {
                Name = "UIListLayout",
                SortOrder = Enum.SortOrder.LayoutOrder,
                Parent = dropdownList
            })
            
            local function updateDropdownText()
                if dropdown.Multi then
                    local selected = {}
                    for value, state in pairs(Fluent.Options[id].Value) do
                        if state then
                            table.insert(selected, value)
                        end
                    end
                    dropdownText.Text = #selected > 0 and table.concat(selected, ", ") or "Select..."
                else
                    dropdownText.Text = tostring(Fluent.Options[id].Value) or "Select..."
                end
            end
            
            local function createDropdownOptions()
                dropdownList:ClearAllChildren()
                
                for i, value in ipairs(dropdown.Values) do
                    local optionFrame = Create("Frame", {
                        Name = "Option_"..value,
                        BackgroundColor3 = self.Themes[window.Theme].Secondary,
                        BorderSizePixel = 0,
                        Size = UDim2.new(1, 0, 0, 30),
                        LayoutOrder = i,
                        Parent = dropdownList
                    })
                    
                    local optionText = Create("TextLabel", {
                        Name = "Text",
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 10, 0, 0),
                        Size = UDim2.new(1, -30, 1, 0),
                        Font = Enum.Font.Gotham,
                        Text = tostring(value),
                        TextColor3 = self.Themes[window.Theme].Text,
                        TextSize = 14,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Parent = optionFrame
                    })
                    
                    if dropdown.Multi then
                        local checkbox = Create("Frame", {
                            Name = "Checkbox",
                            BackgroundColor3 = Fluent.Options[id].Value[value] and self.Themes[window.Theme].Primary or self.Themes[window.Theme].Secondary,
                            BorderColor3 = self.Themes[window.Theme].Border,
                            BorderSizePixel = 1,
                            Position = UDim2.new(1, -25, 0.5, -7),
                            Size = UDim2.new(0, 14, 0, 14),
                            AnchorPoint = Vector2.new(1, 0.5),
                            Parent = optionFrame
                        })
                        
                        if Fluent.Options[id].Value[value] then
                            local checkmark = Create("TextLabel", {
                                Name = "Checkmark",
                                BackgroundTransparency = 1,
                                Size = UDim2.new(1, 0, 1, 0),
                                Font = Enum.Font.GothamBold,
                                Text = "✓",
                                TextColor3 = Color3.fromRGB(255, 255, 255),
                                TextSize = 12,
                                Parent = checkbox
                            })
                        end
                    else
                        if tostring(Fluent.Options[id].Value) == tostring(value) then
                            local checkmark = Create("TextLabel", {
                                Name = "Checkmark",
                                BackgroundTransparency = 1,
                                Position = UDim2.new(1, -20, 0, 0),
                                Size = UDim2.new(0, 20, 1, 0),
                                Font = Enum.Font.GothamBold,
                                Text = "✓",
                                TextColor3 = self.Themes[window.Theme].Primary,
                                TextSize = 14,
                                Parent = optionFrame
                            })
                        end
                    end
                    
                    optionFrame.MouseButton1Click:Connect(function()
                        if dropdown.Multi then
                            Fluent.Options[id].Value[value] = not Fluent.Options[id].Value[value]
                            createDropdownOptions()
                        else
                            Fluent.Options[id].Value = value
                            dropdownList.Visible = false
                            Tween(dropdownIcon, {Rotation = 0}, 0.2)
                        end
                        updateDropdownText()
                        dropdown.Callback(Fluent.Options[id].Value)
                    end)
                end
                
                dropdownList.CanvasSize = UDim2.new(0, 0, 0, #dropdown.Values * 30)
            end
            
            local function toggleDropdown()
                dropdownList.Visible = not dropdownList.Visible
                if dropdownList.Visible then
                    Tween(dropdownIcon, {Rotation = 180}, 0.2)
                    dropdownList.Size = UDim2.new(1, 0, 0, math.min(#dropdown.Values * 30, 150))
                    createDropdownOptions()
                else
                    Tween(dropdownIcon, {Rotation = 0}, 0.2)
                    dropdownList.Size = UDim2.new(1, 0, 0, 0)
                end
            end
            
            dropdownButton.MouseButton1Click:Connect(toggleDropdown)
            
            -- Initialize
            createDropdownOptions()
            updateDropdownText()
            
            -- Auto-size the frame
            dropdownFrame.Size = UDim2.new(1, 0, 0, dropdownButton.Position.Y.Offset + dropdownButton.Size.Y.Offset + (dropdownList.Visible and dropdownList.Size.Y.Offset or 0))
            
            dropdownList:GetPropertyChangedSignal("Visible"):Connect(function()
                dropdownFrame.Size = UDim2.new(1, 0, 0, dropdownButton.Position.Y.Offset + dropdownButton.Size.Y.Offset + (dropdownList.Visible and dropdownList.Size.Y.Offset or 0))
            end)
            
            -- Dropdown methods
            function dropdown:SetValue(value)
                if dropdown.Multi then
                    if type(value) == "table" then
                        Fluent.Options[id].Value = {}
                        for _, v in pairs(value) do
                            Fluent.Options[id].Value[v] = true
                        end
                    else
                        Fluent.Options[id].Value = {[value] = true}
                    end
                else
                    Fluent.Options[id].Value = value
                end
                updateDropdownText()
                createDropdownOptions()
                dropdown.Callback(Fluent.Options[id].Value)
            end
            
            function dropdown:OnChanged(callback)
                dropdown.Callback = callback
            end
            
            return dropdown
        end
        
        function tab:AddColorpicker(id, options)
            options = options or {}
            local colorpicker = {}
            colorpicker.Title = options.Title or "Colorpicker"
            colorpicker.Default = options.Default or Color3.fromRGB(255, 255, 255)
            colorpicker.Transparency = options.Transparency or 0
            colorpicker.Callback = options.Callback or function() end
            
            -- Store in options
            Fluent.Options[id] = {Value = colorpicker.Default, Transparency = colorpicker.Transparency, Type = "Colorpicker"}
            
            local colorpickerFrame = Create("Frame", {
                Name = "Colorpicker",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 0),
                LayoutOrder = #tabContentFrame:GetChildren(),
                Parent = tabContentFrame
            })
            
            local titleLabel = Create("TextLabel", {
                Name = "Title",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 0, 0, 0),
                Size = UDim2.new(1, -60, 0, 20),
                Font = Enum.Font.Gotham,
                Text = colorpicker.Title,
                TextColor3 = self.Themes[window.Theme].Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = colorpickerFrame
            })
            
            local previewFrame = Create("Frame", {
                Name = "Preview",
                BackgroundColor3 = colorpicker.Default,
                BorderColor3 = self.Themes[window.Theme].Border,
                BorderSizePixel = 1,
                Position = UDim2.new(1, -50, 0, 0),
                Size = UDim2.new(0, 50, 0, 20),
                Parent = colorpickerFrame
            })
            
            local transparencyFrame = Create("Frame", {
                Name = "Transparency",
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BorderColor3 = self.Themes[window.Theme].Border,
                BorderSizePixel = 1,
                Position = UDim2.new(0, 0, 0, 0),
                Size = UDim2.new(1, 0, 1, -colorpicker.Transparency * 20),
                Parent = Create("Frame", {
                    Name = "TransparencyContainer",
                    BackgroundColor3 = Color3.fromRGB(175, 175, 175),
                    BorderSizePixel = 0,
                    Position = UDim2.new(0, 0, 0, 0),
                    Size = UDim2.new(1, 0, 1, 0),
                    Parent = previewFrame
                })
            })
            
            previewFrame.MouseButton1Click:Connect(function()
                -- Color picker would open here
                Fluent:Notify({
                    Title = "Color Picker",
                    Content = "Color picker would open here",
                    Duration = 2
                })
            end)
            
            -- Auto-size the frame
            colorpickerFrame.Size = UDim2.new(1, 0, 0, previewFrame.Position.Y.Offset + previewFrame.Size.Y.Offset)
            
            -- Colorpicker methods
            function colorpicker:SetValue(color, transparency)
                transparency = transparency or colorpicker.Transparency
                previewFrame.BackgroundColor3 = color
                transparencyFrame.Size = UDim2.new(1, 0, 1, -transparency * 20)
                Fluent.Options[id].Value = color
                Fluent.Options[id].Transparency = transparency
                colorpicker.Callback(color, transparency)
            end
            
            function colorpicker:SetValueRGB(color, transparency)
                self:SetValue(color, transparency)
            end
            
            function colorpicker:OnChanged(callback)
                colorpicker.Callback = callback
            end
            
            return colorpicker
        end
        
        function tab:AddKeybind(id, options)
            options = options or {}
            local keybind = {}
            keybind.Title = options.Title or "Keybind"
            keybind.Mode = options.Mode or "Toggle" -- "Always", "Toggle", "Hold"
            keybind.Default = options.Default or "LeftControl"
            keybind.Callback = options.Callback or function() end
            keybind.ChangedCallback = options.ChangedCallback or function() end
            
            -- Store in options
            Fluent.Options[id] = {Value = keybind.Default, Mode = keybind.Mode, Type = "Keybind"}
            
            local keybindFrame = Create("Frame", {
                Name = "Keybind",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 0),
                LayoutOrder = #tabContentFrame:GetChildren(),
                Parent = tabContentFrame
            })
            
            local titleLabel = Create("TextLabel", {
                Name = "Title",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 0, 0, 0),
                Size = UDim2.new(1, -100, 0, 20),
                Font = Enum.Font.Gotham,
                Text = keybind.Title,
                TextColor3 = self.Themes[window.Theme].Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = keybindFrame
            })
            
            local keybindButton = Create("TextButton", {
                Name = "KeybindButton",
                BackgroundColor3 = self.Themes[window.Theme].Secondary,
                BorderColor3 = self.Themes[window.Theme].Border,
                BorderSizePixel = 1,
                Position = UDim2.new(1, -90, 0, 0),
                Size = UDim2.new(0, 90, 0, 20),
                Font = Enum.Font.Gotham,
                Text = keybind.Default,
                TextColor3 = self.Themes[window.Theme].Text,
                TextSize = 14,
                Parent = keybindFrame
            })
            
            local listening = false
            local state = false
            
            local function getKeyName(keyCode)
                if typeof(keyCode) == "EnumItem" then
                    return keyCode.Name
                elseif typeof(keyCode) == "string" then
                    return keyCode
                end
                return "None"
            end
            
            local function setKeybind(key, mode)
                key = key or Fluent.Options[id].Value
                mode = mode or Fluent.Options[id].Mode
                
                Fluent.Options[id].Value = key
                Fluent.Options[id].Mode = mode
                keybindButton.Text = getKeyName(key)
                keybind.ChangedCallback(key)
            end
            
            keybindButton.MouseButton1Click:Connect(function()
                if not listening then
                    listening = true
                    keybindButton.Text = "[...]"
                    keybindButton.BackgroundColor3 = self.Themes[window.Theme].Accent
                    
                    local connection
                    connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
                        if gameProcessed then return end
                        
                        local key
                        if input.UserInputType == Enum.UserInputType.Keyboard then
                            key = input.KeyCode
                        elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
                            key = "MB1"
                        elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
                            key = "MB2"
                        elseif input.UserInputType == Enum.UserInputType.MouseButton3 then
                            key = "MB3"
                        else
                            return
                        end
                        
                        setKeybind(key)
                        listening = false
                        keybindButton.BackgroundColor3 = self.Themes[window.Theme].Secondary
                        connection:Disconnect()
                    end)
                end
            end)
            
            -- Initialize
            setKeybind(keybind.Default, keybind.Mode)
            
            -- Auto-size the frame
            keybindFrame.Size = UDim2.new(1, 0, 0, keybindButton.Position.Y.Offset + keybindButton.Size.Y.Offset)
            
            -- Keybind methods
            function keybind:SetValue(key, mode)
                setKeybind(key, mode)
            end
            
            function keybind:OnClick(callback)
                keybind.Callback = callback
            end
            
            function keybind:OnChanged(callback)
                keybind.ChangedCallback = callback
            end
            
            return keybind
        end
        
        function tab:AddInput(id, options)
            options = options or {}
            local input = {}
            input.Title = options.Title or "Input"
            input.Default = options.Default or ""
            input.Placeholder = options.Placeholder or ""
            input.Numeric = options.Numeric or false
            input.Finished = options.Finished or false
            input.Callback = options.Callback or function() end
            
            -- Store in options
            Fluent.Options[id] = {Value = input.Default, Type = "Input"}
            
            local inputFrame = Create("Frame", {
                Name = "Input",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 0),
                LayoutOrder = #tabContentFrame:GetChildren(),
                Parent = tabContentFrame
            })
            
            local titleLabel = Create("TextLabel", {
                Name = "Title",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 0, 0, 0),
                Size = UDim2.new(1, 0, 0, 20),
                Font = Enum.Font.Gotham,
                Text = input.Title,
                TextColor3 = self.Themes[window.Theme].Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = inputFrame
            })
            
            local inputBox = Create("TextBox", {
                Name = "InputBox",
                BackgroundColor3 = self.Themes[window.Theme].Secondary,
                BorderColor3 = self.Themes[window.Theme].Border,
                BorderSizePixel = 1,
                Position = UDim2.new(0, 0, 0, 25),
                Size = UDim2.new(1, 0, 0, 30),
                Font = Enum.Font.Gotham,
                PlaceholderText = input.Placeholder,
                Text = input.Default,
                TextColor3 = self.Themes[window.Theme].Text,
                TextSize = 14,
                ClearTextOnFocus = false,
                Parent = inputFrame
            })
            
            local function updateInput(value)
                Fluent.Options[id].Value = value
                input.Callback(value)
            end
            
            if input.Numeric then
                inputBox:GetPropertyChangedSignal("Text"):Connect(function()
                    local text = inputBox.Text
                    local newText = text:gsub("[^%d%.%-]", "")
                    
                    if newText ~= text then
                        inputBox.Text = newText
                    end
                end)
            end
            
            if input.Finished then
                inputBox.FocusLost:Connect(function()
                    updateInput(inputBox.Text)
                end)
            else
                inputBox:GetPropertyChangedSignal("Text"):Connect(function()
                    updateInput(inputBox.Text)
                end)
            end
            
            -- Auto-size the frame
            inputFrame.Size = UDim2.new(1, 0, 0, inputBox.Position.Y.Offset + inputBox.Size.Y.Offset)
            
            -- Input methods
            function input:SetValue(value)
                inputBox.Text = tostring(value)
                updateInput(value)
            end
            
            function input:OnChanged(callback)
                input.Callback = callback
            end
            
            return input
        end
        
        return tab
    end
    
    function window:Dialog(options)
        options = options or {}
        local title = options.Title or "Dialog"
        local content = options.Content or ""
        local buttons = options.Buttons or {}
        
        local dialogFrame = Create("Frame", {
            Name = "Dialog",
            BackgroundColor3 = self.Themes[Fluent.CurrentTheme].Secondary,
            BorderColor3 = self.Themes[Fluent.CurrentTheme].Border,
            BorderSizePixel = 1,
            Position = UDim2.new(0.5, -150, 0.5, -75),
            Size = UDim2.new(0, 300, 0, 150),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Parent = LocalPlayer:WaitForChild("PlayerGui")
        })
        
        local titleLabel = Create("TextLabel", {
            Name = "Title",
            BackgroundColor3 = self.Themes[Fluent.CurrentTheme].Primary,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 0, 30),
            Font = Enum.Font.GothamSemibold,
            Text = title,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 16,
            Parent = dialogFrame
        })
        
        local contentLabel = Create("TextLabel", {
            Name = "Content",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 10, 0, 40),
            Size = UDim2.new(1, -20, 0, 70),
            Font = Enum.Font.Gotham,
            Text = content,
            TextColor3 = self.Themes[Fluent.CurrentTheme].Text,
            TextSize = 14,
            TextWrapped = true,
            Parent = dialogFrame
        })
        
        local buttonContainer = Create("Frame", {
            Name = "ButtonContainer",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 10, 1, -40),
            Size = UDim2.new(1, -20, 0, 30),
            Parent = dialogFrame
        })
        
        local uiListLayout = Create("UIListLayout", {
            Name = "UIListLayout",
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Right,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 5),
            Parent = buttonContainer
        })
        
        for i, buttonInfo in ipairs(buttons) do
            local button = Create("TextButton", {
                Name = "Button_"..buttonInfo.Title,
                BackgroundColor3 = self.Themes[Fluent.CurrentTheme].Primary,
                BorderSizePixel = 0,
                Size = UDim2.new(0, 80, 1, 0),
                Font = Enum.Font.Gotham,
                Text = buttonInfo.Title,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 14,
                LayoutOrder = i,
                Parent = buttonContainer
            })
            
            button.MouseButton1Click:Connect(function()
                if buttonInfo.Callback then
                    buttonInfo.Callback()
                end
                dialogFrame:Destroy()
            end)
        end
        
        return dialogFrame
    end
    
    function window:SelectTab(index)
        local tabs = {}
        for _, child in ipairs(tabButtons:GetChildren()) do
            if child:IsA("TextButton") and child.Name:match("TabButton_") then
                table.insert(tabs, child)
            end
        end
        
        if tabs[index] then
            tabs[index]:MouseButton1Click()
        end
    end
    
    return window
end

return Fluent
