local beautiful = require "beautiful"
local utils = {}

function utils.get_parameters(parameters, user_params)
    local ret = {}
    for key, parameter in pairs(parameters) do
        ret[key] = user_params[key]
            or (parameter.beautiful_fallbacks and utils.first_beautiful(
                parameter.beautiful_fallbacks
            ))
            or parameter.default_value
    end
    return ret
end

function utils.first_beautiful(keys)
    for _, key in ipairs(keys) do
        local value = beautiful[key]
        if value then
            return value
        end
    end
    return nil
end

return utils
