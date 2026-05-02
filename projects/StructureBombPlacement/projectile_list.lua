-- StructureBombPlacement: Explosive Barrel Spawner(once each shot)
local SBP_EBS = {
	SaveName = "SBP_EBS",
	ProjectileDamage = 0,

	-- As same as the cannon
	ProjectileType = "mortar",
	ProjectileSprite = "weapons/media/bullet",
	ProjectileSpriteMipMap = false,
	DrawBlurredProjectile = true,
	ProjectileMass = 16,
	ProjectileDrag = 0,
	Impact = 20000,
	DestroyShields = true,
	DeflectedByShields = false,
	PassesThroughMaterials = false,
	ExplodeOnTouch = false,
	ProjectileThickness = 10.0,
	ProjectileShootDownRadius = 60,
	BeamTileRate = 0.02,
	BeamScrollRate = 0.0,
	ProjectileSplashDamage = 30.0,
	ProjectileSplashDamageMaxRadius = 200.0,
	ProjectileSplashMaxForce = 10000,
	SpeedIndicatorFactor = 0.25,
	TrailEffect = "effects/cannon_trail.lua",
	Effects = {
		Impact = {
			["device"] = "effects/impact_heavy.lua",
			["foundations"] = "effects/impact_heavy_ground.lua",
			["rocks01"] = "effects/impact_heavy_ground.lua",
			["bracing"] = "effects/impact_heavy.lua",
			["armour"] = "effects/impact_heavy.lua",
			["door"] = "effects/impact_heavy.lua",
			["default"] = "effects/impact_heavy.lua",
		},
		Deflect = {
			["armour"] = "effects/armor_ricochet.lua",
			["door"] = "effects/armor_ricochet.lua",
			["shield"] = "effects/energy_shield_ricochet.lua",
		},
	},
	MomentumThreshold = {
		["armour"] = {Reflect = 0, Penetrate = 4000},
		["door"] = {Reflect = 0, Penetrate = 4000},
	},
}
table.insert(Projectiles, SBP_EBS)
-- StructureBombPlacement: Explosive Barrel Filler(fill all the structure)
table.insert(Projectiles, InheritType(SBP_EBS, nil, {
	SaveName = "SBP_EBF",
	ProjectileDamage = 0,
}))
