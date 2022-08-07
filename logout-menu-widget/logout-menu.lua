-------------------------------------------------
-- Logout Menu Widget for Awesome Window Manager
-- More details could be found here:
-- https://github.com/streetturtle/awesome-wm-widgets/tree/master/logout-menu-widget

-- @author Pavel Makhov
-- @copyright 2020 Pavel Makhov
-------------------------------------------------

local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local gobject = require("gears.object")
local gtable = require("gears.table")
local beautiful = require("beautiful")
local utils = require("awesome-wm-widgets.logout-menu-widget.utils")
local background = require("wibox.container.background")
local beautiful = require("beautiful")
local button = require("awful.button")
local fixed = require("wibox.layout.fixed")
local hover_container = require("awesome-wm-widgets.logout-menu-widget.hover_container")
local imagebox = require("wibox.widget.imagebox")
local margin = require("wibox.container.margin")
local popup = require("awful.popup")
local shape = require("gears.shape")
local textbox = require("wibox.widget.textbox")
local widget = require("wibox.widget")
local menu_popup = require("awesome-wm-widgets.logout-menu-widget.menu_popup")

local HOME = os.getenv("HOME")
local ICON_DIR = HOME .. "/home/aireone/documents/prog/awesome-workspace/awesome-wm-widgets/logout-menu-widget/icons/"

-- local logout_menu_widget = wibox.widget({
-- 	{
-- 		{
-- 			image = ICON_DIR .. "power_w.svg",
-- 			resize = true,
-- 			widget = wibox.widget.imagebox,
-- 		},
-- 		margins = 4,
-- 		layout = wibox.container.margin,
-- 	},
-- 	shape = function(cr, width, height)
-- 		gears.shape.rounded_rect(cr, width, height, 4)
-- 	end,
-- 	widget = wibox.container.background,
-- })

-- local popup = awful.popup({
-- 	ontop = true,
-- 	visible = false,
-- 	shape = function(cr, width, height)
-- 		gears.shape.rounded_rect(cr, width, height, 4)
-- 	end,
-- 	border_width = 1,
-- 	border_color = beautiful.bg_focus,
-- 	maximum_width = 400,
-- 	offset = { y = 5 },
-- 	widget = {},
-- })

-- local function worker(user_args)
-- 	local rows = { layout = wibox.layout.fixed.vertical }

-- 	local args = user_args or {}

-- 	local font = args.font or beautiful.font

-- 	local onlogout = args.onlogout or function()
-- 		awesome.quit()
-- 	end
-- 	local onlock = args.onlock or function()
-- 		awful.spawn.with_shell("i3lock")
-- 	end
-- 	local onreboot = args.onreboot or function()
-- 		awful.spawn.with_shell("reboot")
-- 	end
-- 	local onsuspend = args.onsuspend or function()
-- 		awful.spawn.with_shell("systemctl suspend")
-- 	end
-- 	local onpoweroff = args.onpoweroff or function()
-- 		awful.spawn.with_shell("shutdown now")
-- 	end

-- 	local menu_items = {
-- 		{ name = "Log out", icon_name = "log-out.svg", command = onlogout },
-- 		{ name = "Lock", icon_name = "lock.svg", command = onlock },
-- 		{ name = "Reboot", icon_name = "refresh-cw.svg", command = onreboot },
-- 		{ name = "Suspend", icon_name = "moon.svg", command = onsuspend },
-- 		{ name = "Power off", icon_name = "power.svg", command = onpoweroff },
-- 	}

-- 	for _, item in ipairs(menu_items) do
-- 		local row = wibox.widget({
-- 			{
-- 				{
-- 					{
-- 						image = ICON_DIR .. item.icon_name,
-- 						resize = false,
-- 						widget = wibox.widget.imagebox,
-- 					},
-- 					{
-- 						text = item.name,
-- 						font = font,
-- 						widget = wibox.widget.textbox,
-- 					},
-- 					spacing = 12,
-- 					layout = wibox.layout.fixed.horizontal,
-- 				},
-- 				margins = 8,
-- 				layout = wibox.container.margin,
-- 			},
-- 			bg = beautiful.bg_normal,
-- 			widget = wibox.container.background,
-- 		})

-- 		row:connect_signal("mouse::enter", function(c)
-- 			c:set_bg(beautiful.bg_focus)
-- 		end)
-- 		row:connect_signal("mouse::leave", function(c)
-- 			c:set_bg(beautiful.bg_normal)
-- 		end)

-- 		local old_cursor, old_wibox
-- 		row:connect_signal("mouse::enter", function()
-- 			local wb = mouse.current_wibox
-- 			old_cursor, old_wibox = wb.cursor, wb
-- 			wb.cursor = "hand1"
-- 		end)
-- 		row:connect_signal("mouse::leave", function()
-- 			if old_wibox then
-- 				old_wibox.cursor = old_cursor
-- 				old_wibox = nil
-- 			end
-- 		end)

