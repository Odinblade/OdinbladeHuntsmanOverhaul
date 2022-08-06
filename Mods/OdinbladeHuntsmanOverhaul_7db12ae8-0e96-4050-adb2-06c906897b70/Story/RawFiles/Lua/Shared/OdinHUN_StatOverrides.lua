Ext.Require("Shared/OdinHUN_SharedData.lua")

-- Credit: LaughingLeader and Norbyte for base of this function
function OverrideStats()
    local total_changes = 0
    local total_stats = 0
    local debug_print = false
    local description = ""

    for statname,overrides in pairs(HuntsmanOverhaul_StatOverrides) do
        for property,value in pairs(overrides) do
            if debug_print then Ext.Print("[OdinHUN:Bootstrap.lua] Overriding stat: " .. statname .. " (".. property ..") = \"".. value .."\"") end
            if property == "SkillCustomDescription" then 
                Ext.StatAddCustomDescription(statname, "SkillProperties", value) 
                if debug_print then Ext.Print("[OdinHUN:Bootstrap.lua] Custom description set: " .. statname .. " (".. property ..") = \"".. value .."\"") end
            else 
                Ext.StatSetAttribute(statname, property, value)
                if debug_print then Ext.Print("[OdinHUN:Bootstrap.lua] Stat attribute overwritten: " .. statname .. " (".. property ..") = \"".. value .."\"") end
            end
            total_changes = total_changes + 1
        end
        total_stats = total_stats + 1
    end

    Ext.Print("[OdinHUN:Bootstrap.lua] Changed ("..tostring(total_changes)..") properties in ("..tostring(total_stats)..") stats.")
end