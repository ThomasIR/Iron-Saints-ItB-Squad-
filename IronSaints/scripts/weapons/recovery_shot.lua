local wt2 = {
	Recovery_Shot_Upgrade1 = "Full Heal",
	Recovery_Shot_Upgrade2 = "+2 Damage",
}
for k,v in pairs(wt2) do Weapon_Texts[k] = v end

----- RECOVERY SHOT -----
Recovery_Shot = LineArtillery:new{ 
	Class = "Science",
	Icon = "weapons/science_recovery_shot.png",
	LaunchSound = "/weapons/science_enrage_launch",
	ImpactSound = "/impact/generic/enrage",
	AttackSound = "/weapons/science_enrage_attack",
	TwoClickError = "Science_TC_Enrage_Error",
	TwoClick = true,
	AnyTarget = true,
	Healing = -1,
	Damage = 0,
	PowerCost = 0,
	Upgrades = 2,
	UpgradeCost = { 1,3 },
	TipImage = {
		Unit = Point(2,3),
		Target = Point(2,1),
		Friendly_Damaged = Point(2,1),
		Enemy = Point(3,1),
		Second_Click = Point(3,1),
	},
}

function Recovery_Shot:IsEnrageable(curr)
		
	if self.AnyTarget and Board:IsBlocked(curr, PATH_FLYER) then
		return true
	end

	if not Board:IsPawnSpace(curr) then
		return false
	end
	
	if Board:GetPawn(curr):GetBaseMove() > 0 then
		return true
	end
	
	local pawn_type = Board:GetPawn(curr):GetType() 
	local OK_Types = {"Totem1", "Totem2", "VIP_Truck", "Snowmine1", "TotemB"} --things with move 0 that can still enrage
	
	for i,v in ipairs(OK_Types) do
		if pawn_type == v then
			return true
		end
	end
	
	return false
end


function Recovery_Shot:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local damage = SpaceDamage(p2,0)
	
	if self:IsEnrageable(p2) then
		damage.sImageMark = "combat/icons/icon_mind_glow.png"
	else
		damage.sImageMark = "combat/icons/icon_mind_off_glow.png"
	end
	ret:AddDamage(damage)
	return ret
end

function Recovery_Shot:GetSecondTargetArea(p1, p2)
	local ret = PointList()
	
	if not self:IsEnrageable(p2) then
		return ret
	end
	
	for dir = DIR_START, DIR_END do
		ret:push_back(p2 + DIR_VECTORS[dir])
	end
	return ret
end

function Recovery_Shot:GetFinalEffect(p1,p2,p3)
	local direction = GetDirection(p3 - p2)
	local ret = SkillEffect()
	
	ret:AddArtillery(SpaceDamage(p2,0), "advanced/effects/shotup_swapother.png", FULL_DELAY)
	
	local dummy_damage = SpaceDamage(p2,0)
	dummy_damage.sAnimation = "ExploRepulseSmall"
	ret:AddDamage(dummy_damage)

	if Board:IsPawnSpace(p2) and Board:IsPawnTeam(p2, TEAM_PLAYER) then
		ret:AddDamage(SpaceDamage(p2,self.Healing))
	end

	ret:AddDelay(0.2)
	
	local final_damage = self.Damage
	
	local damage = SpaceDamage(p3, final_damage, direction)
	damage.sAnimation = "explopunch1_"..direction
	damage.sSound = self.AttackSound
	ret:AddMelee(p2, damage)
	return ret
end

Recovery_Shot_A = Recovery_Shot:new{
		Damage = 0, Healing = -10,
		--[[TipImage = {
			Unit = Point(2,3),
			Target = Point(2,1),
			Building = Point(2,1),
			Enemy = Point(3,1),
			Second_Click = Point(3,1),
		},]]--
}
Recovery_Shot_B = Recovery_Shot:new{
		Damage = 2, Healing = -1,
}
Recovery_Shot_AB = Recovery_Shot:new{
		Damage = 2, Healing = -10,
		--[[TipImage = {
			Unit = Point(2,3),
			Target = Point(2,1),
			Building = Point(2,1),
			Enemy = Point(3,1),
			Second_Click = Point(3,1),
		},]]--
}
