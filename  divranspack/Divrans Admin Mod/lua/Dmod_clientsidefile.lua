-------------------------------------------------------------------------------------------------------------------------
-- This admin mod was made by Divran.
-- Thanks to Overv and Nev for helping me.
-- This is the client side file that is only loaded on clients
-------------------------------------------------------------------------------------------------------------------------

Dmod = { }
Dmod.Plugins = { }

-------------------------------------------------------------------------------------------------------------------------
-- Add & Load Plugins
-------------------------------------------------------------------------------------------------------------------------

function Dmod_ClientLoadPlugins()
	local Files = file.FindInLua( "Dmod_plugins/*.lua" )
	for _, file in pairs( Files ) do
		include( "Dmod_plugins/" .. file )
	end
end

function Dmod_ClientAddPlugin( Table )
	table.insert( Dmod.Plugins, Table )
end

Dmod_ClientLoadPlugins()