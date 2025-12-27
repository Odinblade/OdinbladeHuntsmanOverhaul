Ext.Require("Server/OdinHUN_SeekingArrows.lua")

Ext.Events.SessionLoading:Subscribe(function (e)
    print("[OdinHUN:BootstrapServer.lua] Session is loading.")
end)

Ext.Events.ModuleLoading:Subscribe(function (e)
    print("[OdinHUN:BootstrapServer.lua] Module is loading.")
    OverrideStats()
end)