/*-------------------------------------------------------------------------------------------------------------------------
	Get maps and gamemodes for use in the maps tab
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Get Maps"
PLUGIN.Description = "Get maps and gamemodes for use in the maps tab."
PLUGIN.Author = "Divran"
PLUGIN.ChatCommand = nil
PLUGIN.Usage = nil

if (SERVER) then
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
	if !datastream then require"datastream" end

	evolve.Maps = {}
	evolve.Gamemodes = {}
	
	function PLUGIN:RecieveMaps( handler, id, decoded )
		evolve.Maps = decoded[1]
		evolve.Gamemodes = decoded[2]
	end
	datastream.Hook("evolve_sendmaps", PLUGIN.RecieveMaps)
end

evolve:RegisterPlugin( PLUGIN )