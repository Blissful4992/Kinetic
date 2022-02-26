--
local CLAMP = math.clamp
local ROUND = math.round
local ABS = math.abs
local HUGE = math.huge
local SMALL = 10e-3
local RANDOM = math.random
local FLOOR = math.floor
local RAD = math.rad
local ACOS = math.acos
local COS = math.cos
local FMOD = math.fmod
local SEED = math.randomseed
local MAX = math.max
local MIN = math.min
--
local MATCH = string.match 
local FIND = string.find
local SUB = string.sub 
local GSUB = string.gsub
local CHAR = string.char
local BYTE = string.byte
local LEN = string.len
local REVERSE = string.reverse
local WAIT = task.wait 
--
local C3 = Color3.new
local RGB = Color3.fromRGB
local HSV = Color3.fromHSV
--
local V3 = Vector3.new 
local V2 = Vector2.new 
local U2 = UDim2.new 
local U1 = UDim.new
local CF = CFrame.new
local CF_ORIENTATION = CFrame.fromOrientation
local ANGLES = CFrame.Angles
--
local WRAP = coroutine.wrap
local RCP = RaycastParams.new
local NEW = Instance.new
local TBINSERT = table.insert
local TBFIND = table.find
--
local COLOR_SEQUENCE = ColorSequence.new
local COLOR_KEYPOINT = ColorSequenceKeypoint.new
--
local TIME = os.time
local DATE = os.date
local CLOCK = os.clock
local DRAWING = Drawing.new
local TWEEN = TweenInfo.new
--
local Space = game:GetService("Workspace")
--
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGUI = Player.PlayerGui
local Mouse = Player:GetMouse()
--
local RES = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local RStepped = RS.RenderStepped
local TS = game:GetService("TweenService")
--

local charset = {}

for i = 48,  57 do TBINSERT(charset, CHAR(i)) end
for i = 65,  90 do TBINSERT(charset, CHAR(i)) end
for i = 97, 122 do TBINSERT(charset, CHAR(i)) end

