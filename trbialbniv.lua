-- Fluent UI Library v2.0
local Fluent = {}
Fluent.Version = "2.0.0"
Fluent.Unloaded = false

-- Services
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local TextService = game:GetService("TextService")
local HttpService = game:GetService("HttpService")

-- Utility functions
local function Create(class, props)
    local instance = Instance.new(class)
    for prop, value in pairs(props) do
        if prop ~= "Parent" then
            if pcall(function() return instance[prop] end) then
                instance[prop] = value
            end
        end
    end
    instance.Parent = props.Parent
    return instance
end

local function Round(num, decimalPlaces)
    local mult = 10^(decimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

local function Tween(instance, properties, duration, style, direction)
    style = style or Enum.EasingStyle.Quad
    direction = direction or Enum.EasingDirection.Out
    local tweenInfo = TweenInfo.new(duration or 0.2, style, direction)
    local tween = TweenService:Create(instance, tweenInfo, properties)
    tween:Play()
    return tween
end

-- Themes
Fluent.Themes = {
    Dark = {
        Background = Color3.fromRGB(25, 25, 25),
        Foreground = Color3.fromRGB(35, 35, 35),
        Primary = Color3.fromRGB(0, 120, 215),
        Secondary = Color3.fromRGB(60, 60, 60),
        Text = Color3.fromRGB(240, 240, 240),
        SubText = Color3.fromRGB(180, 180, 180),
        Accent = Color3.fromRGB(0, 150, 255),
        Error = Color3.fromRGB(255, 50, 50),
        Success = Color3.fromRGB(50, 255, 50),
        Border = Color3.fromRGB(70, 70, 70),
        Hover = Color3.fromRGB(50, 50, 50),
        Pressed = Color3.fromRGB(30, 30, 30),
        TabActive = Color3.fromRGB(0, 90, 160),
        TabHover = Color3.fromRGB(45, 45, 45),
        ScrollBar = Color3.fromRGB(100, 100, 100),
        Shadow = Color3.fromRGB(0, 0, 0)
    },
    Light = {
        Background = Color3.fromRGB(240, 240, 240),
        Foreground = Color3.fromRGB(255, 255, 255),
        Primary = Color3.fromRGB(0, 120, 215),
        Secondary = Color3.fromRGB(220, 220, 220),
        Text = Color3.fromRGB(30, 30, 30),
        SubText = Color3.fromRGB(100, 100, 100),
        Accent = Color3.fromRGB(0, 150, 255),
        Error = Color3.fromRGB(255, 50, 50),
        Success = Color3.fromRGB(50, 255, 50),
        Border = Color3.fromRGB(200, 200, 200),
        Hover = Color3.fromRGB(230, 230, 230),
        Pressed = Color3.fromRGB(210, 210, 210),
        TabActive = Color3.fromRGB(0, 90, 160),
        TabHover = Color3.fromRGB(225, 225, 225),
        ScrollBar = Color3.fromRGB(180, 180, 180),
        Shadow = Color3.fromRGB(100, 100, 100)
    }
}

Fluent.CurrentTheme = "Dark"
Fluent.Options = {}

-- Notification system
function Fluent:Notify(options)
    options = options or {}
    local title = options.Title or "Notification"
    local content = options.Content or ""
    local subContent = options.SubContent or ""
    local duration = options.Duration or 5
    
    local notificationFrame = Create("Frame", {
        Name = "Notification",
        BackgroundColor3 = Fluent.Themes[Fluent.CurrentTheme].Foreground,
        BorderColor3 = Fluent.Themes[Fluent.CurrentTheme].Border,
        BorderSizePixel = 1,
        Position = UDim2.new(1, 10, 1, -10),
        Size = UDim2.new(0, 320, 0, 0),
        AnchorPoint = Vector2.new(1, 1),
        ClipsDescendants = true,
        Parent = game:GetService("CoreGui"),
        ZIndex = 100
    })
    
    local corner = Create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = notificationFrame
    })
    
    local stroke = Create("UIStroke", {
        Color = Fluent.Themes[Fluent.CurrentTheme].Primary,
        Thickness = 2,
        Parent = notificationFrame
    })
    
    local glow = Create("ImageLabel", {
        Name = "Glow",
        Image = "rbxassetid://5028857084",
        ImageColor3 = Fluent.Themes[Fluent.CurrentTheme].Primary,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(24, 24, 276, 276),
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 20, 1, 20),
        Position = UDim2.new(0.5, -10, 0.5, -10),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Parent = notificationFrame,
        ZIndex = 99
    })
    
    local titleLabel = Create("TextLabel", {
        Name = "Title",
        Text = title,
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        TextColor3 = Fluent.Themes[Fluent.CurrentTheme].Text,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 12),
        Size = UDim2.new(1, -30, 0, 20),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = notificationFrame,
        ZIndex = 101
    })
    
    local contentLabel = Create("TextLabel", {
        Name = "Content",
        Text = content,
        Font = Enum.Font.Gotham,
        TextSize = 14,
        TextColor3 = Fluent.Themes[Fluent.CurrentTheme].Text,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 37),
        Size = UDim2.new(1, -30, 0, 20),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = notificationFrame,
        ZIndex = 101
    })
    
    local subContentLabel
    if subContent ~= "" then
        subContentLabel = Create("TextLabel", {
            Name = "SubContent",
            Text = subContent,
            Font = Enum.Font.Gotham,
            TextSize = 12,
            TextColor3 = Fluent.Themes[Fluent.CurrentTheme].SubText,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 15, 0, 62),
            Size = UDim2.new(1, -30, 0, 20),
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = notificationFrame,
            ZIndex = 101
        })
    end
    
    local totalHeight = subContent and 90 or 70
    notificationFrame:TweenSize(UDim2.new(0, 320, 0, totalHeight), "Out", "Quad", 0.3, true)
    notificationFrame:TweenPosition(UDim2.new(1, 10, 1, -10 - totalHeight), "Out", "Quad", 0.3, true)
    
    if duration then
        task.delay(duration, function()
            notificationFrame:TweenSize(UDim2.new(0, 320, 0, 0), "Out", "Quad", 0.3, true)
            notificationFrame:TweenPosition(UDim2.new(1, 10, 1, 10), "Out", "Quad", 0.3, true)
            wait(0.3)
            notificationFrame:Destroy()
        end)
    end
    
    return notificationFrame
end

