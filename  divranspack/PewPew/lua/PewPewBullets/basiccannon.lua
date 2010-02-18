-- Basic Cannon

local BULLET = {}

-- General Information
BULLET.Name = "Basic Cannon"
BULLET.Category = "Cannons"
BULLET.Author = "Divran"
BULLET.Description = "Aim away from face."
BULLET.AdminOnly = false
BULLET.SuperAdminOnly = false

-- Appearance
BULLET.Model = "models/combatmodels/tankshell.mdl"
BULLET.Material = nil
BULLET.Color = nil
BULLET.Trail = nil

-- Effects / Sounds
BULLET.FireSound = {"arty/37mm.wav"}
BULLET.ExplosionSound = {"weapons/explode1.wav","weapons/explode2.wav"}
BULLET.FireEffect = "cannon_flare"
BULLET.ExplosionEffect = "big_splosion"

-- Movement
BULLET.Speed = 50
BULLET.PitchChange = 0.2
BULLET.RecoilForce = 500
BULLET.Spread = 0

-- Damage
BULLET.DamageType = "BlastDamage" -- Look in gcombat_damagecontrol.lua for available damage types
BULLET.Damage = 400
BULLET.Radius = 800
BULLET.RangeDamageMul = 0.3
BULLET.NumberOfSlices = nil
BULLET.SliceDistance = nil
BULLET.PlayerDamage = 150
BULLET.PlayerDamageRadius = 300

-- Reloading/Ammo
BULLET.Reloadtime = 3.5
BULLET.Ammo = 0
BULLET.AmmoReloadtime = 0

pewpew:AddBullet( BULLET )