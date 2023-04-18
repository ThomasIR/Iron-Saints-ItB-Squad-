local function init(self)
    require(self.scriptPath.."FURL")(self, {
    {
        Type = "mech",
        Name = "MechMartyr",
        Filename = "mech_martyr",
        Path = "img/units/player",
        ResourcePath = "units/player",

        Default =           { PosX = -17, PosY = -8 },
        Animated =          { PosX = -17, PosY = -8, NumFrames = 4 },
        Submerged =         { PosX = -17, PosY = 3 },
        Broken =            { PosX = -17, PosY = -6 },
        SubmergedBroken =   { PosX = -17, PosY = 5 },
        Icon =              {},
    },
    {
        Type = "mech",
        Name = "MechHalo",
        Filename = "mech_halo",
        Path = "img/units/player",
        ResourcePath = "units/player",

        Default =           { PosX = -21, PosY = -6 },
        Animated =          { PosX = -21, PosY = -6, NumFrames = 4 },
        Submerged =         { PosX = -21, PosY = -3 },
        Broken =            { PosX = -21, PosY = -6 },
        SubmergedBroken =   { PosX = -21, PosY = -3 },
        Icon =              {},
    },
    {
        Type = "mech",
        Name = "MechSalve",
        Filename = "mech_repair",
        Path = "img/units/player",
        ResourcePath = "units/player",

        Default =           { PosX = -27, PosY = -6 },
        Animated =          { PosX = -27, PosY = -6, NumFrames = 4 },
        Submerged =         { PosX = -27, PosY = -6 },
        Broken =            { PosX = -27, PosY = -2 },
        SubmergedBroken =   { PosX = -27, PosY = -1 },
        Icon =              {},
    },
    {
    		Type = "color",
    		Name = "IronSaints",
    		PawnLocation = self.scriptPath.."pawns",

    		PlateHighlight = {235,255,245},
    		PlateLight = {157,214,184},
    		PlateMid = {141,45,62},
    		PlateDark = {57,29,40},
    		PlateOutline = {15,22,16},
    		PlateShadow = {34,36,34},
    		BodyColor = {66,91,96},
    		BodyHighlight = {90,140,150},
    },
    {
        Type = "base",
        Filename = "prime_needle_vents",
        Path = "img/weapons",
        ResourcePath = "weapons",
    },
    {
        Type = "base",
        Filename = "brute_magnetic_pulse",
        Path = "img/weapons",
        ResourcePath = "weapons",
    },
    {
        Type = "base",
        Filename = "science_recovery_shot",
        Path = "img/weapons",
        ResourcePath = "weapons",
    },
    {
        Type = "base",
        Filename = "passive_force_reflector",
        Path = "img/weapons",
        ResourcePath = "weapons",
    },
});

require(self.scriptPath.."pawns")
require(self.scriptPath.."weapons/needle_vents")
require(self.scriptPath.."weapons/magnetic_pulse")
require(self.scriptPath.."weapons/recovery_shot")
require(self.scriptPath.."weapons/force_reflector")
modApi:addWeapon_Texts(require(self.scriptPath.."weapon_texts"))

end

local function load(self,options,version)
  modApi:addSquadTrue({"Iron Saints","MartyrMech","HaloMech","SalveMech"},"Iron Saints","From a timeline dominated by an austere theocracy, these Mechs will suffer any amount of punishment to eliminate the Vek.",self.resourcePath.."/squad.png")
end

return {
    id = "Iron Saints",
    name = "Iron Saints",
    icon = "/squad.png",
    version = "1.0",
    init = init,
    load = load
}
