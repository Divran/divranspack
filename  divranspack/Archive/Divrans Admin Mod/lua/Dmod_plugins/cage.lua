-------------------------------------------------------------------------------------------------------------------------
-- Cage
-------------------------------------------------------------------------------------------------------------------------
local DmodPlugin = {}
DmodPlugin.ChatCommand = "cage" -- The chat command you need to use this plugin
DmodPlugin.Name = "Cage" -- The name of the plugin
DmodPlugin.Description = "Cage someone." -- The description shown in the Menu
DmodPlugin.ShowInMenu = true -- Do you want this plugin to be shown in the menu at all?
DmodPlugin.Type = "punishment" -- Where in the Menu will it show?
DmodPlugin.Creator = "Divran" -- Who created it?
DmodPlugin.RequiredRank = "Admin" -- The rank required to use this command. Can be "Guest", "Respected", "Admin", "Super Admin", or "Owner".
if SERVER then Dmod_AddPlugin(DmodPlugin) else Dmod_ClientAddPlugin(DmodPlugin) end


local function Dmod_Plugin( ply, Args )
if (Dmod_CheckRequiredRank(ply, DmodPlugin.RequiredRank)) then
	if (Args[2]) then
		if (Dmod_FindPlayer(Args[2])) then
			local T = Dmod_FindPlayer(Args[2])
			if (T.Jailed == false) then
				local Pos = T:GetPos() + Vector(0,0,5)
				Dmod_ControlJail( T, true, Pos, true )
				Dmod_Message(true, ply, ply:Nick() .. " caged " .. T:Nick() .. ".", "punish" )
			else
				Dmod_Message(false, ply, T:Nick() .. " is already caged or jailed!","warning")
			end
		else
			Dmod_Message(false, ply, "No player named '".. Args[2].."' found.","warning")
		end
	else
		Dmod_Message(false, ply, "You must enter a name!","warning" )
	end
end
end
hook.Add( DmodPlugin.Name, DmodPlugin.Name, Dmod_Plugin )

-------------------------------------------------------------------------------------------------------------------------
-- Spawn Cage
-------------------------------------------------------------------------------------------------------------------------

function Dmod_SpawnCage( ply )
	if (ply.Jailed == true) then
		ply.CageLeft = ents.Create("prop_physics")
		ply.CageLeft:SetModel("models/props_wasteland/interior_fence002c.mdl")
		ply.CageLeft:SetPos( ply:GetPos() + Vector(0,-65,60) )
		ply.CageLeft:SetAngles(Angle(0,90,0))
		ply.CageLeft:Spawn()
		
		ply.CageRight = ents.Create("prop_physics")
		ply.CageRight:SetModel("models/props_wasteland/interior_fence002c.mdl")
		ply.CageRight:SetPos( ply:GetPos() + Vector(0,65,60) )
		ply.CageRight:SetAngles(Angle(0,90,0))
		ply.CageRight:Spawn()
		
		ply.CageFront = ents.Create("prop_physics")
		ply.CageFront:SetModel("models/props_wasteland/interior_fence002c.mdl")
		ply.CageFront:SetPos( ply:GetPos() + Vector(65,0,60) )
		ply.CageFront:SetAngles(Angle(0,0,0))
		ply.CageFront:Spawn()
		
		ply.CageBack = ents.Create("prop_physics")
		ply.CageBack:SetModel("models/props_wasteland/interior_fence002c.mdl")
		ply.CageBack:SetPos( ply:GetPos() + Vector(-65,0,60) )
		ply.CageBack:SetAngles(Angle(0,0,0))
		ply.CageBack:Spawn()
		
		ply.CageAbove = ents.Create("prop_physics")
		ply.CageAbove:SetModel("models/props_wasteland/interior_fence002c.mdl")
		ply.CageAbove:SetPos( ply:GetPos() + Vector(0,0,125) )
		ply.CageAbove:SetAngles(Angle(90,0,0))
		ply.CageAbove:Spawn()
		
		ply.CageBelow = ents.Create("prop_physics")
		ply.CageBelow:SetModel("models/props_wasteland/interior_fence002c.mdl")
		ply.CageBelow:SetPos( ply:GetPos() + Vector(0,0,-5) )
		ply.CageBelow:SetAngles(Angle(90,0,0))
		ply.CageBelow:Spawn()
		
		ply.CageLeft:SetNetworkedString("Owner", "World")
		local PT = ply.CageLeft:GetPhysicsObject()
		PT:EnableMotion(false)
		PT:Wake()
		ply.CageRight:SetNetworkedString("Owner", "World")
		local PT = ply.CageRight:GetPhysicsObject()
		PT:EnableMotion(false)
		PT:Wake()
		ply.CageFront:SetNetworkedString("Owner", "World")
		local PT = ply.CageFront:GetPhysicsObject()
		PT:EnableMotion(false)
		PT:Wake()
		ply.CageBack:SetNetworkedString("Owner", "World")
		local PT = ply.CageBack:GetPhysicsObject()
		PT:EnableMotion(false)
		PT:Wake()
		ply.CageAbove:SetNetworkedString("Owner", "World")
		local PT = ply.CageAbove:GetPhysicsObject()
		PT:EnableMotion(false)
		PT:Wake()
		ply.CageBelow:SetNetworkedString("Owner", "World")
		local PT = ply.CageBelow:GetPhysicsObject()
		PT:EnableMotion(false)
		PT:Wake()
	else
			if (ValidEntity(ply.CageLeft)) then ply.CageLeft:Remove() end
			if (ValidEntity(ply.CageRight)) then ply.CageRight:Remove() end
			if (ValidEntity(ply.CageFront)) then ply.CageFront:Remove() end
			if (ValidEntity(ply.CageBack)) then ply.CageBack:Remove() end
			if (ValidEntity(ply.CageAbove)) then ply.CageAbove:Remove() end
			if (ValidEntity(ply.CageBelow)) then ply.CageBelow:Remove() end
	end
end