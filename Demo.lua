--[[
	================================================================================
	 GEMSUI  -  DEMO / TEST SCRIPT
	 ================================================================================
	 This LocalScript loads the framework exactly as a user would
	 (via loadstring + HttpGet from GitHub) and builds all UI elements
	 exclusively through the public API.

	 Nothing in Framework.lua needs to be changed to build your own UI.
	 All windows, tabs and elements are created via the API shown here.

	 WHERE TO PUT THIS:
		StarterPlayer → StarterPlayerScripts → (this script as a LocalScript)
	 ================================================================================
]]

--================================================================================
-- 1) LOAD FRAMEWORK
--================================================================================
-- Switch for testing:
--   true  → loads the framework from a ModuleScript in ReplicatedStorage
--            (handy for local testing in Roblox Studio, no GitHub needed)
--   false → loads the framework exactly like an executor via loadstring + HttpGet
local USE_LOCAL_MODULE = true

local Library

if USE_LOCAL_MODULE then
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local moduleScript = ReplicatedStorage:WaitForChild("GemsUI", 10)
	if not moduleScript then
		error("[GemsUI Demo] No ModuleScript 'GemsUI' found in ReplicatedStorage. " ..
			"Paste the contents of Framework.lua into a ModuleScript there, " ..
			"or set USE_LOCAL_MODULE = false and enter your GitHub raw URL.")
	end
	Library = require(moduleScript)
else
	-- Production mode: loads the framework directly from GitHub (raw link).
	-- IMPORTANT: Replace the URL with your own GitHub raw link after
	-- uploading Framework.lua to your repository, e.g.:
	--   https://raw.githubusercontent.com/<YourUser>/<YourRepo>/main/Framework.lua
	local FRAMEWORK_URL = "https://raw.githubusercontent.com/YOURUSERNAME/YOURREPO/main/Framework.lua"
	Library = loadstring(game:HttpGet(FRAMEWORK_URL, true))()
end

Library:Init()

--================================================================================
-- 2) CREATE MAIN WINDOW
--================================================================================
local MainWindow = Library:CreateWindow({
	Title          = "FrostByte .EXE",
	SubTitle       = "V1.0 PRIME",
	Theme          = "Frost",
	ToggleButton   = true,
	ToggleKeybind  = Enum.KeyCode.RightControl,
	-- Tip: the three dot-buttons in the header (next to the title) control:
	--   ▿ Resize handle (bottom-right corner)
	--   ⠿ ⚡-button dragging on/off
	--   ⠿ Window drag on/off
	-- All states are saved automatically.
	WindowDraggable = true,
	ButtonDraggable = false,
	OnClose = function()
		Library:Notify({
			Title   = "Window closed",
			Message = "Use the ⚡ button or Right-Ctrl to reopen it.",
			Type    = "Info",
			Duration = 4,
		})
	end,
})

--================================================================================
-- 3) TAB: COMBAT
--================================================================================
local CombatTab = MainWindow:CreateTab({ Name = "Combat", Icon = Library.Icons.combat })

local CombatSection = CombatTab:CreateSection("Combat Engine")

CombatSection:CreateToggle({
	Name        = "Active Combat Engine",
	Description = "Activates the simulated combat module (demo callback)",
	Default     = true,
	Flag        = "combatEngineActive",
	Tooltip     = "Enable or disable the demo function",
	Callback    = function(value)
		print("[Demo] Combat engine active:", value)
	end,
})

CombatSection:CreateSlider({
	Name      = "Field Velocity",
	Min       = 10, Max = 100, Default = 85,
	Increment = 1, Suffix = "%",
	Flag      = "fieldVelocity",
	Callback  = function(value)
		print("[Demo] Field velocity:", value)
	end,
})

CombatSection:CreateSlider({
	Name      = "Reaction Time",
	Min       = 0, Max = 2, Default = 0.5,
	Increment = 0.05, Suffix = "s",
	Flag      = "reactionTime",
})

local CombatSection2 = CombatTab:CreateSection("Quick Actions")

