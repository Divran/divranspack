-- Basic Cannon

local BULLET = {}

-- General Information
BULLET.Name = "Flamethrower"
BULLET.Category = "CloseCombat" -- This is the weapon Category. This is used in the Weapons Menu to choose weapons more easily.
BULLET.Author = "Divran"
BULLET.Description = "Kill it with fire!"
BULLET.AdminOnly = false
BULLET.SuperAdminOnly = false

-- Appearance
BULLET.Model = "models/weapons/w_bugbait.mdl" 
BULLET.Material = nil
BULLET.Color = Color(255,255,255,0)
BULLET.Trail = nil

-- Effects / Sounds
BULLET.FireSound = {"ambient/fire/mtov_flame2.wav"}
BULLET.ExplosionSound = nil
BULLET.FireEffect = nil
BULLET.ExplosionEffect = nil
BULLET.EmptyMagSound = nil

-- Movement
BULLET.Speed = 35
BULLET.Gravity = 1
BULLET.RecoilForce = 0
BULLET.Spread = 5

-- Damage
BULLET.DamageType = "BlastDamage"
BULLET.Damage = 150
BULLET.Radius = 80
BULLET.RangeDamageMul = 1
BULLET.NumberOfSlices = nil
BULLET.SliceDistance = nil
BULLET.Duration = nil
BULLET.PlayerDamage = 40
BULLET.PlayerDamageRadius = 50

-- Reloading/Ammo
BULLET.Reloadtime = 0.1
BULLET.Ammo = 0
BULLET.AmmoReloadtime = 0

-- Custom Functions 
-- (If you set the override var to true, the cannon/bullet will run these instead. Use these functions to do stuff which is not possible with the above variables)

-- Client side overrides:

BULLET.CLInitializeOverride = true
function BULLET:CLInitializeFunc()
	self.emitter = ParticleEmitter( Vector(0,0,0) )
end

BULLET.CLThinkOverride = true
function BULLET:CLThinkFunc()
	local Pos = self.Entity:GetPos()
	local particle = self.emitter:Add("particles/flamelet" .. math.random(1,5), Pos)
	if (particle) then
		particle:SetVelocity( self.Entity:GetUp() * 30 )
		particle:SetLifeTime(0)
		particle:SetDieTime(1)
		particle:SetStartAlpha(math.random( 200, 255 ) )
		particle:SetEndAlpha(0)
		particle:SetStartSize(math.random(20,60))
		particle:SetEndSize(10)
		particle:SetRoll(math.random(0, 360))
		particle:SetRollDelta(math.random(-10, 10))
		particle:SetColor(255, 255, 255) 
	end
end

pewpew:AddBullet( BULLET )