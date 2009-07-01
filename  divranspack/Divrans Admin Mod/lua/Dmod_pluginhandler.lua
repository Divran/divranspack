-------------------------------------------------------------------------------------------------------------------------
-- This admin mod was made by Divran.
-- This is an attempt at a better admin mod.
-- Thanks to Overv for letting me use some of his functions and Nev for helping me.
-------------------------------------------------------------------------------------------------------------------------

AddCSLuaFile( "Dmod_pluginhandler.lua" )
include( "Dmod_pluginhandler.lua" )
Dmod = { }
Dmod.Plugins = { }

-------------------------------------------------------------------------------------------------------------------------
-- Add & Load Plugins
-------------------------------------------------------------------------------------------------------------------------

function Dmod_LoadPlugins()
	local Files = file.FindInLua( "Dmod_plugins/*.lua" )
	for _, file in pairs( Files ) do
		include( "Dmod_plugins/" .. file )
		if SERVER then AddCSLuaFile( "Dmod_plugins/" .. file ) end
	end
end

function Dmod_AddPlugin( Table )
	table.insert( Dmod.Plugins, Table )
end

Dmod_LoadPlugins()

-------------------------------------------------------------------------------------------------------------------------
-- Find players
-------------------------------------------------------------------------------------------------------------------------

function Dmod_FindPlayer( Name, ply )
	if (!Name) then return nil end
		
	for _, pl in pairs(player.GetAll()) do
		if (string.find(string.lower(pl:Nick()), string.lower(Name))) then
			return pl
		end
	end
end

-------------------------------------------------------------------------------------------------------------------------
-- Print to Chat
-------------------------------------------------------------------------------------------------------------------------

function Dmod_Message( ToAll, ply, Txt )
	if (ToAll) then
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
		if (v.ChatCommand == Args[1]) then -- Find the plugin
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
		Txt = string.Right(Txt, string.len(Txt) - 1 ) -- Remove dot
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