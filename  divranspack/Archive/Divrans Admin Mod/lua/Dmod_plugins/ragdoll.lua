-------------------------------------------------------------------------------------------------------------------------
-- Ragdoll
-------------------------------------------------------------------------------------------------------------------------
local DmodPlugin = {}
DmodPlugin.ChatCommand = "ragdoll" -- The chat command you need to use this plugin
DmodPlugin.Name = "Ragdoll" -- The name of the plugin
DmodPlugin.Description = "Ragdollize someone." -- The description shown in the Menu
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
				if (T.Ragdolled) then
					Dmod_Message( false, ply, T:Nick() .. " is already ragdolled!","warning" )
				else
					Dmod_RagdollControl( T, true )
					Dmod_Message(true, ply, ply:Nick() .. " ragdollized " .. T:Nick() .. ".","punish")
				end
		else
			Dmod_Message(false, ply, "No player named '"..Args[2].."' found.","warning")
		end
	else
		if (ply.Ragdolled) then
			Dmod_Message( false, ply, "You are already ragdolled!","warning" )
		else
			Dmod_RagdollControl( ply, true )
			Dmod_Message( true, ply, ply:Nick() .. " ragdollized him/herself.","punish")
		end
	end
end
end
hook.Add( DmodPlugin.Name, DmodPlugin.Name, Dmod_Plugin )

-------------------------------------------------------------------------------------------------------------------------
-- Ragdoll Control
-------------------------------------------------------------------------------------------------------------------------

function Dmod_RagdollControl( ply, Bool )
	if (Bool) then
		ply.Ragdolled = true
		
		-- Thanks to Overv
		-- Spawn the ragdoll:
		ply.Rag = ents.Create("prop_ragdoll")
		ply.Rag:SetModel( ply:GetModel() )
		ply.Rag:SetPos( ply:GetPos() )
		ply.Rag:SetAngles( ply:GetAngles() )
		ply.Rag:Spawn()
		ply.Rag:Activate()
		ply.Rag:GetPhysicsObject():SetVelocity( 4 * ply:GetVelocity() )
		
		-- Fix third person view:
		ply:DrawViewModel( false )
		ply:SetParent( ply.Rag )
		ply:StripWeapons()
		ply:Spectate( OBS_MODE_CHASE )
		ply:SpectateEntity( ply.Rag )
		ply:GodEnable()
	else
		ply.Ragdolled = false
		
		-- Respawn the player
		ply:SetParent()
		local RagPos = ply.Rag:GetPos()
		ply.Rag:Remove()
		ply:Spawn()
		ply:SetNoTarget( false )
		ply.Rag = nil
		ply:DrawViewModel( true )
		timer.Simple( .05, function() ply:SetPos( RagPos + Vector( 0,0,5 ) ) end )
		ply:GodDisable()
	end
end