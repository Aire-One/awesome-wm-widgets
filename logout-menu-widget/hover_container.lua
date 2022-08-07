local base = require "wibox.widget.base"
local beautiful = require "beautiful"
local gobject = require "gears.object"
local gtable = require "gears.table"

local hover_container = { _private = { drawable_cursor = "left_ptr" }, mt = {} }

local parameters = {
    bg_normal = "#FF0000",
    bg_focus = "#00FF00",
}

function hover_container:fit(context, width, height)
    return base.fit_widget(self, context, self._private.widget, width, height)
end

function hover_container:layout(_, width, height)
    return { base.place_widget_at(self._private.widget, 0, 0, width, height) }
end

-- for parameter in pairs(parameters) do
-- 	hover_container["get_" .. parameter] = function(self)
-- 		return rawget(self, parameter)
-- 	end
-- 	hover_container["set_" .. parameter] = function(self, value)
-- 		rawset(self, parameter, value)
-- 	end
-- end

hover_container.set_widget = base.set_widget_common
function hover_container:get_widget()
    return self._private.widget
end

function hover_container:set_children(widgets)
    self:set_widget(widgets[1])
end

function hover_container:get_children()
    return { self._private.widget }
end

function hover_container:mouse_enter(find_widgets_result)
    self._private.drawable_cursor = find_widgets_result.drawable.cursor
    find_widgets_result.drawable.cursor = self.hover_cursor
    self:set_bg(self.bg_hovered)
end

function hover_container:mouse_leave(find_widgets_result)
    find_widgets_result.drawable.cursor = self._private.drawable_cursor
    self:set_bg(self.bg_normal)
end

function hover_container.new(widget, params)
    params = params or {}
    local ret = base.make_widget(nil, nil, { enable_properties = true })

    gtable.crush(ret, hover_container, true)
    ret.widget_name = gobject.modulename(2)

    ret._private.widget = widget

    for parameter, default_value in pairs(parameters) do
        ret[parameter] = params[parameter]
            or beautiful["hover_container_" .. parameter]
            or default_value
    end

    ret:connect_signal("mouse::enter", ret.mouse_enter)
    ret:connect_signal("mouse::leave", ret.mouse_leave)

    return ret
end

function hover_container.mt:__call(...)
    return hover_container.new(...)
end

return setmetatable(hover_container, hover_container.mt)
