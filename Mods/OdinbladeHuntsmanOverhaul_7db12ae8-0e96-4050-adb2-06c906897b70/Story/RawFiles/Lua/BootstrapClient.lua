Ext.Require("Client/OdinHUN_DescriptionParams.lua")

Ext.Events.ModuleLoading:Subscribe(function (e)
    print("[OdinHUN:BootstrapClient.lua] Module is loading.")
    OverrideStats()
end)

Ext.Events.SessionLoading:Subscribe(function (e)
    print("[OdinHUN:BootstrapClient.lua] Session is loading.")
end)