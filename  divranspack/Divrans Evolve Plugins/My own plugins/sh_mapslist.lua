/*-------------------------------------------------------------------------------------------------------------------------
	Get maps and gamemodes for use in the maps tab
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Get Maps"
PLUGIN.Description = "Get maps and gamemodes for use in the maps tab."
PLUGIN.Author = "Divran"
PLUGIN.ChatCommand = nil
PLUGIN.Usage = nil

if !datastream then require"datastream" end

if (SERVER) then
	concommand.Add( "ev_changemapandgamemode", function( ply, command, args )
		if ( ply:EV_IsAdmin() ) then
			local map = args[1]
			local gamemode = args[2]
			evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " has changed the map to ", evolve.colors.red, map, evolve.colors.white, " and gamemode to ", evolve.colors.red, gamemode, evolve.colors.white, "." )
			timer.Simple( 0.5, function() RunConsoleCommand("changegamemode", map, gamemode) end)
		else
			evolve:Notify( ply, evolve.colors.red, evolve.constants.notallowed )
		end
	end)

	function PLUGIN:GetMaps()
		PLUGIN.Maps = {}
		PLUGIN.Gamemodes = {}

		local files = file.Find( "../maps/*.bsp" )
		local temp = ""
		for _, filename in pairs( files ) do
			temp = filename:gsub( "%.bsp$", "" )
			table.insert( PLUGIN.Maps, temp)
		end

		local folders = file.FindDir("../gamemodes/*")
		for _, foldername in pairs( folders ) do
			table.insert(PLUGIN.Gamemodes, foldername)
		end
	end
	PLUGIN:GetMaps()

	function PLUGIN:PlayerInitialSpawn( ply )	
		datastream.StreamToClients( ply, "evolve_sendmaps", { self.Maps, self.Gamemodes } )
	end
else
	evolve.Maps = {}
	evolve.Gamemodes = {}
	
	function PLUGIN:RecieveMaps( handler, id, decoded )
		evolve.Maps = decoded[1]
		evolve.Gamemodes = decoded[2]
	end
	datastream.Hook("evolve_sendmaps", PLUGIN.RecieveMaps)
end

evolve:RegisterPlugin( PLUGIN )