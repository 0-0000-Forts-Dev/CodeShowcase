-- StructureBombPlacement: Explosive Barrel Spawner(once each shot)
local SBP_EBS = {
	SaveName = "SBP_EBS",
	FileName = path.."/projects/StructureBombPlacement/weapon.lua",

	-- As same as the cannon(no skirmish)
	Icon = "hud-cannon-icon",
	GroupButton = "hud-group-cannon",
	Detail = "hud-detail-cannon",
	Prerequisite = "factory",
	BuildTimeComplete = 110.0,
	ScrapPeriod = 8,
	MetalCost = 900,
	EnergyCost = 5000,
	MetalRepairCost = 150,
	EnergyRepairCost = 3000,
	MaxSpotterAssistance = 1,
	MaxUpAngle = StandardMaxUpAngle,
	BuildOnGroundOnly = false,
	SelectEffect = "ui/hud/weapons/ui_weapons",
	ObserverBuildEvent = true,
},
-- 神秘 Forts?
#Weapons;
table.insert(Weapons, SBP_EBS)
-- StructureBombPlacement: Explosive Barrel Filler(fill all the structure)
table.insert(Weapons, InheritType(SBP_EBS, nil, {
	SaveName = "SBP_EBF",
}))
