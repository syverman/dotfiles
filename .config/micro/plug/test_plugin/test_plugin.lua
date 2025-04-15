local micro = import("micro")

return function()
    function onBufferOpen(buf)
        micro.Log("test_plugin - Buffer opened: " .. buf.Path())
    end
end
