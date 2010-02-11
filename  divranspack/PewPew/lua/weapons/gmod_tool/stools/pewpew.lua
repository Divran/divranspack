-- PewTool
-- This is the tool used to spawn all PewPew weapons

--TOOL = nil
--TOOL = ToolObj:Create()
TOOL.Category = "Construction"
TOOL.Name = "PewPew"
TOOL.Mode = "pewpew"
TOOL.ent = {}
TOOL.ClientConVar[ "bulletname" ] = ""
TOOL.CannonModel = "models/combatmodels/tank_gun.mdl"

cleanup.Register("pewpew")



if (SERVER) then
	CreateConVar("sbox_maxpewpew", 10)

	
	function TOOL:GetBulletName()
		local ent = self:GetClientInfo("bulletname") or nil
		if (!ent) then return end
		return ent
	end
	
	function TOOL:CreateCannon( trace, bullet )
		self.ent = ents.Create( "pewpew_base_cannon" )
		if (!self.ent:IsValid()) then return end
		self.ent:SetOptions( bullet )
		self.ent:SetModel( self.CannonModel )
		self.ent:SetPos( trace.HitPos + trace.HitNormal * 4 )
		self.ent:SetAngles( trace.HitNormal:Angle() + Angle( 90, 0, 0 ) )
		self.ent:Spawn()
		self.ent:Activate()
	end
	
	function TOOL:LeftClick( trace )
		if (CLIENT) then return true end
		if (!trace) then return end
		local ply = self:GetOwner()
		if (!ply:CheckLimit("pewpew")) then return end
		
		local bullet = pewpew:GetBullet( self:GetBulletName() )
		if (!bullet) then return end
		
		-- If the trace hit an entity
		local traceent = trace.Entity
		if (traceent and traceent:IsValid() and traceent:GetClass() == "pewpew_base_cannon") then
			-- Update it
			traceent:SetOptions( bullet )
			ply:ChatPrint("PewPew Cannon updated with bullet: " .. bullet.Name)
		else
			-- else create a new one
			self:CreateCannon( trace, bullet )
		
			local weld = constraint.Weld( self.ent, trace.Entity, 0, trace.PhysicsBone, 0 )
			local nocollide = constraint.NoCollide( self.ent, trace.Entity, 0, trace.PhysicsBone )
				
			ply:AddCount( "pewpew", self.ent )
			ply:AddCleanup ( "pewpew", self.ent )

			undo.Create( "pewpew" )
				undo.AddEntity( self.ent )
				undo.AddEntity( weld )
				undo.AddEntity( nocollide )
				undo.SetPlayer( ply )
			undo.Finish()
		end
			
		return true
	end
	
	function TOOL:RightClick( trace )
		if (CLIENT) then return true end
		if (!trace) then return end
		local ply = self:GetOwner()
		if (!ply:CheckLimit("pewpew")) then return end
		
		local bullet = pewpew:GetBullet( self:GetBulletName() )
		if (!bullet) then return end
		
		-- If the trace hit an entity
		local traceent = trace.Entity
		if (traceent and traceent:IsValid() and traceent:GetClass() == "pewpew_base_cannon") then
			-- Update it
			traceent:SetOptions( bullet )
			ply:ChatPrint("PewPew Weapon updated with bullet: " .. bullet.Name)
		else
			-- else create a new one
			self:CreateCannon( trace, bullet )
				
			ply:AddCount( "pewpew", self.ent )
			ply:AddCleanup ( "pewpew", self.ent )

			undo.Create( "pewpew" )
				undo.AddEntity( self.ent )
				undo.SetPlayer( ply )
			undo.Finish()
				
			return true
		end
	end
	
	function TOOL:Reload( trace )
		if (trace.Hit) then
			if (trace.Entity and ValidEntity(trace.Entity)) then
				self.CannonModel = trace.Entity:GetModel()
				self:GetOwner():ChatPrint("GCombat Cannon model set to: " .. self.CannonModel)
			end
		end
	end
else
	language.Add( "Tool_pewpew_name", "PewTool" )
	language.Add( "Tool_pewpew_desc", "Used to spawn PewPew weaponry." )
	language.Add( "Tool_pewpew_0", "Primary: Spawn a PewPew weapon and weld it, Secondary: Spawn a PewPew weapon and don't weld it, Reload: Change the model of the weapon." )
	language.Add( "undone_pewpew", "Undone PewPew Weapon" )
	language.Add( "Cleanup_pewpew", "PewPew Weapons" )
	language.Add( "Cleaned_pewpew", "Cleaned up all PewPew Weapons" )
	language.Add( "SBoxLimit_pewpew", "You've reached the PewPew Weapon limit!" )
	
	function TOOL.BuildCPanel( CPanel )
		CPanel:ClearControls()
		CPanel:AddHeader()
		CPanel:AddDefaultControls()
		CPanel:AddControl("Header", { Text = "#Tool_pewpew_name", Description = "#Tool_pewpew_desc" })
		
		local Ctype = {Label = "#Tool_turret_type", MenuButton = 0, Options={}}
		for _, blt in pairs( pewpew.bullets ) do
			if (blt.Name) then
				Ctype["Options"]["#" .. blt.Name]	= { pewpew_bulletname = blt.Name }
			end
		end
		
		CPanel:AddControl("ComboBox", Ctype )
	end

end
