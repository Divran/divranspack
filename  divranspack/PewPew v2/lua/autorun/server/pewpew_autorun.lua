-- PewPew Autorun
-- Initialize variables
pewpew = {}

-- Include files
include("pewpew_weaponhandler.lua")
include("pewpew_damagecontrol.lua")
include("pewpew_bulletcontrol.lua")

-- Add Plugin files
local function AddFiles( folder, files, N )
	for k,v in ipairs( files ) do
		if (N == 1) then
			AddCSLuaFile(folder..v)
		elseif (N == 2) then
			AddCSLuaFile(folder..v)
			include(folder..v)
		elseif (N == 3) then
			include(folder..v)
		end
	end
end
AddFiles( "PewPewPlugins/Server/", file.FindInLua("PewPewPlugins/Server/*.lua"), 3 )
AddFiles( "PewPewPlugins/Shared/", file.FindInLua("PewPewPlugins/Shared/*.lua"), 2 )
AddFiles( "PewPewPlugins/Client/", file.FindInLua("PewPewPlugins/Client/*.lua"), 1 )

-- Add files
AddCSLuaFile("pewpew_weaponhandler.lua")
AddCSLuaFile("pewpew_bulletcontrol.lua")
AddCSLuaFile("autorun/client/pewpew_autorun_client.lua")

-- Run functions
pewpew:LoadWeapons()

-- Tags
local tags = GetConVar( "sv_tags" ):GetString()
if (!string.find( tags, "PewPew_v2" )) then
	RunConsoleCommand( "sv_tags", tags .. ",PewPew_v2" )
end

-- If we got this far without errors, it's safe to assume the addon is installed.
pewpew.Installed = true