-- Laser Damage Scaler: Amplifier
local LDS_A = {
	SaveName = "LDS_A",
	FileName = path.."/projects/LaserDamageScaler/weapon.lua",
	-- Don't let a 1:1 locating weapon to have it non-zero!
	MaxSpotterAssistance = 0,

	-- As same as the machinegun
	Icon = "hud-machinegun-icon",
	GroupButton = "hud-group-machinegun",
	Detail = "hud-detail-machinegun",
	BuildTimeComplete = 15.0,
	ScrapPeriod = 5,
	MetalCost = 75,
	EnergyCost = 250,
	MetalRepairCost = 7.5,
	EnergyRepairCost = 225,
	BuildOnGroundOnly = false,
	FireGroupWhenDoorBlocks = true,
	MaxUpAngle = StandardMaxUpAngle,
	SelectEffect = "ui/hud/weapons/ui_weapons",
}
if dlc1Var_Active then
	table.insert(Weapons, LDS_A)
	-- Laser Damage Scaler: Damper
	table.insert(Weapons, InheritType(LDS_A, nil, {
		SaveName = "LDS_D",
	}))
end
