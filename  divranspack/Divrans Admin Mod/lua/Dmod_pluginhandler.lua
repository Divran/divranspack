-------------------------------------------------------------------------------------------------------------------------
-- This admin mod was made by Divran.
-- Thanks to Overv and Nevec for helping me.
-- This is the server side file that is only loaded on servers.
-------------------------------------------------------------------------------------------------------------------------

AddCSLuaFile("autorun/Dmod_autorun.lua")
AddCSLuaFile("Dmod_teamcolors.lua")
AddCSLuaFile("Dmod_clientsidefile.lua")
include( "Dmod_teamcolors.lua" )
Dmod = { }
Dmod.Plugins = { }

-------------------------------------------------------------------------------------------------------------------------
-- Add & Load Plugins
-------------------------------------------------------------------------------------------------------------------------

function Dmod_LoadPlugins()
	local Files = file.FindInLua( "Dmod_plugins/*.lua" )
	for _, file in pairs( Files ) do
		include( "Dmod_plugins/" .. file )
		AddCSLuaFile( "Dmod_plugins/" .. file )
	end
end

function Dmod_AddPlugin( Table )
	table.insert( Dmod.Plugins, Table )
end

Dmod_LoadPlugins()

-------------------------------------------------------------------------------------------------------------------------
-- Add gui Materials
-------------------------------------------------------------------------------------------------------------------------

function Dmod_LoadMaterials()
	local path = "materials/gui/silkicons/"
	resource.AddFile( path .. "map.vmt" )
	resource.AddFile( path .. "map.vtf" )
	resource.AddFile( path .. "server.vmt" )
	resource.AddFile( path .. "server.vtf" )
end
Dmod_LoadMaterials()

-------------------------------------------------------------------------------------------------------------------------
-- Find players
-------------------------------------------------------------------------------------------------------------------------

function Dmod_FindPlayer( Name )
	if (!Name) then return nil end
		
	for _, pl in pairs(player.GetAll()) do
		if string.find(string.lower(pl:Nick()), string.lower(Name), 1, true) then
			return pl
		end
	end
end

-------------------------------------------------------------------------------------------------------------------------
-- Print to Chat
-------------------------------------------------------------------------------------------------------------------------

function Dmod_Message( ToAll, ply, Txt )
	if ToAll then
		for k, v in pairs(player.GetAll()) do
			v:PrintMessage( HUD_PRINTTALK, "[D] " .. Txt )
		end
	else
		ply:PrintMessage( HUD_PRINTTALK, "[D] (Silent) " .. Txt )
	end
end

-------------------------------------------------------------------------------------------------------------------------
-- Plugin Caller
-------------------------------------------------------------------------------------------------------------------------

function Dmod_CallPlugin( ply, Args )
local Found = false
	for _, v in pairs( Dmod.Plugins ) do -- Scan all plugins
		if (v.ChatCommand == string.lower(Args[1])) then -- Find the plugin
			if (ply:IsAdmin()) then -- Check for admin
				hook.Call(v.Name, "", ply, Args ) -- Call the plugin
			else
				Dmod_Message( false, ply, "You are not an admin!" )
			end
			Found = true -- Found it!
		end
	end
	
	if (Found == false) then
		Dmod_Message( false, ply, "Unknown command!" )
	end
end

-------------------------------------------------------------------------------------------------------------------------
-- Chat Detection
-------------------------------------------------------------------------------------------------------------------------

local function ChatDetect( ply, Txt )
Txt = string.lower(Txt) -- Lower
	if (string.Left(Txt, 1) == "!") then -- Check for the "!"
		Txt = string.Right(Txt, string.len(Txt) - 1 ) -- Remove the "!"
		local Args = string.Explode( " ", Txt ) -- KABOOM
		Dmod_CallPlugin( ply, Args ) -- Continue to CallPlugin
		return ""
	end
end
hook.Add( "PlayerSay", "ChatDetect", ChatDetect )

-------------------------------------------------------------------------------------------------------------------------
-- Console Commands
-------------------------------------------------------------------------------------------------------------------------

function Dmod_CommandRecieve( ply, Com, Command )
	Dmod_CallPlugin( ply, Command )
end
concommand.Add( "Dmod", Dmod_CommandRecieve )

	Dmod_Message( true, nil, "Dmod Initialized." )
	
	
-------------------------------------------------------------------------------------------------------------------------
-- Get Reason (Used for Ban and Kick)
-------------------------------------------------------------------------------------------------------------------------

function Dmod_GetReason(Args, Num)
	local Rsn = ""
	if (Args[Num] and Args[Num] != "") then
		for i = 1, table.Count(Args) do
			if (i >= Num) then
				Rsn = Rsn .. Args[i] .. " "
			end
		end
	end
	if (string.Trim(Rsn) == "") then Rsn = "No reason" end
	return Rsn
end

-------------------------------------------------------------------------------------------------------------------------
-- Get Maps and Gamemodes. (Used for the Menu)
-- I didn't know how to use usermessages, so thanks Nevec!
-------------------------------------------------------------------------------------------------------------------------

function GetUserMessage( ply )
	local files = file.Find( "../maps/*.bsp" )
	for _, filename in pairs( files ) do
		umsg.Start( "dmod_addmap", ply )
			umsg.String( filename:gsub( "%.bsp$", "" ) )
		umsg.End( )
	end

	local Gamemodes = file.FindDir("../gamemodes/*")
	for _, filename in pairs( Gamemodes ) do
		umsg.Start( "dmod_addgamemode", ply )
			if (filename != "base") then
				umsg.String( filename )
			end
		umsg.End( )
	end
end
hook.Add( "PlayerInitialSpawn", "GetUserMessage", GetUserMessage )
