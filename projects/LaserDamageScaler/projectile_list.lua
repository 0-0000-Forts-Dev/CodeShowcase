-- A: Amplify the beam damage
-- D: Dampen the beam damage

-- The projectile that the weapon fires to stop at the specified position and create the scaler projectile
local LDS_A_transport = {
	SaveName = "LDS_A_transport",
	ProjectileType = "mortar",
	Gravity = 0,
	CollidesWithProjectiles = false,
	CollidesWithBeams = false,
	CollidesWithStructure = false,
    ProjectileDamage = 0,
	Effects = {
		Age = {
			-- the actual trigger time in Age doesn't matter, that in weapon matters.
			t10000 = {
				Projectile = {
					Type = "LDS_A_base",
					-- extremely small velocity but not 0, so the scaler projectile can be motionless
					Speed = FLT_MIN,
					Count = 1,
				},
				Terminate = true,
				Offset = 0,
			},
		},
	},
}
-- The projectile that stays motionless and scales the beam
local LDS_A_base = {
	SaveName = "LDS_A_base",
	ProjectileType = "mortar",
	Gravity = 0,
	CollidesWithProjectiles = false,
	CollidesWithStructure = false,
    ProjectileDamage = 0,
	MaxAge = 15, -- Let it exists for 15 seconds

	-- Although it doesn't collide with beams, it can still scale the beam.
	-- Note that it might be destroyed by beams, so let it be false.
	--CollidesWithBeams = false,
	FieldType = FIELD_BLOCK_BEAMS, -- FIELD_BLOCK_BEAMS = 4
	-- The actual circle radius that this projectile affects the beam damage.
	FieldRadius = 600,
	Projectile = {
		Root = {
			Name = "Root",
			Angle = 0,
			-- a 75 radius cyan circle
			Sprite = path.."/projects/LaserDamageScaler/LDS_A_base.png",
			Pivot = {0,0},
			Scale = 8, -- radius*Scale = FieldRadius, ex 75*8=600
		}
	},
	DamageMultiplier = {
		--[[
		Let x equals the length of intersection segment of the beam and the FieldRadius circle(>0), c equals the Block multiplier(!=0).
		Then the beam damage is increased by x*(-c)/600 relative to basic damage.
		The max extra multiplier now: (600*2)*0.5/600 = 1.
		That means if a beam passes through the centre of it, it will gain double damage.
		The scale effects can be stacked linearly.
		Note that it has no effects on antiair damage.
		]]
		{SaveName = "default", Block = -0.5},
	},
}
-- The damp version
local LDS_D_transport = {
	SaveName = "LDS_D_transport",
	ProjectileType = "mortar",
	Gravity = 0,
	CollidesWithProjectiles = false,
	CollidesWithBeams = false,
	CollidesWithStructure = false,
    ProjectileDamage = 0,
	Effects = {
		Age = {
			t10000 = {
				Projectile = {
					Type = "LDS_D_base",
					Speed = 1e-12,
					Count = 1,
				},
				Terminate = true,
				Offset = 0,
			},
		},
	},
}
local LDS_D_base = {
	SaveName = "LDS_D_base",
	ProjectileType = "mortar",
	Gravity = 0,
	CollidesWithProjectiles = false,
	CollidesWithStructure = false,
    ProjectileDamage = 0,
	MaxAge = 20, -- Let it exists for 20 seconds

	CollidesWithBeams = false,
	FieldType = FIELD_BLOCK_BEAMS,
	FieldRadius = 300,
	Projectile = {
		Root = {
			Name = "Root",
			Angle = 0,
			-- a 75 radius red circle
			Sprite = path.."/projects/LaserDamageScaler/LDS_D_base.png",
			Pivot = {0,0},
			Scale = 4, -- 75*4=300
		}
	},
	DamageMultiplier = {
		--[[
		The max extra multiplier now: (300*2)*(-0.4)/600 = -0.4.
		That means if a beam passes through the centre of it, it will gain half damage.
		The scale effects can be stacked linearly.
		if the total multiplier is less than 1, the brightness of the beam will also be decreased.
		When it reaches 0, the beam fully disapper, although there are amplifier in the extension.
		]]
		{SaveName = "default", Block = 0.4},
	},
}
-- Field active with dlc1
if dlc1Var_Active then
	table.insert(Projectiles, LDS_A_transport)
	table.insert(Projectiles, LDS_A_base)
	table.insert(Projectiles, LDS_D_transport)
	table.insert(Projectiles, LDS_D_base)
end
