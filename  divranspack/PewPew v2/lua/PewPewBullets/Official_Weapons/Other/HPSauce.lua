-- Basic Cannon

local BULLET = {}

-- Important Information
BULLET.Version = 2

-- General Information
BULLET.Name = "HP Sauce"
BULLET.Author = "Divran"
BULLET.Description = "HP Sauce"
BULLET.AdminOnly = false
BULLET.SuperAdminOnly = false

-- Appearance
BULLET.Model = "models/weapons/w_bugbait.mdl" 
BULLET.Material = nil
BULLET.Color = Color(255,255,255,0)
BULLET.Trail = nil

-- Effects / Sounds
BULLET.FireSound = {"ambient/water/water_spray1.wav", "ambient/water/water_spray2.wav", "ambient/water/water_spray3.wav"}
BULLET.ExplosionSound = {"ambient/water/water_splash1.wav", "ambient/water/water_splash2.wav", "ambient/water/water_splash3.wav"}
BULLET.FireEffect = nil
BULLET.ExplosionEffect = nil
BULLET.EmptyMagSound = nil

-- Movement
BULLET.Speed = 45
--BULLET.Gravity = 0.7
BULLET.RecoilForce = 0.1
BULLET.Spread = 3

-- Damage
BULLET.DamageType = "BlastDamage"
BULLET.Damage = 100
BULLET.Radius = 80
BULLET.RangeDamageMul = 2.4
BULLET.NumberOfSlices = nil
BULLET.SliceDistance = nil
BULLET.Duration = nil
BULLET.PlayerDamage = 40
BULLET.PlayerDamageRadius = 50

-- Reloading/Ammo
BULLET.Reloadtime = 0.1
BULLET.Ammo = 0
BULLET.AmmoReloadtime = 0

BULLET.EnergyPerShot = 100

function BULLET:CLInitialize()
	self.emitter = ParticleEmitter( Vector(0,0,0) )
end

function BULLET:CLThink()
	local Pos = self.Entity:GetPos()
	local effectdata = EffectData()
		effectdata:SetOrigin( Pos )
		effectdata:SetNormal( self.Entity:GetUp() )
		effectdata:SetRadius( 10 )
		effectdata:SetScale( 5 )
	util.Effect( "watersplash", effectdata )
end

pewpew:AddWeapon( BULLET )