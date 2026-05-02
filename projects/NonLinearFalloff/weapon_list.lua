-- NonLinearFalloff: Exponential Falloff Splash
local NLF_EFS = {
	SaveName = "NLF_EFS",
	FileName = path.."/projects/NonLinearFalloff/weapon.lua",

	-- As same as the missile, without the inverted version
	Icon = "hud-missile-icon",
	GroupButton = "hud-group-missile",
	Detail = "hud-detail-missile",
	AnimationScript = "weapons/missilelauncher_anim.lua",
	Prerequisite = "upgrade",
	BuildTimeComplete = 65.0,
	ScrapPeriod = 8,
	MetalCost = 900,
	EnergyCost = 4500,
	MetalRepairCost = 80,
	EnergyRepairCost = 1250,
	SpotterFactor = 0.0, -- can't spot for itself (need a sniper with LOS)
	MaxSpotterAssistance = 0,
	MaxUpAngle = 45,
	BuildOnGroundOnly = true,
	AlignToCursorNormal = false,
	RequiresSpotterToFire = true,
	SelectEffect = "ui/hud/weapons/ui_weapons",
}
table.insert(Weapons, NLF_EFS)
-- NonLinearFalloff: Linear falloff*Cos wave Impact
table.insert(Weapons, InheritType(NLF_EFS, nil, {
	SaveName = "NLF_LCI",
}))
