-- Repair Tool
-- This tool repairs stuff

TOOL.Category = "PewPew"
TOOL.Name = "Repair Tool"
TOOL.ent = {}
						
if (SERVER) then
	AddCSLuaFile("pewpew_repair_tool.lua")
	TOOL.Timer = 0
	
	function TOOL:Think()
		if (CurTime() > self.Timer) then
			local ply = self:GetOwner()
			if (ply:KeyDown( IN_ATTACK )) then
				local trace = ply:GetEyeTrace()
				if (!trace.Hit) then return end
				if (trace.HitPos:Distance(ply:GetShootPos()) < 125 and trace.Entity and pewpew:CheckValid( trace.Entity )) then
					if (trace.Entity:GetClass() == "pewpew_core" and trace.Entity.pewpewCoreHealth) then
						pewpew:RepairCoreHealth( trace.Entity, pewpew.RepairToolHealCores )
					elseif (trace.Entity.pewpewHealth) then
						pewpew:RepairHealth( trace.Entity, pewpew.RepairToolHeal )
					end
					-- Effect
					local effectdata = EffectData()
					effectdata:SetOrigin( trace.HitPos )
					effectdata:SetAngle( trace.HitNormal:Angle() )
					util.Effect( "Sparks", effectdata )
					-- Run slower!
					self.Timer = CurTime() + 0.1
				end
			end
		end
	end
else
	language.Add( "Tool_pewpew_repair_tool_name", "PewPew Repair Tool" )
	language.Add( "Tool_pewpew_repair_tool_desc", "Used to repair entities." )
	language.Add( "Tool_pewpew_repair_tool_0", "Primary: Hold to repair an entity, Reload: Toggle Health Vision." )
	
	TOOL.HealthVision = true
	TOOL.ReloadTimer = 0
	
	function TOOL:Reload()
		if (CurTime() > self.ReloadTimer) then
			self.HealthVision = !self.HealthVision
			if (self.HealthVision == true) then
				self:GetOwner():ChatPrint("Health Vision on.")
			else
				self:GetOwner():ChatPrint("Health Vision off.")
			end
			self.ReloadTimer = CurTime() + 0.2
		end
	end
	
	function TOOL:DrawHUD()
		local ply = self:GetOwner()
		if (!self.HealthVision) then return end
		
		-- Find all nearby entities
		local ents = ents.FindInSphere( ply:GetPos(), 1000 )
		for _, ent in pairs( ents ) do
			if (ent:GetMoveType() == MOVETYPE_VPHYSICS and ent:IsValid()) then
				-- Get the health and maxhealth
				local hp = ent:GetNWInt( "pewpewHealth" )
				local maxhealth = ent:GetNWInt( "pewpewMaxHealth" )
				-- Create vars
				local percent = 100
				local hp2 = "?"
				local maxhealth2 = "?"
				-- Check if valid
				if (hp and hp > 0 and maxhealth and maxhealth > 0) then
					-- Calculate percent
					percent = math.Round(hp / maxhealth * 100)
					hp2 = math.Round(hp)
					maxhealth2 = math.Round(maxhealth)
				end
				-- Create string
				local pos = ent:GetPos():ToScreen()
				local dist = ent:GetPos():Distance(ply:GetShootPos())
				local txt =  percent .. "% (" .. hp2 .. "/" .. maxhealth2 .. ")"
				surface.SetFont("ScoreboardText")
				local length = surface.GetTextSize(txt)
				-- Draw string
				draw.WordBox( 6, pos.x - length / 2, pos.y + 20, txt, "ScoreboardText", Color( 255 * (1-percent/100), 255 * (percent/100), 0, math.Clamp(745-dist,0,255) ), Color( 50, 50, 50, math.Clamp(745-dist,0,255) ) )
			end
		end
	end
end