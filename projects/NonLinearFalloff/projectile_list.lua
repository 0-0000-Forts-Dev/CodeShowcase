--[[
Transform a custom non-linear falloff to several linear falloff
@cnt: the number of the linear falloff used to fit the custom falloff
@radius: can be a table or a positive number
	table: an "increasing" table indexed from 1 to cnt. Each index will be accessed once.
		Each element should represents the max radius each linear falloff has.
	number: It will regard max radius to be an arithmetic sequence a with a[0]=0, a[cnt]=radius
@func(x): the custom falloff function, should return the actual value at a distance of x from the centre
	radius[n-1],radius[n-2],...,radius[1],0 will be passed to func, each once.
@return: a table with the centre value each linear falloff has
Suggested: Assign more precision at the part where func(x) changes sharply.
Suggested: Don't let the relative difference between two radius too small.
Note: If func is a positive function and its falloff rate never decreases, the result will have no negatives.
]]
function CustomFalloff(cnt, radius, func)
	local step = type(radius)=="number" and radius/cnt or nil
	local prev, curr = (step and step*cnt or radius[cnt])
	local res = {}
	local slope_sum, prev_y = 0, 0
	for i = cnt, 1, -1 do
		curr = prev
		prev = i==1 and 0 or (step and step*(i-1) or radius[i-1])
		local y = func(prev)
		local intercept = (y-prev_y-slope_sum*(curr-prev))/(1-prev/curr)
		res[i] = intercept
		slope_sum = slope_sum + intercept/curr
		prev_y = y
	end
	return res
end
-- example usage
--[[
-- Quadratic Falloff: Centre 1000, Max Radius 800
CustomFalloff(39, 800, function(x) return (800-x)*(800-x)/640 end)
-- Exponential Falloff: Centre 524288, decrease 50% by 100 distance
CustomFalloff(79, 1900, function(x) return 2^((1900-x)/100) end)
-- Square Wave: ......
local swr = {}
for i=1, 30 do
	table.insert(swr, i*200-2)
	table.insert(swr, i*200-1)
	table.insert(swr, i*200+1)
	table.insert(swr, i*200+2)
end
CustomFalloff(120, swr, function(x) return x%400<200 and 1e6 or -1e6 end)
]]

--[[
Add a series of splash projectile to Projectiles to fit a custom damage/force falloff.
They are expected to trigger at on tick.
@base: the SaveName of the basic projectile.
	You can spawn it in Effects so the splash fully works.
@name_func(i): can be a function or a string
	function: the SaveName spawner function.
		Receives a positve interger and returns the unique SaveName of i-th splash projectile
		1,2,3,...,n will be passed to it, each once.
	string: will use $it$..i to replace the function
@cnt: the number of the splash projectiles used to fit the custom falloff
	don't make it too huge, as the trigger delay might be too long
@radius: can be a table or a positive number
	table: an "increasing" table indexed from 1 to cnt. Each index will be accessed once.
		Each element should represents the max radius each projectile has.
	number: It will regard max radius to be an arithmetic sequence a with a[0]=0, a[cnt]=radius
@damage(x): a custom SplashDamage falloff function that return the damage at a distance of x from the centre
	radius[n-1],radius[n-2],...,radius[1],0 will be passed to it, each once.
@force(x): like damage(x), but represents the SplashForce.
@return: whether all the values are as good(no limit overflow, no negative splash damage)

Suggested: Don't let the relative difference between two radius too small. It can lead overflow values.
Waring: Behaves bad for falloffs whose falloff rate isn't always decreases. That's Forts itself charged.
]]
function CreateCustomFalloffProjectile(base, name_func, cnt, radius, damage, force)
	if type(name_func)=="string" then
		local prefix = name_func
		name_func = function(i)
			return prefix..i
		end
	end
	local step = type(radius)=="number" and radius/cnt or nil
	local names = {}
	for i = 1, cnt do names[i] = name_func(i) end
	local result = true

	-- The base projectile that spawns all the splash projectiles by Age
	local base_proj = {
		SaveName = base,
		ProjectileType = "mortar",
		CollidesWithProjectiles = false,
		CollidesWithBeams = false,
		CollidesWithStructure = false,
		Gravity = 0,
		Effects = {Age = {}},
	}
	projs = {}

	if type(damage)=="function" then
		damage = CustomFalloff(cnt, radius, damage)
		for i = 1, cnt do
			-- Overflow damage can directly destroy links and prevent it from "heal"
			-- And overflow "heal" will have no effects, so the damage is expected to be positve
			-- |ProjectileSplashDamage| is limited to 1e6 in Forts, otherwise truncate it
			if damage[i]<0 or damage[i]>1e6 then return false end
		end
	else damage = nil end
	if type(force)=="function" then
		force = CustomFalloff(cnt, radius, force)
		for i = 1, cnt do
			-- Forces applied in one tick will superpose
			-- |ProjectileSplashMaxForce| is limited to 1e12 in Forts, otherwise truncate it
			if force[i]<-1e12 or force[i]>1e12 then result = false end
		end
	else force = nil end
	local ticks = math.floor((cnt-1)/40)
	for i = 1, cnt do
		projs[i] = {
			SaveName = names[i],
			ProjectileType = "mortar",
			CollidesWithProjectiles = false,
			CollidesWithBeams = false,
			CollidesWithStructure = false,
			-- Note the SplashForce apply only with SplashDamage~=0
			ProjectileSplashDamage = damage and damage[i] or -FLT_MIN,
			ProjectileSplashDamageMaxRadius = (step and step*i or radius[i]),
			ProjectileSplashMaxForce = force and force[i] or 0,
			Gravity = 0,
			-- To ensure that they trigger at the same tick
			Effects = {Age = {['t'..1+(ticks-math.floor((i-1)/40))*40]={Terminate=true}},},
		}
		-- It seems to have problem with t1~t40
		-- If the base projectile is spawned by Age, t1~t40 works as wonders
		-- But you can't ensure that, so increase it by 40
		base_proj.Effects.Age['t'..i+41] = {
			Projectile = {
				Count = 1,
				Type = names[i],
				Speed = FLT_MIN,
				StdDev = 0
			},
			Offset = 0,
			Terminate = false,
		}
	end
	base_proj.Effects.Age['t'..cnt+41].Terminate = true

	table.insert(Projectiles, base_proj)
	for i = 1, cnt do
		table.insert(Projectiles, projs[i])
	end
	return result
