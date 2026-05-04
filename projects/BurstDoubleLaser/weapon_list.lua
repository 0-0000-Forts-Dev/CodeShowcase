-- Burst Double Laser
local BDL = {
	SaveName = "BDL",
	FileName = path.."/projects/BurstDoubleLaser/weapon.lua",

	-- As same as the beamlaser(no skirmish)
	Icon = "hud-beamlaser-icon",
	GroupButton = "hud-group-laser",
	Detail = "hud-detail-laser",
	Prerequisite = "factory",
	BuildTimeComplete = 120,
	ScrapPeriod = 8,
	MetalCost = 1000,
	EnergyCost = 6000,
	MetalRepairCost = 100,
	EnergyRepairCost = 4000,
	MaxSpotterAssistance = 0.5,
	MaxUpAngle = StandardMaxUpAngle,
	BuildOnGroundOnly = false,
	SelectEffect = "ui/hud/weapons/ui_weapons",
	ObserverBuildEvent = true,
}

table.insert(Weapons, BDL)