CombatSection2:CreateButton({
	Name        = "Restart Engine",
	Description = "Resets all combat values to default",
	Icon        = Library.Icons.bolt,
	Tooltip     = "Resets velocity & reaction time",
	Callback    = function()
		Library:Notify({
			Title   = "Engine restarted",
			Message = "All combat values have been reset.",
			Type    = "Success",
		})
	end,
})

--================================================================================
-- 4) TAB: ELEMENTS  (demonstrates every available element type)
--================================================================================
local ElementsTab = MainWindow:CreateTab({ Name = "Elements", Icon = "▤" })

----------------------------------------------------------------------------
-- Section: Selection elements
----------------------------------------------------------------------------
local SelectionSection = ElementsTab:CreateSection("Selection Elements")

SelectionSection:CreateDropdown({
	Name     = "Weapon",
	Options  = { "Sword", "Bow", "Axe", "Dagger", "Hammer" },
	Default  = "Sword",
	Flag     = "selectedWeapon",
	Tooltip  = "Single-select dropdown",
	Callback = function(value)
		print("[Demo] Weapon selected:", value)
	end,
})

SelectionSection:CreateMultiDropdown({
	Name     = "Active Modules",
	Options  = { "ESP", "Aimbot-Sim", "Tracer", "Radar", "Logger" },
	Default  = { "ESP", "Radar" },
	Flag     = "activeModules",
	Tooltip  = "Multi-select dropdown",
	Callback = function(values)
		print("[Demo] Active modules:", table.concat(values, ", "))
	end,
})

local LongOptionList = {
	"Berlin", "Munich", "Hamburg", "Cologne", "Frankfurt",
	"Stuttgart", "Düsseldorf", "Leipzig", "Dortmund", "Essen",
	"Bremen", "Dresden", "Hannover", "Nuremberg", "Vienna",
	"Zurich", "Salzburg", "Graz",
}

SelectionSection:CreateSearchDropdown({
	Name     = "City (Search)",
	Options  = LongOptionList,
	Default  = "Berlin",
	Flag     = "selectedCity",
	Tooltip  = "Type to filter the list",
	Callback = function(value)
		print("[Demo] City selected:", value)
	end,
})

SelectionSection:CreateSearchMultiDropdown({
	Name     = "Travel Destinations (Search, Multi)",
	Options  = LongOptionList,
	Default  = { "Vienna", "Zurich" },
	Flag     = "travelTargets",
	Callback = function(values)
		print("[Demo] Destinations:", table.concat(values, ", "))
	end,
})

----------------------------------------------------------------------------
-- Section: Input elements
----------------------------------------------------------------------------
local InputSection = ElementsTab:CreateSection("Input Elements")

InputSection:CreateTextbox({
	Name        = "Display Name",
	Placeholder = "Enter a name...",
	Default     = "",
	Flag        = "displayName",
	Tooltip     = "Normal text field",
	Callback    = function(text, enterPressed)
		print("[Demo] Display name:", text, "| Enter pressed:", enterPressed)
	end,
})

InputSection:CreateTextbox({
	Name        = "Maximum Count",
	Placeholder = "0",
	Default     = "10",
	Numeric     = true,
	Flag        = "maxAmount",
	Tooltip     = "Numbers only",
})

InputSection:CreateKeybind({
	Name    = "Quick Action Key",
	Default = Enum.KeyCode.F,
	Flag    = "quickActionKey",
	Tooltip = "Click and press a new key (Esc to cancel)",
	Callback = function(keyCode)
		print("[Demo] New keybind set:", keyCode and keyCode.Name)
	end,
	OnTrigger = function(isPressed)
		if isPressed then
			print("[Demo] Quick action triggered!")
		end
	end,
})

InputSection:CreateColorPicker({
	Name     = "Highlight Color",
	Default  = Color3.fromRGB(0, 242, 255),
	Flag     = "highlightColor",
	Tooltip  = "Click the color swatch to open the picker",
	Callback = function(color)
		print(string.format("[Demo] Color: R=%d G=%d B=%d",
			math.floor(color.R * 255),
			math.floor(color.G * 255),
			math.floor(color.B * 255)))
	end,
})

