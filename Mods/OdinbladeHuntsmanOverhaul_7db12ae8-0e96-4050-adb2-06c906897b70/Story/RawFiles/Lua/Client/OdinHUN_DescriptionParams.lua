Ext.Require("Shared/OdinHUN_SharedData.lua")
Ext.Require("Shared/OdinHUN_StatOverrides.lua")

-- Credit: LaughingLeader
local DamageTypeHandles = {
    None = {Handle="h8a070775gc251g4f34g9086gb1772f7e2cff",Content="pure damage", Color="#CD1F1F"},
    Physical = {Handle="h40782d69gbfaeg40cegbe3cg370ef44e3980",Content="physical damage", Color="#a8a8a8"},
    Piercing = {Handle="hd05581a1g83a7g4d95gb59fgfa5ef68f5c90",Content="piercing damage", Color="#CD1F1F"},
    Corrosive = {Handle="h161d5479g06d6g408egade2g37a203e3361f",Content="corrosive damage", Color="#797980"},
    Magic = {Handle="hdb4307b4g1a6fg4c05g9602g6a4a6e7a29d9",Content="magic damage", Color="#7F00FF"},
    -- Special LeaderLib handle
    Chaos = {Handle="h2bc14afag7627g4db8gaaa6g19c26b9820d5",Content="chaos damage", Color="#CD1F1F"},
    Air = {Handle="hdd80e44fg9585g48b8ga34dgab20dc18f077",Content="air damage", Color="#7D71D9"},
    Earth = {Handle="h68b77a37g9c43g4436gb360gd651af08d7bb",Content="earth damage", Color="#7f3d00"},
    Fire = {Handle="hc4d062edgd8e6g4048gaa44g160fe3c7b018",Content="fire damage", Color="#FE6E27"},
    Poison = {Handle="ha77d36b3ge969g4461g9b30gfff624024b18",Content="poison damage", Color="#65C900"},
    Shadow = {Handle="h256557fbg1d49g45d9g8690gb86b39d2a135",Content="shadow damage", Color="#797980"},
    Water = {Handle="h8cdcfeedg357eg4877ga69egc05dbe9c68a4",Content="water damage", Color="#4197E2"},
}

-- Credit: LaughingLeader
local function GetDamageText(damageType, damageValue)
    local entry = DamageTypeHandles[damageType]
    if entry ~= nil then
        local name = Ext.GetTranslatedString(entry.Handle, entry.Content)
        return string.format("<font color='%s'>%s %s</font>", entry.Color, damageValue, name)
    else
        Ext.PrintError("No damage name/color entry for type " .. tostring(damageType))
    end
    return ""
end

-- Custom calculation for Huntsman boost
local function GetGrenadeBoostVal(character, skill)
    local damageMultiplier = skill['Damage Multiplier'] * 0.01
    local baseDamage = Game.Math.CalculateBaseDamage(skill.Damage, character, 0, character.Level) * damageMultiplier
    local damageRange = skill['Damage Range'] * baseDamage * 0.005
    local damageType = skill.DamageType
    local damageTypeBoost = 1.0 + Game.Math.GetDamageBoostByType(character, damageType)
    local rangerMultiplier = 1 + (character.RangerLore * 0.05)
    local damageBoost = 1.0 + (character.DamageBoost / 100.0)

    local floor = math.floor(math.floor(math.floor((baseDamage - damageRange) * damageBoost) * damageTypeBoost) * rangerMultiplier)
    local ceil = math.ceil(math.ceil(math.ceil((baseDamage + damageRange) * damageBoost) * damageTypeBoost) * rangerMultiplier)

    local rangeText = floor.."-"..ceil
    local damageRangeParam = GetDamageText(skill.DamageType, rangeText)

    return damageRangeParam
end

-- Changes damage range formatting to match element type from Elemental Arrowheads
local function GetEARange(character, skill)
    local damageRange = Game.Math.GetSkillDamageRange(character, skill)
    local min = ""
    local max = ""
    local type = "None"

    for damageType, damage in pairs(damageRange) do
        type = damageType
        min = math.floor(damage[1])
        max = math.floor(damage[2])
    end

    for status,data in pairs(HuntsmanOverhaul.EAStatuses) do
        if character.Character:GetStatus(status) ~= nil then
            type = data
            -- TODO:- Add boosted values
            
            -- local weaponDamage = Game.Math.CalculateWeaponDamageRange(character, character.MainWeapon)
            -- min = min + ((0.15*0.7)*weaponDamage["Physical"][1])
            -- max = max + ((0.25*0.7)*weaponDamage["Physical"][2])
        end
    end

    local rangeText = min.."-"..max
    local damageRangeParam = GetDamageText(type, rangeText)

    return damageRangeParam
end

local function OdinHUN_BeginEACheck(skill, character)
    local craftedArrow = HuntsmanOverhaul.CraftedArrows[skill.Name]
    if craftedArrow == nil then --Skill is not a crafted arrow
        local mainWeapon = character.MainWeapon
        if skill.UseWeaponDamage == "Yes" and Game.Math.IsRangedWeapon(mainWeapon) and skill.DamageType ~= "Piercing" then
            local status, result = xpcall(GetEARange, debug.traceback, character, skill)
            return result
        end
    end
end

-- Listeners
local function OdinHUN_SkillGetDescriptionParam(skill, character, isFromItem, param)
    local damageParam = HuntsmanOverhaul.DamageParams[param]
    if damageParam ~= nil then
        local isGrenade = HuntsmanOverhaul.Grenades[skill.Name]
        if isGrenade ~= nil then
            local status, result = xpcall(GetGrenadeBoostVal, debug.traceback, character, skill)
            return result
        end
        if skill.Requirement == "RangedWeapon" then
            local result = OdinHUN_BeginEACheck(skill, character)
            return result
        end
    else
        local tooltipDamageParam = HuntsmanOverhaul.TooltipStatuses[param]
        if tooltipDamageParam ~= nil then
            tooltipDamageParam = Ext.GetStat(tooltipDamageParam, nil)
            local result = OdinHUN_BeginEACheck(tooltipDamageParam, character)
            return result
        end
    end
end

Ext.RegisterListener("SkillGetDescriptionParam", OdinHUN_SkillGetDescriptionParam)
Ext.Print("[OdinHUN_DescriptionParams.lua] Registered listener SkillGetDescriptionParam.")
