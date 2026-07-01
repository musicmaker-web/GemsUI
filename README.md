# GemsUI – Luau UI Framework for Roblox

A modular, standalone UI framework for Roblox, inspired by the design and
features of the HTML reference design ("Dynamic Exploit Environment"):
glassy windows with a rotating gradient background, 4 switchable themes,
sidebar tabs and a complete element library.

Three files are included:

| File            | Purpose                                                                 |
|-----------------|-------------------------------------------------------------------------|
| `Framework.lua` | The actual framework (goes on GitHub / as a ModuleScript)              |
| `Demo.lua`      | LocalScript that loads the framework and demonstrates **all** features |
| `API.md`        | Full API reference and step-by-step tutorial                           |

**Important:** You never need to edit `Framework.lua` to build your own UI.
All windows, tabs and elements are created exclusively through the API
shown in `Demo.lua`.

---

## 1. Setup in Roblox Studio (local testing)

1. Create a `ModuleScript` named `GemsUI` in **ReplicatedStorage** and
   paste the full contents of `Framework.lua` into it.
2. Create a `LocalScript` in **StarterPlayer → StarterPlayerScripts**
   and paste the full contents of `Demo.lua` into it.
3. Start the play-test. Two small ⚡ buttons appear (one per window) —
   use them to toggle window visibility. The main window can also be
   toggled with **Right Ctrl**.

`Demo.lua` defaults to `USE_LOCAL_MODULE = true` — fully usable without
internet access or GitHub.

---

## 2. Production use via GitHub (`loadstring`)

1. Upload `Framework.lua` to your own (preferably **public**) GitHub repository.
2. Copy the **raw link**, e.g.:
   ```
   https://raw.githubusercontent.com/<YourUser>/<YourRepo>/main/Framework.lua
   ```
3. Load it in any script (e.g. via an executor):
   ```lua
   local Library = loadstring(game:HttpGet(
       "https://raw.githubusercontent.com/<YourUser>/<YourRepo>/main/Framework.lua",
       true
   ))()
   Library:Init()
   ```
4. In `Demo.lua`, set `USE_LOCAL_MODULE = false` and update the
   `FRAMEWORK_URL` variable to your own raw link.

The framework automatically checks for `syn.protect_gui` or `gethui`
(common executor functions) and uses them if available.

---

## 3. Quick-start example

```lua
local Library = loadstring(game:HttpGet("YOUR_URL_HERE", true))()
Library:Init()

local Window = Library:CreateWindow({
    Title = "My UI",
    SubTitle = "V1.0",
    Theme = "Frost",   -- Frost | Inferno | Viper | Nebula
})

local Tab     = Window:CreateTab({ Name = "General", Icon = "⚙" })
local Section = Tab:CreateSection("Example Section")

Section:CreateButton({
    Name     = "Click me",
    Callback = function()
        Library:Notify({ Title = "Hello!", Message = "Button pressed.", Type = "Success" })
    end,
})
```

---

## 4. Window options reference

| Option | Type | Description |
|---|---|---|
| `Title` | string | Window title (accent colour) |
| `SubTitle` | string | Small text on the right of the header (e.g. version) |
| `Theme` | string | Starting theme name |
| `Size` | UDim2 | Fixed window size (defaults depend on device) |
| `Position` | UDim2 | Starting position (default: screen centre) |
| `MinSize` | Vector2 | Minimum size when resizing (default `Vector2.new(420, 260)`) |
| `ToggleButton` | bool | Floating ⚡ button to show/hide the window (default `true`) |
| `ToggleKeybind` | Enum.KeyCode | Key that toggles the window |
| `WindowDraggable` | bool | Window draggable via header bar (default `true`) |
| `ButtonDraggable` | bool | ⚡ button draggable (default `false`) |
| `OnClose` / `OnMinimize` / `OnMaximize` | function | Callback hooks |

**Window methods:** `Window:CreateTab(opts)`, `Window:Show()`,
`Window:Hide()`, `Window:ToggleVisibility()`, `Window:Close()`,
`Window:ToggleMinimize()`, `Window:ToggleMaximize()`, `Window:SetTitle(text)`,
`Window:BringToFront()`, `Window:ApplyTheme(theme, name)`, `Window:Destroy()`.