----------------------------------------------------------------------------
-- Section: Display elements
----------------------------------------------------------------------------
local DisplaySection = ElementsTab:CreateSection("Display Elements")

DisplaySection:CreateLabel({
	Text = "This is a simple, static label.",
	Icon = Library.Icons.info,
})

DisplaySection:CreateParagraph({
	Title   = "Note",
	Content = "This is a paragraph element for longer descriptive text. " ..
		"It wraps automatically and adjusts its height to fit the content — " ..
		"perfect for explanations, changelogs or instructions inside the UI.",
})

DisplaySection:CreateButton({
	Name        = "Send Test Notification",
	Description = "Shows a sample notification",
	Icon        = Library.Icons.bolt,
	Callback    = function()
		Library:Notify({
			Title   = "Hello!",
			Message = "This is a test notification from GemsUI.",
			Type    = "Info",
			Duration = 4,
		})
	end,
})

--================================================================================
-- 5) TAB: CONFIG  (save/load + dialog demo)
-- Note: Theme selection and changelog are in the built-in
-- "UI Settings" tab (last tab, created automatically by the framework).
--================================================================================
local ConfigTab = MainWindow:CreateTab({ Name = "Config", Icon = Library.Icons.settings })

local ConfigSection = ConfigTab:CreateSection("Configuration")

ConfigSection:CreateLabel({
	Text = "Saves/loads all flags (toggles, sliders, dropdowns, ...) as a JSON file.",
})

ConfigSection:CreateButton({
	Name     = "Save Config",
	Icon     = Library.Icons.check,
	Callback = function()
		Library:SaveConfig("demo")
	end,
})

ConfigSection:CreateButton({
	Name     = "Load Config",
	Icon     = Library.Icons.dropdown,
	Callback = function()
		Library:LoadConfig("demo")
	end,
})

local DialogSection = ConfigTab:CreateSection("Dialogs & Confirmations")

DialogSection:CreateButton({
	Name        = "Reset All",
	Description = "Opens a confirmation dialog",
	Icon        = Library.Icons.warning,
	Callback    = function()
		Library:CreateDialog({
			Title   = "Are you sure?",
			Message = "This resets all demo settings. This action cannot be undone.",
			Buttons = {
				{
					Text     = "Reset",
					Style    = "Primary",
					Callback = function()
						Library:Notify({
							Title   = "Reset",
							Message = "All values have been reset.",
							Type    = "Warning",
						})
					end,
				},
				{ Text = "Cancel" },
			},
		})
	end,
})

--================================================================================
-- 6) SECOND WINDOW  (proof: multiple windows work simultaneously)
--================================================================================
local SecondWindow = Library:CreateWindow({
	Title    = "System Monitor",
	SubTitle = "V1.0",
	Theme    = "Viper",
	Position = UDim2.new(0.72, 0, 0.7, 0),
	Size     = UDim2.new(0, 380, 0, 260),
	ToggleButton = true,
})

local MonitorTab     = SecondWindow:CreateTab({ Name = "Status", Icon = Library.Icons.info })
local MonitorSection = MonitorTab:CreateSection("Live Values (Demo)")

MonitorSection:CreateLabel({ Text = "This window runs independently from the main window." })

MonitorSection:CreateSlider({
	Name    = "CPU Load (simulated)",
	Min = 0, Max = 100, Default = 42, Suffix = "%",
})

MonitorSection:CreateToggle({
	Name    = "Auto-Refresh",
	Default = true,
})

MonitorTab:CreateSection("Note"):CreateParagraph({
	Content = "Both windows have their own themes, toggle buttons and " ..
		"can be moved, minimised and closed independently of each other.",
})

--================================================================================
-- 7) WELCOME NOTIFICATION
--================================================================================
task.delay(1, function()
	Library:Notify({
		Title    = "GemsUI loaded",
		Message  = "Framework version " .. Library.Version .. " successfully initialised.",
		Type     = "Success",
		Duration = 5,
	})
end)

print("[GemsUI Demo] Loaded. Device detected as: " .. Library.Device)
