local wt2 = {
	Magnetic_Pulse_Upgrade1 = "Shield Allies",
	Magnetic_Pulse_Upgrade2 = "+1 Damage" ,
}
for k,v in pairs(wt2) do Weapon_Texts[k] = v end

----- MAGNETIC PULSE -----
Magnetic_Pulse = TankDefault:new{
	Class = "Brute",
  name = "Magnetic Pulse",
	Damage = 0,
    BackShot = 1,
    Push = 1,
	ShieldAlly = 0,
	PowerCost = 0,
	LaunchSound = "/weapons/enhanced_tractor",
	ImpactSound = "/impact/generic/tractor_beam",
	Icon = "weapons/brute_magnetic_pulse.png",
	Upgrades = 2,
	UpgradeCost = { 1,2 },
	ZoneTargeting = ZONE_DIR,
  TipImage = {
	Unit = Point(2,2),
	Enemy = Point(1,2),
	Friendly = Point(4,2),
	Target = Point(1,2)
  }
}

function Magnetic_Pulse:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)
			
	local target = GetProjectileEnd(p1,p2)

	local dummy_damage = SpaceDamage(p1,0)
	dummy_damage.sAnimation = "ExploRepulseSmall"
	ret:AddDamage(dummy_damage)
	
	local damage = SpaceDamage(target, self.Damage, GetDirection(p1 - p2))
	if Board:IsPawnTeam(target, TEAM_PLAYER) then
		damage.iDamage = 0
		local shielddamage = SpaceDamage(target,0)
		shielddamage.iShield = self.ShieldAlly
		ret:AddDamage(shielddamage)
	end
	--ret.path = Board:GetSimplePath(p1, target)
	ret:AddProjectile(damage,"effects/shot_pull", NO_DELAY)
		
	if self.BackShot == 1 then
		local backdir = GetDirection(p1 - p2)
		local target2 = GetProjectileEnd(p1,p1 + DIR_VECTORS[backdir])

		if target2 ~= p1 then
			damage = SpaceDamage(target2, self.Damage, GetDirection(p2 - p1))
				
			if Board:IsPawnTeam(target2, TEAM_PLAYER) then
				damage.iDamage = 0
				local shielddamage = SpaceDamage(target2,0)
				shielddamage.iShield = self.ShieldAlly
				ret:AddDamage(shielddamage)
			end
		
			damage.sAnimation = self.Explo..GetDirection(p2 - p1)
			ret:AddProjectile(damage,self.ProjectileArt)
		end
	end
	
	local temp = p1 
	while temp ~= target  do 
		ret:AddDelay(0.05)
		ret:AddBounce(temp,-1)
		temp = temp + DIR_VECTORS[direction]
	end

	return ret
end

Magnetic_Pulse_A = Magnetic_Pulse:new{ShieldAlly = 1, Damage = 0, UpgradeDescription = "If used on an ally unit it gives them a Shield.",}
Magnetic_Pulse_B = Magnetic_Pulse:new{ShieldAlly = 0, Damage = 1, UpgradeDescription = "Increases damage to enemy units by 1.",}
Magnetic_Pulse_AB = Magnetic_Pulse:new{ShieldAlly = 1, Damage = 1}
