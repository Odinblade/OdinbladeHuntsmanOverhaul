local function SessionLoading()
    Ext.Print("[OdinHUN:BootstrapClient.lua] Session is loading.")
end

Ext.Require("Client/OdinHUN_DescriptionParams.lua")

local ModuleLoading = function ()
    Ext.Print("[OdinHUN:BootstrapClient.lua] Module is loading.")
    OverrideStats()
end

Ext.RegisterListener("ModuleLoading", ModuleLoading)
Ext.RegisterListener("SessionLoading", SessionLoading)