local function SessionLoading()
    Ext.Print("[OdinHUN:BootstrapServer.lua] Session is loading.")
end

local ModuleLoading = function ()
    Ext.Print("[OdinHUN:BootstrapServer.lua] Module is loading.")
    OverrideStats()
end

Ext.RegisterListener("ModuleLoading", ModuleLoading)
Ext.RegisterListener("SessionLoading", SessionLoading)