/*-------------------------------------------------------------------------------------------------------------------------
	Prints a message to console whenever someone spawns something
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = { }
PLUGIN.Title = "Message Print"
PLUGIN.Description = "Prints a message to console whenever someone spawns something."
PLUGIN.Author = "Divran"
PLUGIN.ChatCommand = "!conmsg"
PLUGIN.Usage = "1/0"

if (SERVER) then
	-- Enable/Disable
	function PLUGIN:Call( ply, args )
		ply.EV_ConmsgEnabled = !ply.EV_ConmsgEnabled
		evolve:Notify( ply, evolve.colors.blue, "Conmsg Print ", evolve.colors.white, "set to: ", evolve.colors.red, tostring(ply.EV_ConmsgEnabled) )
	end
	
	function PLUGIN:SendData( ply, what, model )
		-- Get targets
		local targets = {}
		for _,v in pairs( player.GetAll() ) do
			if (v.EV_ConmsgEnabled == true) then
				targets[table.Count(targets)+1] = v
			end
		end
		
		if (#targets > 0) then
			-- Send to targets
			umsg.Start("Evolve conmsg", targets)
				umsg.Entity( ply )
				umsg.String( what )
				umsg.String( model )
			umsg.End()
		end
		
		-- Print to server's console
		local String = "[EV - conmsg] " .. ply:Nick() .. " (" .. ply:SteamID() .. ") spawned a"
		local mid = ""
		if (what == "prop") then
			mid = " prop. Model: " 
		elseif (what == "vehicle") then
			mid = " vehicle. Model: "
		elseif (what == "npc") then
			mid = "n NPC. Model: "
		elseif (what == "effect") then
			mid = "n effect. Model: "
		elseif (what == "ragdoll") then
			mid = " ragdoll. Model: "
		elseif (what == "entity") then
			mid = "n entity. Type: "
		end

		String = String .. mid .. model

		print(String)
	end

	-- Check for spawns
	function PLUGIN:PlayerSpawnedProp( ply, mdl ) self:SendData( ply, "prop", mdl ) end
	function PLUGIN:PlayerSpawnedVehicle( ply, obj ) self:SendData( ply, "vehicle", obj:GetModel() ) end
	function PLUGIN:PlayerSpawnedNPC( ply, npc ) self:SendData( ply, "npc", npc:GetModel() ) end
	function PLUGIN:PlayerSpawnedEffect( ply, mdl ) self:SendData( ply, "effect", mdl ) end
	function PLUGIN:PlayerSpawnedRagdoll( ply, mdl ) self:SendData( ply, "ragdoll", mdl ) end
	function PLUGIN:PlayerSpawnedSENT( ply, obj ) self:SendData( ply, "entity", obj:GetClass() ) end
	
	-- Enabled by default
	function PLUGIN:PlayerInitialSpawn( ply )
		ply.EV_ConmsgEnabled = true
	end
else
	usermessage.Hook( "Evolve conmsg", function( um )
		-- Get necessary variables
		local ply = um:ReadEntity()
		local what = um:ReadString()
		local model = um:ReadString()
		
		-- Create the string
		local String = "[EV - conmsg] " .. ply:Nick() .. " (" .. ply:SteamID() .. ") spawned a"
		local mid = ""
		if (what == "prop") then
			mid = " prop. Model: " 
		elseif (what == "vehicle") then
			mid = " vehicle. Model: "
		elseif (what == "npc") then
			mid = "n NPC. Model: "
		elseif (what == "effect") then
			mid = "n effect. Model: "
		elseif (what == "ragdoll") then
			mid = " ragdoll. Model: "
		elseif (what == "entity") then
			mid = "n entity. Type: "
		end

		String = String .. mid .. model

		-- Print
		print(String)
	end)
end

evolve:RegisterPlugin( PLUGIN )