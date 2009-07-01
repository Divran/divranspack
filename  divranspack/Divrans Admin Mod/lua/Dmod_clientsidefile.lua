-------------------------------------------------------------------------------------------------------------------------
-- This admin mod was made by Divran.
-- Thanks to Overv and Nev for helping me.
-- This is the client side file that is only loaded on clients
-------------------------------------------------------------------------------------------------------------------------

include( "Dmod_teamcolors.lua" )
Dmod = { }
Dmod.Plugins = { }

-------------------------------------------------------------------------------------------------------------------------
-- Add Plugins
-------------------------------------------------------------------------------------------------------------------------

local Files = file.FindInLua( "Dmod_plugins/*.lua" )
for _, file in pairs( Files ) do
	include( "Dmod_plugins/" .. file )
end