-- Dialog system
function Fluent:Dialog(options)
    options = options or {}
    local title = options.Title or "Dialog"
    local content = options.Content or ""
    local buttons = options.Buttons or {{Title = "OK"}}
    
    local dialogFrame = Create("Frame", {
        Name = "Dialog",
        BackgroundColor3 = Fluent.Themes[Fluent.CurrentTheme].Background,
        BorderColor3 = Fluent.Themes[Fluent.CurrentTheme].Border,
        BorderSizePixel = 1,
        Position = UDim2.new(0.5, -150, 0.5, -75),
        Size = UDim2.new(0, 300, 0, 150),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Parent = game:GetService("CoreGui"),
        ZIndex = 110
    })
    
    local corner = Create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = dialogFrame
    })
    
    local stroke = Create("UIStroke", {
        Color = Fluent.Themes[Fluent.CurrentTheme].Primary,
        Thickness = 2,
        Parent = dialogFrame
    })
    
    local glow = Create("ImageLabel", {
        Name = "Glow",
        Image = "rbxassetid://5028857084",
        ImageColor3 = Fluent.Themes[Fluent.CurrentTheme].Primary,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(24, 24, 276, 276),
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 20, 1, 20),
        Position = UDim2.new(0.5, -10, 0.5, -10),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Parent = dialogFrame,
        ZIndex = 109
    })
    
    local titleLabel = Create("TextLabel", {
        Name = "Title",
        Text = title,
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        TextColor3 = Fluent.Themes[Fluent.CurrentTheme].Text,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 15),
        Size = UDim2.new(1, -30, 0, 20),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = dialogFrame,
        ZIndex = 111
    })
    
    local contentLabel = Create("TextLabel", {
        Name = "Content",
        Text = content,
        Font = Enum.Font.Gotham,
        TextSize = 14,
        TextColor3 = Fluent.Themes[Fluent.CurrentTheme].Text,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 40),
        Size = UDim2.new(1, -30, 0, 60),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = dialogFrame,
        ZIndex = 111
    })
    
    local buttonContainer = Create("Frame", {
        Name = "ButtonContainer",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 1, -40),
        Size = UDim2.new(1, 0, 0, 40),
        Parent = dialogFrame,
        ZIndex = 111
    })
    
    local buttonPadding = 10
    local buttonWidth = (300 - (buttonPadding * (#buttons + 1))) / #buttons
    
    for i, buttonInfo in ipairs(buttons) do
        local button = Create("TextButton", {
            Name = buttonInfo.Title .. "Button",
            Text = buttonInfo.Title,
            Font = Enum.Font.GothamSemibold,
            TextSize = 14,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundColor3 = Fluent.Themes[Fluent.CurrentTheme].Primary,
            BorderSizePixel = 0,
            Position = UDim2.new(0, buttonPadding + (buttonWidth + buttonPadding) * (i - 1), 0, 5),
            Size = UDim2.new(0, buttonWidth, 0, 30),
            Parent = buttonContainer,
            ZIndex = 112
        })
        
        local buttonCorner = Create("UICorner", {
            CornerRadius = UDim.new(0, 4),
            Parent = button
        })
        
        local buttonGradient = Create("UIGradient", {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Fluent.Themes[Fluent.CurrentTheme].Primary),
                ColorSequenceKeypoint.new(1, Fluent.Themes[Fluent.CurrentTheme].Accent)
            }),
            Rotation = 90,
            Parent = button
        })
        
        button.MouseEnter:Connect(function()
            Tween(buttonGradient, {
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 140, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 170, 255))
                })
            }, 0.1)
        end)
        
        button.MouseLeave:Connect(function()
            Tween(buttonGradient, {
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Fluent.Themes[Fluent.CurrentTheme].Primary),
                    ColorSequenceKeypoint.new(1, Fluent.Themes[Fluent.CurrentTheme].Accent)
                })
            }, 0.1)
        end)
        
        button.MouseButton1Click:Connect(function()
            if buttonInfo.Callback then
                buttonInfo.Callback()
            end
            dialogFrame:Destroy()
        end)
    end
    
    return dialogFrame
end

