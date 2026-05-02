-- StructureBombPlacement: Explosive Barrel
table.insert(Devices, {
	SaveName = "SBP_EB",
	FileName = path.."/projects/StructureBombPlacement/device.lua",
	BuildTimeComplete = 0,
	ScrapPeriod = 10,
	MetalCost = 0,
	EnergyCost = 0,
	NoReclaim = false,

	-- As same as the barrel
	Icon = "hud-explosivebarrel-icon",
	Detail = "hud-detail-explosivebarrel",
	Enabled = false,
	MetalRepairCost = 10,
	EnergyRepairCost = 10,
	MaxUpAngle = StandardMaxUpAngle,
	BuildOnGroundOnly = false,
	CanMove = false,
	SelectEffect = "ui/hud/devices/ui_devices",
})
