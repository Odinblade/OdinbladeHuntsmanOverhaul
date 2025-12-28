Ext.Require("Shared/OdinHUN_Utils.lua")

Ext.Events.StatusHitEnter:Subscribe(function (e)
    local skillId = GetSkillEntryName(e.Hit.SkillId)

    -- End processing if the hit is already coming from a Seeking Arrows hit
    if skillId == "Projectile_OdinHUN_SeekingArrows_Shot" then
        return
    end

    local casterObject = Ext.Entity.GetCharacter(e.Hit.StatusSourceHandle)
    local casterGuid = casterObject.MyGuid

    if casterObject:GetStatus("OdinHUN_SEEKINGARROWS") then
        local isBow = false
        local skillRangedRequirement = false

        local weaponItem = Ext.Entity.GetItem(e.Hit.WeaponHandle)
        if weaponItem then
            local weaponType = weaponItem.Stats.WeaponType
            isBow = IsBow(weaponType)
        else
            local stat = Ext.Stats.Get(skillId)
            skillRangedRequirement = stat.Requirement == "RangedWeapon"
        end

        if isBow or skillRangedRequirement then
            local x, y, z = GetPosition(casterGuid)
            local targetGuid = Ext.Entity.GetGameObject(e.Hit.TargetHandle).MyGuid

            NRD_ProjectilePrepareLaunch()
            NRD_ProjectileSetString("SkillId", "Projectile_OdinHUN_SeekingArrows_Shot")
            NRD_ProjectileSetVector3("SourcePosition", x, y + 1, z)
            NRD_ProjectileSetGuidString("TargetPosition", targetGuid)
            NRD_ProjectileSetGuidString("Caster", casterGuid)
            NRD_ProjectileSetGuidString("Target", targetGuid)
            NRD_ProjectileSetGuidString("HitObject", targetGuid)
            NRD_ProjectileLaunch()
        end
    end
end)