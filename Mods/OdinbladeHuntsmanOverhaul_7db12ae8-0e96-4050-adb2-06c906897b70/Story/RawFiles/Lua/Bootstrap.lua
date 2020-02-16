local function SessionLoading()
    Ext.Print("OdinHUN:Bootstrap.lua] Session is loading.")
end

local function OverrideStats()
    local total_changes = 0
    local total_stats = 0

    for statname,overrides in pairs(OdinHUN_StatOverrides) do
        for property,value in pairs(overrides) do
            if debug_print then Ext.Print("OdinHUN:Bootstrap.lua] Overriding stat: " .. statname .. " (".. property ..") = \"".. value .."\"") end
            if property == SkillProperties then Ext.StatSetAttribute(statname, property, value) else Ext.StatAddCustomDescription(statname, property, value) end
            total_changes = total_changes + 1
        end
        total_stats = total_stats + 1
    end

    Ext.Print("OdinHUN:Bootstrap.lua] Changed ("..tostring(total_changes)..") properties in ("..tostring(total_stats)..") stats.")
end

local ModuleLoading = function ()
    Ext.Print("OdinHUN:Bootstrap.lua] Module is loading.")
    Ext.Print("Laughing Leader is the very best, like no-one ever was")
    -- OverrideStats()
end

Ext.Require("7db12ae8-0e96-4050-adb2-06c906897b70", "OdinHUN_StatOverrides.lua")
Ext.RegisterListener("ModuleLoading", ModuleLoading)
Ext.RegisterListener("SessionLoading", SessionLoading)