-- 		row:buttons(awful.util.table.join(awful.button({}, 1, function()
-- 			popup.visible = not popup.visible
-- 			item.command()
-- 		end)))

-- 		table.insert(rows, row)
-- 	end
-- 	popup:setup(rows)

-- 	logout_menu_widget:buttons(awful.util.table.join(awful.button({}, 1, function()
-- 		if popup.visible then
-- 			popup.visible = not popup.visible
-- 			logout_menu_widget:set_bg("#00000000")
-- 		else
-- 			popup:move_next_to(mouse.current_widget_geometry)
-- 			logout_menu_widget:set_bg(beautiful.bg_focus)
-- 		end
-- 	end)))

-- 	return logout_menu_widget
-- end

local actions = { "Logout", "Lock", "Reboot", "Suspend", "Power off" }
local action_callbacks = {}

action_callbacks.on_logout = function()
	-- awesome.quit()
end

action_callbacks.on_lock = function()
	awful.spawn.with_shell("i3lock")
end

action_callbacks.on_reboot = function()
	awful.spawn.with_shell("reboot")
end

action_callbacks.on_suspend = function()
	awful.spawn.with_shell("systemctl suspend")
end

action_callbacks.on_poweroff = function()
	awful.spawn.with_shell("shutdown now")
end

local logout_menu_widget = { mt = {} }

local parameters = {
	icon = { beautiful_fallbacks = { "logout_menu_icon", "awesome_icon" }, default_value = ICON_DIR .. "power_w.svg" },
	font = { beautiful_fallbacks = { "logout_menu_font", "font" } },
	-- logout_icon = { beautiful_fallbacks = { "logout_menu_icon_logout" }, default_value = ICON_DIR .. "log-out.svg" },
	-- logout_label = { default_value = "Log out" },
	-- logout_callback = { default_value = onLogout },
	-- lock_icon = { beautiful_fallbacks = { "logout_menu_icon_lock" }, default_value = ICON_DIR .. "lock.svg" },
	-- lock_label = { default_value = "Lock" },
	-- lock_callback = { default_value = onLock },
	-- reboot_icon = { beautiful_fallbacks = { "logout_menu_icon_reboot" }, default_value = ICON_DIR .. "refresh-cw.svg" },
	-- reboot_label = { default_value = "Reboot" },
	-- reboot_callback = { default_value = onReboot },
	-- suspend_icon = { beautiful_fallbacks = { "logout_menu_icon_suspend" }, default_value = ICON_DIR .. "moon.svg" },
	-- suspend_label = { default_value = "Suspend" },
	-- suspend_callback = { default_value = onSuspend },
	-- poweroff_icon = { beautiful_fallbacks = { "logout_menu_icon_poweroff" }, default_value = ICON_DIR .. "power.svg" },
	-- poweroff_label = { default_value = "Power off" },
	-- poweroff_callback = { default_value = onPoweroff },
}

-- Generate entries in parameters for each action icon, label and callback
for _, action in ipairs(actions) do
	local sanitized_action = action:lower():gsub("%s+", "")
	parameters[sanitized_action .. "_icon"] = {
		beautiful_fallbacks = { "logout_menu_icon_" .. sanitized_action },
		default_value = ICON_DIR .. sanitized_action .. ".svg",
	}
	parameters[sanitized_action .. "_label"] = { default_value = action }
	parameters[sanitized_action .. "_callback"] = { default_value = action_callbacks["on_" .. sanitized_action] }
end

function logout_menu_widget.new(params)
	local vars = utils.get_parameters(parameters, params)
	local ret = wibox.widget({
		{
			{
				image = vars.icon,
				resize = true,
				widget = imagebox,
			},
			margins = 4,
			layout = margin,
		},
		shape = function(cr, width, height)
			shape.rounded_rect(cr, width, height, 4)
		end,
		widget = background,
	})

	gtable.crush(ret, logout_menu_widget, true)
	gtable.crush(ret, vars, true)
	ret.widget_name = gobject.modulename(2)

	local rows = {}
	for _, action in ipairs(actions) do
		local sanitized_action = action:lower():gsub("%s+", "")
		table.insert(rows, {
			label = ret[sanitized_action .. "_label"],
			icon = ret[sanitized_action .. "_icon"],
			callback = ret[sanitized_action .. "_callback"],
			font = ret.font,
		})
	end
	ret.popup = menu_popup({
		rows = rows,
		bind_to_widget = ret
	})
	-- ret:buttons({
	-- 	awful.button({}, 1, function()
	-- 		-- Make sure the popup appear next to the widget
	-- 		if not ret.popup.visible then
	-- 			ret.popup:move_next_to(ret.geometry)
	-- 		else
	-- 			ret.popup.visible = false
	-- 		end
	-- 	end),
	-- })

	return ret
end

function logout_menu_widget.mt:__call(...)
	return logout_menu_widget.new(...)
end

return setmetatable(logout_menu_widget, logout_menu_widget.mt)
