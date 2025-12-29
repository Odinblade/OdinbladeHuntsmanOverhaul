Ext.Require("Shared/OdinHUN_Utils.lua")

Ext.Events.StatusHitEnter:Subscribe(function (e)
    local casterObject = Ext.Entity.GetCharacter(e.Hit.StatusSourceHandle)
    if casterObject == nil then
        return
    end

    local skillId = GetSkillEntryName(e.Hit.SkillId)

    -- End processing if the hit is already coming from a Seeking Arrows hit
    if skillId == "Projectile_OdinHUN_SeekingArrows_Shot" then
        return
    end

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
            local casterGuid = casterObject.MyGuid
            local x, y, z = GetPosition(casterGuid)
            local targetGuid = Ext.Entity.GetGameObject(e.Hit.TargetHandle).MyGuid

            NRD_ProjectilePrepareLaunch()
            NRD_ProjectileSetString("SkillId", "Projectile_OdinHUN_SeekingArrows_Shot")
            NRD_ProjectileSetVector3("SourcePosition", x, y + 1.5, z)
            NRD_ProjectileSetGuidString("TargetPosition", targetGuid)
            NRD_ProjectileSetGuidString("Caster", casterGuid)
            NRD_ProjectileSetGuidString("Target", targetGuid)
            NRD_ProjectileSetGuidString("HitObject", targetGuid)
            NRD_ProjectileLaunch()
        end
    end
end)

Ext.Events.OnBeforeSortAiActions:Subscribe(function (e)
    local seekingArrowsAction = nil
    local seekingArrowsActionIndex = nil
    local boosted = false

    -- Find the SeekingArrows action
    for i, action in ipairs(e.Request.AiActions) do
        if action.SkillId then
            if GetSkillEntryName(action.SkillId) == "Shout_OdinHUN_Enemy_SeekingArrows" then
                seekingArrowsAction = action
                seekingArrowsActionIndex = i
                break
            end
        end
    end

    -- If found, check other actions for ranged weapon skills or StandardAttack
    if seekingArrowsAction then
        local char = Ext.ServerEntity.GetCharacter(e.CharacterHandle)
        if char.Stats.CurrentAP <= 3 then
            seekingArrowsAction.FinalScore = 0
            seekingArrowsAction.ActionFinalScore = 0
            return
        end

        for i, action in ipairs(e.Request.AiActions) do
            if i ~= seekingArrowsActionIndex then
                -- If action has a SkillId, check its requirement
                if action.SkillId and action.SkillId ~= "" then
                    local entryName = GetSkillEntryName(action.SkillId)
                    local stat = Ext.Stats.Get(entryName)
                    if stat and stat.Requirement == "RangedWeapon" then
                        seekingArrowsAction.FinalScore = 999
                        seekingArrowsAction.ActionFinalScore = 999
                        boosted = true
                        break
                    end
                end

                -- If it's a standard attack (may have empty SkillId), boost the seeking arrows score
                if action.ActionType == "StandardAttack" then
                    seekingArrowsAction.FinalScore = 999
                    seekingArrowsAction.ActionFinalScore = 999
                    boosted = true
                    break
                end
            end
        end

        -- If not boosted, set FinalScore to 0
        if not boosted then
            seekingArrowsAction.FinalScore = 0
            seekingArrowsAction.ActionFinalScore = 0
        end
    end
end)

