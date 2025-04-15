local micro = import("micro")
local config = import("micro/config")

config.AddRuntimeFile("colored_status", config.RTPlugin, "colored_status.lua")

return function()
    function init()
        micro.Log("colored_status plugin initialized")
    end

    function color_status_line()
        local current_file = micro.CurFile().Name()
        local colored_text = "\x1b[32m" .. current_file .. "\x1b[0m"
        micro.SetStatusLine(colored_text)
    end

    micro.AddHook("OnInit", color_status_line)
    -- micro.AddHook("OnCursorMove", color_status_line)
end