**Resize (header toggle buttons):** Three small dot-buttons sit next to the
title in the header:
1. **Triangle dots** – show/hide the resize handle (bottom-right corner).
   Drag it to resize; the top-left corner stays fixed.
2. **2×3 grid** – enable/disable dragging of the ⚡ toggle button.
3. **2×3 grid** – enable/disable window drag.

All three states are saved to `GemsUI/toggles_<WindowTitle>.json` and
restored on the next session.

---

## 5. All element methods

All elements below are available identically on **Tab** and **Section**:

| Method | Key options |
|---|---|
| `CreateButton` | `Name`, `Description`, `Icon`, `Tooltip`, `Callback()` |
| `CreateToggle` | `Name`, `Description`, `Default`, `Flag`, `Callback(value)` |
| `CreateSlider` | `Name`, `Min`, `Max`, `Default`, `Increment`, `Suffix`, `Flag`, `Callback(value)` |
| `CreateDropdown` | `Name`, `Options`, `Default`, `Flag`, `Callback(value)` |
| `CreateMultiDropdown` | `Name`, `Options`, `Default` (table), `Flag`, `Callback(values)` |
| `CreateSearchDropdown` | like `CreateDropdown`, adds a search field at the top |
| `CreateSearchMultiDropdown` | like `CreateMultiDropdown`, adds a search field at the top |
| `CreateTextbox` | `Name`, `Placeholder`, `Default`, `Numeric`, `ClearTextOnFocus`, `Flag`, `Callback(text, enterPressed)` |
| `CreateLabel` | `Text`, `Icon` (or just a string as the sole argument) |
| `CreateParagraph` | `Title`, `Content` |
| `CreateKeybind` | `Name`, `Default` (Enum.KeyCode), `Flag`, `Callback(keyCode)`, `OnTrigger(isPressed)` |
| `CreateColorPicker` | `Name`, `Default` (Color3), `Flag`, `Callback(color3)` |

Every created element returns an object with `:Get()`, `:Set(value)` and
`:Destroy()`. Each element optionally accepts a `Tooltip` and a `Flag`
(for the config system).

---

## 6. Notifications

```lua
Library:Notify({
    Title    = "Done",
    Message  = "Action completed successfully.",
    Type     = "Success",   -- Info | Success | Warning | Error
    Duration = 5,           -- seconds (0 = stays until manually dismissed)
})
```

---

## 7. Dialogs

```lua
Library:CreateDialog({
    Title   = "Are you sure?",
    Message = "This action cannot be undone.",
    Buttons = {
        { Text = "Confirm", Style = "Primary", Callback = function() end },
        { Text = "Cancel" },
    },
})
```

---

## 8. Themes

```lua
-- Switch theme at runtime for ALL windows:
Library:SetTheme("Inferno")

-- Register a custom theme:
Library:RegisterTheme("Custom", {
    Name            = "My Theme",
    Accent          = Color3.fromRGB(255, 200, 0),
    GradientColors  = { ... },
    SpinSeconds     = 12,
    SpinReverse     = false,
})
Library:SetTheme("Custom")
```

---

## 9. Config system

```lua
Library:SaveConfig("myProfile")   -- saves all flags to GemsUI/myProfile.json
Library:LoadConfig("myProfile")   -- loads and applies saved values
Library:ListConfigs()             -- returns list of saved config names
Library:DeleteConfig("myProfile") -- deletes the file

-- Read any flag value directly:
print(Library.Flags["walkSpeed"])
```

> Requires `writefile`/`readfile` (provided by executors).
> In Roblox Studio without an executor, a notification is shown and
> nothing is saved.

---

## 10. Built-in UI Settings tab

Every window automatically gets a **UI Settings** tab as its last tab
(`LayoutOrder = 9999`). It contains:
- **Interface Theme** – all registered themes as clickable cards
- **Changelog** – feature list for the current version

This tab is **not** counted in `#Window.Tabs` and does not interfere
with user-created tabs or the auto-select logic.

---

## 11. License

Free to use and modify for your own projects.
