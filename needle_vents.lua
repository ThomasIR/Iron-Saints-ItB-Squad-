local wt2 = {
  Needle_Vents_Upgrade1 = "Buildings Immune",
  Needle_Vents_Upgrade2 = "Gain Shield",
}
for k,v in pairs(wt2) do Weapon_Texts[k] = v end

----- NEEDLE VENTS -----
Needle_Vents = Skill:new{
    Class = "Prime",
    Damage = 2,
	BuildingDamage = true,
	Shield = false,
    PowerCost = 0,
    Icon = "weapons/prime_needle_vents.png",
	Explosion = "ExploAir2",
    LaunchSound = "/weapons/ice_throw",
    Upgrades = 2,
    UpgradeCost = { 1,2 },
	TipImage = {
		Unit = Point(2,2),
		Enemy = Point(2,1),
		Enemy2 = Point(1,2),
		Building = Point(1,3),
		Building2 = Point(3,2),
		Target = Point(2,2),
		Queued = Point(2,2),
		Queued2 = Point(1,3),
		--CustomEnemy = "Firefly2",
		Length = 4,
	}
}

function Needle_Vents:GetTargetArea(p1)
	local ret = PointList()
	ret:push_back(p1)

	for dir = DIR_START, DIR_END do
		local point = p1 + DIR_VECTORS[dir]
		ret:push_back(point)
	end
	
	return ret
end
		
function Needle_Vents:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	p2 = p1
	
	local damage = SpaceDamage(p2)
	ret:AddDamage(damage)
	
	for dir = DIR_START, DIR_END do
		local p3 = p2 + DIR_VECTORS[dir]
		if Board:IsValid(p3) then	
			local damage2 = SpaceDamage(p3)
			damage2.iDamage = self.Damage

			if Board:IsPawnTeam(p3, TEAM_ENEMY) and Board:GetPawn(p3):IsQueued() then
				local threat = Board:GetPawn(p3):GetQueuedTarget()
				local newthreat = threat

				local queuedWeaponName = Board:GetPawn(p3):GetQueuedWeapon()
				local queuedWeapon = _G[queuedWeaponName]
				local targetArea = queuedWeapon:GetTargetArea(Board:GetPawn(p3):GetSpace())
				--LOG("GetTargetArea", "\ncurrent Pawn = ", Board:GetPawn(p3))
				for _, point in pairs(extract_table(targetArea)) do 
					if (GetDirection(p3 - p2) == GetDirection(p3 - point) and p3:Manhattan(threat) == p3:Manhattan(point)) then
						--LOG("\np = ", point:GetString(), "\nPawn at p = ", Board:GetPawn(point))
						newthreat = point
					end
				end

				if GetDirection(p3 - p2) ~= GetDirection(p3 - newthreat) and p3 ~= newthreat then
					ret:AddScript("Board:GetPawn("..p3:GetString().."):ClearQueued()")
					ret:AddScript("Board:AddAlert("..p3:GetString()..",\"ATTACK CANCELLED\")")
				end

				if threat ~= newthreat then
					ret:AddScript("Board:GetPawn("..p3:GetString().."):SetQueuedTarget("..newthreat:GetString()..")")

					if Board:IsValid(newthreat) then
						ret:AddScript("Board:AddAlert("..p3:GetString()..",\"ATTACK CHANGED\")")
					end

					if not Board:IsValid(newthreat) then
						ret:AddScript("Board:AddAlert("..p3:GetString()..",\"ATTACK CANCELLED\")")
					end
				end
			end

			if Board:GetSize() == Point(6,6) and Board:IsPawnTeam(p3, TEAM_ENEMY) and p3 == Point(1,2) then
				ret:AddScript("Board:GetPawn("..p3:GetString().."):SetQueuedTarget("..p2:GetString()..")")
				ret:AddScript("Board:AddAlert("..p3:GetString()..",\"ATTACK CHANGED\")")
			end
			
			if not self.BuildingDamage and Board:IsBuilding(p3) then
				damage2.iDamage = 0
			end
			
			damage.sSound = "/impact/generic/explosion"
			damage.sAnimation = "explohornet_"..dir
			ret:AddDamage(damage2)			
		end
	end
	
	if self.Shield then
		local shield = SpaceDamage(p1,0)
		shield.iShield = 1
		shield.bHide = true
		ret:AddDamage(shield)
	end
    
    return ret

end

Needle_Vents_A = Needle_Vents:new{ BuildingDamage = false, Shield = false, UpgradeDescription = "This attack will no longer damage Grid Buildings." }
Needle_Vents_B = Needle_Vents:new{ BuildingDamage = true, Shield = true, UpgradeDescription = "Gain a Shield when attacking.", }
Needle_Vents_AB = Needle_Vents:new{ BuildingDamage = false, Shield = true }
