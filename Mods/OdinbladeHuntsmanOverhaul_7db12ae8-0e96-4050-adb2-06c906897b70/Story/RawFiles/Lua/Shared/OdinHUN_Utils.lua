---Returns true if a given WeaponType is either a bow or crossbow
---@param weaponType StatsWeaponType
function IsBow(weaponType)
    return weaponType == "Bow" or weaponType == "Crossbow"
end

---Gets a skillId without prototype suffixes (e.g. _-1)
---@param skill string
---@return string
function GetSkillEntryName(skill)
    local skillId = string.gsub(skill, "_%-?%d+$", "")
    return skillId
end