end

-- Exponential Falloff: Centre 8192, decrease 50% by 150 distance, but wholly -1
CreateCustomFalloffProjectile("NLF_EFS_base", "NLF_EFS_", 79, 1950, function(x)
	return 2^(13-x/150)-1
end, nil)
local NLF_EFSMissile = {
	SaveName = "NLF_EFSMissile",
	ProjectileDamage = 0,
	ProjectileSplashDamage = -FLT_MIN,
	ProjectileSplashDamageMaxRadius = FLT_MIN,
	ProjectileSplashMaxForce = 0,
	Effects = {
		Impact = {
			["antiair"] = "effects/missile_structure_hit.lua",
			["default"] = {
				Effect = "effects/mushroom_cloud.lua",
				Projectile = {
					-- spawn the base's SaveName you give
					Type = "NLF_EFS_base",
					Speed = FLT_MIN,
					Count = 1,
				},
				Terminate = true,
				Offset = 0,
			},
		},
	},

	---
	-- As same as the missile2
	ProjectileType = "missile",
	DrawBlurredProjectile = false,
	ProjectileMass = 5.0,
	ProjectileDrag = 64,
	DisableShields = true,
	DeflectedByShields = false,
	ExplodeOnTouch = true,
	ProjectileThickness = 2.0,
	ProjectileShootDownRadius = 6,
	Impact = 120000,
	BeamTileRate = 0.02,
	BeamScrollRate = 0.0,
	SpeedIndicatorFactor = 0.05,
	MaxAge = 60,
	EMPSensitivity = 4,
	EMPMissileProbabilityOfCircling = 0.25,
	FlipSpriteFacingLeft = true,
	Projectile = {
		Root = {
			Name = "Root",
			Angle = 0,
			Sprite = "warhead",
			Pivot = {0, 0.35},
			ChildrenInFront = {
				{
					Name = "Flame",
					Angle = 0,
					Offset = {0, 0.5},
					Pivot = {0, 0.1 },
					PivotOffset = {0, 0},
					Sprite = "missile_tail",
				},
			},
		}
	},
	TrailEffect = "effects/missile_trail.lua",
	Missile = {
		ThrustAngleExtent = 25,
		ErraticAngleExtentStdDev = 2.5,
		ErraticAngleExtentMax = 5,
		MaxSteerPerSecond = 150,
		MaxSteerPerSecondErratic = 250,
		ErraticAnglePeriodMean = 0.5,
		ErraticAnglePeriodStdDev = 0.1,
		ErraticThrust = 0.5,
		ErraticThrustMagneticField = 0.7,
		LaunchThrust = 105000,
		RocketThrust = 115000,
		CruiseTargetDistance = 2000,
		CruiseTargetDuration = .5,
		TargetRearOffsetDistance = 100000,
		MinTargetUpdateDistance = 2000,
		DecoyFramesToRedirect = 2,
	},
}
table.insert(Projectiles, NLF_EFSMissile)

-- Linear Falloff*Cos Wave Impact: Peak 8e5, Period 800
CreateCustomFalloffProjectile("NLF_LCI_base", "NLF_LCI_", 120, 2800, nil, function(x)
	return math.cos((2*math.pi/800)*x)*8e5*(1-x/2800)
end)
local NLF_SWIMissile = InheritType(NLF_EFSMissile, function(t)
	t.Effects.Impact["default"].Projectile.Type = "NLF_LCI_base"
end, {
	SaveName = "NLF_LCIMissile",
})
table.insert(Projectiles, NLF_SWIMissile)
