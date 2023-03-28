MartyrMech = {
	Name = "Martyr Mech",
	Class = "Prime",
	Health = 4,
	MoveSpeed = 4,
	Image = "MechMartyr",
	ImageOffset = FURL_COLORS.IronSaints,
	SkillList = { "Needle_Vents" },
	SoundLocation = "/mech/prime/punch_mech/",
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	Massive = true
}
AddPawn("MartyrMech")

HaloMech = {
	Name = "Halo Mech",
	Class = "Brute",
	Health = 3,
	MoveSpeed = 3,
	Image = "MechHalo",
	ImageOffset = FURL_COLORS.IronSaints,
	SkillList = { "Magnetic_Pulse", "Passive_Force_Reflector" },
	SoundLocation = "/mech/brute/tank/",
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	Massive = true
}
AddPawn("HaloMech")

SalveMech = {
	Name = "Salve Mech",
	Class = "Science",
	Health = 2,
	MoveSpeed = 3,
	Image = "MechSalve",
	ImageOffset = FURL_COLORS.IronSaints,
	SkillList = { "Recovery_Shot" },
	SoundLocation = "/mech/science/science_mech/",
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	Massive = true,
	Flying = true
}
AddPawn("SalveMech")
