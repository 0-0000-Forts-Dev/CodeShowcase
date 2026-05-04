dofile("weapons/beamlaser.lua")
Sprites = {}


-- Laser weapon's round vars can do double lasers
-- Achieve double damage without increasing its bracing kill threshold
-- But the latest frame's damage only apply once, not twice
RoundsEachBurst = FrameRate * BeamDuration
RoundPeriod = 1 / FrameRate
-- FrameRate: physic ticks in one second, almost always be 25

-- setting the round vars above, BeamThickness's and BeamDamage's t will be always 0 for the extra laser
-- but ProjectileAngle helps to know how long it has been since it fired
local beamIndex = 0
local _ProjectileAngle = ProjectileAngle
if _ProjectileAngle then
	ProjectileAngle = function(index)
		beamIndex = index
		return _ProjectileAngle(index)
	end
else
	ProjectileAngle = function(index)
		beamIndex = index
	end
end

-- Note that if the functions below are defined in the projectile(who has higher priority):
-- You can't infer the actual t in that function, as ProjectileAngle isn't available
-- You can only secure a suitable still time for that
local _BeamThickness = BeamThickness
if _BeamThickness then
	BeamThickness = function(t)
		-- use ProjectileAngle's index to infer the actual time since fire
		return _BeamThickness((beamIndex-1) / FrameRate)
	end
end
local _BeamDamage = BeamDamage
if _BeamDamage then
	BeamDamage = function(t)
		return _BeamDamage((beamIndex-1) / FrameRate)
	end
end

EnergyFireCost = EnergyFireCost * 2