local function random_string(length)
    SEED(TIME())

    if length > 0 then
        return random_string(length - 1) .. charset[RANDOM(1, #charset)]
    else
        return ""
    end
end

--

local Library = {}
local DESTROY_UI = false

--
local UI_Inset = game:GetService("GuiService"):GetGuiInset()

local MUTEX = false -- Mutual Exclusion VARIABLE

local HorizontalSize    = 'rbxassetid://8943647369'
local VerticalSize      = 'rbxassetid://8943646025'

local ColorModule = {}
function ColorModule:rgbToHsv(r, g, b)
    r, g, b = r / 255, g / 255, b / 255
    local max, min = MAX(r, g, b), MIN(r, g, b)
    local h, s, v
    v = max

    local d = max - min
    if max == 0 then
        s = 0
    else
        s = d / max
    end

    if max == min then
        h = 0 -- achromatic
    else
        if max == r then
            h = (g - b) / d
            if g < b then
                h = h + 6
            end
        elseif max == g then
            h = (b - r) / d + 2
        elseif max == b then
            h = (r - g) / d + 4
        end
        h = h / 6
    end

    return h, s, v
end

function ColorModule:hsvToRgb(h, s, v)
    local r, g, b

    local i = FLOOR(h * 6);
    local f = h * 6 - i;
    local p = v * (1 - s);
    local q = v * (1 - f * s);
    local t = v * (1 - (1 - f) * s);

    i = i % 6

    if i == 0 then
        r, g, b = v, t, p
    elseif i == 1 then
        r, g, b = q, v, p
    elseif i == 2 then
        r, g, b = p, v, t
    elseif i == 3 then
        r, g, b = p, q, v
    elseif i == 4 then
        r, g, b = t, p, v
    elseif i == 5 then
        r, g, b = v, p, q
    end

    return r * 255, g * 255, b * 255
end

function ColorModule:darkenColor(r, g, b, p)
    local h, s, v = ColorModule:rgbToHsv(r, g, b)
    v = p
    local nr, ng, nb = ColorModule:hsvToRgb(h, s, v)
    return RGB(nr, ng, nb)
end

local function MouseIn(obj)
    if (Mouse.X < obj.AbsolutePosition.X or Mouse.X > obj.AbsolutePosition.X + obj.AbsoluteSize.X) or (Mouse.Y < obj.AbsolutePosition.Y or Mouse.Y > obj.AbsolutePosition.Y + obj.AbsoluteSize.Y) then
        return false
    end
    return true
end

local function rgbToHex(rgb)
    rgb = {rgb.R*255, rgb.G*255, rgb.B*255}
	local hexadecimal = ''

	for key, value in pairs(rgb) do
		local hex = ''

		while(value > 0)do
			local index = FMOD(value, 16) + 1
			value = FLOOR(value / 16)
			hex = SUB('0123456789ABCDEF', index, index) .. hex			
		end

		if(LEN(hex) == 0)then
			hex = '00'

		elseif(LEN(hex) == 1)then
			hex = '0' .. hex
		end

		hexadecimal = hexadecimal .. hex
	end

	return "#"..hexadecimal
end

local function hexToRGB(hex)
    hex = hex:gsub("#","")
	return RGB(tonumber("0x"..hex:sub(1,2)), tonumber("0x"..hex:sub(3,4)), tonumber("0x"..hex:sub(5,6)))
end

local function Protect_GUI(UI)
    if syn then
        UI.Parent=game.CoreGui
        syn.protect_gui(UI)
        print("Synapse")
    elseif KRNL_LOADED then
        print("KRNL")
        UI.Parent=gethui()
    elseif getexecutorname and getexecutorname() == "ScriptWare" then
        print("Script-Ware")
        UI.Parent=gethui()
    else
        UI.Parent=game.CoreGui
    end
end
--

local WinTheme = {
    Background = RGB(30, 30, 30),

    Dark_Borders = RGB(25, 25, 25),
    Light_Borders = RGB(255, 255, 255),

    Text_Color = RGB(255, 255, 255),
    Text_Size_Big = 14,
    Text_Size_Medium = 12,
    Text_Size_Small = 10,

    Section_Background = RGB(25, 25, 25),

    Accent = RGB(0, 255, 0),
    DarkAccent = RGB(0, 100, 0)
}

Library.NewWindow = function(window_info)
    window_info.CloseCallBack = window_info.CloseCallBack or function()end
    window_info.WindowSizeCallBack = window_info.WindowSizeCallBack or function(a,b)end
    window_info.WindowSize = window_info.WindowSize or {X = 557, Y = 500}
    window_info.ThemeOverrides = window_info.ThemeOverrides or {}

    for i,v in pairs(window_info.ThemeOverrides) do
        local o = tostring(i)
        if WinTheme[o] and WinTheme[o] ~= v then
            WinTheme[o] = v
        end
    end

    local UI = NEW("ScreenGui")
    local Window = NEW("Frame")
    local Top_Bar = NEW("Frame")
    local Title = NEW("TextLabel")
    local Close = NEW("ImageButton")
    local Close_Left = NEW("Frame")
    local Close_Right = NEW("Frame")
    local Minimize = NEW("ImageButton")
    local Minimize_Left = NEW("Frame")
    local Minimize_Right = NEW("Frame")
    local Minimize_Top= NEW("Frame")
    local Minimize_Bottom = NEW("Frame")
    local Page_Selector = NEW("ScrollingFrame")
    local Page_List_Layout = NEW("UIListLayout")
    local Main = NEW("Frame")
    local Manager = NEW("Frame")
    local Manager_Border = NEW("Frame")
    local Feature_Info = NEW("TextLabel")
    local Pages = NEW("Frame")

    local Picker_Windows = NEW("Frame")

    UI.Name="UI"

    Protect_GUI(UI)

    UI.ResetOnSpawn=false;Window.Name="Window"Window.Parent=UI;Window.BackgroundColor3=RGB(255,255,255)Window.BackgroundTransparency=1.000;Window.Position=U2(0.341666669,0,0.257407397,0)Window.Size=U2(0,window_info.WindowSize.X,0,window_info.WindowSize.Y)Top_Bar.Name="Top_Bar"Top_Bar.Parent=Window;Top_Bar.Active=true;Top_Bar.BackgroundColor3=RGB(40,40,40)Top_Bar.BackgroundColor3=WinTheme.Background;Top_Bar.BorderColor3=WinTheme.Dark_Borders;Top_Bar.BorderSizePixel=2;Top_Bar.Size=U2(1,0,0,20)Top_Bar.ZIndex=10001;Title.Name="Title"Title.Parent=Top_Bar;Title.BackgroundColor3=RGB(255,255,255)Title.BackgroundTransparency=1.000;Title.Position=U2(0.5,0,0,0)Title.Size=U2(0,1,1,0)Title.ZIndex=10002;Title.Font=Enum.Font.Gotham;Title.Text=window_info.Text or"Test Title"Title.TextColor3=WinTheme.Text_Color;Title.TextSize=WinTheme.Text_Size_Medium;Close.Name="Close"Close.Parent=Top_Bar;Close.BackgroundTransparency=1;Close.BackgroundColor3=WinTheme.Background;Close.BorderColor3=WinTheme.Accent;Close.BorderSizePixel=1;Close.Position=U2(1,-20,0,0)Close.Size=U2(0,20,0,20)Close.ZIndex=10005;Close.AutoButtonColor=false;Close.Image="rbxassetid://7246920077"Close_Left.Name="Close_Left"Close_Left.Parent=Close;Close_Left.BackgroundColor3=WinTheme.Background;Close_Left.BorderSizePixel=0;Close_Left.Size=U2(0,6,1,0)Close_Left.ZIndex=10006;Close_Right.Name="Close_Right"Close_Right.Parent=Close;Close_Right.BackgroundColor3=WinTheme.Background;Close_Right.BorderSizePixel=0;Close_Right.Position=U2(1,-6,0,0)Close_Right.Size=U2(0,6,1,0)Close_Right.ZIndex=10006;Minimize.Name="Minimize"Minimize.Parent=Top_Bar;Minimize.BackgroundTransparency=1;Minimize.BackgroundColor3=WinTheme.Background;Minimize.BorderColor3=WinTheme.Accent;Minimize.BorderSizePixel=1;Minimize.Position=U2(1,-41,0,0)Minimize.Size=U2(0,20,0,20)Minimize.ZIndex=10005;Minimize.AutoButtonColor=false;Minimize.Image="rbxassetid://7247993381"Minimize_Left.Name="Minimize_Left"Minimize_Left.Parent=Minimize;Minimize_Left.BackgroundColor3=WinTheme.Background;Minimize_Left.BorderSizePixel=0;Minimize_Left.Size=U2(0,6,1,0)Minimize_Left.ZIndex=10006;Minimize_Right.Name="Minimize_Right"Minimize_Right.Parent=Minimize;Minimize_Right.BackgroundColor3=WinTheme.Background;Minimize_Right.BorderSizePixel=0;Minimize_Right.Position=U2(1,-6,0,0)Minimize_Right.Size=U2(0,6,1,0)Minimize_Right.ZIndex=10006;Minimize_Top.Name="Minimize_Top"Minimize_Top.Parent=Minimize;Minimize_Top.BackgroundColor3=WinTheme.Background;Minimize_Top.BorderSizePixel=0;Minimize_Top.Size=U2(1,0,0,6)Minimize_Top.ZIndex=10006;Minimize_Bottom.Name="Minimize_Bottom"Minimize_Bottom.Parent=Minimize;Minimize_Bottom.BackgroundColor3=WinTheme.Background;Minimize_Bottom.BorderSizePixel=0;Minimize_Bottom.Position=U2(0,0,1,-6)Minimize_Bottom.Size=U2(1,0,0,6)Minimize_Bottom.ZIndex=10006;Page_Selector.Name="Page_Selector"Page_Selector.Parent=Window;Page_Selector.Active=true;Page_Selector.BackgroundColor3=WinTheme.Background;Page_Selector.BorderColor3=WinTheme.Dark_Borders;Page_Selector.BorderSizePixel=2;Page_Selector.Position=U2(0,0,0,22)Page_Selector.Size=U2(1,0,0,32)Page_Selector.ZIndex=10000;Page_Selector.CanvasSize=U2(0,0,0,0)Page_Selector.AutomaticCanvasSize=Enum.AutomaticSize.X;Page_Selector.ScrollBarThickness=0;Page_List_Layout.Name="Page_List_Layout"Page_List_Layout.Parent=Page_Selector;Page_List_Layout.Padding=U1(0,0)Page_List_Layout.FillDirection=Enum.FillDirection.Horizontal;Page_List_Layout.HorizontalAlignment=Enum.HorizontalAlignment.Center;Page_List_Layout.SortOrder=Enum.SortOrder.LayoutOrder;Main.Name="Main"Main.Parent=Window;Main.BackgroundColor3=WinTheme.Background;Main.BorderColor3=WinTheme.Dark_Borders;Main.BorderSizePixel=2;Main.Position=U2(0,0,0,55)Main.Size=U2(1,0,1,-55)Manager.Name="Manager"Manager.Parent=Main;Manager.BackgroundColor3=RGB(255,255,255)Manager.BackgroundTransparency=1.000;Manager.Position=U2(0,0,1,-60)Manager.Size=U2(1,0,0,60)Manager_Border.Name="Manager_Border"Manager_Border.Parent=Manager;Manager_Border.BackgroundColor3=WinTheme.Dark_Borders;Manager_Border.BorderSizePixel=0;Manager_Border.Position=U2(0,9,0,-1)Manager_Border.Size=U2(1,-18,0,2)Picker_Windows.Name="Picker_Windows"Picker_Windows.Parent=UI;Picker_Windows.BackgroundColor3=RGB(255,255,255)Picker_Windows.BackgroundTransparency=1.000;Picker_Windows.Size=U2(1,0,1,0)Feature_Info.Name="Feature_Info"Feature_Info.Parent=Manager;Feature_Info.BackgroundColor3=WinTheme.Dark_Borders;Feature_Info.BorderColor3=WinTheme.Dark_Borders;Feature_Info.BorderSizePixel=4;Feature_Info.Position=U2(0,9,1,-25)Feature_Info.Size=U2(1,-18,0,16)Feature_Info.Font=Enum.Font.SourceSans;Feature_Info.Text="This will turn ESP on/off"Feature_Info.TextColor3=WinTheme.Text_Color;Feature_Info.TextSize=WinTheme.Text_Size_Big;Feature_Info.TextTruncate=Enum.TextTruncate.AtEnd;Feature_Info.TextXAlignment=Enum.TextXAlignment.Left

    local function infoMessage(text)
        RStepped:Wait()
        Feature_Info.Text = text
    end
    local function resetMessage(text)
        Feature_Info.Text = ""
    end

    Pages.Name = "Pages"Pages.Parent = Main;Pages.BackgroundColor3 = RGB(255, 255, 255);Pages.BackgroundTransparency = 1.000;Pages.Size = U2(1, 0, 1, -60)

    local structurer = {}

    local prompt_Active = false

    local UI_TOGGLED = true
    function structurer.Toggle(state)
        if not prompt_Active then
            UI_TOGGLED = state or not UI_TOGGLED
            Window.Visible = state or UI_TOGGLED
            Picker_Windows.Visible = state or UI_TOGGLED  
        end
    end
    
    local MINIMIZED = false
    local function TOGGLE_UI()
        MINIMIZED = not MINIMIZED
        Page_Selector.Visible = not MINIMIZED
        Main.Visible = not MINIMIZED

        if Main.Visible then
            Minimize.Image = "rbxassetid://7247993381"
        else
            Minimize.Image = "rbxassetid://7275743788"
        end
    end

    function structurer.Destroy()
        DESTROY_UI = true
        UI:Destroy()
    end

    do -- MINIMIZE

        Minimize.MouseButton1Click:Connect(function()
            TOGGLE_UI()
        end)

        Minimize.MouseEnter:Connect(function()
            Minimize.ZIndex = 10006
            Minimize.BackgroundTransparency = 0
            Minimize.ImageColor3 = WinTheme.Accent;

            infoMessage("Minimizes the Window")
        end)
    
        Minimize.MouseLeave:Connect(function()
            resetMessage()

            Minimize.ZIndex = 10005
            Minimize.BackgroundTransparency = 1
            Minimize.ImageColor3 = RGB(255, 255, 255)
        end)
    end

    do -- CLOSE

        Close.MouseButton1Click:Connect(function()
            window_info.CloseCallBack()
            structurer.Destroy()
        end)

        Close.MouseEnter:Connect(function()
            Close.ZIndex = 10006
            Close.BackgroundTransparency = 0
            Close.ImageColor3 = WinTheme.Accent;

            infoMessage("Kills the Window")
        end)
    
        Close.MouseLeave:Connect(function()
            resetMessage()

            Close.ZIndex = 10005
            Close.BackgroundTransparency = 1
            Close.ImageColor3 = RGB(255, 255, 255)
        end)
    end

    do -- WINDOW DRAGGING
        local Dragging_UI
        local Previous_Offset

        local drag
        drag = UIS.InputChanged:Connect(function(input)
            if DESTROY_UI then
                drag:Disconnect()
            elseif Dragging_UI and input.UserInputType == Enum.UserInputType.MouseMovement then
                TS:Create(Window, TWEEN(0.04, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Position = U2(0, Mouse.X + Previous_Offset.X, 0, Mouse.Y + Previous_Offset.Y)}):Play()
            end
        end)

        local inp
        inp = UIS.InputBegan:Connect(function(input)
            if DESTROY_UI then
                inp:Disconnect()
            elseif input.UserInputType == Enum.UserInputType.MouseButton1 and MouseIn(Top_Bar) and not MouseIn(Close) and not MouseIn(Minimize) then
                Previous_Offset = V2(Window.AbsolutePosition.X, Window.AbsolutePosition.Y) - V2(Mouse.X, Mouse.Y)
                Dragging_UI = true
            end
        end)

        local outp
        outp = UIS.InputEnded:Connect(function(input)
            if DESTROY_UI then
                outp:Disconnect()
            elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
                Dragging_UI = false
            end
        end)
    end

    do -- WINDOW SCALING
        local ResizeX = NEW("TextButton")
        local ResizeY = NEW("TextButton")

        ResizeX.Name="ResizeX"ResizeX.Parent=Window;ResizeX.AutoButtonColor=false;ResizeX.BackgroundColor3=WinTheme.DarkAccent;ResizeX.BackgroundTransparency=0;ResizeX.Position=U2(1,-2,0,27)ResizeX.BorderSizePixel=0;ResizeX.Size=U2(0,2,1,-32)ResizeX.ZIndex=100000;ResizeX.Font=Enum.Font.SourceSans;ResizeX.Text=""ResizeX.TextColor3=RGB(0,0,0)ResizeX.TextSize=WinTheme.Text_Size_Medium;ResizeX.Visible=true;ResizeY.Name="ResizeY"ResizeY.Parent=Window;ResizeY.AutoButtonColor=false;ResizeY.BackgroundColor3=WinTheme.DarkAccent;ResizeY.BorderSizePixel=0;ResizeY.BackgroundTransparency=0;ResizeY.Position=U2(0,5,1,-2)ResizeY.Size=U2(1,-10,0,2)ResizeY.ZIndex=100000;ResizeY.Font=Enum.Font.SourceSans;ResizeY.Text=""ResizeY.TextColor3=RGB(0,0,0)ResizeY.TextSize=WinTheme.Text_Size_Big;ResizeY.Visible=true

        local Mouse_Scaling_X = false
        local Mouse_Scaling_Y = false

        ResizeX.MouseEnter:Connect(function(ags)
            ResizeX.BackgroundColor3 = WinTheme.Accent;
            Mouse.Icon = HorizontalSize
            infoMessage("Scales the Window (X)")
        end)

        ResizeX.MouseLeave:Connect(function(ags)
            if not Mouse_Scaling_X then
                ResizeX.BackgroundColor3 = WinTheme.DarkAccent
                Mouse.Icon = ""
                resetMessage()
            end
        end)

        ResizeY.MouseEnter:Connect(function(ags)
            ResizeY.BackgroundColor3 = WinTheme.Accent;
            Mouse.Icon = VerticalSize
            infoMessage("Scales the Window (Y)")
        end)

        ResizeY.MouseLeave:Connect(function(ags)
            if not Mouse_Scaling_Y then
                ResizeY.BackgroundColor3 = WinTheme.DarkAccent
                Mouse.Icon = ""
                resetMessage()
            end
        end)

        ResizeX.MouseButton1Down:Connect(function()
            if not Mouse_Scaling_Y then
                Mouse_Scaling_X = true
            end
        end)

        ResizeY.MouseButton1Down:Connect(function()
            if not Mouse_Scaling_X then
                Mouse_Scaling_Y = true
            end
        end)

        local Mouse_Connection
        Mouse_Connection = UIS.InputEnded:Connect(function(input)
            if DESTROY_UI then
                Mouse_Connection:Disconnect()
            elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
                if (Mouse_Scaling_X or Mouse_Scaling_Y) and not MouseIn(ResizeX) and not MouseIn(ResizeY) then
                    resetMessage()
                end

                if MouseIn(ResizeX) then
                    ResizeX.BackgroundColor3 = WinTheme.Accent;
                else
                    ResizeX.BackgroundColor3 = WinTheme.DarkAccent
                end
                
                if MouseIn(ResizeY) then
                    ResizeY.BackgroundColor3 = WinTheme.Accent;
                else
                    ResizeY.BackgroundColor3 = WinTheme.DarkAccent
                end

                Mouse_Scaling_X = false
                Mouse_Scaling_Y = false
            end
        end)

        local scalingBind = "CScaling"..random_string(10)
        local Scaling_Connection
        Scaling_Connection = function()
            if DESTROY_UI then
                RS:UnbindFromRenderStep(scalingBind)
            elseif UI_TOGGLED and MINIMIZED == false and Mouse_Scaling_Y then
                local offset_mouse = Mouse.Y - Window.AbsolutePosition.Y

                TS:Create(Window, TWEEN(0.05, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Size = U2(0, Window.AbsoluteSize.X, 0, CLAMP(offset_mouse, 300, HUGE))}):Play()
                -- Window.Size = U2(0, Window.AbsoluteSize.X, 0, CLAMP(offset_mouse, 300, HUGE))
                window_info.WindowSizeCallBack(V2(Window.AbsoluteSize.X, Window.AbsoluteSize.Y))
            elseif UI_TOGGLED and MINIMIZED == false and Mouse_Scaling_X then
                local offset_mouse = Mouse.X - Window.AbsolutePosition.X

                TS:Create(Window, TWEEN(0.05, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Size = U2(0, CLAMP(offset_mouse, 144, HUGE), 0, Window.AbsoluteSize.Y)}):Play()
                -- Window.Size = U2(0, CLAMP(offset_mouse, 144, HUGE), 0, Window.AbsoluteSize.Y)
                window_info.WindowSizeCallBack(V2(Window.AbsoluteSize.X, Window.AbsoluteSize.Y))
            else
                if UI_TOGGLED == false or MINIMIZED then
                    ResizeY.Visible = false
                    ResizeX.Visible = false

                    WRAP(function()
                        repeat WAIT() until UI_TOGGLED and MINIMIZED == false
                        RS:BindToRenderStep(scalingBind, 1, Scaling_Connection)
                    end)()
                    RS:UnbindFromRenderStep(scalingBind)
                else
                    ResizeY.Visible = true
                    ResizeX.Visible = true
                end
            end
        end

        RS:BindToRenderStep(scalingBind, 1, Scaling_Connection)
    end

    do -- SAVE BUTTON
        if window_info.SaveCallBack ~= nil and type(window_info.SaveCallBack) == "function" then
            local Save_Button = NEW("TextButton")

            Save_Button.Name="Save_Button"Save_Button.Parent=Manager;Save_Button.BackgroundColor3=WinTheme.Dark_Borders;Save_Button.BorderColor3=WinTheme.Light_Borders;Save_Button.Position=U2(1,-56,0,7)Save_Button.Size=U2(0,50,0,18)Save_Button.AutoButtonColor=false;Save_Button.Font=Enum.Font.Gotham;Save_Button.Text="Save"Save_Button.TextColor3=WinTheme.Text_Color;Save_Button.TextSize=WinTheme.Text_Size_Medium;Save_Button.TextWrapped=true

            Save_Button.MouseButton1Click:Connect(function()
                window_info.SaveCallBack()
            end)

            Save_Button.MouseEnter:Connect(function()
                Save_Button.BorderColor3 = WinTheme.Accent;
                Save_Button.TextColor3 = WinTheme.Accent;
    
                infoMessage("Saves Global Settings")
            end)
        
            Save_Button.MouseLeave:Connect(function()
                resetMessage()
    
                Save_Button.BorderColor3 = WinTheme.Light_Borders;
                Save_Button.TextColor3 = WinTheme.Text_Color;
            end)
        end
    end

    local Prompt = NEW("Folder")
    local Prompt_Blur = NEW("Frame")
    local Prompt_Window = NEW("Frame")
    local Prompt_Top_Bar = NEW("Frame")
    local Prompt_Title = NEW("TextLabel")
    local Prompt_Main = NEW("Frame")
    local Prompt_Body = NEW("TextLabel")
    local Prompt_Countdown = NEW("TextLabel")
    local Accept_Button = NEW("TextButton")
    local Prompt_Border = NEW("Frame")
    local Reject_Button = NEW("TextButton")

    Prompt.Name="Prompt"Prompt.Parent=UI;Prompt_Blur.Name="Prompt_Blur"Prompt_Blur.Parent=Prompt;Prompt_Blur.BackgroundColor3=RGB(100,100,100)Prompt_Blur.BackgroundTransparency=0.8;Prompt_Blur.Size=U2(1,0,1,UI_Inset.Y)Prompt_Blur.Position=U2(0,0,0,-UI_Inset.Y)Prompt_Blur.BorderSizePixel=0;Prompt_Blur.ZIndex=1000000;Prompt_Blur.Visible=false;Prompt_Window.Name="Prompt_Window"Prompt_Window.Parent=Prompt;Prompt_Window.BackgroundColor3=RGB(255,255,255)Prompt_Window.BackgroundTransparency=1.000;Prompt_Window.BorderColor3=RGB(27,42,53)Prompt_Window.Position=U2(0.5,-180,0.5,-80)Prompt_Window.Size=U2(0,360,0,162)Prompt_Window.ZIndex=1000000;Prompt_Window.Visible=false;Prompt_Top_Bar.Name="Prompt_Top_Bar"Prompt_Top_Bar.Parent=Prompt_Window;Prompt_Top_Bar.BackgroundColor3=WinTheme.Background;Prompt_Top_Bar.BorderColor3=WinTheme.Dark_Borders;Prompt_Top_Bar.BorderSizePixel=2;Prompt_Top_Bar.Size=U2(1,0,0,20)Prompt_Top_Bar.ZIndex=1000001;Prompt_Title.Name="Prompt_Title"Prompt_Title.Parent=Prompt_Top_Bar;Prompt_Title.BackgroundColor3=RGB(255,255,255)Prompt_Title.BackgroundTransparency=1.000;Prompt_Title.Position=U2(0,5,0,0)Prompt_Title.Size=U2(0,1,1,0)Prompt_Title.ZIndex=1000002;Prompt_Title.Font=Enum.Font.Gotham;Prompt_Title.Text="Prompt"Prompt_Title.TextColor3=WinTheme.Text_Color;Prompt_Title.TextSize=WinTheme.Text_Size_Medium;Prompt_Title.TextXAlignment=Enum.TextXAlignment.Left;Prompt_Main.Name="Prompt_Main"Prompt_Main.Parent=Prompt_Window;Prompt_Main.BackgroundColor3=WinTheme.Background;Prompt_Main.BorderColor3=WinTheme.Dark_Borders;Prompt_Main.BorderSizePixel=2;Prompt_Main.Position=U2(0,0,0,22)Prompt_Main.Size=U2(1,0,1,-22)Prompt_Main.ZIndex=1000001;Prompt_Body.Name="Prompt_Body"Prompt_Body.Parent=Prompt_Main;Prompt_Body.BackgroundColor3=WinTheme.Background;Prompt_Body.BorderSizePixel=0;Prompt_Body.Position=U2(0,5,0,10)Prompt_Body.Size=U2(1,-10,1,-44)Prompt_Body.ZIndex=1000002;Prompt_Body.Font=Enum.Font.Gotham;Prompt_Body.RichText=true;Prompt_Body.Text=""Prompt_Body.TextColor3=WinTheme.Text_Color;Prompt_Body.TextSize=WinTheme.Text_Size_Medium;Prompt_Body.TextWrapped=true;Prompt_Body.TextXAlignment=Enum.TextXAlignment.Left;Prompt_Body.TextYAlignment=Enum.TextYAlignment.Top;Prompt_Countdown.Name="Prompt_Countdown"Prompt_Countdown.Parent=Prompt_Main;Prompt_Countdown.BackgroundColor3=RGB(255,255,255)Prompt_Countdown.BackgroundTransparency=1.000;Prompt_Countdown.Position=U2(0,5,1,-24)Prompt_Countdown.Size=U2(0,1,0,18)Prompt_Countdown.ZIndex=1000002;Prompt_Countdown.Font=Enum.Font.Gotham;Prompt_Countdown.Text="Time Remaining:"Prompt_Countdown.TextColor3=WinTheme.Text_Color;Prompt_Countdown.TextSize=WinTheme.Text_Size_Medium;Prompt_Countdown.TextXAlignment=Enum.TextXAlignment.Left;Accept_Button.Name="Accept_Button"Accept_Button.Parent=Prompt_Main;Accept_Button.BackgroundColor3=WinTheme.Dark_Borders;Accept_Button.BorderColor3=WinTheme.Light_Borders;Accept_Button.Position=U2(1,-72,1,-24)Accept_Button.Size=U2(0,30,0,18)Accept_Button.ZIndex=1000002;Accept_Button.AutoButtonColor=false;Accept_Button.Font=Enum.Font.Gotham;Accept_Button.Text="Yes"Accept_Button.TextColor3=WinTheme.Text_Color;Accept_Button.TextSize=WinTheme.Text_Size_Medium;Accept_Button.TextWrapped=true;Prompt_Border.Name="Prompt_Border"Prompt_Border.Parent=Prompt_Main;Prompt_Border.BackgroundColor3=WinTheme.Dark_Borders;Prompt_Border.BorderSizePixel=0;Prompt_Border.Position=U2(0,5,1,-30)Prompt_Border.Size=U2(1,-10,0,1)Prompt_Border.ZIndex=1000002;Reject_Button.Name="Reject_Button"Reject_Button.Parent=Prompt_Main;Reject_Button.BackgroundColor3=WinTheme.Dark_Borders;Reject_Button.BorderColor3=WinTheme.Light_Borders;Reject_Button.Position=U2(1,-36,1,-24)Reject_Button.Size=U2(0,30,0,18)Reject_Button.ZIndex=1000002;Reject_Button.AutoButtonColor=false;Reject_Button.Font=Enum.Font.Gotham;Reject_Button.Text="No"Reject_Button.TextColor3=WinTheme.Text_Color;Reject_Button.TextSize=WinTheme.Text_Size_Medium;Reject_Button.TextWrapped=true

    local prompt_Accept_Callback = function()end
    local prompt_Reject_Callback = function()end

    Accept_Button.MouseButton1Click:Connect(function()
        Prompt_Blur.Visible = false
        Prompt_Window.Visible = false
        prompt_Active = false
        Window.Visible = true

        prompt_Accept_Callback()
    end)

    Accept_Button.MouseEnter:Connect(function()
        Accept_Button.BorderColor3 = WinTheme.Accent;
        Accept_Button.TextColor3 = WinTheme.Accent;
    end)

    Accept_Button.MouseLeave:Connect(function()
        Accept_Button.BorderColor3 = WinTheme.Light_Borders;
        Accept_Button.TextColor3 = WinTheme.Text_Color;
    end)

    Reject_Button.MouseButton1Click:Connect(function()
        Prompt_Blur.Visible = false
        Prompt_Window.Visible = false
        prompt_Active = false
        Window.Visible = true

        prompt_Reject_Callback()
    end)

    Reject_Button.MouseEnter:Connect(function()
        Reject_Button.BorderColor3 = WinTheme.Accent;
        Reject_Button.TextColor3 = WinTheme.Accent;
    end)

    Reject_Button.MouseLeave:Connect(function()
        Reject_Button.BorderColor3 = WinTheme.Light_Borders;
        Reject_Button.TextColor3 = WinTheme.Text_Color;
    end)

    function structurer.NewPrompt(prompt_info)
        prompt_info.Name = prompt_info.Name or "Def Prompt"
        prompt_info.Text = prompt_info.Text or "I am a prompt"

        prompt_Active = true
        Window.Visible = false

        prompt_Accept_Callback = prompt_info.Accept or function()end
        prompt_Reject_Callback = prompt_info.Reject or function()end

        Prompt_Countdown.Text = ""
        local Countdown = 0
        if prompt_info.Countdown and tonumber(prompt_info.Countdown) then 
            Countdown = tonumber(prompt_info.Countdown)
            Prompt_Countdown.Text = "Time Remaining: "..Countdown.." s"
            spawn(function()
                repeat
                    WAIT(1)
                    Countdown = Countdown - 1
                    Prompt_Countdown.Text = "Time Remaining: "..Countdown.." s"
                until Countdown <= 0 or not prompt_Active

                Prompt_Blur.Visible = false
                Prompt_Window.Visible = false
                prompt_Active = false
                Window.Visible = true

                prompt_Reject_Callback()
            end)
        end

        Prompt_Body.Text = prompt_info.Text
        Prompt_Title.Text = "Prompt: "..prompt_info.Name

        Prompt_Blur.Visible = true
        Prompt_Window.Visible = true

        local prompt_funcs = {}

        function prompt_funcs.GetName()
            return prompt_info.Name
        end
        function prompt_funcs.GetText()
            return prompt_info.Text
        end
        function prompt_funcs.GetTimeLeft()
            return Countdown
        end
        function prompt_funcs.Destroy()
            Prompt_Blur.Visible = false
            Prompt_Window.Visible = false
            prompt_Active = false
            Window.Visible = true

            prompt_Reject_Callback()
        end

        return prompt_funcs
    end

    function structurer.NewPage(page_info)

        local Page = NEW("ScrollingFrame")
        local Page_Grid_Layout = NEW("UIGridLayout")

        local Page_Option = NEW("TextButton")
        local Page_Option_Right = NEW("Frame")
        local Page_Option_Left = NEW("Frame")

        Page.Name="Page"Page.Parent=Pages;Page.Active=true;Page.BackgroundColor3=RGB(255,255,255)Page.BackgroundTransparency=1.000;Page.BorderColor3=RGB(255,0,4)Page.BorderSizePixel=0;Page.Position=U2(0,5,0,10)Page.Size=U2(1,-10,1,-10)Page.Visible=false;Page.CanvasSize=U2(1,0,20,0)Page.ScrollBarImageColor3=WinTheme.DarkAccent;Page.ScrollBarThickness=1;Page.ScrollingDirection=Enum.ScrollingDirection.Y;Page_Grid_Layout.Name="Page_Grid_Layout"Page_Grid_Layout.Parent=Page;Page_Grid_Layout.FillDirection=Enum.FillDirection.Horizontal;Page_Grid_Layout.SortOrder=Enum.SortOrder.LayoutOrder;Page_Grid_Layout.HorizontalAlignment=Enum.HorizontalAlignment.Left;Page_Grid_Layout.CellPadding=U2(0,6,0,6)Page_Grid_Layout.CellSize=U2(0,0,0,0)Page_Option.Name="Page_Option"Page_Option.Parent=Page_Selector;Page_Option.BackgroundColor3=WinTheme.Accent;Page_Option.BackgroundTransparency=1;Page_Option.BorderSizePixel=0;Page_Option.ZIndex=10001;Page_Option.AutoButtonColor=false;Page_Option.Font=Enum.Font.Gotham;Page_Option.Text=page_info.Text or"Page"Page_Option.TextColor3=WinTheme.Text_Color;Page_Option.TextSize=WinTheme.Text_Size_Big;Page_Option.Size=U2(0,Page_Option.TextBounds.X+40,1,0)Page_Option_Right.Name="Page_Option_Right"Page_Option_Right.Parent=Page_Option;Page_Option_Right.BackgroundColor3=WinTheme.Dark_Borders;Page_Option_Right.BorderSizePixel=0;Page_Option_Right.Position=U2(1,-1,0,4)Page_Option_Right.Size=U2(0,2,1,-8)Page_Option_Right.ZIndex=10002;Page_Option_Left.Name="Page_Option_Left"Page_Option_Left.Parent=Page_Option;Page_Option_Left.BackgroundColor3=WinTheme.Dark_Borders;Page_Option_Left.BorderSizePixel=0;Page_Option_Left.Position=U2(0,-1,0,4)Page_Option_Left.Size=U2(0,2,1,-8)Page_Option_Left.ZIndex=10002

        do
            Page_Option.MouseButton1Click:Connect(function()
                local t_selector = Page_Selector:GetChildren()
                for i = 1, #t_selector do
                    local v = t_selector[i]
                    if not v:IsA("UIListLayout") then
                        v.BackgroundTransparency = 1
                    end
                end
                local t_pages = Pages:GetChildren()
                for i = 1, #t_pages do
                    t_pages[i].Visible = false
                end
                Page.Visible = true
                Page_Option.BackgroundTransparency = 0.45
            end)
    
            Page_Option.MouseEnter:Connect(function()
                Page_Option_Right.ZIndex = 10003
                Page_Option_Left.ZIndex = 10003
                Page_Option_Left.BackgroundColor3 = WinTheme.Accent;
                Page_Option_Right.BackgroundColor3 = WinTheme.Accent;
                Page_Option.TextColor3 = WinTheme.Accent;
    
                infoMessage(page_info.Description or "")
            end)
        
            Page_Option.MouseLeave:Connect(function()
                resetMessage()
    
                Page_Option_Right.ZIndex = 10002
                Page_Option_Left.ZIndex = 10002
                Page_Option_Left.BackgroundColor3 = WinTheme.Dark_Borders
                Page_Option_Right.BackgroundColor3 = WinTheme.Dark_Borders
                Page_Option.TextColor3 = WinTheme.Text_Color;
            end)
        end

        local page_funcs = {}
        function page_funcs.NewSection(section_info)
            local section_funcs = {}

            local Section = NEW("Frame")
            local Section_Size = NEW("UISizeConstraint")
            local Section_Title = NEW("TextLabel")
            local Item_Container = NEW("Frame")
            local Section_Item_List = NEW("UIListLayout")

            --Properties:
            Section.Name="Section"Section.Parent=Page;Section.BackgroundColor3=WinTheme.Section_Background;Section.BackgroundTransparency=0;Section.BorderSizePixel=0;Section.BorderMode=Enum.BorderMode.Inset;Section.BorderColor3=WinTheme.Dark_Borders;Section.BorderSizePixel=1;Section.Size=U2(0,100,0,100)Section_Size.Name="Section_Size"Section_Size.Parent=Section;Section_Size.MinSize=V2(131,90)Section_Title.Name="Section_Title"Section_Title.Parent=Section;Section_Title.BackgroundColor3=RGB(255,255,255)Section_Title.BackgroundTransparency=1.000;Section_Title.Size=U2(1,0,0,24)Section_Title.Font=Enum.Font.Gotham;Section_Title.Text=section_info.Text or"Section"Section_Title.TextColor3=WinTheme.Text_Color;Section_Title.TextSize=WinTheme.Text_Size_Medium;Item_Container.Name="Item_Container"Item_Container.Parent=Section;Item_Container.BackgroundColor3=RGB(255,255,255)Item_Container.BackgroundTransparency=1.000;Item_Container.Position=U2(0,0,0,24)Item_Container.Size=U2(1,0,1,-24)Section_Item_List.Name="Section_Item_List"Section_Item_List.Parent=Item_Container;Section_Item_List.SortOrder=Enum.SortOrder.LayoutOrder;Section_Item_List.Padding=U1(0,8)

            local function updateSectionSize()
                local offsety = 0
                local offsetx = 0
                local t_container = Item_Container:GetChildren()
                for i = 1, #t_container do
                    local v = t_container[i]
                    if not v:IsA("UIListLayout") then
                        offsety = offsety + v.AbsoluteSize.Y + 8
                        if v.AbsoluteSize.X > offsetx then
                            offsetx = v.AbsoluteSize.Y
                        end
                    end
                end

                Section_Size.MinSize = V2(160, Section_Title.AbsoluteSize.Y+offsety)
            end
            updateSectionSize()

            function section_funcs.NewButton(info)
                info.CallBack = info.CallBack or function()end
                info.Text = info.Text or "Button"

                local Button = NEW("Frame")
                local Button_Detector = NEW("TextButton")

                Button.Name="Button"Button.Parent=Item_Container;Button.BackgroundColor3=RGB(255,255,255)Button.BackgroundTransparency=1.000;Button.BorderSizePixel=0;Button.Size=U2(1,-10,0,16)Button_Detector.Name="Button_Detector"Button_Detector.Parent=Button;Button_Detector.BackgroundColor3=RGB(0,0,0)Button_Detector.AutoButtonColor=false;Button_Detector.BorderColor3=WinTheme.Light_Borders;Button_Detector.Position=U2(0,5,0,0)Button_Detector.Size=U2(1,0,1,0)Button_Detector.Font=Enum.Font.Gotham;Button_Detector.TextColor3=WinTheme.Text_Color;Button_Detector.Text=info.Text or"Button"Button_Detector.TextSize=WinTheme.Text_Size_Medium;Button_Detector.TextWrapped=true

                Button_Detector.MouseButton1Click:Connect(function()
                    info.CallBack()
                end)

                Button_Detector.MouseEnter:Connect(function()
                    Button_Detector.BorderColor3 = WinTheme.Accent;
                    Button_Detector.TextColor3 = WinTheme.Accent;
        
                    infoMessage(info.Description or "")
                end)
            
                Button_Detector.MouseLeave:Connect(function()
                    resetMessage()
        
                    Button_Detector.BorderColor3 = WinTheme.Light_Borders;
                    Button_Detector.TextColor3 = WinTheme.Text_Color;
                end)

                updateSectionSize()

                local button_funcs = {}

                function button_funcs.Fire(times)
                    for i = 1, times or 1 do
                        info.CallBack()
                    end
                end
                function button_funcs.SetText(text)
                    Button_Detector.Text = text or "Button"
                end
                function button_funcs.GetText()
                    return Button_Detector.Text
                end

                return button_funcs
            end

            function section_funcs.NewToggle(info)
                local isToggled = info.Default or false
                info.CallBack = info.CallBack or function(a)end
                info.Text = info.Text or "Toggle"

                local Toggle = NEW("Frame")
                local Toggle_Detector = NEW("ImageButton")
                local Toggle_Right = NEW("Frame")
                local Toggle_Left = NEW("Frame")
                local Toggle_Title = NEW("TextLabel")

                Toggle.Name="Toggle"Toggle.Parent=Item_Container;Toggle.BackgroundColor3=RGB(255,255,255)Toggle.BackgroundTransparency=1.000;Toggle.BorderSizePixel=0;Toggle.Size=U2(0,120,0,16)Toggle_Detector.Name="Toggle_Detector"Toggle_Detector.Parent=Toggle;Toggle_Detector.BackgroundColor3=RGB(0,0,0)Toggle_Detector.BorderColor3=WinTheme.Light_Borders;Toggle_Detector.Position=U2(0,5,0,0)Toggle_Detector.Size=U2(0,16,0,16)Toggle_Detector.AutoButtonColor=false;Toggle_Detector.Image="rbxassetid://7248316188"Toggle_Detector.ImageColor3=WinTheme.Accent;Toggle_Right.Name="Toggle_Right"Toggle_Right.Parent=Toggle_Detector;Toggle_Right.BackgroundColor3=RGB(0,0,0)Toggle_Right.BorderSizePixel=0;Toggle_Right.Position=U2(1,-2,0,0)Toggle_Right.Size=U2(0,2,1,0)Toggle_Left.Name="Toggle_Left"Toggle_Left.Parent=Toggle_Detector;Toggle_Left.BackgroundColor3=RGB(0,0,0)Toggle_Left.BorderSizePixel=0;Toggle_Left.Size=U2(0,2,1,0)Toggle_Title.Name="Toggle_Title"Toggle_Title.Parent=Toggle;Toggle_Title.BackgroundColor3=RGB(255,255,255)Toggle_Title.BackgroundTransparency=1.000;Toggle_Title.Position=U2(0,31,0,0)Toggle_Title.Size=U2(0,1,1,0)Toggle_Title.Font=Enum.Font.Gotham;Toggle_Title.Text=info.Text or"Toggle"Toggle_Title.TextColor3=WinTheme.Text_Color;Toggle_Title.TextSize=WinTheme.Text_Size_Medium;Toggle_Title.TextXAlignment=Enum.TextXAlignment.Left

                if isToggled then
                    Toggle_Detector.ImageTransparency = 0
                else
                    Toggle_Detector.ImageTransparency = 1
                end

                Toggle_Detector.MouseButton1Click:Connect(function()

                    isToggled = not isToggled

                    if isToggled then
                        Toggle_Detector.ImageTransparency = 0
                    else
                        Toggle_Detector.ImageTransparency = 1
                    end

                    info.CallBack(isToggled)
                end)

                Toggle_Detector.MouseEnter:Connect(function()
                    Toggle_Detector.BorderColor3 = WinTheme.Accent;
        
                    infoMessage(info.Description or "")
                end)
            
                Toggle_Detector.MouseLeave:Connect(function()
                    resetMessage()
        
                    Toggle_Detector.BorderColor3 = WinTheme.Light_Borders;
                end)

                updateSectionSize()

                local toggle_funcs = {}
                function toggle_funcs.Toggle(state)
                    isToggled = state or not isToggled

                    if isToggled then
                        Toggle_Detector.ImageTransparency = 0
                    else
                        Toggle_Detector.ImageTransparency = 1
                    end

                    info.CallBack(isToggled)
                end
                function toggle_funcs.SetText(text)
                    Toggle_Title.Text = text or "Toggle"
                end
                function toggle_funcs.GetText()
                    return Toggle_Title.Text
                end
                function toggle_funcs.GetValue()
                    return isToggled
                end

                return toggle_funcs
            end

            function section_funcs.NewSlider(info)
                info.CallBack = info.CallBack or function(a)end
                info.Default = info.Default or 0
                info.Text = info.Text or "Slider"

                local decimals = info.Decimals or 0
                local function RoundValue(val)
                    if decimals >= 1 then
                        local str = "1"
                        for i = 1, decimals do 
                            str = str.."0"
                        end
                        return ROUND(val * tonumber(str))/tonumber(str)
                    else
                        return ROUND(val)
                    end
                end

                local suffix = info.Suffix or ""
                local current_value = RoundValue(info.Default or ((info.Min + info.Max)/2))

                local Slider = NEW("Frame")
                local Slider_Detector = NEW("TextButton")
                local Fill = NEW("Frame")
                local Value = NEW("TextLabel")
                local Slider_Title = NEW("TextLabel")

                Slider.Name="Slider"Slider.Parent=Item_Container;Slider.BackgroundColor3=RGB(255,255,255)Slider.BackgroundTransparency=1.000;Slider.BorderSizePixel=0;Slider.Size=U2(1,0,0,34)Slider_Detector.Name="Slider_Detector"Slider_Detector.Parent=Slider;Slider_Detector.BackgroundColor3=RGB(0,0,0)Slider_Detector.BorderColor3=WinTheme.Light_Borders;Slider_Detector.Position=U2(0,5,1,-16)Slider_Detector.Size=U2(1,-10,0,16)Slider_Detector.AutoButtonColor=false;Slider_Detector.Font=Enum.Font.Gotham;Slider_Detector.Text=""Slider_Detector.TextColor3=WinTheme.Text_Color;Slider_Detector.TextSize=WinTheme.Text_Size_Medium;Slider_Detector.TextWrapped=true;Fill.Name="Fill"Fill.Parent=Slider_Detector;Fill.BackgroundColor3=RGB(65,65,65)Fill.BorderSizePixel=0;Fill.Size=U2(0,100,1,0)Value.Name="Value"Value.Parent=Slider_Detector;Value.BackgroundColor3=RGB(255,255,255)Value.BackgroundTransparency=1.000;Value.Size=U2(1,0,1,0)Value.Font=Enum.Font.Gotham;Value.TextColor3=WinTheme.Text_Color;Value.TextSize=WinTheme.Text_Size_Small;Value.TextWrapped=true;Value.Text=current_value..tostring(suffix)Slider_Title.Name="Slider_Title"Slider_Title.Parent=Slider;Slider_Title.BackgroundColor3=RGB(255,255,255)Slider_Title.BackgroundTransparency=1.000;Slider_Title.Position=U2(0,5,0,0)Slider_Title.Size=U2(0,1,0,16)Slider_Title.Font=Enum.Font.Gotham;Slider_Title.Text=info.Text or"Slider"Slider_Title.TextColor3=WinTheme.Text_Color;Slider_Title.TextSize=WinTheme.Text_Size_Medium;Slider_Title.TextXAlignment=Enum.TextXAlignment.Left

                local Dragging = false
                local slider_connection
                local RS_ID = "Slider_"..random_string(10)

                Slider_Detector.MouseEnter:Connect(function()
                    if not Dragging then
                        Slider_Detector.BorderColor3 = WinTheme.Accent;
                        Value.TextColor3 = WinTheme.Accent;
                    end
        
                    infoMessage(info.Description or "")
                end)

                Slider_Detector.MouseLeave:Connect(function()
                    if not Dragging then
                        Slider_Detector.BorderColor3 = WinTheme.Light_Borders;
                        Value.TextColor3 = WinTheme.Text_Color;
                    end

                    resetMessage()
                end)

                Slider_Detector.MouseButton1Down:Connect(function()
                    Dragging = true
                    RS:BindToRenderStep(RS_ID, 1, slider_connection)
                end)

                local c_up; c_up = UIS.InputEnded:Connect(function(input)
                    if DESTROY_UI then
                        c_up:Disconnect()
                    elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
                        if MouseIn(Slider_Detector) then
                            Slider_Detector.BorderColor3 = WinTheme.Accent;
                            Value.TextColor3 = WinTheme.Accent;
                        else
                            Slider_Detector.BorderColor3 = WinTheme.Light_Borders;
                            Value.TextColor3 = WinTheme.Text_Color;
                        end
                        Dragging = false
                        RS:UnbindFromRenderStep(RS_ID)
                    end
                end)

                local min = info.Min
                local max = info.Max
                local difference = max - min

                local function PlaceValue(val)
                    local newval = CLAMP(val, min, max)
                    local SASX = Slider_Detector.AbsoluteSize.X
                    local SAPX = Slider_Detector.AbsolutePosition.X
                    local offset = (newval - min) * SASX / difference
                    if Value.Text ~= tostring(newval)..tostring(suffix) then
                        Value.Text = tostring(newval)..tostring(suffix)
                    end
                    Fill.Size = U2(0, CLAMP(offset, 0, SASX), 1, 0)
                end

                PlaceValue(current_value)

                local previous_value = nil
                slider_connection = function()
                    if DESTROY_UI then
                        RS:UnbindFromRenderStep(RS_ID)
                    elseif Dragging then
                        local SASX = Slider_Detector.AbsoluteSize.X
                        local SAPX = Slider_Detector.AbsolutePosition.X

                        -- PLACING
                        local offset = Mouse.X - SAPX
                        local new_x = CLAMP(offset, 0, SASX)
                        
                        -- CALCULATIONS
                        if decimals >= 1 then
                            local str = "1"
                            for i = 1, decimals do 
                                str = str.."0"
                            end
                            current_value = RoundValue(new_x * difference / SASX + min)
                        else
                            current_value = RoundValue(new_x * difference / SASX + min)
                        end

                        if previous_value ~= current_value then
                            info.CallBack(current_value)
                            previous_value = current_value
                        end
                        PlaceValue(current_value)
                    else
                        PlaceValue(current_value)
                    end
                end

                updateSectionSize()

                local slider_funcs = {}

                function slider_funcs.SetValue(val)
                    current_value = CLAMP(val, min, max)
                    info.CallBack(current_value)
                    PlaceValue(current_value)
                end
                function slider_funcs.GetValue()
                    return current_value
                end
                function slider_funcs.SetText(text)
                    Slider_Title.Text = text or "Slider"
                end
                function slider_funcs.GetText()
                    return Slider_Title.Text
                end

                return slider_funcs
            end

            function section_funcs.NewDropdown(info)
                info.CallBack = info.CallBack or function(a)end
                info.Options = info.Options or {}
                info.Default = info.Default or 1
                info.Text = info.Text or "Dropdown"

                local Dropdown = NEW("Frame")
                local Dropdown_Detector = NEW("TextButton")
                local Fill = NEW("Frame")
                local Current_Option = NEW("TextLabel")
                local Options_Container = NEW("Frame")

                local Options_List = NEW("UIListLayout")
                local Dropdown_Title = NEW("TextLabel")

                Dropdown.Name="Dropdown"Dropdown.Parent=Item_Container;Dropdown.BackgroundColor3=RGB(255,255,255)Dropdown.BackgroundTransparency=1.000;Dropdown.BorderSizePixel=0;Dropdown.Size=U2(1,0,0,34)Dropdown_Detector.Name="Dropdown_Detector"Dropdown_Detector.Parent=Dropdown;Dropdown_Detector.BackgroundColor3=RGB(0,0,0)Dropdown_Detector.BorderColor3=WinTheme.Light_Borders;Dropdown_Detector.Position=U2(0,5,1,-16)Dropdown_Detector.Size=U2(1,-10,0,16)Dropdown_Detector.AutoButtonColor=false;Dropdown_Detector.Font=Enum.Font.Gotham;Dropdown_Detector.Text=""Dropdown_Detector.TextColor3=WinTheme.Text_Color;Dropdown_Detector.TextSize=WinTheme.Text_Size_Medium;Dropdown_Detector.TextWrapped=true;Fill.Name="Fill"Fill.Parent=Dropdown_Detector;Fill.BackgroundColor3=RGB(242,239,255)Fill.BorderSizePixel=0;Fill.Position=U2(1,-6,0,0)Fill.Size=U2(0,6,1,0)Current_Option.Name="Current_Option"Current_Option.Parent=Dropdown_Detector;Current_Option.BackgroundColor3=RGB(255,255,255)Current_Option.BackgroundTransparency=1.000;Current_Option.Position=U2(0,5,0,0)Current_Option.Size=U2(0,1,1,0)Current_Option.Font=Enum.Font.Gotham;Current_Option.Text=info.Options[info.Default]or"None"Current_Option.TextColor3=WinTheme.Text_Color;Current_Option.TextSize=WinTheme.Text_Size_Small;Current_Option.TextXAlignment=Enum.TextXAlignment.Left;Options_Container.Name="Options_Container"Options_Container.Parent=Dropdown_Detector;Options_Container.BackgroundColor3=RGB(255,255,255)Options_Container.BackgroundTransparency=1.000;Options_Container.Position=U2(0,0,1,8)Options_Container.Visible=false;Options_Container.Size=U2(1,-6,1,0)Options_List.Parent=Options_Container;Options_List.SortOrder=Enum.SortOrder.LayoutOrder;Options_List.Padding=U1(0,1)Dropdown_Title.Name="Dropdown_Title"Dropdown_Title.Parent=Dropdown;Dropdown_Title.BackgroundColor3=RGB(255,255,255)Dropdown_Title.BackgroundTransparency=1.000;Dropdown_Title.Position=U2(0,5,0,0)Dropdown_Title.Size=U2(0,1,0,16)Dropdown_Title.Font=Enum.Font.Gotham;Dropdown_Title.Text=info.Text or"Dropdown"Dropdown_Title.TextColor3=WinTheme.Text_Color;Dropdown_Title.TextSize=WinTheme.Text_Size_Medium;Dropdown_Title.TextXAlignment=Enum.TextXAlignment.Left

                local previous_option
                Dropdown_Detector.MouseButton1Click:Connect(function()
                    Options_Container.Visible = not Options_Container.Visible

                    if Options_Container.Visible then
                        previous_option = Current_Option.Text
                        Current_Option.Text = "Selecting..."
                    else
                        Current_Option.Text = previous_option
                    end
                end)

                Dropdown_Detector.MouseEnter:Connect(function()
                    Dropdown_Detector.BorderColor3 = WinTheme.Accent;
                    Current_Option.TextColor3 = WinTheme.Accent;
        
                    infoMessage(info.Description or "")
                end)
            
                Dropdown_Detector.MouseLeave:Connect(function()
                    resetMessage()
        
                    Dropdown_Detector.BorderColor3 = WinTheme.Light_Borders;
                    Current_Option.TextColor3 = WinTheme.Text_Color;
                end)

                local function addOption(v)
                    local Option = NEW("TextButton")
                    local Option_Title = NEW("TextLabel")

                    Option.Name="Option"Option.Parent=Options_Container;Option.BackgroundColor3=RGB(0,0,0)Option.BorderColor3=RGB(10,10,10)Option.Size=U2(1,0,0,16)Option.ZIndex=10;Option.AutoButtonColor=false;Option.Font=Enum.Font.SourceSans;Option.Text=""Option.TextColor3=RGB(0,0,0)Option.TextSize=WinTheme.Text_Size_Medium;Option_Title.Name="Option_Title"Option_Title.Parent=Option;Option_Title.BackgroundColor3=RGB(255,255,255)Option_Title.BackgroundTransparency=1.000;Option_Title.Position=U2(0,5,0,0)Option_Title.Size=U2(0,1,1,0)Option_Title.ZIndex=11;Option_Title.Font=Enum.Font.Gotham;Option_Title.Text=v or"Option"Option_Title.TextColor3=WinTheme.Text_Color;Option_Title.TextSize=WinTheme.Text_Size_Small;Option_Title.TextXAlignment=Enum.TextXAlignment.Left

                    Option.MouseButton1Click:Connect(function()
                        Current_Option.Text = v
                        Options_Container.Visible = false
                        info.CallBack(v)
                    end)
    
                    Option.MouseEnter:Connect(function()
                        Option.ZIndex = 12
                        Option_Title.ZIndex = 13

                        Option.BorderColor3 = WinTheme.Accent;
                        Option_Title.TextColor3 = WinTheme.Accent;

                        infoMessage(info.Description or "")
                    end)
                
                    Option.MouseLeave:Connect(function()
                        resetMessage()

                        Option.ZIndex = 10
                        Option_Title.ZIndex = 11

                        Option.BorderColor3 = RGB(10, 10, 10)
                        Option_Title.TextColor3 = WinTheme.Text_Color;
                    end)
                end

                for i,v in pairs(info.Options) do
                    addOption(v)
                end

                updateSectionSize()

                local dropdown_funcs = {}

                function dropdown_funcs.SetOption(option)
                    Current_Option.Text = option
                    Options_Container.Visible = false
                    info.CallBack(option)
                end
                function dropdown_funcs.GetCurrent()
                    return Current_Option.Text
                end
                function dropdown_funcs.AddOption(option)
                    addOption(option)
                end

                return dropdown_funcs
            end

            function section_funcs.NewKeybind(info)
                info.CallBack = info.CallBack or function()end
                info.KCallBack = info.KCallBack or function()end
                info.Default = info.Default or nil
                info.Text = info.Text or "Keybind"

                local Keybind = NEW("Frame")
                local Keybind_Detector = NEW("TextButton")
                local Fill = NEW("Frame")
                local Current_Keybind = NEW("TextLabel")
                local Keybind_Title = NEW("TextLabel")

                Keybind.Name="Keybind"Keybind.Parent=Item_Container;Keybind.BackgroundColor3=RGB(255,255,255)Keybind.BackgroundTransparency=1.000;Keybind.BorderSizePixel=0;Keybind.Size=U2(1,0,0,34)Keybind_Detector.Name="Keybind_Detector"Keybind_Detector.Parent=Keybind;Keybind_Detector.BackgroundColor3=RGB(0,0,0)Keybind_Detector.BorderColor3=WinTheme.Light_Borders;Keybind_Detector.Position=U2(0,5,1,-16)Keybind_Detector.Size=U2(1,-10,0,16)Keybind_Detector.AutoButtonColor=false;Keybind_Detector.Font=Enum.Font.Gotham;Keybind_Detector.Text=""Keybind_Detector.TextColor3=WinTheme.Text_Color;Keybind_Detector.TextSize=WinTheme.Text_Size_Medium;Keybind_Detector.TextWrapped=true;Fill.Name="Fill"Fill.Parent=Keybind_Detector;Fill.BackgroundColor3=RGB(242,239,255)Fill.BorderSizePixel=0;Fill.Position=U2(1,-6,0,0)Fill.Size=U2(0,6,1,0)Current_Keybind.Name="Current_Keybind"Current_Keybind.Parent=Keybind_Detector;Current_Keybind.BackgroundColor3=RGB(255,255,255)Current_Keybind.BackgroundTransparency=1.000;Current_Keybind.Position=U2(0,5,0,0)Current_Keybind.Size=U2(0,1,1,0)Current_Keybind.Font=Enum.Font.Gotham;Current_Keybind.TextColor3=WinTheme.Text_Color;Current_Keybind.TextSize=WinTheme.Text_Size_Small;Current_Keybind.TextXAlignment=Enum.TextXAlignment.Left

                local Current = info.Default
                local function setKeybind(new)
                    Current = new
                    if not Current then
                        Current_Keybind.Text = "None"
                    else
                        Current_Keybind.Text = SUB(tostring(Current), 14, #tostring(Current)) 
                    end
                    info.KCallBack(Current) 
                end
                setKeybind(Current)

                Keybind_Title.Name="Keybind_Title"Keybind_Title.Parent=Keybind;Keybind_Title.BackgroundColor3=RGB(255,255,255)Keybind_Title.BackgroundTransparency=1.000;Keybind_Title.Position=U2(0,5,0,0)Keybind_Title.Size=U2(0,1,0,16)Keybind_Title.Font=Enum.Font.Gotham;Keybind_Title.Text=info.Text or"Keybind"Keybind_Title.TextColor3=WinTheme.Text_Color;Keybind_Title.TextSize=WinTheme.Text_Size_Medium;Keybind_Title.TextXAlignment=Enum.TextXAlignment.Left

                local Binding = false
                local function startSelection()
                    if not Binding then
                        Binding = true
                        
                        setKeybind(nil)

                        Current_Keybind.Text = "Binding..."

                        local set_c
                        local del_c

                        set_c = UIS.InputBegan:Connect(function(input, gameProcessed)
                            if DESTROY_UI then
                                set_c:Disconnect()
                            elseif not gameProcessed and input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode ~= Enum.KeyCode.Backspace and input.KeyCode ~= Enum.KeyCode.Delete then
                                setKeybind(input.KeyCode)
                                set_c:Disconnect()
                                del_c:Disconnect()
                                RStepped:Wait()
                                Binding = false
                            end
                        end)
                        del_c = UIS.InputBegan:Connect(function(input, gameProcessed)
                            if DESTROY_UI then
                                del_c:Disconnect()
                            elseif not gameProcessed and ((input.UserInputType == Enum.UserInputType.Keyboard and (input.KeyCode == Enum.KeyCode.Backspace or input.KeyCode == Enum.KeyCode.Delete)) or (not MouseIn(Keybind_Detector) and input.UserInputType == Enum.UserInputType.MouseButton2)) then
                                setKeybind(nil)
                                set_c:Disconnect()
                                del_c:Disconnect()
                                RStepped:Wait()
                                Binding = false
                            end
                        end)
                    end
                end

                local c_press
                c_press = UIS.InputBegan:Connect(function(input, gameProcessed)
                    if DESTROY_UI then
                        c_press:Disconnect()
                    elseif not gameProcessed and input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Current and Binding == false then
                        info.CallBack()
                    end
                end)

                Keybind_Detector.MouseButton1Click:Connect(function()
                    startSelection()
                end)

                Keybind_Detector.MouseEnter:Connect(function()
                    Keybind_Detector.BorderColor3 = WinTheme.Accent;
                    Current_Keybind.TextColor3 = WinTheme.Accent;
        
                    infoMessage(info.Description or "")
                end)
            
                Keybind_Detector.MouseLeave:Connect(function()
                    resetMessage()
        
                    Keybind_Detector.BorderColor3 = WinTheme.Light_Borders;
                    Current_Keybind.TextColor3 = WinTheme.Text_Color;
                end)

                updateSectionSize()

                local keybind_funcs = {}

                function keybind_funcs.SetKey(key)
                    setKeybind(key)
                end
                function keybind_funcs.GetKey()
                    return Current
                end

                function keybind_funcs.SetText(text)
                    Keybind_Title.Text = text
                end
                function keybind_funcs.GetText()
                    return Keybind_Title.Text
                end

                return keybind_funcs
            end

            function section_funcs.NewColorPicker(info)
                info.CallBack = info.CallBack or function(a)end
                info.Default = info.Default or RGB(255, 255, 255)
                info.Text = info.Text or "Colorpicker"

                local bindName = "CPBinding"..random_string(10)
                
                -- ITEM
                local Colorpicker = NEW("Frame")
                local Colorpicker_Title = NEW("TextLabel")
                local Colorpicker_Detector = NEW("ImageButton")
                local Detector_Gradient = NEW("UIGradient")

                Colorpicker.Name="Colorpicker"Colorpicker.Parent=Item_Container;Colorpicker.BackgroundColor3=RGB(255,255,255)Colorpicker.BackgroundTransparency=1.000;Colorpicker.BorderSizePixel=0;Colorpicker.Size=U2(1,0,0,16)Colorpicker_Title.Name="Colorpicker_Title"Colorpicker_Title.Parent=Colorpicker;Colorpicker_Title.BackgroundColor3=RGB(255,255,255)Colorpicker_Title.BackgroundTransparency=1.000;Colorpicker_Title.Position=U2(0,5,0,0)Colorpicker_Title.Size=U2(0,1,1,0)Colorpicker_Title.Font=Enum.Font.Gotham;Colorpicker_Title.Text=info.Text or"Color"Colorpicker_Title.TextColor3=WinTheme.Text_Color;Colorpicker_Title.TextSize=WinTheme.Text_Size_Medium;Colorpicker_Title.TextXAlignment=Enum.TextXAlignment.Left;Colorpicker_Detector.Name="Colorpicker_Detector"Colorpicker_Detector.Parent=Colorpicker;Colorpicker_Detector.BackgroundColor3=RGB(0,0,0)Colorpicker_Detector.BorderColor3=WinTheme.Light_Borders;Colorpicker_Detector.Position=U2(1,-23,0.5,-6)Colorpicker_Detector.Size=U2(0,18,0,12)Colorpicker_Detector.AutoButtonColor=false;Colorpicker_Detector.ImageTransparency=1.000;Detector_Gradient.Color=COLOR_SEQUENCE{COLOR_KEYPOINT(0.00,RGB(255,255,255)),COLOR_KEYPOINT(0.54,RGB(225,225,225)),COLOR_KEYPOINT(1.00,RGB(125,125,125))}Detector_Gradient.Rotation=90;Detector_Gradient.Name="Detector_Gradient"Detector_Gradient.Parent=Colorpicker_Detector

                -- PICKER WINDOW
                local Picker = NEW("Frame")
                local Picker_Title = NEW("TextLabel")
                local Picker_Close = NEW("ImageButton")
                local Picker_Close_Left = NEW("Frame")
                local Picker_Close_Right = NEW("Frame")
                local Picker_Main = NEW("Frame")
                local HSVBox = NEW("ImageButton")
                local Cursor = NEW("Frame")
                local HUEPicker = NEW("ImageButton")
                local Indicator = NEW("Frame")
                local HUEGradient = NEW("UIGradient")
                local R_Box = NEW("Frame")
                local R_Value = NEW("TextBox")
                local R_Fill = NEW("Frame")
                local G_Box = NEW("Frame")
                local G_Value = NEW("TextBox")
                local G_Fill = NEW("Frame")
                local B_Box = NEW("Frame")
                local B_Value = NEW("TextBox")
                local B_Fill = NEW("Frame")
                local Copy_Values = NEW("TextButton")
                local HEX = NEW("Frame")
                local HEX_Value = NEW("TextBox")
                local HEX_Fill = NEW("Frame")

                Picker.Name="Picker"Picker.Parent=Picker_Windows;Picker.BackgroundColor3=WinTheme.Background;Picker.BorderColor3=WinTheme.Dark_Borders;Picker.Position=U2(0.150000006,0,0.5,0)Picker.Size=U2(0,250,0,16)Picker.ZIndex=100010;Picker.Visible=false;Picker.Active=true;Picker.Draggable=true;Picker_Title.Name="Picker_Title"Picker_Title.Parent=Picker;Picker_Title.BackgroundColor3=RGB(255,255,255)Picker_Title.BackgroundTransparency=1.000;Picker_Title.Position=U2(0,5,0,0)Picker_Title.Size=U2(0,1,1,0)Picker_Title.ZIndex=100011;Picker_Title.Font=Enum.Font.Gotham;Picker_Title.Text="Color: "..(Page_Option.Text or"Page").."/"..(info.Text or"Color")Picker_Title.TextColor3=WinTheme.Text_Color;Picker_Title.TextSize=WinTheme.Text_Size_Medium;Picker_Title.TextXAlignment=Enum.TextXAlignment.Left;Picker_Close.Name="Picker_Close"Picker_Close.Parent=Picker;Picker_Close.BackgroundTransparency=1;Picker_Close.BackgroundColor3=WinTheme.Background;Picker_Close.BorderColor3=WinTheme.Accent;Picker_Close.BorderSizePixel=1;Picker_Close.Position=U2(1,-16,0,0)Picker_Close.Size=U2(0,16,0,16)Picker_Close.ZIndex=100011;Picker_Close.AutoButtonColor=false;Picker_Close.Image="rbxassetid://7248316188"Picker_Close_Left.Name="Picker_Close_Left"Picker_Close_Left.Parent=Picker_Close;Picker_Close_Left.BackgroundColor3=WinTheme.Background;Picker_Close_Left.BorderSizePixel=0;Picker_Close_Left.Size=U2(0,4,1,0)Picker_Close_Left.ZIndex=100012;Picker_Close_Right.Name="Picker_Close_Right"Picker_Close_Right.Parent=Picker_Close;Picker_Close_Right.BackgroundColor3=WinTheme.Background;Picker_Close_Right.BorderSizePixel=0;Picker_Close_Right.Position=U2(1,-4,0,0)Picker_Close_Right.Size=U2(0,4,1,0)Picker_Close_Right.ZIndex=100012;Picker_Main.Name="Picker_Main"Picker_Main.Parent=Picker;Picker_Main.BackgroundColor3=WinTheme.Background;Picker_Main.BorderColor3=WinTheme.Dark_Borders;Picker_Main.Position=U2(0,0,0,17)Picker_Main.Size=U2(1,0,0,134)Picker_Main.ZIndex=100003;HSVBox.Name="HSVBox"HSVBox.Parent=Picker_Main;HSVBox.BackgroundColor3=RGB(255,0,4)HSVBox.BorderColor3=RGB(0,0,0)HSVBox.Position=U2(0,8,0,8)HSVBox.Size=U2(0,118,1,-16)HSVBox.ZIndex=100003;HSVBox.AutoButtonColor=false;HSVBox.Image="rbxassetid://4155801252"Cursor.Name="Cursor"Cursor.Parent=HSVBox;Cursor.BackgroundColor3=RGB(255,255,255)Cursor.BorderColor3=RGB(0,0,0)Cursor.Size=U2(0,1,0,1)Cursor.ZIndex=100003;HUEPicker.Name="HUEPicker"HUEPicker.Parent=Picker_Main;HUEPicker.BackgroundColor3=RGB(255,255,255)HUEPicker.BorderColor3=RGB(0,0,0)HUEPicker.Position=U2(0,131,0,8)HUEPicker.Size=U2(0,10,1,-16)HUEPicker.ZIndex=100003;HUEPicker.AutoButtonColor=false;Indicator.Name="Indicator"Indicator.Parent=HUEPicker;Indicator.BackgroundColor3=RGB(0,0,0)Indicator.BorderColor3=WinTheme.Light_Borders;Indicator.Size=U2(1,0,0,2)Indicator.ZIndex=100003;HUEGradient.Color=COLOR_SEQUENCE{COLOR_KEYPOINT(0.00,RGB(255,0,4)),COLOR_KEYPOINT(0.10,RGB(255,0,200)),COLOR_KEYPOINT(0.20,RGB(153,0,255)),COLOR_KEYPOINT(0.30,RGB(0,0,255)),COLOR_KEYPOINT(0.40,RGB(0,149,255)),COLOR_KEYPOINT(0.50,RGB(0,255,209)),COLOR_KEYPOINT(0.60,RGB(0,255,55)),COLOR_KEYPOINT(0.70,RGB(98,255,0)),COLOR_KEYPOINT(0.80,RGB(251,255,0)),COLOR_KEYPOINT(0.90,RGB(255,106,0)),COLOR_KEYPOINT(1.00,RGB(255,0,0))}HUEGradient.Rotation=90;HUEGradient.Name="HUEGradient"HUEGradient.Parent=HUEPicker;R_Box.Name="R_Box"R_Box.Parent=Picker_Main;R_Box.BackgroundColor3=RGB(0,0,0)R_Box.BorderColor3=WinTheme.Light_Borders;R_Box.Position=U2(1,-95,0,8)R_Box.Size=U2(0,90,0,16)R_Box.ZIndex=100003;R_Value.Name="R_Value"R_Value.Parent=R_Box;R_Value.BackgroundColor3=RGB(255,255,255)R_Value.BackgroundTransparency=1.000;R_Value.Position=U2(0,5,0,0)R_Value.Size=U2(1,-5,1,0)R_Value.ZIndex=100003;R_Value.ClearTextOnFocus=false;R_Value.Font=Enum.Font.Gotham;R_Value.PlaceholderColor3=RGB(178,178,178)R_Value.PlaceholderText="R"R_Value.Text="155"R_Value.TextColor3=WinTheme.Text_Color;R_Value.TextSize=WinTheme.Text_Size_Small;R_Value.TextXAlignment=Enum.TextXAlignment.Left;R_Fill.Name="R_Fill"R_Fill.Parent=R_Box;R_Fill.BackgroundColor3=RGB(242,239,255)R_Fill.BorderSizePixel=0;R_Fill.Position=U2(1,-6,0,0)R_Fill.Size=U2(0,6,1,0)R_Fill.ZIndex=100003

                do -- R_Box VALUE
                    R_Box.MouseEnter:Connect(function()
                        R_Box.BorderColor3 = WinTheme.Accent;
                        R_Value.TextColor3 = WinTheme.Accent;

                        infoMessage("Red setting format: 0-255")
                    end)
                
                    R_Box.MouseLeave:Connect(function()
                        resetMessage()

                        R_Box.BorderColor3 = WinTheme.Light_Borders;
                        R_Value.TextColor3 = WinTheme.Text_Color;
                    end)
                end

                G_Box.Name="G_Box"G_Box.Parent=Picker_Main;G_Box.BackgroundColor3=RGB(0,0,0)G_Box.BorderColor3=WinTheme.Light_Borders;G_Box.Position=U2(1,-95,0,32)G_Box.Size=U2(0,90,0,16)G_Box.ZIndex=100003;G_Value.Name="G_Value"G_Value.Parent=G_Box;G_Value.BackgroundColor3=RGB(255,255,255)G_Value.BackgroundTransparency=1.000;G_Value.Position=U2(0,5,0,0)G_Value.Size=U2(1,-5,1,0)G_Value.ZIndex=100003;G_Value.ClearTextOnFocus=false;G_Value.Font=Enum.Font.Gotham;G_Value.PlaceholderText="G"G_Value.Text="155"G_Value.TextColor3=WinTheme.Text_Color;G_Value.TextSize=WinTheme.Text_Size_Small;G_Value.TextXAlignment=Enum.TextXAlignment.Left;G_Fill.Name="G_Fill"G_Fill.Parent=G_Box;G_Fill.BackgroundColor3=RGB(242,239,255)G_Fill.BorderSizePixel=0;G_Fill.Position=U2(1,-6,0,0)G_Fill.Size=U2(0,6,1,0)G_Fill.ZIndex=100003

                do -- G_Box VALUE
                    G_Box.MouseEnter:Connect(function()
                        G_Box.BorderColor3 = WinTheme.Accent;
                        G_Value.TextColor3 = WinTheme.Accent;

                        infoMessage("Green setting format: 0-255")
                    end)
                
                    G_Box.MouseLeave:Connect(function()
                        resetMessage()

                        G_Box.BorderColor3 = WinTheme.Light_Borders;
                        G_Value.TextColor3 = WinTheme.Text_Color;
                    end)
                end

                B_Box.Name="B_Box"B_Box.Parent=Picker_Main;B_Box.BackgroundColor3=RGB(0,0,0)B_Box.BorderColor3=WinTheme.Light_Borders;B_Box.Position=U2(1,-95,0,56)B_Box.Size=U2(0,90,0,16)B_Box.ZIndex=100003;B_Value.Name="B_Value"B_Value.Parent=B_Box;B_Value.BackgroundColor3=RGB(255,255,255)B_Value.BackgroundTransparency=1.000;B_Value.Position=U2(0,5,0,0)B_Value.Size=U2(1,-5,1,0)B_Value.ZIndex=100003;B_Value.ClearTextOnFocus=false;B_Value.Font=Enum.Font.Gotham;B_Value.PlaceholderText="B"B_Value.Text="155"B_Value.TextColor3=WinTheme.Text_Color;B_Value.TextSize=WinTheme.Text_Size_Small;B_Value.TextXAlignment=Enum.TextXAlignment.Left;B_Fill.Name="B_Fill"B_Fill.Parent=B_Box;B_Fill.BackgroundColor3=RGB(242,239,255)B_Fill.BorderSizePixel=0;B_Fill.Position=U2(1,-6,0,0)B_Fill.Size=U2(0,6,1,0)B_Fill.ZIndex=100003

                do -- B_Box VALUE
                    B_Box.MouseEnter:Connect(function()
                        B_Box.BorderColor3 = WinTheme.Accent;
                        B_Value.TextColor3 = WinTheme.Accent;

                        infoMessage("Blue setting format: 0-255")
                    end)
                
                    B_Box.MouseLeave:Connect(function()
                        resetMessage()

                        B_Box.BorderColor3 = WinTheme.Light_Borders;
                        B_Value.TextColor3 = WinTheme.Text_Color;
                    end)
                end

                HEX.Name="HEX"HEX.Parent=Picker_Main;HEX.BackgroundColor3=RGB(0,0,0)HEX.BorderColor3=WinTheme.Light_Borders;HEX.Position=U2(1,-95,0,80)HEX.Size=U2(0,90,0,16)HEX.ZIndex=100003;HEX_Value.Name="HEX_Value"HEX_Value.Parent=HEX;HEX_Value.BackgroundColor3=RGB(255,255,255)HEX_Value.BackgroundTransparency=1.000;HEX_Value.Position=U2(0,5,0,0)HEX_Value.Size=U2(1,-5,1,0)HEX_Value.ZIndex=100003;HEX_Value.ClearTextOnFocus=false;HEX_Value.Font=Enum.Font.Gotham;HEX_Value.PlaceholderText="HEX"HEX_Value.Text="FFFFFF"HEX_Value.TextColor3=WinTheme.Text_Color;HEX_Value.TextSize=WinTheme.Text_Size_Small;HEX_Value.TextXAlignment=Enum.TextXAlignment.Left;HEX_Fill.Name="HEX_Fill"HEX_Fill.Parent=HEX;HEX_Fill.BackgroundColor3=RGB(242,239,255)HEX_Fill.BorderSizePixel=0;HEX_Fill.Position=U2(1,-6,0,0)HEX_Fill.Size=U2(0,6,1,0)HEX_Fill.ZIndex=100003

                do -- HEX VALUE
                    HEX.MouseEnter:Connect(function()
                        HEX.BorderColor3 = WinTheme.Accent;
                        HEX_Value.TextColor3 = WinTheme.Accent;

                        infoMessage("Hexadecimal setting format: #000000")
                    end)
                
                    HEX.MouseLeave:Connect(function()
                        resetMessage()

                        HEX.BorderColor3 = WinTheme.Light_Borders;
                        HEX_Value.TextColor3 = WinTheme.Text_Color;
                    end)
                end

                Copy_Values.Name="Copy_Values"Copy_Values.Parent=Picker_Main;Copy_Values.BackgroundColor3=RGB(0,0,0)Copy_Values.BorderColor3=WinTheme.Light_Borders;Copy_Values.Position=U2(1,-95,0,109)Copy_Values.Size=U2(0,90,0,16)Copy_Values.ZIndex=100003;Copy_Values.AutoButtonColor=false;Copy_Values.Font=Enum.Font.Gotham;Copy_Values.Text="Copy Values"Copy_Values.TextColor3=WinTheme.Text_Color;Copy_Values.TextSize=WinTheme.Text_Size_Small;Copy_Values.TextWrapped=true
                do -- COPY VALUES
                    Copy_Values.MouseButton1Click:Connect(function()
                        if setclipboard then setclipboard(R_Value.Text..", "..G_Value.Text..", "..B_Value.Text) end
                    end)
    
                    Copy_Values.MouseEnter:Connect(function()
                        Copy_Values.BorderColor3 = WinTheme.Accent;
                        Copy_Values.TextColor3 = WinTheme.Accent;

                        infoMessage("Copies RGB values to your clipboard")
                    end)
                
                    Copy_Values.MouseLeave:Connect(function()
                        resetMessage()

                        Copy_Values.BorderColor3 = WinTheme.Light_Borders;
                        Copy_Values.TextColor3 = WinTheme.Text_Color;
                    end)
                end

                R_Value.Text = ROUND(info.Default.R*255)
                G_Value.Text = ROUND(info.Default.G*255)
                B_Value.Text = ROUND(info.Default.B*255)

                Colorpicker_Detector.BackgroundColor3 = info.Default

                local previous = nil

                local function PlaceColor(col) -- RGB Color
                    local h, s, v = ColorModule:rgbToHsv(col.r*255, col.g*255, col.b*255)

                    Indicator.Position = U2(0, 0, 0, HUEPicker.AbsoluteSize.Y - HUEPicker.AbsoluteSize.Y * h)
                    Cursor.Position = U2(0, HSVBox.AbsoluteSize.X * s, 0, HSVBox.AbsoluteSize.Y - HSVBox.AbsoluteSize.Y * v)

                    HEX_Value.Text = rgbToHex(col)

                    Colorpicker_Detector.BackgroundColor3 = col

                    HSVBox.BackgroundColor3 = HSV(h, 1, 1)
                    if col ~= previous then
                        previous = col
                        info.CallBack(col)
                    end
                end

                local function PlaceColorHSV(hsv) -- HSV Color
                    local h = hsv.h
                    local s = hsv.s
                    local v = hsv.v
                    HSVBox.BackgroundColor3 = HSV(h, 1, 1)
                    local newh, news, newv = ColorModule:hsvToRgb(h, s, v)
                    R_Value.Text = ROUND(newh)
                    G_Value.Text = ROUND(news)
                    B_Value.Text = ROUND(newv)
                    HEX_Value.Text = rgbToHex(RGB(ROUND(newh), ROUND(news), ROUND(newv)))
                    Colorpicker_Detector.BackgroundColor3 = RGB(ROUND(newh), ROUND(news), ROUND(newv))

                    local col = RGB(newh, news, newv)
                    if col ~= previous then
                        previous = col
                        info.CallBack(col)
                    end
                end

                PlaceColor(info.Default)

                local SelectingHUE = false
                local SelectingHSV = false
                
                local prev1
                R_Value.Changed:Connect(function(property)
                    if (SelectingHUE == false and SelectingHSV == false) and tostring(property) == "Text" and tonumber(R_Value.Text) then
                        R_Value.Text = CLAMP(tonumber(R_Value.Text), 0, 255)
                        PlaceColor(RGB(tonumber(R_Value.Text), tonumber(G_Value.Text), tonumber(B_Value.Text)))
                        Colorpicker_Detector.BackgroundColor3 = RGB(tonumber(R_Value.Text), tonumber(G_Value.Text), tonumber(B_Value.Text))
                        prev1 = tonumber(R_Value.Text)
                    elseif (SelectingHUE == false and SelectingHSV == false) and tostring(property) == "Text" and R_Value.Text == " " then
                        R_Value.Text = prev1
                    end
                end)

                local prev2
                G_Value.Changed:Connect(function(property)
                    if (SelectingHUE == false and SelectingHSV == false) and tostring(property) == "Text" and tonumber(G_Value.Text) then
                        G_Value.Text = CLAMP(tonumber(G_Value.Text), 0, 255)
                        PlaceColor(RGB(tonumber(R_Value.Text), tonumber(G_Value.Text), tonumber(B_Value.Text)))
                        Colorpicker_Detector.BackgroundColor3 = RGB(tonumber(R_Value.Text), tonumber(G_Value.Text), tonumber(B_Value.Text))
                        prev2 = tonumber(G_Value.Text)
                    elseif (SelectingHUE == false and SelectingHSV == false) and tostring(property) == "Text" and G_Value.Text == " " then
                        G_Value.Text = prev2
                    end
                end)

                local prev3
                B_Value.Changed:Connect(function(property)
                    if (SelectingHUE == false and SelectingHSV == false) and tostring(property) == "Text" and tonumber(B_Value.Text) then
                        B_Value.Text = CLAMP(tonumber(B_Value.Text), 0, 255)
                        PlaceColor(RGB(tonumber(R_Value.Text), tonumber(G_Value.Text), tonumber(B_Value.Text)))
                        Colorpicker_Detector.BackgroundColor3 = RGB(tonumber(R_Value.Text), tonumber(G_Value.Text), tonumber(B_Value.Text))
                        prev3 = tonumber(B_Value.Text)
                    elseif (SelectingHUE == false and SelectingHSV == false) and tostring(property) == "Text" and B_Value.Text == " " then
                        B_Value.Text = prev3
                    end
                end)

                local prevHEX
                HEX_Value.Changed:Connect(function(property)
                    if (SelectingHUE == false and SelectingHSV == false) and tostring(property) == "Text" and #HEX_Value.Text == 7 then
                        PlaceColor(hexToRGB(HEX_Value.Text))
                    end
                end)

                HUEPicker.MouseButton1Down:Connect(function()
                    SelectingHUE = true
                    Indicator.BorderColor3 = WinTheme.Accent;
                end)
                HSVBox.MouseButton1Down:Connect(function()
                    SelectingHSV = true
                    Cursor.BorderColor3 = WinTheme.Accent;
                end)

                local selecting_c
                selecting_c = UIS.InputEnded:Connect(function(input)
                    if DESTROY_UI then
                        selecting_c:Disconnect()
                    elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
                        SelectingHUE = false
                        SelectingHSV = false

                        Cursor.BorderColor3 = RGB(0, 0, 0)
                        Indicator.BorderColor3 = WinTheme.Light_Borders;
                    end
                end)
                
                local colorpicker_c
                colorpicker_c = function()
                    if DESTROY_UI then
                        RS:UnbindFromRenderStep(bindName)
                    else
                        if SelectingHUE then
                            Indicator.Position = U2(0, 0, 0, CLAMP(Mouse.Y - HUEPicker.AbsolutePosition.Y, 0, HUEPicker.AbsoluteSize.Y))
                            local h1 = (HUEPicker.AbsoluteSize.Y - (Indicator.AbsolutePosition.Y - HUEPicker.AbsolutePosition.Y)) / HUEPicker.AbsoluteSize.Y
                            local s1 = (Cursor.AbsolutePosition.X - HSVBox.AbsolutePosition.X) / HSVBox.AbsoluteSize.X
                            local v1 = (HSVBox.AbsoluteSize.Y - (Cursor.AbsolutePosition.Y - HSVBox.AbsolutePosition.Y)) / HSVBox.AbsoluteSize.Y
                            PlaceColorHSV({h = h1, s = s1, v = v1})
                        end
                        if SelectingHSV then
                            Cursor.Position = U2(0, CLAMP(Mouse.X - HSVBox.AbsolutePosition.X, 0, HSVBox.AbsoluteSize.X), 0, CLAMP(Mouse.Y - HSVBox.AbsolutePosition.Y, 0, HSVBox.AbsoluteSize.Y))
                            local h1 = (HUEPicker.AbsoluteSize.Y - (Indicator.AbsolutePosition.Y - HUEPicker.AbsolutePosition.Y)) / HUEPicker.AbsoluteSize.Y
                            local s1 = (Cursor.AbsolutePosition.X - HSVBox.AbsolutePosition.X) / HSVBox.AbsoluteSize.X
                            local v1 = (HSVBox.AbsoluteSize.Y - (Cursor.AbsolutePosition.Y - HSVBox.AbsolutePosition.Y)) / HSVBox.AbsoluteSize.Y
                            PlaceColorHSV({h = h1, s = s1, v = v1})
                        end
                    end
                end

                do -- CLOSE
                    Picker_Close.MouseButton1Click:Connect(function()
                        Picker.Visible = false
                        RS:UnbindFromRenderStep(bindName)
                    end)

                    Picker_Close.MouseEnter:Connect(function()
                        Picker_Close.BackgroundTransparency = 0
                        Picker_Close.ImageColor3 = WinTheme.Accent;
                    end)
                
                    Picker_Close.MouseLeave:Connect(function()
                        Picker_Close.BackgroundTransparency = 1
                        Picker_Close.ImageColor3 = RGB(255, 255, 255)
                    end)
                end

                do -- CP DETECTOR
                    Colorpicker_Detector.MouseButton1Click:Connect(function()
                        Picker.Visible = not Picker.Visible

                        if Picker.Visible then
                            RS:BindToRenderStep(bindName, 1, colorpicker_c)
                        else
                            RS:UnbindFromRenderStep(bindName)
                        end
                    end)
    
                    Colorpicker_Detector.MouseEnter:Connect(function()
                        Colorpicker_Detector.BorderColor3 = WinTheme.Accent;

                        infoMessage(info.Description or "")
                    end)
                
                    Colorpicker_Detector.MouseLeave:Connect(function()
                        resetMessage()

                        Colorpicker_Detector.BorderColor3 = WinTheme.Light_Borders;
                    end)
                end

                updateSectionSize()

                local color_picker_funcs = {}

                function color_picker_funcs.SetColor(new)
                    PlaceColor(new)
                end
                function color_picker_funcs.GetColor()
                    return Colorpicker_Detector.BackgroundColor3
                end

                function color_picker_funcs.SetText(text)
                    Colorpicker_Title.Text = text
                end
                function color_picker_funcs.GetText()
                    return Colorpicker_Title.Text
                end

                return color_picker_funcs
            end 
            
            function section_funcs.NewChipset(info)
                info.CallBack = info.CallBack or function(a)end
                info.Text = info.Text or "Chipset"
                local Options = info.Options or {}

                local ChipSet = NEW("Frame")
                local Chipset_Detector = NEW("TextButton")
                local Chipset_Title = NEW("TextLabel")
                local Chipset_Arrow = NEW("TextLabel")
                local Options_Container = NEW("Frame")
                local Options_List = NEW("UIListLayout")

                ChipSet.Name="ChipSet"ChipSet.Parent=Item_Container;ChipSet.BackgroundColor3=RGB(255,255,255)ChipSet.BackgroundTransparency=1.000;ChipSet.BorderSizePixel=0;ChipSet.Size=U2(1,0,0,16)Chipset_Detector.Name="Chipset_Detector"Chipset_Detector.Parent=ChipSet;Chipset_Detector.BackgroundColor3=RGB(0,0,0)Chipset_Detector.BorderColor3=WinTheme.Light_Borders;Chipset_Detector.Position=U2(0,5,1,-16)Chipset_Detector.Size=U2(1,-10,0,16)Chipset_Detector.AutoButtonColor=false;Chipset_Detector.Font=Enum.Font.Gotham;Chipset_Detector.Text=""Chipset_Detector.TextColor3=WinTheme.Text_Color;Chipset_Detector.TextSize=WinTheme.Text_Size_Medium;Chipset_Detector.TextWrapped=true;Chipset_Title.Name="Chipset_Title"Chipset_Title.Parent=Chipset_Detector;Chipset_Title.BackgroundColor3=RGB(255,255,255)Chipset_Title.BackgroundTransparency=1.000;Chipset_Title.Position=U2(0,5,0,0)Chipset_Title.Size=U2(0,1,1,0)Chipset_Title.Font=Enum.Font.Gotham;Chipset_Title.Text=info.Text or"Chipset"Chipset_Title.TextColor3=WinTheme.Text_Color;Chipset_Title.TextSize=WinTheme.Text_Size_Small;Chipset_Title.TextXAlignment=Enum.TextXAlignment.Left;Chipset_Arrow.Name="Chipset_Arrow"Chipset_Arrow.Parent=Chipset_Detector;Chipset_Arrow.BackgroundColor3=RGB(255,255,255)Chipset_Arrow.BackgroundTransparency=1.000;Chipset_Arrow.Position=U2(1,-15,0.5,-5)Chipset_Arrow.Size=U2(0,10,0,10)Chipset_Arrow.Font=Enum.Font.Gotham;Chipset_Arrow.Text="v"Chipset_Arrow.TextColor3=WinTheme.Text_Color;Chipset_Arrow.TextSize=WinTheme.Text_Size_Medium;Options_Container.Name="Options_Container"Options_Container.Parent=Chipset_Detector;Options_Container.BackgroundColor3=RGB(255,255,255)Options_Container.BackgroundTransparency=1.000;Options_Container.Position=U2(0,0,1,8)Options_Container.Size=U2(1,0,1,0)Options_Container.Visible=false;Options_List.Name="Options_List"Options_List.Parent=Options_Container;Options_List.SortOrder=Enum.SortOrder.LayoutOrder;Options_List.Padding=U1(0,1)

                Chipset_Detector.MouseButton1Click:Connect(function()
                    Options_Container.Visible = not Options_Container.Visible
                    if Options_Container.Visible then
                        Chipset_Arrow.Text = "<"
                        Chipset_Arrow.TextSize = 12.000
                    else
                        Chipset_Arrow.Text = "v"
                        Chipset_Arrow.TextSize = 11.000
                    end
                end)

                Chipset_Detector.MouseEnter:Connect(function()
                    Chipset_Detector.BorderColor3 = WinTheme.Accent;
                    Chipset_Title.TextColor3 = WinTheme.Accent;
                    Chipset_Arrow.TextColor3 = WinTheme.Accent;
        
                    infoMessage(info.Description or "")
                end)
            
                Chipset_Detector.MouseLeave:Connect(function()
                    resetMessage()
        
                    Chipset_Detector.BorderColor3 = WinTheme.Light_Borders;
                    Chipset_Title.TextColor3 = WinTheme.Text_Color;
                    Chipset_Arrow.TextColor3 = WinTheme.Text_Color;
                end)

                for i,v in pairs(info.Options) do
                    Options[i] = v

                    local Option = NEW("TextButton")
                    local Option_Title = NEW("TextLabel")

                    Option.Name="Option"Option.Parent=Options_Container;Option.BackgroundColor3=RGB(0,0,0)Option.BorderColor3=RGB(10,10,10)Option.Size=U2(1,0,0,16)Option.ZIndex=10;Option.AutoButtonColor=false;Option.Font=Enum.Font.SourceSans;Option.Text=""Option.TextColor3=RGB(0,0,0)Option.TextSize=WinTheme.Text_Size_Medium;Option_Title.Name="Option_Title"Option_Title.Parent=Option;Option_Title.BackgroundColor3=RGB(255,255,255)Option_Title.BackgroundTransparency=1.000;Option_Title.Position=U2(0,5,0,0)Option_Title.Size=U2(1,0,1,0)Option_Title.ZIndex=11;Option_Title.Font=Enum.Font.Gotham;Option_Title.Text=i;Option_Title.TextColor3=WinTheme.Text_Color;Option_Title.TextSize=WinTheme.Text_Size_Small;Option_Title.TextWrapped=true;Option_Title.TextXAlignment=Enum.TextXAlignment.Left

                    local TOGGLED = Options[i]
                    if TOGGLED then
                        Option.BackgroundColor3 = WinTheme.DarkAccent
                    else
                        Option.BackgroundColor3 = RGB(0, 0, 0)
                    end

                    local function Toggle_Option()
                        TOGGLED = not TOGGLED
                        Options[i] = TOGGLED
                        if TOGGLED then
                            Option.BackgroundColor3 = WinTheme.DarkAccent
                        else
                            Option.BackgroundColor3 = RGB(0, 0, 0)
                        end

                        info.CallBack(Options)
                    end

                    Option.MouseButton1Click:Connect(function()
                        Toggle_Option()
                    end)
    
                    Option.MouseEnter:Connect(function()
                        Option.ZIndex = 12
                        Option_Title.ZIndex = 13

                        Option.BorderColor3 = WinTheme.Accent;
                        Option_Title.TextColor3 = WinTheme.Accent;

                        infoMessage(info.Description or "")
                    end)
                
                    Option.MouseLeave:Connect(function()
                        resetMessage()

                        Option.ZIndex = 10
                        Option_Title.ZIndex = 11

                        Option.BorderColor3 = RGB(10, 10, 10)
                        Option_Title.TextColor3 = WinTheme.Text_Color;
                    end)
                end

                updateSectionSize()

                local chipset_funcs = {}

                function chipset_funcs.SetText(text)
                    Chipset_Title.Text = text
                end
                function chipset_funcs.GetText()
                    return Chipset_Title.Text
                end

                return chipset_funcs
            end

            function section_funcs.NewPlayerChipset(info)
                info.CallBack = info.CallBack or function(a)end
                info.Text = info.Text or "Player List"
                local Options = info.Options or {}

                local ChipSet = NEW("Frame")
                local Chipset_Detector = NEW("TextButton")
                local Chipset_Title = NEW("TextLabel")
                local Chipset_Arrow = NEW("TextLabel")
                local Options_Container = NEW("Frame")
                local Options_List = NEW("UIListLayout")

                ChipSet.Name="ChipSet"ChipSet.Parent=Item_Container;ChipSet.BackgroundColor3=RGB(255,255,255)ChipSet.BackgroundTransparency=1.000;ChipSet.BorderSizePixel=0;ChipSet.Size=U2(1,0,0,16)Chipset_Detector.Name="Chipset_Detector"Chipset_Detector.Parent=ChipSet;Chipset_Detector.BackgroundColor3=RGB(0,0,0)Chipset_Detector.BorderColor3=WinTheme.Light_Borders;Chipset_Detector.Position=U2(0,5,1,-16)Chipset_Detector.Size=U2(1,-10,0,16)Chipset_Detector.AutoButtonColor=false;Chipset_Detector.Font=Enum.Font.Gotham;Chipset_Detector.Text=""Chipset_Detector.TextColor3=WinTheme.Text_Color;Chipset_Detector.TextSize=WinTheme.Text_Size_Medium;Chipset_Detector.TextWrapped=true;Chipset_Title.Name="Chipset_Title"Chipset_Title.Parent=Chipset_Detector;Chipset_Title.BackgroundColor3=RGB(255,255,255)Chipset_Title.BackgroundTransparency=1.000;Chipset_Title.Position=U2(0,5,0,0)Chipset_Title.Size=U2(0,1,1,0)Chipset_Title.Font=Enum.Font.Gotham;Chipset_Title.Text=info.Text or"Player List"Chipset_Title.TextColor3=WinTheme.Text_Color;Chipset_Title.TextSize=WinTheme.Text_Size_Small;Chipset_Title.TextXAlignment=Enum.TextXAlignment.Left;Chipset_Arrow.Name="Chipset_Arrow"Chipset_Arrow.Parent=Chipset_Detector;Chipset_Arrow.BackgroundColor3=RGB(255,255,255)Chipset_Arrow.BackgroundTransparency=1.000;Chipset_Arrow.Position=U2(1,-15,0.5,-5)Chipset_Arrow.Size=U2(0,10,0,10)Chipset_Arrow.Font=Enum.Font.Gotham;Chipset_Arrow.Text="v"Chipset_Arrow.TextColor3=WinTheme.Text_Color;Chipset_Arrow.TextSize=11.000;Options_Container.Name="Options_Container"Options_Container.Parent=Chipset_Detector;Options_Container.BackgroundColor3=RGB(255,255,255)Options_Container.BackgroundTransparency=1.000;Options_Container.Position=U2(0,0,1,8)Options_Container.Size=U2(1,0,1,0)Options_Container.Visible=false;Options_List.Name="Options_List"Options_List.Parent=Options_Container;Options_List.SortOrder=Enum.SortOrder.LayoutOrder;Options_List.Padding=U1(0,1)

                Chipset_Detector.MouseButton1Click:Connect(function()
                    Options_Container.Visible = not Options_Container.Visible
                    if Options_Container.Visible then
                        Chipset_Arrow.Text = "<"
                        Chipset_Arrow.TextSize = 12.000
                    else
                        Chipset_Arrow.Text = "v"
                        Chipset_Arrow.TextSize = 11.000
                    end
                end)

                Chipset_Detector.MouseEnter:Connect(function()
                    Chipset_Detector.BorderColor3 = WinTheme.Accent;
                    Chipset_Title.TextColor3 = WinTheme.Accent;
                    Chipset_Arrow.TextColor3 = WinTheme.Accent;
        
                    infoMessage(info.Description or "")
                end)
            
                Chipset_Detector.MouseLeave:Connect(function()
                    resetMessage()
        
                    Chipset_Detector.BorderColor3 = WinTheme.Light_Borders;
                    Chipset_Title.TextColor3 = WinTheme.Text_Color;
                    Chipset_Arrow.TextColor3 = WinTheme.Text_Color;
                end)

                local player_table = {}

                local t_players = Players:GetPlayers()
                for i = 1, #t_players do
                    local v = t_players[i]
                    if v.Name ~= Player.Name then
                        local player_name = v.Name

                        local Option = NEW("TextButton")
                        local Option_Title = NEW("TextLabel")

                        Option.Name="Option"Option.Parent=Options_Container;Option.BackgroundColor3=RGB(0,0,0)Option.BorderColor3=RGB(10,10,10)Option.Size=U2(1,0,0,16)Option.ZIndex=10;Option.AutoButtonColor=false;Option.Font=Enum.Font.SourceSans;Option.Text=""Option.TextColor3=RGB(0,0,0)Option.TextSize=WinTheme.Text_Size_Medium;Option_Title.Name="Option_Title"Option_Title.Parent=Option;Option_Title.BackgroundColor3=RGB(255,255,255)Option_Title.BackgroundTransparency=1.000;Option_Title.Position=U2(0,5,0,0)Option_Title.Size=U2(1,0,1,0)Option_Title.ZIndex=11;Option_Title.Font=Enum.Font.Gotham;Option_Title.Text=v.Name;Option_Title.TextColor3=WinTheme.Text_Color;Option_Title.TextSize=WinTheme.Text_Size_Small;Option_Title.TextWrapped=true;Option_Title.TextXAlignment=Enum.TextXAlignment.Left

                        local TOGGLED = false
                        player_table[player_name] = TOGGLED
                        if TOGGLED then
                            Option.BackgroundColor3 = WinTheme.DarkAccent
                        else
                            Option.BackgroundColor3 = RGB(0, 0, 0)
                        end

                        local function Toggle_Option()
                            TOGGLED = not TOGGLED
                            player_table[player_name] = TOGGLED
                            
                            if TOGGLED then
                                Option.BackgroundColor3 = WinTheme.DarkAccent
                            else
                                Option.BackgroundColor3 = RGB(0, 0, 0)
                            end

                            info.CallBack(player_table)
                        end

                        Option.MouseButton1Click:Connect(function()
                            Toggle_Option()
                        end)
        
                        Option.MouseEnter:Connect(function()
                            Option.ZIndex = 12
                            Option_Title.ZIndex = 13

                            Option.BorderColor3 = WinTheme.Accent;
                            Option_Title.TextColor3 = WinTheme.Accent;

                            infoMessage(info.Description or "")
                        end)
                    
                        Option.MouseLeave:Connect(function()
                            resetMessage()

                            Option.ZIndex = 10
                            Option_Title.ZIndex = 11

                            Option.BorderColor3 = RGB(10, 10, 10)
                            Option_Title.TextColor3 = WinTheme.Text_Color;
                        end)

                        local c_changed
                        c_changed = v.AncestryChanged:connect(function()
                            if not v:IsDescendantOf(game) then
                                Option:Destroy()
                            end
                        end)
                    end
                end

                local c_added; c_added = Players.PlayerAdded:Connect(function(v) 
                    if DESTROY_UI then
                        c_added:Disconnect()
                    elseif v.Name ~= Player.Name then
                        local player_name = v.Name

                        local Option = NEW("TextButton")
                        local Option_Title = NEW("TextLabel")

                        Option.Name="Option"Option.Parent=Options_Container;Option.BackgroundColor3=RGB(0,0,0)Option.BorderColor3=RGB(10,10,10)Option.Size=U2(1,0,0,16)Option.ZIndex=10;Option.AutoButtonColor=false;Option.Font=Enum.Font.SourceSans;Option.Text=""Option.TextColor3=RGB(0,0,0)Option.TextSize=WinTheme.Text_Size_Medium;Option_Title.Name="Option_Title"Option_Title.Parent=Option;Option_Title.BackgroundColor3=RGB(255,255,255)Option_Title.BackgroundTransparency=1.000;Option_Title.Position=U2(0,5,0,0)Option_Title.Size=U2(1,0,1,0)Option_Title.ZIndex=11;Option_Title.Font=Enum.Font.Gotham;Option_Title.Text=v.Name;Option_Title.TextColor3=WinTheme.Text_Color;Option_Title.TextSize=WinTheme.Text_Size_Small;Option_Title.TextWrapped=true;Option_Title.TextXAlignment=Enum.TextXAlignment.Left

                        local TOGGLED = false
                        player_table[player_name] = TOGGLED
                        if TOGGLED then
                            Option.BackgroundColor3 = WinTheme.DarkAccent
                        else
                            Option.BackgroundColor3 = RGB(0, 0, 0)
                        end

                        local function Toggle_Option()
                            TOGGLED = not TOGGLED
                            player_table[player_name] = TOGGLED
                            
                            if TOGGLED then
                                Option.BackgroundColor3 = WinTheme.DarkAccent
                            else
                                Option.BackgroundColor3 = RGB(0, 0, 0)
                            end

                            info.CallBack(player_table)
                        end

                        Option.MouseButton1Click:Connect(function()
                            Toggle_Option()
                        end)
        
                        Option.MouseEnter:Connect(function()
                            Option.ZIndex = 12
                            Option_Title.ZIndex = 13

                            Option.BorderColor3 = WinTheme.Accent;
                            Option_Title.TextColor3 = WinTheme.Accent;

                            infoMessage(info.Description or "")
                        end)
                    
                        Option.MouseLeave:Connect(function()
                            resetMessage()

                            Option.ZIndex = 10
                            Option_Title.ZIndex = 11

                            Option.BorderColor3 = RGB(10, 10, 10)
                            Option_Title.TextColor3 = WinTheme.Text_Color;
                        end)

                        local c_changed
                        c_changed = v.AncestryChanged:connect(function()
                            if not v:IsDescendantOf(game) then
                                Option:Destroy()
                            end
                        end)
                    end
                end)

                updateSectionSize()

                local chipset_funcs = {}

                function chipset_funcs.SetText(text)
                    Chipset_Title.Text = text
                end
                function chipset_funcs.GetText()
                    return Chipset_Title.Text
                end

                return chipset_funcs
            end

            return section_funcs
        end
        return page_funcs
    end
    return structurer
end

return Library
