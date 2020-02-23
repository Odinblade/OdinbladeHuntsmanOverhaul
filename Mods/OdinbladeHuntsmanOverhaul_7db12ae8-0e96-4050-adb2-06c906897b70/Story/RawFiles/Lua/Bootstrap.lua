local function SessionLoading()
    Ext.Print("OdinHUN:Bootstrap.lua] Session is loading.")
end

-- Credit to LaughingLeader/Norbyte for providing the base of this function
local function OverrideStats()
    local total_changes = 0
    local total_stats = 0
    local debug_print = false

    for statname,overrides in pairs(OdinHUN_StatOverrides) do
        for property,value in pairs(overrides) do
            if debug_print then Ext.Print("OdinHUN:Bootstrap.lua] Overriding stat: " .. statname .. " (".. property ..") = \"".. value .."\"") end
            if property == "SkillProperties" then 
                Ext.StatAddCustomDescription(statname, property, value) 
                if debug_print then Ext.Print("OdinHUN:Bootstrap.lua] Custom description set: " .. statname .. " (".. property ..") = \"".. value .."\"") end
            else 
                Ext.StatSetAttribute(statname, property, value)
                if debug_print then Ext.Print("OdinHUN:Bootstrap.lua] Stat attribute overwritten: " .. statname .. " (".. property ..") = \"".. value .."\"") end
            end
            total_changes = total_changes + 1
        end
        total_stats = total_stats + 1
    end

    Ext.Print("OdinHUN:Bootstrap.lua] Changed ("..tostring(total_changes)..") properties in ("..tostring(total_stats)..") stats.")
end

local ModuleLoading = function ()
    Ext.Print("[OdinHUN:Bootstrap.lua] Module is loading.")
    OverrideStats()
end

Ext.Require("7db12ae8-0e96-4050-adb2-06c906897b70", "OdinHUN_StatOverrides.lua")
Ext.RegisterListener("ModuleLoading", ModuleLoading)
Ext.RegisterListener("SessionLoading", SessionLoading)