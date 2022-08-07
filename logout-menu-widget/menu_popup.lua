local background = require "wibox.container.background"
local beautiful = require "beautiful"
local button = require "awful.button"
local fixed = require "wibox.layout.fixed"
local hover_container =
    require "awesome-wm-widgets.logout-menu-widget.hover_container"
local imagebox = require "wibox.widget.imagebox"
local margin = require "wibox.container.margin"
local popup = require "awful.popup"
local shape = require "gears.shape"
local textbox = require "wibox.widget.textbox"
local widget = require "wibox.widget"

local unpack = table.unpack or unpack

local menu_popup = { mt = {} }

-- type Row = {
--    label: string, -- text in the line
--    icon: string, -- icon on the line
--    callback: function -- function on selection
--    font: string -- the font to use for the label
-- }
local function row_widget(row)
    local ret = widget {
        -- {
        {
            {
                image = row.icon,
                resize = false,
                widget = imagebox,
            },
            {
                text = row.label,
                font = row.font,
                widget = textbox,
            },
            spacing = 12,
            layout = fixed.horizontal,
        },
        margins = 8,
        widget = margin,
        -- },
        -- widget = hover_container,
    }

    ret:buttons {
        button({}, 1, function()
            popup.visible = not popup.visible
            row.callback()
        end),
    }

    return ret
end

local function row_factory(rows)
    local row_items = {}
    for _, row in ipairs(rows) do
        table.insert(row_items, row_widget(row))
    end
    return row_items
end

function menu_popup.new(params)
    local ret = popup {
        widget = {
            layout = fixed.vertical,
            unpack(row_factory(params.rows)),
        },
        ontop = true,
        visible = false,
        hide_on_right_click = true,
        border_width = 1,
        border_color = beautiful.bg_focus,
        shape = shape.rounded_rect,
        maximum_width = 400,
        offset = { y = 5 },
    }

    if params.bind_to_widget then
        ret:bind_to_widget(ret)
    end

    return ret
end

function menu_popup.mt:__call(...)
    return menu_popup.new(...)
end

return setmetatable(menu_popup, menu_popup.mt)
