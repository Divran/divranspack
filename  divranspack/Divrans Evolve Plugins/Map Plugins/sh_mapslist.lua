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

if !datastream then require"datastream" end

if (SERVER) then
	function PLUGIN:GetMaps()
		self.Maps = {}
		self.Gamemodes = {}
		
		local files = file.Find( "../maps/*.bsp" )
		for k, filename in pairs( files ) do
			self.Maps[k] = filename:gsub( "%.bsp$", "" )
			self.Maps_Inverted[self.Maps[k]] = k
		end
		
		local folders = file.FindDir( "../gamemodes/*" )
		for k, foldername in pairs( folders ) do
			self.Gamemodes[k] = foldername
			self.Gamemodes_Inverted[foldername] = k
		end
	end
	PLUGIN:GetMaps()

	function PLUGIN:PlayerInitialSpawn( ply )		
		timer.Simple( 1, function()
			if (ply and ply:IsValid()) then
				datastream.StreamToClients( ply, "ev_sendmaps", { self.Maps, self.Gamemodes } )
			end
		end)
	end
else
	function PLUGIN.RecieveMaps( handler, id, encoded, decoded )
		PLUGIN.Maps = decoded[1]
		PLUGIN.Gamemodes = decoded[2]
	end
	datastream.Hook("ev_sendmaps", PLUGIN.RecieveMaps)
end

function evolve:MapPlugin_GetMaps()
	return PLUGIN.Maps, PLUGIN.Maps_Inverted
end

function evolve:MapPlugin_GetGamemodes()
	return PLUGIN.Gamemodes, PLUGIN.Gamemodes_Inverted
end
	

evolve:RegisterPlugin( PLUGIN )