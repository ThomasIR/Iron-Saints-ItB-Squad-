local wt2 = {
	Passive_Force_Reflector_Upgrade1 = "+1 Damage",
}
for k,v in pairs(wt2) do Weapon_Texts[k] = v end

----- FORCE REFLECTOR -----
--[[  Description: Passive that makes enemies suffer damage when they attack mechs.
      Function: Iterates through all targets of an action and creates a new spacedamage-event
      Upgrades: +1 Damage and +1 Damage
]]--
Passive_Force_Reflector = PassiveSkill:new{
	Name = "Force Reflector",
	Description = "Vek take damage when they hit a Mech.",
	PowerCost = 1,
	Icon = "weapons/passive_force_reflector.png",
	Upgrades = 1,
	UpgradeCost = {3},
	Damage = 1, --Edit this to change the damage of the passive
	Passive = "Passive_Force_Reflector",
	TipImage = {
		Unit = Point(2,2),
		Enemy = Point(2,1)
	}
}

function Passive_Force_Reflector:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
    local d = SpaceDamage(Point(2,1), self.Damage, FULL_DELAY)

    d.sScript = string.format("Board:Ping(%s,GL_Color(150, 150, 255))", Point(2,1):GetString())
    ret:AddDamage(d)
	ret:AddMelee(Point(2,1),SpaceDamage(Point(2,2),1))
	return ret
end

Passive_Force_Reflector_A = Passive_Force_Reflector:new{
	Damage = 2,
	Passive = "Passive_Force_Reflector_A",
    UpgradeDescription = "Damage increased by 1",
}

Force_Reflector_SkillEffect = function(mission, pawn, weaponId, p1, p2, skillEffect)
  --Check if ability needs to trigger
    if not mission then return end
    if not pawn then return end
    if IsTestMechScenario() then return end
    --if IsTipImage() then return end
    if 
      not IsPassiveSkill("Passive_Force_Reflector") or
      pawn:GetTeam() == TEAM_PLAYER
    then return end

	--Setup of the variables for the for-loop 
    local countedtargets = 0
    local countedtargets_q = 0
    local lastTargetLocation_q = p2
    local damagemultiplicator = Passive_Force_Reflector.Damage
    local modifyEffect = false
    for _, spaceDamage in ipairs(extract_table(skillEffect.effect)) do
        if    
            --Checks if damage is dealt, if a pawn is on the field, if the pawn is a Mech
            spaceDamage.iDamage > 0                  and
            Board:IsPawnSpace(spaceDamage.loc)
        then
            if Board:GetPawn(spaceDamage.loc):IsMech() then
                --Increase the targets by 1. This is only for parts where enemies actually attack directly.
                countedtargets = countedtargets + 1
                modifyEffect = true
            end
        end
    end
    for _, spaceDamage in ipairs(extract_table(skillEffect.q_effect)) do
        if    
            --Checks if damage is dealt, if a pawn is on the field, if the pawn is a Mech
            spaceDamage.iDamage > 0                  and
            Board:IsPawnSpace(spaceDamage.loc)
        then
            if Board:GetPawn(spaceDamage.loc):IsMech() then
                --Increase the queued targets by 1. The differentiation is important else the enemy will attack directly and suffer the damage.
                countedtargets_q = countedtargets_q + 1
                lastTargetLocation_q = spaceDamage.loc
                LOG("Attempted Target Location: ", spaceDamage.loc:GetString())
                LOG("Last Target Location: ", lastTargetLocation_q:GetString())
                modifyEffect = true
            end
        end
    end
    
    -- Fires if hit targets are found to create a new SpaceDamage-Event
    if countedtargets > 0 or countedtargets_q > 0
    then
    
        --This part differentiates the passive to calculate the damage properly
        if IsPassiveSkill("Passive_Force_Reflector_A")
        then
            damagemultiplicator = damagemultiplicator + Passive_Force_Reflector_A.Damage - Passive_Force_Reflector.Damage
        end
        --This one is for direct attacks. There should be none in the base game
        --For some reason, this does not work with reflexive fire. The Hook does not seem to trigger within reflexive fire's Hook. Need to write a proper test here.
        --Also does not work with enemies that move when attacking. Replacing 'p1' with 'GAME.trackedPawns[pawn:GetId()].loc' doesn't help.
        if countedtargets > 0
        then
            local d = SpaceDamage(p1, countedtargets * damagemultiplicator, FULL_DELAY)

            d.sSound = "/weapons/area_shield"
            d.sScript = string.format("Board:Ping(%s,GL_Color(150, 150, 255))", p1:GetString())
            skillEffect:AddDamage(d)
        end
        --This one is for queued attacks. Most if not all enemy attacks will be these
        if countedtargets_q > 0
        then
            -- Make sure damage reflected to moths targets the correct tile
            if (Board:GetPawn(p1):GetType() == "Moth1" or Board:GetPawn(p1):GetType() == "Moth2") and Game:GetTeamTurn() == TEAM_ENEMY then
                --LOG("OLD p1 = ", p1:GetString())
                for dir = DIR_START, DIR_END do
		            local newTarget = p1 + DIR_VECTORS[dir]
                    if GetDirection(p2 - p1) == GetDirection(p1 - newTarget) and not Board:IsBlocked(newTarget, PATH_GROUND) then
                        p1 = newTarget
                        --LOG("NEW p1 = ", p1:GetString())
                    end
                end
            end

            --[[LOG("Double-Checking Last Target Location: ", lastTargetLocation_q:GetString())
            LOG("OLD p2 = ", p2:GetString())]]--

            p2 = lastTargetLocation_q;
            
            --[[LOG("NEW p2 = ", p2:GetString())
            LOG("Attacker Name: ", Board:GetPawn(p1):GetType())
            
            if Game:GetTeamTurn() == TEAM_ENEMY then
                LOG("Team Turn: ENEMY")
            end

            if Game:GetTeamTurn() == TEAM_PLAYER then
                LOG("Team Turn: PLAYER")
            end]]--

            -- Do the same for beetles
            if (Board:GetPawn(p1):GetType() == "Beetle1" or Board:GetPawn(p1):GetType() == "Beetle2"
                or Board:GetPawn(p1):GetType() == "BurnbugBoss") then
                
                --[[if Game:GetTeamTurn() == TEAM_ENEMY then
                    LOG("Team Turn: ENEMY")
                end

                if Game:GetTeamTurn() == TEAM_PLAYER then
                    LOG("Team Turn: PLAYER")
                end
                
                LOG("OLD p1 = ", p1:GetString())]]--

                for dir = DIR_START, DIR_END do
		            local newTarget = lastTargetLocation_q + DIR_VECTORS[dir]
                    if GetDirection(lastTargetLocation_q - p1) == GetDirection(lastTargetLocation_q - newTarget) then
                        p1 = newTarget
                        LOG("NEW p1 = ", p1:GetString())
                    end
                end
            end
        
            local d = SpaceDamage(p1, countedtargets_q * damagemultiplicator, FULL_DELAY)

            d.sSound = "/weapons/area_shield"
            d.sScript = string.format("Board:Ping(%s,GL_Color(150, 150, 255))", p1:GetString())
        
            skillEffect:AddQueuedDamage(d)
        end
    else
        return
    end
end

local function EVENT_onModsLoaded()
	modapiext:addSkillBuildHook(Force_Reflector_SkillEffect)
end

modApi.events.onModsLoaded:subscribe(EVENT_onModsLoaded)
