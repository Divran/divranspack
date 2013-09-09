/*-------------------------------------------------------------------------------------------------------------------------
	Get maps and gamemodes for use in the maps tab
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Get Maps"
PLUGIN.Description = "Gets all maps on the server and sends them to the client for use in other plugins."
PLUGIN.Author = "Divran"
PLUGIN.ChatCommand = nil
PLUGIN.Usage = nil
PLUGIN.Maps = {}
PLUGIN.Maps_Inverted = {}
PLUGIN.Gamemodes = {}
PLUGIN.Gamemodes_Inverted = {}

if (SERVER) then
	function PLUGIN:GetMaps()
		self.Maps = {}
		self.Gamemodes = {}
		
		local files, _ = file.Find( "maps/*.bsp", "GAME" )
		for k, filename in pairs( files ) do
			self.Maps[k] = filename:gsub( "%.bsp$", "" )
			self.Maps_Inverted[self.Maps[k]] = k
		end
		
		local _, folders = file.Find( "gamemodes/*", "GAME" )
		for k, foldername in pairs( folders ) do
			self.Gamemodes[k] = foldername
			self.Gamemodes_Inverted[foldername] = k
		end
	end
	PLUGIN:GetMaps()
	
	util.AddNetworkString("ev_sendmaps")

	function PLUGIN:PlayerInitialSpawn( ply )
		timer.Simple( 2, function()
			if IsValid(ply) then
				net.Start( "ev_sendmaps" )
					net.WriteTable( self.Maps )
					net.WriteTable( self.Gamemodes )
				net.Send( ply )
			end
		end)
	end
else
	function PLUGIN.RecieveMaps( len )
		PLUGIN.Maps = net.ReadTable()
		PLUGIN.Gamemodes = net.ReadTable()
	end
	net.Receive("ev_sendmaps", PLUGIN.RecieveMaps)
end

function evolve:MapPlugin_GetMaps()
	return PLUGIN.Maps, PLUGIN.Maps_Inverted
end

function evolve:MapPlugin_GetGamemodes()
	return PLUGIN.Gamemodes, PLUGIN.Gamemodes_Inverted
end
	

evolve:RegisterPlugin( PLUGIN )