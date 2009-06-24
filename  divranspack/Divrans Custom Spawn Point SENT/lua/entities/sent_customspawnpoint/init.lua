-------------------------------------------------------------------------------------------------------------------------
-- Custom Spawn Point
-- By Divran
-------------------------------------------------------------------------------------------------------------------------
AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')
include('shared.lua')


function ENT:SpawnFunction(ply, tr)
	if (!tr.Hit) then return end
	local SpawnPos = tr.HitPos + Vector(0,0,5)
	local ent = ents.Create("sent_customspawnpoint")
	ent:SetPos(SpawnPos)
	ent:SetVar("Owner",ply)
	ent:Spawn()
	ent:Activate()
	return ent
end

function ENT:Initialize()
	self.Entity:SetModel("models/props_trainstation/trainstation_clock001.mdl")
	self.Entity:SetMaterial("models/debug/debugwhite")
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)	
	self.Entity:SetSolid(SOLID_VPHYSICS)
	self.Entity:SetUseType(SIMPLE_USE)

	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then phys:Wake() end

	phys:SetAngle(Angle(90,0,0))
	self.Entity:SetColor(255,50,50,200)
	self.Position = Vector()
end

function ENT:Use(activator, caller) -- Use
	if (activator == self.Player) then
		if (activator.SpawnPoint == nil or activator.SpawnPoint != self.Entity) then -- Activate
			activator.SpawnPoint = self.Entity
			local Clr = self.Entity:GetColor()
			self.Entity:SetColor(50,255,50,Clr[4]) -- Set Color
		else -- Deactivate
			activator.SpawnPoint = nil
			local Clr = self.Entity:GetColor()
			self.Entity:SetColor(255,50,50,Clr[4]) -- Set Color
		end
	end
end

local function Spawn(ply)
	if (ply.SpawnPoint and ply.SpawnPoint:IsValid()) then -- If spawn point is on
		ply:SetPos(ply.SpawnPoint:GetPos() + Vector(0,0,20)) -- Teleport player
	end
end
hook.Add("PlayerSpawn", "Spawn", Spawn)

function ENT:Think()
	if (self.Player.SpawnPoint != self.Entity) then
		local Clr = self.Entity:GetColor()
		self.Entity:SetColor(255,50,50,Clr[4])
	end
end
