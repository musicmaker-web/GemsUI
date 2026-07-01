# GemsUI – API Overview & Tutorial

GemsUI is a modular Luau UI framework for Roblox.  
This document walks you through every feature step by step.

---

## Table of Contents

1. [Load the framework](#1-load-the-framework)
2. [Create a window](#2-create-a-window)
3. [Create tabs](#3-create-tabs)
4. [Create sections](#4-create-sections)
5. [Elements](#5-elements)
   - [Button](#button)
   - [Toggle](#toggle)
   - [Slider](#slider)
   - [Dropdown](#dropdown)
   - [Multi-Dropdown](#multi-dropdown)
   - [Search-Dropdown](#search-dropdown)
   - [Search-Multi-Dropdown](#search-multi-dropdown)
   - [Textbox](#textbox)
   - [Label](#label)
   - [Paragraph](#paragraph)
   - [Keybind](#keybind)
   - [ColorPicker](#colorpicker)
6. [Notifications](#6-notifications)
7. [Dialogs](#7-dialogs)
8. [Tooltips](#8-tooltips)
9. [Themes](#9-themes)
10. [Config system](#10-config-system)
11. [Window methods](#11-window-methods)
12. [Flags & callbacks](#12-flags--callbacks)
13. [Full example](#13-full-example)

---

## 1. Load the framework

### Via GitHub (executor / production)

```lua
local Library = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/musicmaker-web/GemsUI/refs/heads/main/GemsUI.lua",
    true
))()

Library:Init()
```

### As a ModuleScript (Roblox Studio / local)

1. Create a `ModuleScript` named `GemsUI` in **ReplicatedStorage**
2. Paste the full contents of `Framework.lua` into it
3. Load it in a `LocalScript` inside `StarterPlayerScripts`:

```lua
local Library = require(game.ReplicatedStorage:WaitForChild("GemsUI"))
Library:Init()
```

> **Tip:** `Library:Init()` is called automatically on the first
> `CreateWindow` call — you don't need to call it manually.

---

## 2. Create a window

```lua
local Window = Library:CreateWindow({
    Title           = "My UI",          -- Window title (shown in accent colour)
    SubTitle        = "V1.0",           -- Small text on the right of the header
    Theme           = "Frost",          -- Starting theme: Frost | Inferno | Viper | Nebula
    Size            = UDim2.new(0, 580, 0, 360),   -- optional: custom size
    Position        = UDim2.new(0.5, 0, 0.5, 0),  -- optional: custom position
    MinSize         = Vector2.new(420, 260),        -- minimum size when resizing
    ToggleButton    = true,             -- floating ⚡ button to show/hide (default: true)
    ToggleKeybind   = Enum.KeyCode.RightControl,   -- keyboard shortcut
    WindowDraggable = true,             -- drag window via header bar (default: true)
    ButtonDraggable = false,            -- drag ⚡ button (default: false)
    OnClose    = function() print("Window closed")          end,
    OnMinimize = function(isMin) print("Minimised:", isMin) end,
    OnMaximize = function(isMax) print("Maximised:", isMax) end,
})
```

### Header toggle buttons (next to the title)

Three small dot-buttons sit in the header next to the window title:

| Symbol | Function |
|---|---|
| Triangle dots | Show/hide the resize handle (bottom-right corner) |
| 2×3 dot grid | Enable/disable ⚡ button dragging |
| 2×3 dot grid | Enable/disable window drag via header |

The state of all three buttons is saved automatically and restored on
the next session (file: `GemsUI/toggles_<Title>.json`).

### Multiple windows simultaneously

```lua
local WindowA = Library:CreateWindow({ Title = "Window A", Theme = "Frost" })
local WindowB = Library:CreateWindow({ Title = "Window B", Theme = "Inferno",
    Position = UDim2.new(0.72, 0, 0.5, 0) })
```

Each window has its own toggle button, its own theme and can be moved,
minimised and closed independently.

---

## 3. Create tabs

```lua
local Tab = Window:CreateTab({
    Name = "Combat",         -- Display name in the sidebar
    Icon = "⚔",             -- Unicode glyph or "rbxassetid://..."
})
```

Available built-in icons (via `Library.Icons`):

```lua
Library.Icons.bolt       -- ⚡
Library.Icons.settings   -- ⚙
Library.Icons.combat     -- ⚔
Library.Icons.search     -- 🔍
Library.Icons.check      -- ✓
Library.Icons.info       -- ℹ
Library.Icons.warning    -- ⚠
Library.Icons.error      -- ✕
Library.Icons.palette    -- 🎨
Library.Icons.key        -- ⌨
Library.Icons.frost      -- ❄
Library.Icons.fire       -- 🔥
Library.Icons.viper      -- 🧪
Library.Icons.nebula     -- 🔮
```

The first tab created is automatically selected.  
Custom rbxassetid images work the same way:

```lua
local Tab = Window:CreateTab({ Name = "Items", Icon = "rbxassetid://123456789" })
```

> The built-in **UI Settings** tab (themes + changelog) appears
> automatically as the last tab (`LayoutOrder 9999`) in every window.
> You never need to create or configure it.

---

## 4. Create sections

Sections group multiple elements visually inside a rounded card.

```lua
-- Short form (name only):
local Section = Tab:CreateSection("My Section")

-- Long form:
local Section = Tab:CreateSection({ Name = "My Section" })
```

Elements can also be created **directly on a Tab** (without a section):

```lua
Tab:CreateButton({ Name = "Direct Button", Callback = function() end })
```

---

## 5. Elements

All elements can be created on either a **Tab** or a **Section**.
The API is identical in both cases.

---

### Button

```lua
Section:CreateButton({
    Name        = "Click me",
    Description = "Optional subtitle",   -- second line (optional)
    Icon        = Library.Icons.bolt,    -- optional
    Tooltip     = "Appears on hover",    -- optional
    Callback    = function()
        print("Button pressed!")
    end,
})
```

**Return value:**

```lua
local btn = Section:CreateButton({ ... })
btn:Destroy()   -- remove the element
```

---

### Toggle

```lua
local toggle = Section:CreateToggle({
    Name        = "God Mode",
    Description = "Activates the demo mode",
    Default     = false,           -- starting value
    Flag        = "godMode",       -- config-system key (optional)
    Tooltip     = "On / Off",
    Callback    = function(value)  -- value: true | false
        print("Toggle:", value)
    end,
})

-- Read current value:
print(toggle:Get())           -- true or false

-- Set value (fires callback):
toggle:Set(true)

-- Set value silently (no callback):
toggle:Set(true, true)        -- second parameter = silent

toggle:Destroy()
```

---

### Slider

```lua
local slider = Section:CreateSlider({
    Name      = "Walk Speed",
    Min       = 0,
    Max       = 100,
    Default   = 16,
    Increment = 1,           -- step size (use 0.1 for decimals)
    Suffix    = " sps",      -- unit appended to the value (optional)
    Flag      = "walkSpeed",
    Tooltip   = "Adjust walk speed",
    Callback  = function(value)
        print("Speed:", value)
    end,
})

print(slider:Get())   -- current value (number)
slider:Set(50)        -- set value
slider:Destroy()
```

---

### Dropdown

Single selection from a list:

```lua
local dd = Section:CreateDropdown({
    Name     = "Weapon",
    Options  = { "Sword", "Bow", "Axe", "Dagger" },
    Default  = "Sword",        -- starting value (optional)
    Flag     = "weapon",
    Tooltip  = "Select a weapon",
    Callback = function(value)
        print("Selected:", value)   -- value: string
    end,
})

print(dd:Get())                     -- current value (string)
dd:Set("Axe")                       -- set value
dd:Refresh({ "Sword", "Spear" })   -- update options list
dd:Destroy()
```

---

### Multi-Dropdown

Multiple selections — callback receives a sorted table:

```lua
local mdd = Section:CreateMultiDropdown({
    Name     = "Active Modules",
    Options  = { "ESP", "Aimbot", "Tracer", "Radar" },
    Default  = { "ESP", "Radar" },   -- table of starting values
    Flag     = "activeModules",
    Callback = function(values)
        print("Active:", table.concat(values, ", "))   -- values: {string}
    end,
})

print(mdd:Get())           -- { "ESP", "Radar" } (sorted)
mdd:Set({ "Tracer" })     -- set new selection
mdd:Destroy()
```

---

### Search-Dropdown

Like `CreateDropdown`, but with a full-row search field at the top of
the list. Works on mobile and desktop alike:

```lua
local sdd = Section:CreateSearchDropdown({
    Name     = "City",
    Options  = { "Berlin", "Munich", "Hamburg", "Vienna", "Zurich", ... },
    Default  = "Berlin",
    Flag     = "city",
    Callback = function(value) print(value) end,
})
```

---

### Search-Multi-Dropdown

Like `CreateMultiDropdown`, but with a search field:

```lua
local smdd = Section:CreateSearchMultiDropdown({
    Name     = "Targets",
    Options  = { "Berlin", "Munich", "Hamburg", "Vienna", "Zurich", ... },
    Default  = { "Vienna" },
    Flag     = "targets",
    Callback = function(values) print(table.concat(values, ", ")) end,
})
```

---

### Textbox

```lua
local box = Section:CreateTextbox({
    Name             = "Player Name",
    Placeholder      = "Enter a name...",
    Default          = "",
    Numeric          = false,   -- true = numbers only
    ClearTextOnFocus = false,
    Flag             = "playerName",
    Tooltip          = "Type something",
    Callback = function(text, enterPressed)
        print("Text:", text, "| Enter:", enterPressed)
    end,
})

print(box:Get())       -- current text (string)
box:Set("Hello")       -- set text
box:Destroy()
```

---

### Label

Static informational text (not interactive):

```lua
-- Short form:
Section:CreateLabel("Simple info text")

-- With icon:
local lbl = Section:CreateLabel({
    Text = "Status: Active",
    Icon = Library.Icons.check,
})

lbl:SetText("Status: Inactive")   -- update text
lbl:Destroy()
```

---

### Paragraph

Title + longer, auto-wrapping body text:

```lua
local para = Section:CreateParagraph({
    Title   = "Important Note",
    Content = "This text can be very long and wraps automatically "
           .. "to the next line. Great for descriptions, instructions "
           .. "or changelogs.",
})

para:SetTitle("New Title")
para:SetText("New content")
para:Destroy()
```

---

### Keybind

```lua
local kb = Section:CreateKeybind({
    Name    = "Open Menu",
    Default = Enum.KeyCode.RightControl,
    Flag    = "menuKey",
    Tooltip = "Click and press a key. Esc = cancel.",

    -- Fired when the key is pressed/released in-game:
    OnTrigger = function(isPressed)
        if isPressed then
            print("Key pressed!")
        end
    end,

    -- Fired when the user changes the binding:
    Callback = function(keyCode)
        print("New key:", keyCode and keyCode.Name or "none")
    end,
})

print(kb:Get())                      -- Enum.KeyCode.RightControl
kb:Set(Enum.KeyCode.F)              -- set key
kb:Destroy()
```

---

### ColorPicker

```lua
local cp = Section:CreateColorPicker({
    Name     = "Highlight Color",
    Default  = Color3.fromRGB(0, 242, 255),
    Flag     = "highlightColor",
    Tooltip  = "Click the color swatch to open the picker",
    Callback = function(color)
        -- color: Color3
        print(string.format("R:%d G:%d B:%d",
            math.floor(color.R * 255),
            math.floor(color.G * 255),
            math.floor(color.B * 255)))
    end,
})

print(cp:Get())                              -- Color3
cp:Set(Color3.fromRGB(255, 0, 128))         -- set color
cp:Destroy()
```

---

## 6. Notifications

```lua
Library:Notify({
    Title    = "Success!",
    Message  = "Action completed.",
    Type     = "Success",   -- "Info" | "Success" | "Warning" | "Error"
    Duration = 5,           -- seconds (0 = stays until manually dismissed)
    Icon     = nil,         -- custom icon (overrides type default, optional)
})
```

**All types:**

```lua
Library:Notify({ Title = "Info",    Message = "General notice.",         Type = "Info" })
Library:Notify({ Title = "Done",    Message = "Saved successfully.",      Type = "Success" })
Library:Notify({ Title = "Warning", Message = "Please be careful.",       Type = "Warning" })
Library:Notify({ Title = "Error",   Message = "Something went wrong.",    Type = "Error" })
```

**Return value:**

```lua
local notif = Library:Notify({ Title = "Test", Duration = 0 })
notif.Dismiss()   -- dismiss manually
```

---

## 7. Dialogs

```lua
Library:CreateDialog({
    Title       = "Are you sure?",
    Message     = "This action cannot be undone.",
    Dismissable = true,   -- click outside to close (default: true)
    Buttons = {
        {
            Text     = "Confirm",
            Style    = "Primary",   -- "Primary" = highlighted in accent colour
            Callback = function()
                print("Confirmed!")
            end,
        },
        {
            Text     = "Cancel",
            Callback = function()
                print("Cancelled.")
            end,
        },
    },
})
```

**Close a dialog programmatically:**

```lua
local dialog = Library:CreateDialog({
    Title       = "...",
    Dismissable = false,
    Buttons     = { { Text = "Close" } },
})
dialog.Close()
```

---

## 8. Tooltips

Tooltips are attached automatically when you pass `Tooltip = "..."` to any
element. You can also attach them manually to arbitrary GuiObjects:

```lua
-- Automatic (via element option):
Section:CreateButton({ Name = "Test", Tooltip = "Appears on hover" })

-- Manual on any GuiObject:
local cleanup = Library:AttachTooltip(myFrame, "Help text")
cleanup()   -- remove tooltip
```

**Desktop:** Appears on MouseEnter / disappears on MouseLeave.  
**Mobile:** A small `?` badge appears in the top-right corner of the
element. Tapping it shows the tooltip text for 2.5 seconds in an
overlay layer (not clipped by ScrollingFrames).

---

## 9. Themes

### Built-in themes

| Name | Style |
|---|---|
| `"Frost"` | Blue-cyan, cold colours |
| `"Inferno"` | Red-orange, volcanic |
| `"Viper"` | Green-neon, toxic |
| `"Nebula"` | Pink-purple, cosmic |

### Switch theme at runtime

```lua
-- All open windows change theme:
Library:SetTheme("Inferno")

-- Only one specific window:
Library:SetTheme("Viper", Window)

-- Read current theme name:
print(Library.CurrentThemeName)   -- e.g. "Frost"

-- Read theme data:
local t = Library:GetTheme("Frost")
print(t.Accent)   -- Color3
```

### Register a custom theme

```lua
Library:RegisterTheme("Midnight", {
    Name            = "Midnight Blue",
    Icon            = "🌙",
    Accent          = Color3.fromRGB(100, 120, 255),
    AccentSecondary = Color3.fromRGB(60, 80, 200),
    GradientColors  = {
        Color3.fromRGB(5, 5, 20),
        Color3.fromRGB(20, 20, 60),
        Color3.fromRGB(50, 50, 140),
        Color3.fromRGB(100, 120, 255),
        Color3.fromRGB(5, 5, 20),
    },
    SpinSeconds = 14,
    SpinReverse = false,
})

Library:SetTheme("Midnight")
```

Custom themes also appear automatically in the built-in UI Settings tab.

### React to theme changes

```lua
Window:OnThemeChange(function(newTheme)
    print("Theme changed to:", newTheme.Name)
    print("New accent colour:", newTheme.Accent)
    -- update your own UI elements here
end)
```

---

## 10. Config system

The config system automatically saves all registered **flags** (the
`Flag` parameter on each element) as a JSON file on the device.

> Requires `writefile` / `readfile` (executor functions).
> In Roblox Studio without an executor a notification appears and
> nothing is saved.

### Save a config

```lua
Library:SaveConfig("myProfile")
-- Saves to: GemsUI/myProfile.json
```

### Load a config

```lua
Library:LoadConfig("myProfile")
-- All saved flags are applied back to the elements via their setter functions
```

### List all saved configs

```lua
local configs = Library:ListConfigs()
for _, name in ipairs(configs) do
    print(name)   -- e.g. "myProfile", "default", ...
end
```

### Delete a config

```lua
Library:DeleteConfig("myProfile")
```

### Read flags directly

```lua
print(Library.Flags["walkSpeed"])       -- number
print(Library.Flags["godMode"])         -- boolean
print(Library.Flags["playerName"])      -- string
print(Library.Flags["weapon"])          -- string
print(Library.Flags["highlightColor"]) -- Color3
```

---

## 11. Window methods

```lua
-- Visibility
Window:Show()
Window:Hide()
Window:ToggleVisibility()

-- States
Window:ToggleMinimize()   -- shrink to header / restore
Window:ToggleMaximize()   -- fullscreen (85% of screen) / restore

-- All Minimize + Maximize combinations work correctly:
-- Min → Max       window goes fullscreen (Body visible again)
-- Max → Min       window shrinks to header bar
-- Min → Max → Max (again) → returns to NormalSize
-- Max → Min → Min (again) → opens back to NormalSize

-- Z-order
Window:BringToFront()

-- Tab switching
Window:SelectTab(tabObject)

-- Title
Window:SetTitle("New Title")

-- Per-window theme change
Window:ApplyTheme(Library:GetTheme("Inferno"), "Inferno")

-- Theme change listener
Window:OnThemeChange(function(newTheme) ... end)

-- Remove window entirely
Window:Destroy()
```

---

## 12. Flags & callbacks

Every element with a `Flag` parameter registers itself in the global
`Library.Flags` dictionary and provides a setter that `LoadConfig` uses.

```lua
local toggle = Section:CreateToggle({
    Name     = "Debug",
    Default  = false,
    Flag     = "debugMode",
    Callback = function(value)
        -- Called when value changes (by user interaction or LoadConfig)
        game.Lighting.Brightness = value and 2 or 1
    end,
})

-- Read the current value from anywhere:
if Library.Flags["debugMode"] then
    print("Debug is ON")
end

-- Change programmatically with callback:
toggle:Set(true)

-- Change programmatically without callback (silent):
toggle:Set(true, true)
```

---

## 13. Full example

A complete, working script that demonstrates the most important features:

```lua
--======================================================
-- GemsUI – Full Example Script
--======================================================

local Library = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/musicmaker-web/GemsUI/refs/heads/main/GemsUI.lua",
    true
))()

-- Create window
local Window = Library:CreateWindow({
    Title         = "MyScript",
    SubTitle      = "V2.0",
    Theme         = "Frost",
    ToggleKeybind = Enum.KeyCode.RightControl,
})

----------------------------------------------------------
-- TAB 1: Player
----------------------------------------------------------
local PlayerTab = Window:CreateTab({ Name = "Player", Icon = "👤" })

local SpeedSection = PlayerTab:CreateSection("Movement")

PlayerTab:CreateSlider({
    Name      = "Walk Speed",
    Min       = 0, Max = 200, Default = 16,
    Flag      = "walkSpeed",
    Callback  = function(v)
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = v
        end
    end,
})

SpeedSection:CreateToggle({
    Name     = "Infinite Jump",
    Default  = false,
    Flag     = "infiniteJump",
    Tooltip  = "Allows unlimited jumps",
    Callback = function(v)
        Library:Notify({
            Title   = "Infinite Jump",
            Message = v and "Enabled" or "Disabled",
            Type    = v and "Success" or "Info",
        })
    end,
})

local ToolSection = PlayerTab:CreateSection("Tools")

ToolSection:CreateDropdown({
    Name     = "Active Tool",
    Options  = { "Sword", "Shield", "Bow", "Staff" },
    Default  = "Sword",
    Flag     = "activeTool",
    Callback = function(v) print("Tool:", v) end,
})

ToolSection:CreateColorPicker({
    Name     = "Highlight Color",
    Default  = Color3.fromRGB(0, 242, 255),
    Flag     = "highlightColor",
    Callback = function(c) -- apply your highlight logic here end,
})

----------------------------------------------------------
-- TAB 2: Graphics
----------------------------------------------------------
local GfxTab = Window:CreateTab({ Name = "Graphics", Icon = Library.Icons.palette })
local GfxSection = GfxTab:CreateSection("Rendering")

GfxSection:CreateSlider({
    Name      = "Brightness",
    Min       = 0, Max = 10, Default = 1,
    Increment = 0.1, Flag = "brightness",
    Callback  = function(v) game.Lighting.Brightness = v end,
})

GfxSection:CreateDropdown({
    Name     = "Quality",
    Options  = { "Low", "Medium", "High", "Ultra" },
    Default  = "Medium",
    Flag     = "quality",
    Callback = function(v) print("Quality:", v) end,
})

GfxSection:CreateToggle({
    Name     = "Bloom",
    Default  = false,
    Flag     = "bloom",
    Callback = function(v) print("Bloom:", v) end,
})

----------------------------------------------------------
-- TAB 3: Hotkeys
----------------------------------------------------------
local HotkeyTab = Window:CreateTab({ Name = "Hotkeys", Icon = Library.Icons.key })
local HotkeySection = HotkeyTab:CreateSection("Key Bindings")

HotkeySection:CreateKeybind({
    Name      = "Quick Attack",
    Default   = Enum.KeyCode.Q,
    Flag      = "quickAttackKey",
    OnTrigger = function(pressed)
        if pressed then print("Quick attack!") end
    end,
})

HotkeySection:CreateKeybind({
    Name      = "Heal",
    Default   = Enum.KeyCode.H,
    Flag      = "healKey",
    OnTrigger = function(pressed)
        if pressed then print("Heal!") end
    end,
})

local ConfigSection = HotkeyTab:CreateSection("Config")

ConfigSection:CreateButton({
    Name     = "Save Settings",
    Icon     = Library.Icons.check,
    Callback = function() Library:SaveConfig("default") end,
})

ConfigSection:CreateButton({
    Name     = "Load Settings",
    Icon     = Library.Icons.settings,
    Callback = function() Library:LoadConfig("default") end,
})

----------------------------------------------------------
-- Welcome notification
----------------------------------------------------------
task.delay(0.8, function()
    Library:Notify({
        Title    = "MyScript loaded",
        Message  = "Use Right-Ctrl or the ⚡ button to toggle the UI.",
        Type     = "Success",
        Duration = 5,
    })
end)
```

---

## Quick option reference

| Option | Type | Available on | Description |
|---|---|---|---|
| `Name` | string | all | Display text |
| `Description` | string | Button, Toggle | Second line (subtitle) |
| `Icon` | string | Button, Label, Tab | Glyph or rbxassetid:// |
| `Default` | *varies* | all interactive | Starting value |
| `Flag` | string | all interactive | Config system key |
| `Tooltip` | string | all | Hover / tap hint |
| `Callback` | function | all interactive | Called on value change |
| `Min` / `Max` | number | Slider | Range |
| `Increment` | number | Slider | Step size |
| `Suffix` | string | Slider | Unit appended to value |
| `Options` | {string} | Dropdown variants | Selection options |
| `Numeric` | bool | Textbox | Numbers only |
| `Placeholder` | string | Textbox | Placeholder text |
| `ClearTextOnFocus` | bool | Textbox | Clear on focus |
| `OnTrigger` | function | Keybind | On key press / release |
| `Content` | string | Paragraph | Body text |
| `Title` | string | Paragraph, Section | Heading |

---

*GemsUI v1.0.0 – Luau UI Framework for Roblox*