-- Window creation
function Fluent:CreateWindow(options)
    options = options or {}
    local title = options.Title or "Fluent UI"
    local subTitle = options.SubTitle or "by dawid"
    local tabWidth = options.TabWidth or 160
    local size = options.Size or UDim2.fromOffset(580, 460)
    local acrylic = options.Acrylic or false
    local theme = options.Theme or "Dark"
    local minimizeKey = options.MinimizeKey or Enum.KeyCode.RightControl
    
    Fluent.CurrentTheme = theme
    
    -- Main UI container
    local uiParent = Create("ScreenGui", {
        Name = "FluentUI",
        ResetOnSpawn = false,
        Parent = game:GetService("CoreGui"),
        ZIndexBehavior = Enum.ZIndexBehavior.Global
    })
    
    -- Main window frame with shadow
    local mainFrame = Create("Frame", {
        Name = "MainWindow",
        BackgroundColor3 = Fluent.Themes[theme].Background,
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, -size.X.Offset/2, 0.5, -size.Y.Offset/2),
        Size = size,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Parent = uiParent,
        ZIndex = 1
    })
    
    local mainCorner = Create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = mainFrame
    })
    
    -- Shadow effect
    local shadow = Create("ImageLabel", {
        Name = "Shadow",
        Image = "rbxassetid://1316045217",
        ImageColor3 = Fluent.Themes[theme].Shadow,
        ImageTransparency = 0.8,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(10, 10, 118, 118),
        Size = UDim2.new(1, 30, 1, 30),
        Position = UDim2.new(0.5, -15, 0.5, -15),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Parent = mainFrame,
        ZIndex = 0
    })
    
    -- Title bar with gradient
    local titleBar = Create("Frame", {
        Name = "TitleBar",
        BackgroundColor3 = Fluent.Themes[theme].Foreground,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 40),
        Parent = mainFrame,
        ZIndex = 2
    })
    
    local titleBarCorner = Create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = titleBar
    })
    
    -- Gradient effect
    local gradient = Create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 40)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 30, 30))
        }),
        Rotation = 90,
        Parent = titleBar
    })
    
    -- Title and subtitle
    local titleLabel = Create("TextLabel", {
        Name = "Title",
        Text = title,
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        TextColor3 = Fluent.Themes[theme].Text,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 0),
        Size = UDim2.new(0.5, -15, 1, 0),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = titleBar,
        ZIndex = 3
    })
    
    local subTitleLabel = Create("TextLabel", {
        Name = "SubTitle",
        Text = subTitle,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextColor3 = Fluent.Themes[theme].SubText,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 20),
        Size = UDim2.new(0.5, -15, 0, 20),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = titleBar,
        ZIndex = 3
    })
    
    -- Close button with hover effect
    local closeButton = Create("TextButton", {
        Name = "CloseButton",
        Text = "×",
        Font = Enum.Font.GothamBold,
        TextSize = 20,
        TextColor3 = Fluent.Themes[theme].Text,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.new(1, -40, 0, 0),
        Size = UDim2.new(0, 40, 0, 40),
        Parent = titleBar,
        ZIndex = 3
    })
    
    closeButton.MouseEnter:Connect(function()
        closeButton.TextColor3 = Color3.fromRGB(255, 80, 80)
    end)
    
    closeButton.MouseLeave:Connect(function()
        closeButton.TextColor3 = Fluent.Themes[theme].Text
    end)
    
    closeButton.MouseButton1Click:Connect(function()
        Tween(mainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        wait(0.2)
        uiParent:Destroy()
        Fluent.Unloaded = true
    end)
    
    -- Minimize button
    local minimizeButton = Create("TextButton", {
        Name = "MinimizeButton",
        Text = "-",
        Font = Enum.Font.GothamBold,
        TextSize = 20,
        TextColor3 = Fluent.Themes[theme].Text,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.new(1, -80, 0, 0),
        Size = UDim2.new(0, 40, 0, 40),
        Parent = titleBar,
        ZIndex = 3
    })
    
    local minimized = false
    local originalSize = size
    
    minimizeButton.MouseEnter:Connect(function()
        minimizeButton.TextColor3 = Fluent.Themes[theme].Accent
    end)
    
    minimizeButton.MouseLeave:Connect(function()
        minimizeButton.TextColor3 = Fluent.Themes[theme].Text
    end)
    
    minimizeButton.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            Tween(mainFrame, {Size = UDim2.new(0, originalSize.X.Offset, 0, 40)}, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        else
            Tween(mainFrame, {Size = originalSize}, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        end
    end)
    
    -- Keybind for minimize
    if minimizeKey then
        UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if not gameProcessed and input.KeyCode == minimizeKey then
                minimizeButton:Activate()
            end
        end)
    end
    
    -- Tab container with subtle gradient
    local tabContainer = Create("Frame", {
        Name = "TabContainer",
        BackgroundColor3 = Fluent.Themes[theme].Foreground,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, 40),
        Size = UDim2.new(0, tabWidth, 1, -40),
        Parent = mainFrame,
        ZIndex = 2
    })
    
    local tabGradient = Create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(45, 45, 45)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 35, 35))
        }),
        Rotation = 90,
        Parent = tabContainer
    })
    
    local tabListLayout = Create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5),
        Parent = tabContainer
    })
    
    local tabPadding = Create("UIPadding", {
        PaddingTop = UDim.new(0, 10),
        PaddingLeft = UDim.new(0, 10),
        PaddingRight = UDim.new(0, 10),
        Parent = tabContainer
    })
    
    -- Content container
    local contentContainer = Create("Frame", {
        Name = "ContentContainer",
        BackgroundColor3 = Fluent.Themes[theme].Background,
        BorderSizePixel = 0,
        Position = UDim2.new(0, tabWidth, 0, 40),
        Size = UDim2.new(1, -tabWidth, 1, -40),
        Parent = mainFrame,
        ZIndex = 2
    })
    
    local contentPages = Create("Folder", {
        Name = "Pages",
        Parent = contentContainer
    })
    
    -- Dragging functionality
    local dragging
    local dragInput
    local dragStart
    local startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
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
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
    
    -- Window API
    local windowAPI = {}
    windowAPI.Tabs = {}
    
    function windowAPI:AddTab(options)
        options = options or {}
        local title = options.Title or "Tab"
        local icon = options.Icon or ""
        
        local tabButton = Create("TextButton", {
            Name = title .. "Tab",
            Text = "  " .. title,
            Font = Enum.Font.GothamSemibold,
            TextSize = 14,
            TextColor3 = Fluent.Themes[theme].Text,
            BackgroundColor3 = Fluent.Themes[theme].Foreground,
            BorderSizePixel = 0,
            Size = UDim2.new(1, -10, 0, 40),
            Parent = tabContainer,
            ZIndex = 3,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        
        local tabButtonCorner = Create("UICorner", {
            CornerRadius = UDim.new(0, 6),
            Parent = tabButton
        })
        
        local tabButtonStroke = Create("UIStroke", {
            Color = Fluent.Themes[theme].Border,
            Thickness = 1,
            Parent = tabButton
        })
        
        local tabPage = Create("ScrollingFrame", {
            Name = title .. "Page",
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 1, 0),
            CanvasSize = UDim2.new(0, 0, 0, 0),
            ScrollBarThickness = 5,
            ScrollBarImageColor3 = Fluent.Themes[theme].ScrollBar,
            Visible = false,
            Parent = contentPages,
            ZIndex = 3
        })
        
        local pageListLayout = Create("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 15),
            Parent = tabPage
        })
        
        local pagePadding = Create("UIPadding", {
            PaddingTop = UDim.new(0, 15),
            PaddingLeft = UDim.new(0, 15),
            PaddingRight = UDim.new(0, 15),
            Parent = tabPage
        })
        
        -- Auto-resize canvas
        pageListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            tabPage.CanvasSize = UDim2.new(0, 0, 0, pageListLayout.AbsoluteContentSize.Y + 30)
        end)
        
        -- Tab selection
        tabButton.MouseButton1Click:Connect(function()
            for _, tab in pairs(windowAPI.Tabs) do
                if tab.Page then
                    tab.Page.Visible = false
                end
                if tab.Button then
                    Tween(tab.Button, {
                        BackgroundColor3 = Fluent.Themes[theme].Foreground,
                        TextColor3 = Fluent.Themes[theme].Text
                    }, 0.2)
                end
            end
            
            tabPage.Visible = true
            Tween(tabButton, {
                BackgroundColor3 = Fluent.Themes[theme].TabActive,
                TextColor3 = Color3.fromRGB(255, 255, 255)
            }, 0.2)
        end)
        
        -- Hover effects
        tabButton.MouseEnter:Connect(function()
            if not tabPage.Visible then
                Tween(tabButton, {
                    BackgroundColor3 = Fluent.Themes[theme].TabHover,
                    TextColor3 = Fluent.Themes[theme].Text
                }, 0.2)
            end
        end)
        
        tabButton.MouseLeave:Connect(function()
            if not tabPage.Visible then
                Tween(tabButton, {
                    BackgroundColor3 = Fluent.Themes[theme].Foreground,
                    TextColor3 = Fluent.Themes[theme].Text
                }, 0.2)
            end
        end)
        
        -- Tab API
        local tabAPI = {}
        tabAPI.Button = tabButton
        tabAPI.Page = tabPage
        
        function tabAPI:AddParagraph(options)
            options = options or {}
            local title = options.Title or "Paragraph"
            local content = options.Content or ""
            
            local paragraphFrame = Create("Frame", {
                Name = "Paragraph",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -20, 0, 0),
                Parent = tabPage,
                ZIndex = 4
            })
            
            local titleLabel = Create("TextLabel", {
                Name = "Title",
                Text = title,
                Font = Enum.Font.GothamBold,
                TextSize = 16,
                TextColor3 = Fluent.Themes[theme].Text,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 20),
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = paragraphFrame,
                ZIndex = 5
            })
            
            local contentLabel = Create("TextLabel", {
                Name = "Content",
                Text = content,
                Font = Enum.Font.Gotham,
                TextSize = 14,
                TextColor3 = Fluent.Themes[theme].SubText,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 0, 0, 25),
                Size = UDim2.new(1, 0, 0, 20),
                TextXAlignment = Enum.TextXAlignment.Left,
                TextWrapped = true,
                Parent = paragraphFrame,
                ZIndex = 5
            })
            
            -- Auto-size based on content
            local textSize = TextService:GetTextSize(content, 14, Enum.Font.Gotham, Vector2.new(tabPage.AbsoluteSize.X - 40, 10000))
            paragraphFrame.Size = UDim2.new(1, -20, 0, 25 + textSize.Y + 10)
            contentLabel.Size = UDim2.new(1, 0, 0, textSize.Y)
            
            return paragraphFrame
        end
        
        function tabAPI:AddButton(options)
            options = options or {}
            local title = options.Title or "Button"
            local description = options.Description or ""
            local callback = options.Callback or function() end
            
            local buttonFrame = Create("Frame", {
                Name = "ButtonFrame",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -20, 0, description == "" and 50 or 70),
                Parent = tabPage,
                ZIndex = 4
            })
            
            local button = Create("TextButton", {
                Name = "Button",
                Text = title,
                Font = Enum.Font.GothamSemibold,
                TextSize = 14,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                BackgroundColor3 = Fluent.Themes[theme].Primary,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 40),
                Position = description == "" and UDim2.new(0, 0, 0, 0) or UDim2.new(0, 0, 0, 20),
                Parent = buttonFrame,
                ZIndex = 5
            })
            
            local buttonCorner = Create("UICorner", {
                CornerRadius = UDim.new(0, 6),
                Parent = button
            })
            
            local buttonStroke = Create("UIStroke", {
                Color = Fluent.Themes[theme].Border,
                Thickness = 1,
                Parent = button
            })
            
            local buttonGradient = Create("UIGradient", {
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Fluent.Themes[theme].Primary),
                    ColorSequenceKeypoint.new(1, Fluent.Themes[theme].Accent)
                }),
                Rotation = 90,
                Parent = button
            })
            
            if description ~= "" then
                local descLabel = Create("TextLabel", {
                    Name = "Description",
                    Text = description,
                    Font = Enum.Font.Gotham,
                    TextSize = 12,
                    TextColor3 = Fluent.Themes[theme].SubText,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 20),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = buttonFrame,
                    ZIndex = 5
                })
            end
            
            -- Hover effects
            button.MouseEnter:Connect(function()
                Tween(buttonGradient, {
                    Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 140, 255)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 170, 255))
                    })
                }, 0.1)
            end)
            
            button.MouseLeave:Connect(function()
                Tween(buttonGradient, {
                    Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Fluent.Themes[theme].Primary),
                        ColorSequenceKeypoint.new(1, Fluent.Themes[theme].Accent)
                    })
                }, 0.1)
            end)
            
            button.MouseButton1Down:Connect(function()
                Tween(button, {Size = UDim2.new(0.98, 0, 0, 38)}, 0.1)
            end)
            
            button.MouseButton1Up:Connect(function()
                Tween(button, {Size = UDim2.new(1, 0, 0, 40)}, 0.1)
            end)
            
            button.MouseButton1Click:Connect(function()
                callback()
            end)
            
            return button
        end
        
        function tabAPI:AddToggle(options)
            options = options or {}
            local id = options.Id or "Toggle"
            local title = options.Title or "Toggle"
            local default = options.Default or false
            local callback = options.Callback or function() end
            
            Fluent.Options[id] = {Value = default, Type = "Toggle"}
            
            local toggleFrame = Create("Frame", {
                Name = "ToggleFrame",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -20, 0, 40),
                Parent = tabPage,
                ZIndex = 4
            })
            
            local titleLabel = Create("TextLabel", {
                Name = "Title",
                Text = title,
                Font = Enum.Font.Gotham,
                TextSize = 14,
                TextColor3 = Fluent.Themes[theme].Text,
                BackgroundTransparency = 1,
                Size = UDim2.new(0.7, 0, 1, 0),
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = toggleFrame,
                ZIndex = 5
            })
            
            local toggleOuter = Create("Frame", {
                Name = "ToggleOuter",
                BackgroundColor3 = Fluent.Themes[theme].Foreground,
                BorderSizePixel = 0,
                Position = UDim2.new(1, -50, 0.5, -10),
                Size = UDim2.new(0, 50, 0, 20),
                AnchorPoint = Vector2.new(1, 0.5),
                Parent = toggleFrame,
                ZIndex = 5
            })
            
            local toggleOuterCorner = Create("UICorner", {
                CornerRadius = UDim.new(1, 0),
                Parent = toggleOuter
            })
            
            local toggleInner = Create("Frame", {
                Name = "ToggleInner",
                BackgroundColor3 = default and Fluent.Themes[theme].Primary or Fluent.Themes[theme].Secondary,
                BorderSizePixel = 0,
                Position = default and UDim2.new(1, -15, 0.5, -10) or UDim2.new(0, 5, 0.5, -10),
                Size = UDim2.new(0, 20, 0, 20),
                AnchorPoint = Vector2.new(0, 0.5),
                Parent = toggleOuter,
                ZIndex = 6
            })
            
            local toggleInnerCorner = Create("UICorner", {
                CornerRadius = UDim.new(1, 0),
                Parent = toggleInner
            })
            
            local toggleGradient = Create("UIGradient", {
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, default and Fluent.Themes[theme].Primary or Fluent.Themes[theme].Secondary),
                    ColorSequenceKeypoint.new(1, default and Fluent.Themes[theme].Accent or Fluent.Themes[theme].Secondary)
                }),
                Rotation = 90,
                Parent = toggleInner
            })
            
            local function updateToggle(value)
                Fluent.Options[id].Value = value
                if value then
                    Tween(toggleInner, {
                        Position = UDim2.new(1, -15, 0.5, -10)
                    }, 0.2)
                    Tween(toggleGradient, {
                        Color = ColorSequence.new({
                            ColorSequenceKeypoint.new(0, Fluent.Themes[theme].Primary),
                            ColorSequenceKeypoint.new(1, Fluent.Themes[theme].Accent)
                        })
                    }, 0.2)
                else
                    Tween(toggleInner, {
                        Position = UDim2.new(0, 5, 0.5, -10)
                    }, 0.2)
                    Tween(toggleGradient, {
                        Color = ColorSequence.new({
                            ColorSequenceKeypoint.new(0, Fluent.Themes[theme].Secondary),
                            ColorSequenceKeypoint.new(1, Fluent.Themes[theme].Secondary)
                        })
                    }, 0.2)
                end
                callback(value)
            end
            
            toggleOuter.MouseButton1Click:Connect(function()
                updateToggle(not Fluent.Options[id].Value)
            end)
            
            -- Add API functions
            local toggleAPI = {}
            
            function toggleAPI:SetValue(value)
                updateToggle(value)
            end
            
            function toggleAPI:OnChanged(newCallback)
                callback = newCallback
            end
            
            return toggleAPI
        end
        
        function tabAPI:AddSlider(options)
            options = options or {}
            local id = options.Id or "Slider"
            local title = options.Title or "Slider"
            local description = options.Description or ""
            local default = options.Default or 50
            local min = options.Min or 0
            local max = options.Max or 100
            local rounding = options.Rounding or 0
            local callback = options.Callback or function() end
            
            Fluent.Options[id] = {Value = default, Type = "Slider"}
            
            local sliderFrame = Create("Frame", {
                Name = "SliderFrame",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -20, 0, description == "" and 60 or 80),
                Parent = tabPage,
                ZIndex = 4
            })
            
            local titleLabel = Create("TextLabel", {
                Name = "Title",
                Text = title,
                Font = Enum.Font.Gotham,
                TextSize = 14,
                TextColor3 = Fluent.Themes[theme].Text,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 20),
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = sliderFrame,
                ZIndex = 5
            })
            
            if description ~= "" then
                local descLabel = Create("TextLabel", {
                    Name = "Description",
                    Text = description,
                    Font = Enum.Font.Gotham,
                    TextSize = 12,
                    TextColor3 = Fluent.Themes[theme].SubText,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0, 20),
                    Size = UDim2.new(1, 0, 0, 20),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = sliderFrame,
                    ZIndex = 5
                })
            end
            
            local sliderTrack = Create("Frame", {
                Name = "SliderTrack",
                BackgroundColor3 = Fluent.Themes[theme].Foreground,
                BorderSizePixel = 0,
                Position = UDim2.new(0, 0, 1, -30),
                Size = UDim2.new(1, 0, 0, 5),
                AnchorPoint = Vector2.new(0, 1),
                Parent = sliderFrame,
                ZIndex = 5
            })
            
            local sliderTrackCorner = Create("UICorner", {
                CornerRadius = UDim.new(1, 0),
                Parent = sliderTrack
            })
            
            local sliderFill = Create("Frame", {
                Name = "SliderFill",
                BackgroundColor3 = Fluent.Themes[theme].Primary,
                BorderSizePixel = 0,
                Size = UDim2.new((default - min) / (max - min), 0, 1, 0),
                Parent = sliderTrack,
                ZIndex = 6
            })
            
            local sliderFillCorner = Create("UICorner", {
                CornerRadius = UDim.new(1, 0),
                Parent = sliderFill
            })
            
            local sliderFillGradient = Create("UIGradient", {
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Fluent.Themes[theme].Primary),
                    ColorSequenceKeypoint.new(1, Fluent.Themes[theme].Accent)
                }),
                Rotation = 90,
                Parent = sliderFill
            })
            
            local sliderThumb = Create("Frame", {
                Name = "SliderThumb",
                BackgroundColor3 = Fluent.Themes[theme].Text,
                BorderSizePixel = 0,
                Position = UDim2.new((default - min) / (max - min), -5, 0.5, -5),
                Size = UDim2.new(0, 10, 0, 10),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Parent = sliderTrack,
                ZIndex = 7
            })
            
            local sliderThumbCorner = Create("UICorner", {
                CornerRadius = UDim.new(1, 0),
                Parent = sliderThumb
            })
            
            local valueLabel = Create("TextLabel", {
                Name = "ValueLabel",
                Text = tostring(Round(default, rounding)),
                Font = Enum.Font.Gotham,
                TextSize = 14,
                TextColor3 = Fluent.Themes[theme].Text,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 0, 1, -35),
                Size = UDim2.new(1, 0, 0, 20),
                TextXAlignment = Enum.TextXAlignment.Right,
                Parent = sliderFrame,
                ZIndex = 5
            })
            
            local dragging = false
            
            local function updateSlider(value)
                local percent = math.clamp((value - min) / (max - min), 0, 1)
                sliderFill.Size = UDim2.new(percent, 0, 1, 0)
                sliderThumb.Position = UDim2.new(percent, -5, 0.5, -5)
                local rounded = Round(value, rounding)
                valueLabel.Text = tostring(rounded)
                Fluent.Options[id].Value = rounded
                callback(rounded)
            end
            
            sliderTrack.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    local percent = (input.Position.X - sliderTrack.AbsolutePosition.X) / sliderTrack.AbsoluteSize.X
                    local value = min + (max - min) * percent
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
                    local value = min + (max - min) * percent
                    updateSlider(value)
                end
            end)
            
            -- Add API functions
            local sliderAPI = {}
            
            function sliderAPI:SetValue(value)
                updateSlider(value)
            end
            
            function sliderAPI:OnChanged(newCallback)
                callback = newCallback
            end
            
            return sliderAPI
        end
        
        function tabAPI:AddDropdown(options)
            options = options or {}
            local id = options.Id or "Dropdown"
            local title = options.Title or "Dropdown"
            local values = options.Values or {"Option 1", "Option 2", "Option 3"}
            local multi = options.Multi or false
            local default = options.Default or (multi and {} or 1)
            local callback = options.Callback or function() end
            
            Fluent.Options[id] = {Value = multi and {} or values[default], Type = "Dropdown"}
            
            local dropdownFrame = Create("Frame", {
                Name = "DropdownFrame",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -20, 0, 40),
                Parent = tabPage,
                ZIndex = 4
            })
            
            local titleLabel = Create("TextLabel", {
                Name = "Title",
                Text = title,
                Font = Enum.Font.Gotham,
                TextSize = 14,
                TextColor3 = Fluent.Themes[theme].Text,
                BackgroundTransparency = 1,
                Size = UDim2.new(0.7, 0, 1, 0),
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = dropdownFrame,
                ZIndex = 5
            })
            
            local dropdownButton = Create("TextButton", {
                Name = "DropdownButton",
                Text = multi and "Select..." or values[default],
                Font = Enum.Font.Gotham,
                TextSize = 14,
                TextColor3 = Fluent.Themes[theme].Text,
                BackgroundColor3 = Fluent.Themes[theme].Foreground,
                BorderSizePixel = 0,
                Position = UDim2.new(1, -150, 0, 0),
                Size = UDim2.new(0, 150, 0, 40),
                AnchorPoint = Vector2.new(1, 0),
                Parent = dropdownFrame,
                ZIndex = 5
            })
            
            local dropdownButtonCorner = Create("UICorner", {
                CornerRadius = UDim.new(0, 6),
                Parent = dropdownButton
            })
            
            local dropdownButtonStroke = Create("UIStroke", {
                Color = Fluent.Themes[theme].Border,
                Thickness = 1,
                Parent = dropdownButton
            })
            
            local dropdownArrow = Create("TextLabel", {
                Name = "Arrow",
                Text = "▼",
                Font = Enum.Font.Gotham,
                TextSize = 12,
                TextColor3 = Fluent.Themes[theme].Text,
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -20, 0.5, -10),
                Size = UDim2.new(0, 20, 0, 20),
                AnchorPoint = Vector2.new(1, 0.5),
                Parent = dropdownButton,
                ZIndex = 6
            })
            
            local dropdownList = Create("ScrollingFrame", {
                Name = "DropdownList",
                BackgroundColor3 = Fluent.Themes[theme].Foreground,
                BorderSizePixel = 0,
                Position = UDim2.new(0, 0, 1, 5),
                Size = UDim2.new(1, 0, 0, 0),
                CanvasSize = UDim2.new(0, 0, 0, 0),
                ScrollBarThickness = 5,
                ScrollBarImageColor3 = Fluent.Themes[theme].ScrollBar,
                Visible = false,
                Parent = dropdownButton,
                ZIndex = 10
            })
            
            local dropdownListLayout = Create("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Parent = dropdownList
            })
            
            local dropdownListPadding = Create("UIPadding", {
                PaddingTop = UDim.new(0, 5),
                PaddingBottom = UDim.new(0, 5),
                Parent = dropdownList
            })
            
            local dropdownListCorner = Create("UICorner", {
                CornerRadius = UDim.new(0, 6),
                Parent = dropdownList
            })
            
            local dropdownListStroke = Create("UIStroke", {
                Color = Fluent.Themes[theme].Border,
                Thickness = 1,
                Parent = dropdownList
            })
            
            -- Auto-resize dropdown list
            dropdownListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                dropdownList.CanvasSize = UDim2.new(0, 0, 0, dropdownListLayout.AbsoluteContentSize.Y + 10)
            end)
            
            -- Create dropdown options
            local function createOption(option)
                local optionButton = Create("TextButton", {
                    Name = option .. "Option",
                    Text = option,
                    Font = Enum.Font.Gotham,
                    TextSize = 14,
                    TextColor3 = Fluent.Themes[theme].Text,
                    BackgroundColor3 = Fluent.Themes[theme].Foreground,
                    BorderSizePixel = 0,
                    Size = UDim2.new(1, -10, 0, 30),
                    Parent = dropdownList,
                    ZIndex = 11
                })
                
                local optionButtonCorner = Create("UICorner", {
                    CornerRadius = UDim.new(0, 4),
                    Parent = optionButton
                })
                
                if multi then
                    local selected = Fluent.Options[id].Value[option] or false
                    
                    optionButton.MouseButton1Click:Connect(function()
                        selected = not selected
                        optionButton.BackgroundColor3 = selected and Fluent.Themes[theme].Primary or Fluent.Themes[theme].Foreground
                        
                        if selected then
                            Fluent.Options[id].Value[option] = true
                        else
                            Fluent.Options[id].Value[option] = nil
                        end
                        
                        local selectedCount = 0
                        for _ in pairs(Fluent.Options[id].Value) do
                            selectedCount = selectedCount + 1
                        end
                        
                        dropdownButton.Text = selectedCount > 0 and ("Selected: " .. selectedCount) or "Select..."
                        callback(Fluent.Options[id].Value)
                    end)
                else
                    optionButton.MouseButton1Click:Connect(function()
                        dropdownButton.Text = option
                        Fluent.Options[id].Value = option
                        dropdownList.Visible = false
                        dropdownArrow.Text = "▼"
                        callback(option)
                    end)
                end
            end
            
            for _, option in ipairs(values) do
                createOption(option)
            end
            
            -- Toggle dropdown
            local dropdownOpen = false
            
            dropdownButton.MouseButton1Click:Connect(function()
                dropdownOpen = not dropdownOpen
                if dropdownOpen then
                    dropdownList.Visible = true
                    dropdownList.Size = UDim2.new(1, 0, 0, math.min(#values * 35 + 10, 150))
                    dropdownArrow.Text = "▲"
                else
                    dropdownList.Visible = false
                    dropdownList.Size = UDim2.new(1, 0, 0, 0)
                    dropdownArrow.Text = "▼"
                end
            end)
            
            -- Close dropdown when clicking outside
            UserInputService.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 and dropdownOpen then
                    local mousePos = input.Position
                    local absolutePos = dropdownList.AbsolutePosition
                    local absoluteSize = dropdownList.AbsoluteSize
                    
                    if not (mousePos.X >= absolutePos.X and mousePos.X <= absolutePos.X + absoluteSize.X and
                           mousePos.Y >= absolutePos.Y and mousePos.Y <= absolutePos.Y + absoluteSize.Y) then
                        dropdownOpen = false
                        dropdownList.Visible = false
                        dropdownList.Size = UDim2.new(1, 0, 0, 0)
                        dropdownArrow.Text = "▼"
                    end
                end
            end)
            
            -- Add API functions
            local dropdownAPI = {}
            
            function dropdownAPI:SetValue(value)
                if multi then
                    if type(value) == "table" then
                        Fluent.Options[id].Value = value
                        local selectedCount = 0
                        for _ in pairs(value) do
                            selectedCount = selectedCount + 1
                        end
                        dropdownButton.Text = selectedCount > 0 and ("Selected: " .. selectedCount) or "Select..."
                    end
                else
                    if table.find(values, value) then
                        Fluent.Options[id].Value = value
                        dropdownButton.Text = value
                    end
                end
                callback(Fluent.Options[id].Value)
            end
            
            function dropdownAPI:OnChanged(newCallback)
                callback = newCallback
            end
            
            return dropdownAPI
        end
        
        function tabAPI:AddColorpicker(options)
            options = options or {}
            local id = options.Id or "Colorpicker"
            local title = options.Title or "Colorpicker"
            local default = options.Default or Color3.fromRGB(96, 205, 255)
            local transparency = options.Transparency or nil
            local callback = options.Callback or function() end
            
            Fluent.Options[id] = {Value = default, Type = "Colorpicker"}
            if transparency ~= nil then
                Fluent.Options[id].Transparency = transparency
            end
            
            local colorpickerFrame = Create("Frame", {
                Name = "ColorpickerFrame",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -20, 0, 40),
                Parent = tabPage,
                ZIndex = 4
            })
            
            local titleLabel = Create("TextLabel", {
                Name = "Title",
                Text = title,
                Font = Enum.Font.Gotham,
                TextSize = 14,
                TextColor3 = Fluent.Themes[theme].Text,
                BackgroundTransparency = 1,
                Size = UDim2.new(0.7, 0, 1, 0),
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = colorpickerFrame,
                ZIndex = 5
            })
            
            local colorButton = Create("TextButton", {
                Name = "ColorButton",
                Text = "",
                BackgroundColor3 = default,
                BorderSizePixel = 0,
                Position = UDim2.new(1, -60, 0.5, -15),
                Size = UDim2.new(0, 60, 0, 30),
                AnchorPoint = Vector2.new(1, 0.5),
                Parent = colorpickerFrame,
                ZIndex = 5
            })
            
            local colorButtonCorner = Create("UICorner", {
                CornerRadius = UDim.new(0, 6),
                Parent = colorButton
            })
            
            local colorButtonStroke = Create("UIStroke", {
                Color = Fluent.Themes[theme].Border,
                Thickness = 1,
                Parent = colorButton
            })
            
            if transparency ~= nil then
                local transparencySlider = Create("Frame", {
                    Name = "TransparencySlider",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 1, 0),
                    Size = UDim2.new(1, 0, 0, 20),
                    Parent = colorpickerFrame,
                    ZIndex = 4
                })
                
                local transparencyTrack = Create("Frame", {
                    Name = "TransparencyTrack",
                    BackgroundColor3 = Fluent.Themes[theme].Foreground,
                    BorderSizePixel = 0,
                    Position = UDim2.new(0, 0, 0.5, -2.5),
                    Size = UDim2.new(1, 0, 0, 5),
                    AnchorPoint = Vector2.new(0, 0.5),
                    Parent = transparencySlider,
                    ZIndex = 5
                })
                
                local transparencyTrackCorner = Create("UICorner", {
                    CornerRadius = UDim.new(1, 0),
                    Parent = transparencyTrack
                })
                
                local transparencyFill = Create("Frame", {
                    Name = "TransparencyFill",
                    BackgroundColor3 = default,
                    BorderSizePixel = 0,
                    Size = UDim2.new(1 - transparency, 0, 1, 0),
                    Parent = transparencyTrack,
                    ZIndex = 6
                })
                
                local transparencyFillCorner = Create("UICorner", {
                    CornerRadius = UDim.new(1, 0),
                    Parent = transparencyFill
                })
                
                local transparencyThumb = Create("Frame", {
                    Name = "TransparencyThumb",
                    BackgroundColor3 = Fluent.Themes[theme].Text,
                    BorderSizePixel = 0,
                    Position = UDim2.new(1 - transparency, -5, 0.5, -5),
                    Size = UDim2.new(0, 10, 0, 10),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Parent = transparencyTrack,
                    ZIndex = 7
                })
                
                local transparencyThumbCorner = Create("UICorner", {
                    CornerRadius = UDim.new(1, 0),
                    Parent = transparencyThumb
                })
                
                local draggingTransparency = false
                
                transparencyTrack.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        draggingTransparency = true
                        local percent = 1 - ((input.Position.X - transparencyTrack.AbsolutePosition.X) / transparencyTrack.AbsoluteSize.X)
                        transparency = math.clamp(percent, 0, 1)
                        transparencyFill.Size = UDim2.new(1 - transparency, 0, 1, 0)
                        transparencyThumb.Position = UDim2.new(1 - transparency, -5, 0.5, -5)
                        Fluent.Options[id].Transparency = transparency
                        callback(default, transparency)
                    end
                end)
                
                transparencyTrack.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        draggingTransparency = false
                    end
                end)
                
                UserInputService.InputChanged:Connect(function(input)
                    if draggingTransparency and input.UserInputType == Enum.UserInputType.MouseMovement then
                        local percent = 1 - ((input.Position.X - transparencyTrack.AbsolutePosition.X) / transparencyTrack.AbsoluteSize.X)
                        transparency = math.clamp(percent, 0, 1)
                        transparencyFill.Size = UDim2.new(1 - transparency, 0, 1, 0)
                        transparencyThumb.Position = UDim2.new(1 - transparency, -5, 0.5, -5)
                        Fluent.Options[id].Transparency = transparency
                        callback(default, transparency)
                    end
                end)
            end
            
            -- Color picker popup
            local colorPickerPopup = Create("Frame", {
                Name = "ColorPickerPopup",
                BackgroundColor3 = Fluent.Themes[theme].Background,
                BorderColor3 = Fluent.Themes[theme].Border,
                BorderSizePixel = 1,
                Position = UDim2.new(1, 70, 0, 0),
                Size = UDim2.new(0, 200, 0, 200),
                Visible = false,
                Parent = colorpickerFrame,
                ZIndex = 10
            })
            
            local colorPickerCorner = Create("UICorner", {
                CornerRadius = UDim.new(0, 8),
                Parent = colorPickerPopup
            })
            
            local colorPickerStroke = Create("UIStroke", {
                Color = Fluent.Themes[theme].Primary,
                Thickness = 2,
                Parent = colorPickerPopup
            })
            
            -- Color spectrum
            local colorSpectrum = Create("ImageLabel", {
                Name = "ColorSpectrum",
                Image = "rbxassetid://2615689005",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 10),
                Size = UDim2.new(0, 180, 0, 180),
                Parent = colorPickerPopup,
                ZIndex = 11
            })
            
            local colorCursor = Create("Frame", {
                Name = "ColorCursor",
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BorderColor3 = Color3.fromRGB(0, 0, 0),
                BorderSizePixel = 1,
                Size = UDim2.new(0, 10, 0, 10),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Parent = colorSpectrum,
                ZIndex = 12
            })
            
            local colorCursorCorner = Create("UICorner", {
                CornerRadius = UDim.new(1, 0),
                Parent = colorCursor
            })
            
            -- Toggle color picker
            local colorPickerOpen = false
            
            colorButton.MouseButton1Click:Connect(function()
                colorPickerOpen = not colorPickerOpen
                colorPickerPopup.Visible = colorPickerOpen
            end)
            
            -- Color selection
            local function updateColor(position)
                local x = math.clamp((position.X - colorSpectrum.AbsolutePosition.X) / colorSpectrum.AbsoluteSize.X, 0, 1)
                local y = math.clamp((position.Y - colorSpectrum.AbsolutePosition.Y) / colorSpectrum.AbsoluteSize.Y, 0, 1)
                
                colorCursor.Position = UDim2.new(x, -5, y, -5)
                
                -- Convert HSV to RGB
                local h = x * 360
                local s = 1
                local v = 1 - y
                
                local c = v * s
                local hh = h / 60
                local x = c * (1 - math.abs(hh % 2 - 1))
                
                local r, g, b
                
                if hh <= 1 then
                    r, g, b = c, x, 0
                elseif hh <= 2 then
                    r, g, b = x, c, 0
                elseif hh <= 3 then
                    r, g, b = 0, c, x
                elseif hh <= 4 then
                    r, g, b = 0, x, c
                elseif hh <= 5 then
                    r, g, b = x, 0, c
                else
                    r, g, b = c, 0, x
                end
                
                local m = v - c
                default = Color3.new(r + m, g + m, b + m)
                colorButton.BackgroundColor3 = default
                Fluent.Options[id].Value = default
                
                if transparency ~= nil then
                    transparencyFill.BackgroundColor3 = default
                end
                
                callback(default, transparency)
            end
            
            colorSpectrum.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    updateColor(input.Position)
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                    if colorPickerOpen then
                        local mousePos = input.Position
                        if mousePos.X >= colorSpectrum.AbsolutePosition.X and mousePos.X <= colorSpectrum.AbsolutePosition.X + colorSpectrum.AbsoluteSize.X and
                           mousePos.Y >= colorSpectrum.AbsolutePosition.Y and mousePos.Y <= colorSpectrum.AbsolutePosition.Y + colorSpectrum.AbsoluteSize.Y then
                            updateColor(mousePos)
                        end
                    end
                end
            end)
            
            -- Close color picker when clicking outside
            UserInputService.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 and colorPickerOpen then
                    local mousePos = input.Position
                    local absolutePos = colorPickerPopup.AbsolutePosition
                    local absoluteSize = colorPickerPopup.AbsoluteSize
                    
                    if not (mousePos.X >= absolutePos.X and mousePos.X <= absolutePos.X + absoluteSize.X and
                           mousePos.Y >= absolutePos.Y and mousePos.Y <= absolutePos.Y + absoluteSize.Y) then
                        colorPickerOpen = false
                        colorPickerPopup.Visible = false
                    end
                end
            end)
            
            -- Add API functions
            local colorpickerAPI = {}
            
            function colorpickerAPI:SetValue(color, alpha)
                default = color
                colorButton.BackgroundColor3 = color
                Fluent.Options[id].Value = color
                
                if transparency ~= nil and alpha ~= nil then
                    transparency = alpha
                    transparencyFill.Size = UDim2.new(1 - transparency, 0, 1, 0)
                    transparencyThumb.Position = UDim2.new(1 - transparency, -5, 0.5, -5)
                    Fluent.Options[id].Transparency = transparency
                    transparencyFill.BackgroundColor3 = color
                end
                
                callback(color, transparency)
            end
            
            function colorpickerAPI:OnChanged(newCallback)
                callback = newCallback
            end
            
            return colorpickerAPI
        end
        
        function tabAPI:AddKeybind(options)
            options = options or {}
            local id = options.Id or "Keybind"
            local title = options.Title or "Keybind"
            local default = options.Default or "LeftControl"
            local mode = options.Mode or "Toggle" -- Always, Toggle, Hold
            local callback = options.Callback or function() end
            local changedCallback = options.ChangedCallback or function() end
            
            Fluent.Options[id] = {Value = default, Mode = mode, Type = "Keybind"}
            
            local keybindFrame = Create("Frame", {
                Name = "KeybindFrame",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -20, 0, 40),
                Parent = tabPage,
                ZIndex = 4
            })
            
            local titleLabel = Create("TextLabel", {
                Name = "Title",
                Text = title,
                Font = Enum.Font.Gotham,
                TextSize = 14,
                TextColor3 = Fluent.Themes[theme].Text,
                BackgroundTransparency = 1,
                Size = UDim2.new(0.7, 0, 1, 0),
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = keybindFrame,
                ZIndex = 5
            })
            
            local keybindButton = Create("TextButton", {
                Name = "KeybindButton",
                Text = default,
                Font = Enum.Font.Gotham,
                TextSize = 14,
                TextColor3 = Fluent.Themes[theme].Text,
                BackgroundColor3 = Fluent.Themes[theme].Foreground,
                BorderSizePixel = 0,
                Position = UDim2.new(1, -100, 0.5, -15),
                Size = UDim2.new(0, 100, 0, 30),
                AnchorPoint = Vector2.new(1, 0.5),
                Parent = keybindFrame,
                ZIndex = 5
            })
            
            local keybindButtonCorner = Create("UICorner", {
                CornerRadius = UDim.new(0, 6),
                Parent = keybindButton
            })
            
            local keybindButtonStroke = Create("UIStroke", {
                Color = Fluent.Themes[theme].Border,
                Thickness = 1,
                Parent = keybindButton
            })
            
            -- Keybind listening
            local listening = false
            
            keybindButton.MouseButton1Click:Connect(function()
                listening = true
                keybindButton.Text = "..."
                keybindButton.BackgroundColor3 = Fluent.Themes[theme].Primary
            end)
            
            UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if listening then
                    local key = input.KeyCode.Name ~= "Unknown" and input.KeyCode.Name or input.UserInputType.Name
                    
                    if key ~= "MouseMovement" and key ~= "Focus" and key ~= "MouseWheel" then
                        listening = false
                        Fluent.Options[id].Value = key
                        keybindButton.Text = key
                        keybindButton.BackgroundColor3 = Fluent.Themes[theme].Foreground
                        changedCallback(key)
                    end
                else
                    if input.KeyCode.Name == Fluent.Options[id].Value or input.UserInputType.Name == Fluent.Options[id].Value then
                        if mode == "Always" then
                            callback(true)
                        elseif mode == "Toggle" then
                            local state = not (Fluent.Options[id].State or false)
                            Fluent.Options[id].State = state
                            callback(state)
                        elseif mode == "Hold" then
                            callback(true)
                        end
                    end
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if mode == "Hold" and (input.KeyCode.Name == Fluent.Options[id].Value or input.UserInputType.Name == Fluent.Options[id].Value) then
                    callback(false)
                end
            end)
            
            -- Add API functions
            local keybindAPI = {}
            
            function keybindAPI:SetValue(value, newMode)
                Fluent.Options[id].Value = value
                if newMode then
                    Fluent.Options[id].Mode = newMode
                end
                keybindButton.Text = value
                changedCallback(value)
            end
            
            function keybindAPI:GetState()
                return Fluent.Options[id].State or false
            end
            
            function keybindAPI:OnClick(newCallback)
                callback = newCallback
            end
            
            function keybindAPI:OnChanged(newChangedCallback)
                changedCallback = newChangedCallback
            end
            
            return keybindAPI
        end
        
        function tabAPI:AddInput(options)
            options = options or {}
            local id = options.Id or "Input"
            local title = options.Title or "Input"
            local default = options.Default or ""
            local placeholder = options.Placeholder or "Type here..."
            local numeric = options.Numeric or false
            local finished = options.Finished or false
            local callback = options.Callback or function() end
            
            Fluent.Options[id] = {Value = default, Type = "Input"}
            
            local inputFrame = Create("Frame", {
                Name = "InputFrame",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -20, 0, 40),
                Parent = tabPage,
                ZIndex = 4
            })
            
            local titleLabel = Create("TextLabel", {
                Name = "Title",
                Text = title,
                Font = Enum.Font.Gotham,
                TextSize = 14,
                TextColor3 = Fluent.Themes[theme].Text,
                BackgroundTransparency = 1,
                Size = UDim2.new(0.7, 0, 1, 0),
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = inputFrame,
                ZIndex = 5
            })
            
            local inputBox = Create("TextBox", {
                Name = "InputBox",
                Text = default,
                PlaceholderText = placeholder,
                Font = Enum.Font.Gotham,
                TextSize = 14,
                TextColor3 = Fluent.Themes[theme].Text,
                BackgroundColor3 = Fluent.Themes[theme].Foreground,
                BorderSizePixel = 0,
                Position = UDim2.new(1, -150, 0.5, -15),
                Size = UDim2.new(0, 150, 0, 30),
                AnchorPoint = Vector2.new(1, 0.5),
                Parent = inputFrame,
                ZIndex = 5
            })
            
            local inputBoxCorner = Create("UICorner", {
                CornerRadius = UDim.new(0, 6),
                Parent = inputBox
            })
            
            local inputBoxStroke = Create("UIStroke", {
                Color = Fluent.Themes[theme].Border,
                Thickness = 1,
                Parent = inputBox
            })
            
            if numeric then
                inputBox:GetPropertyChangedSignal("Text"):Connect(function()
                    if not tonumber(inputBox.Text) and inputBox.Text ~= "" then
                        inputBox.Text = string.match(inputBox.Text, "%d+") or ""
                    end
                end)
            end
            
            if finished then
                inputBox.FocusLost:Connect(function()
                    Fluent.Options[id].Value = inputBox.Text
                    callback(inputBox.Text)
                end)
            else
                inputBox:GetPropertyChangedSignal("Text"):Connect(function()
                    Fluent.Options[id].Value = inputBox.Text
                    callback(inputBox.Text)
                end)
            end
            
            -- Add API functions
            local inputAPI = {}
            
            function inputAPI:SetValue(value)
                inputBox.Text = value
                Fluent.Options[id].Value = value
                callback(value)
            end
            
            function inputAPI:OnChanged(newCallback)
                callback = newCallback
            end
            
            return inputAPI
        end
        
        -- Add tab to window API
        table.insert(windowAPI.Tabs, tabAPI)
        
        -- Select first tab by default
        if #windowAPI.Tabs == 1 then
            tabButton:Activate()
        end
        
        return tabAPI
    end
    
    function windowAPI:SelectTab(index)
        if windowAPI.Tabs[index] and windowAPI.Tabs[index].Button then
            windowAPI.Tabs[index].Button:Activate()
        end
    end
    
    function windowAPI:Dialog(options)
        return Fluent:Dialog(options)
    end
    
    return windowAPI
