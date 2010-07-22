-- PewPew Autorun
-- Initialize variables
pewpew = {}

-- Include files
include("pewpew_weaponhandler.lua")
include("pewpew_bulletcontrol.lua")

-- Include Plugin files
local function AddFiles( folder, files )
	for k,v in ipairs( files ) do
		include(folder .. v)
	end
end
AddFiles( "PewPewPlugins/Client/", file.FindInLua("PewPewPlugins/Client/*.lua") )
AddFiles( "PewPewPlugins/Shared/", file.FindInLua("PewPewPlugins/Shared/*.lua") )


-- Run functions
pewpew:LoadWeapons()

-- If we got this far without errors, it's safe to assume the addon is installed.
pewpew.Installed = true