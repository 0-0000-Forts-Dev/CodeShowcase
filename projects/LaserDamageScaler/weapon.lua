dofile("weapons/machinegun.lua")
Sprites = {}

if SaveName == "LDS_A" then
	Projectile = "LDS_A_transport"
elseif SaveName == "LDS_D" then
	Projectile = "LDS_D_transport"
end


RoundsEachBurst = 1
-- To trigger the transport projectile at the specified position
-- Just make sure that speed*time=1.75*radius, ex 0.07*1e5=1.75*4000
TriggerProjectileAgeAction = true
MinFireRadius = 320
MaxFireRadius = 4000
MinFireSpeed = 1e5
MaxFireSpeed = 1e5
MinAgeTrigger = 0.0056
MaxAgeTrigger = 0.07

-- No fire block
BarrelLength = 0
MinFireClearance = 0
FireClearanceOffsetInner = 0
FireClearanceOffsetOuter = 0

-- No fire angle limits
MinFireAngle = -180
MaxFireAngle = 180
ShowFireAngle = false

-- No instability
KickbackMean = 0
KickbackStdDev = 0
PanDuration = 0
FireStdDev = 0
FireStdDevAuto = 0
Recoil = 0
