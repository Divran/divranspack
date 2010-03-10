/*-------------------------------------------------------------------------------------------------------------------------
	Prints a message to console whenever someone spawns something
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = { }
PLUGIN.Title = "Message Print"
PLUGIN.Description = "Prints a message to console whenever someone spawns something."
PLUGIN.Author = "Divran"
PLUGIN.ChatCommand = "conmsg"
PLUGIN.Usage = "1/0"

if (SERVER) then
	-- Enable/Disable
	function PLUGIN:Call( ply, args )
		ply.EV_ConmsgEnabled = !ply.EV_ConmsgEnabled
		evolve:Notify( ply, evolve.colors.blue, "Conmsg Print ", evolve.colors.white, "set to: ", evolve.colors.red, tostring(ply.EV_ConmsgEnabled) )
	end
	
	function PLUGIN:SendData( ply, obj )
		-- Get targets
		local targets = {}
		for _,v in pairs( player.GetAll() ) do
			if (v.EV_ConmsgEnabled == true) then
				targets[table.Count(targets)+1] = v
			end
		end
		
		local String = "[EV] " .. ply:Nick() .. " (" .. ply:SteamID() .. ") spawned (" .. obj:GetClass() .. ") " .. obj:GetModel()
		
		if (#targets > 0) then
			-- Send to targets
			umsg.Start("Evolve conmsg", targets)
				umsg.String( String )
			umsg.End()
		end
		
		-- Print to server's console
		print(String)
	end

	-- Check for spawns
	function PLUGIN:PlayerSpawnedProp( ply, mdl, obj ) self:SendData( ply, obj ) end
	function PLUGIN:PlayerSpawnedVehicle( ply, obj ) self:SendData( ply, obj ) end
	function PLUGIN:PlayerSpawnedNPC( ply, npc ) self:SendData( ply, npc ) end
	function PLUGIN:PlayerSpawnedEffect( ply, mdl, obj ) self:SendData( ply, obj ) end
	function PLUGIN:PlayerSpawnedRagdoll( ply, mdl, obj ) self:SendData( ply, obj ) end
	function PLUGIN:PlayerSpawnedSENT( ply, obj ) self:SendData( ply, obj ) end
	
	-- Enabled by default
	function PLUGIN:PlayerInitialSpawn( ply )
		ply.EV_ConmsgEnabled = true
	end
else
	usermessage.Hook( "Evolve conmsg", function( um )
		local String = um:ReadString()
		-- Print
		print(String)
	end)
end

evolve:RegisterPlugin( PLUGIN )