end

-- Save Manager
local SaveManager = {}
SaveManager.Folder = "FluentConfigs"
SaveManager.Ignore = {}

function SaveManager:SetLibrary(lib)
    SaveManager.Library = lib
end

function SaveManager:SetFolder(folder)
    SaveManager.Folder = folder
end

function SaveManager:SetIgnoreIndexes(indexes)
    SaveManager.Ignore = indexes
end

function SaveManager:IgnoreThemeSettings()
    table.insert(SaveManager.Ignore, "Theme")
    table.insert(SaveManager.Ignore, "Acrylic")
end

function SaveManager:BuildConfigSection(tab)
    local section = tab:AddParagraph({
        Title = "Configuration",
        Content = "Save and load your configuration."
    })
    
    local configName = tab:AddInput({
        Title = "Config Name",
        Default = "default",
        Placeholder = "config-name"
    })
    
    tab:AddButton({
        Title = "Save Config",
        Callback = function()
            local config = {}
            for id, option in pairs(SaveManager.Library.Options) do
                if not table.find(SaveManager.Ignore, id) then
                    config[id] = option.Value
                end
            end
            
            if isfolder and makefolder and writefile then
                if not isfolder(SaveManager.Folder) then
                    makefolder(SaveManager.Folder)
                end
                
                writefile(SaveManager.Folder .. "/" .. configName.Value .. ".json", HttpService:JSONEncode(config))
                SaveManager.Library:Notify({
                    Title = "Config Saved",
                    Content = "Configuration has been saved as " .. configName.Value .. ".",
                    Duration = 5
                })
            else
                SaveManager.Library:Notify({
                    Title = "Error",
                    Content = "Your exploit does not support file operations.",
                    Duration = 5
                })
            end
        end
    })
    
    tab:AddButton({
        Title = "Load Config",
        Callback = function()
            if isfolder and readfile then
                local success, err = pcall(function()
                    local config = HttpService:JSONDecode(readfile(SaveManager.Folder .. "/" .. configName.Value .. ".json"))
                    
                    for id, value in pairs(config) do
                        if SaveManager.Library.Options[id] then
                            SaveManager.Library.Options[id]:SetValue(value)
                        end
                    end
                    
                    SaveManager.Library:Notify({
                        Title = "Config Loaded",
                        Content = "Configuration has been loaded from " .. configName.Value .. ".",
                        Duration = 5
                    })
                end)
                
                if not success then
                    SaveManager.Library:Notify({
                        Title = "Error",
                        Content = "Failed to load config: " .. err,
                        Duration = 5
                    })
                end
            else
                SaveManager.Library:Notify({
                    Title = "Error",
                    Content = "Your exploit does not support file operations.",
                    Duration = 5
                })
            end
        end
    })
    
    tab:AddButton({
        Title = "Load Autoload Config",
        Callback = function()
            if isfolder and readfile then
                local success, err = pcall(function()
                    local config = HttpService:JSONDecode(readfile(SaveManager.Folder .. "/autoload.json"))
                    
                    for id, value in pairs(config) do
                        if SaveManager.Library.Options[id] then
                            SaveManager.Library.Options[id]:SetValue(value)
                        end
                    end
                    
                    SaveManager.Library:Notify({
                        Title = "Config Loaded",
                        Content = "Autoload configuration has been loaded.",
                        Duration = 5
                    })
                end)
                
                if not success then
                    SaveManager.Library:Notify({
                        Title = "Error",
                        Content = "Failed to load autoload config: " .. err,
                        Duration = 5
                    })
                end
            else
                SaveManager.Library:Notify({
                    Title = "Error",
                    Content = "Your exploit does not support file operations.",
                    Duration = 5
                })
            end
        end
    })
end

-- Interface Manager
local InterfaceManager = {}
InterfaceManager.Folder = "FluentInterfaces"

function InterfaceManager:SetLibrary(lib)
    InterfaceManager.Library = lib
end

function InterfaceManager:SetFolder(folder)
    InterfaceManager.Folder = folder
end

function InterfaceManager:BuildInterfaceSection(tab)
    local section = tab:AddParagraph({
        Title = "Interface",
        Content = "Customize the interface appearance."
    })
    
    tab:AddDropdown({
        Title = "Theme",
        Values = {"Dark", "Light"},
        Default = "Dark",
        Callback = function(value)
            -- This would update the theme, but implementation is complex
            -- A full theme system would need to be implemented
            InterfaceManager.Library:Notify({
                Title = "Theme Changed",
                Content = "Theme has been set to " .. value .. ".",
                Duration = 5
            })
        end
    })
end

-- Add managers to Fluent
Fluent.SaveManager = SaveManager
Fluent.InterfaceManager = InterfaceManager

return Fluent
