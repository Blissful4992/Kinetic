local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Blissful4992/Kinetic/main/src.lua"))()

local Overrides = {
    Background = Color3.fromRGB(23, 30, 51),
    Section_Background = Color3.fromRGB(18, 23, 38),

    Dark_Borders = Color3.fromRGB(18, 23, 38),
    Light_Borders = Color3.fromRGB(255, 255, 255),

    Text_Color = Color3.fromRGB(235, 235, 235),

    Accent = Color3.fromRGB(255, 81, 0),
    DarkAccent = Color3.fromRGB(140, 45, 0),
}

local Window = Library.NewWindow({
    Text = "Test UI",
    WindowSize = {X = 550, Y = 450},

    ThemeOverrides = Overrides,
    
    -- WindowSizeCallBack will fire everytime the user changes the size of the UI, 
    -- you can use this to save the size into a config system for example
    WindowSizeCallBack = function(new)
        print("You changed the window size to: " .. new.X .. ", " .. new.Y)
    end,

    -- CloseCallBack will fire when the user presses the close button on the UI (Top Right)
    CloseCallBack = function()
        print("You closed the script !")
    end
})

local Page = Window.NewPage({Text = "Page 1"})

local Section = Page.NewSection({Text = "Section 1"})

local Button = Section.NewButton({
    Text = "Click Me", 
    CallBack = function()
        print("I got clicked !")
    end, 
    Description = "This can be used as a one time feature !"
})

local Toggle = Section.NewToggle({
    Text = "Toggle Me", 
    CallBack = function(bool)
        print(bool)
    end, 
    Default = true,
    Description = "This turns ON and OFF when you click it !"
})

local Slider = Section.NewSlider({
    Text = "Slide Me",
    CallBack = function(value)
        print("You slid to: " .. value)
    end,
    Default = 50,
    Min = 1, Max = 100,
    Decimals = 0, -- Number of decimal numbers after the .
    Suffix = "m",
    Description = "You can slide me with your mouse to change the value !"
})

local Dropdown = Section.NewDropdown({
    Text = "Select Me", 
    CallBack = function(option)
        print("You selected: " .. option)
    end, 
    Options = {
        "Red",
        "Green",
        "Blue"
    }, 
    Default = 2, -- Index of the default option (e.g. "Green")
    Description = "You can select a single item from this list !"
})

local Keybind = Section.NewKeybind({
    Text = "Press Me", 
    CallBack = function()
        print("You pressed the right key !")
    end, 
    KCallBack = function(new)
        print("You changed the key to: " .. SUB(tostring(new), 14, #tostring(new)))
    end, 
    Default = Enum.KeyCode.X,
    Description = "Press the key to activate this !",
})

local Picker = Section.NewColorPicker({
    Text = "Pick Me", 
    CallBack = function(color)
        print("You picked the new color: " .. color.R .. ", " .. color.G .. ", " .. color.B)
    end, 
    Default = Color3.fromRGB(0, 50, 0),
    Description = "Pick a new color from this little frame !"
})

local Chipset = Section.NewChipset({
    Text = "Select Me", 
    CallBack = function(tbl)
        print("New Options:")
        for i,v in pairs(tbl) do
            print("    " .. tostring(i) .. ": " .. tostring(v))
        end
    end, 
    Options = {
        Switch1 = true,
        Switch2 = false,
        Switch3 = true
    }, 
    Description = "Select individual options from this little dropdown !"
})

local PlayerTbl = {}
local PlayerList = Section.NewPlayerChipset({
    Text = "Player List", 
    CallBack = function(tbl) 
        PlayerTbl = tbl
    end, 
    Description = "Select individual players from this auto-updating list of players !"
})
