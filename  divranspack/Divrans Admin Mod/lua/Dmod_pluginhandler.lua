-------------------------------------------------------------------------------------------------------------------------
-- This admin mod was made by Divran.
-- Thanks to Overv and Nevec for helping me.
-- This is the server side file that is only loaded on servers.
-------------------------------------------------------------------------------------------------------------------------

AddCSLuaFile("autorun/Dmod_autorun.lua")
AddCSLuaFile("Dmod_clientsidefile.lua")
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
			if (Dmod_CheckRequiredRank(ply, v.RequiredRank)) then
				hook.Call(v.Name, "", ply, Args ) -- Call the plugin
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
-- Check Required Rank
-------------------------------------------------------------------------------------------------------------------------
function Dmod_CheckRequiredRank( ply, Rank, MessageBool )
	local PlayerRank = ply:Team()
	local Nr = 4
	Rank = string.lower( Rank )
	if (Rank == "admin") then Nr = 3 elseif
	(Rank == "super admin") then Nr = 2 elseif
	(Rank == "owner") then Nr = 1 end
	
	if (PlayerRank <= Nr) then 
		return true 
	else 
		if (MessageBool == true or MessageBool == nil) then Dmod_Message( false, ply, "You are a(n) '" .. team.GetName( ply:Team() ) .. "' and that command requires a rank of '" .. Rank .. "' or higher." ) end
		return false 
	end
end
	
-------------------------------------------------------------------------------------------------------------------------
-- Get Reason (Used for Ban and Kick)
-------------------------------------------------------------------------------------------------------------------------

function Dmod_GetReason(Args, Num)
	local Rsn = ""
	Rsn = table.concat( Args, " ", Num, table.Count(Args))
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

-------------------------------------------------------------------------------------------------------------------------
-- Jail Control
-------------------------------------------------------------------------------------------------------------------------

function Dmod_ControlJail( TargetPly, Bool, Pos )
		TargetPly.JailPos = Pos
		TargetPly.JailOn = Bool
		
		if (Bool == true) then
			TargetPly:StripWeapons()
			TargetPly:SetPos( Pos )
		else
			local Ang = TargetPly:GetAimVector():Angle()
			local Pos2 = TargetPly:GetPos()
			TargetPly:Spawn()
			TargetPly:SetPos( Pos2 )
			TargetPly:SnapEyeAngles( Ang )
		end
end

local function Dmod_TeleToJail( ply )
	if (ply.JailOn == true) then
		ply:SetPos( ply.JailPos )
		ply:StripWeapons()
	end
end
hook.Add( "PlayerSpawn", "", Dmod_TeleToJail )

local function Dmod_BlockStuff( ply )
	if (ply.JailOn == true) then 
		Dmod_Message( false, ply, "You are jailed!" )
		return false 
	else 
		return true 
	end
end
hook.Add( "PlayerSpawnProp", "", Dmod_BlockStuff )
hook.Add( "PlayerSpawnSENT", "", Dmod_BlockStuff )
hook.Add( "PlayerSpawnNPC", "", Dmod_BlockStuff )
hook.Add( "PlayerSpawnSWEP", "", Dmod_BlockStuff )
hook.Add( "PlayerSpawnVehicle", "", Dmod_BlockStuff )
hook.Add( "CanTool", "", Dmod_BlockStuff )
hook.Add( "PlayerNoClip", "", Dmod_BlockStuff )
hook.Add( "SpawnMenuOpen", "", Dmod_BlockStuff )

local function Dmod_BlockWeapons( ply )
	timer.Simple( 0.05, function() if (ply.JailOn == true) then ply:StripWeapons() end end )
	return true
end
hook.Add( "PlayerCanPickupWeapon", "", Dmod_BlockWeapons )


-------------------------------------------------------------------------------------------------------------------------
-- Admin Noclip Control
-------------------------------------------------------------------------------------------------------------------------

function Dmod_ServerAdminNoclip( ply )
	if AdminNoclip then AdminNoclip = false else AdminNoclip = true end
	if (AdminNoclip) then Dmod_Message( true, ply, ply:Nick() .. " enabled Admin Only Noclip." ) end
	if (!AdminNoclip) then Dmod_Message( true, ply, ply:Nick() .. " disabled Admin Only Noclip." ) end
end

local function Dmod_DisableNoclip( ply )
	if (AdminNoclip == true and !Dmod_CheckRequiredRank( ply, "admin", false )) then
		return false
	end
	return true
end
hook.Add("PlayerNoClip", "", Dmod_DisableNoclip)

-------------------------------------------------------------------------------------------------------------------------
-- Gimp Control
-------------------------------------------------------------------------------------------------------------------------

local GimpMessages = { -- Add or change here if you want
"IM GAY",
"How do you fly?",
"CAPS LOCK IS CRUISE CONTROL FOR COOL",
"Wut",
"What",
"Lol",
"Lul",
"Lolz",
"Lulz",
"GWAFITY KAT NUT AMOOSED",
"Blah blah blah...",
"I love lamp..",
"I love carpet..",
"I love desk..",
"Whut",
"OMGWTFBBQ",
"MmmmmKaaay",
"Divran rules!",
"AAAAAARGH!!!!!!!!!", -- Special
"IS THIS REEL LIEF???",
"R U GARRY?",
"YOU SPIN ME RIGHT ROUND BABY RIGHT ROUND LIKE A RECORD BABY RIGHT ROUND ROUND ROUND!!!!!!!", -- Special
"HAI WHO R U?",
"GIMME CAKE",
"The cake is a LIE!",
"I C DED PPLZ",
"Words words words...",
"Simon says JUMP!", -- Special
"Simon says RUN!", -- Special
"Simon says DIE!", -- Special
"Simon says SHOOT!", -- Special
"Simon says DUCK!", -- Special
"Simon says TURN!", -- Special
"Simon says BLOW UP!" } -- Special


local function Dmod_GimpChat( ply )
	if (ply.Gimped) then
	local Gimp = table.Random( GimpMessages )
	Dmod_CheckGimps( Gimp, ply ) -- Put "--" in front of this to disable "special" gimps.
	return Gimp
	end
end
hook.Add( "PlayerSay" , "", Dmod_GimpChat )

-- "Special" gimps:
function Dmod_CheckGimps( Gimp, ply ) -- Check if the gimp message is a special one
if (Gimp == "AAAAAARGH!!!!!!!!!") then ply:ConCommand( "kill" ) end
if (Gimp == "YOU SPIN ME RIGHT ROUND BABY RIGHT ROUND LIKE A RECORD BABY RIGHT ROUND ROUND ROUND!!!!!!!") then 
	ply:ConCommand( "+right" )
	timer.Simple( 10, function( ) ply:ConCommand( "-right" ) end) 
end
if (Gimp == "Simon says JUMP!") then
	ply:ConCommand( "+jump" )
	timer.Simple( 0.5, function() ply:ConCommand( "-jump" ) end )
end
if (Gimp == "Simon says RUN!") then
	ply:ConCommand( "+forward" )
	timer.Simple( 10, function() ply:ConCommand( "-forward" ) end )
end
if (Gimp == "Simon says DIE!") then
	ply:ConCommand( "kill" )
end
if (Gimp == "Simon says SHOOT!") then
	ply:ConCommand( "+attack" )
	timer.Simple( 2, function() ply:ConCommand( "-attack" ) end )
end
if (Gimp == "Simon says DUCK!") then
	ply:ConCommand( "+duck" )
	timer.Simple( 2, function() ply:ConCommand( "-duck" ) end )
end
if (Gimp == "Simon says TURN!") then
	ply:ConCommand( "+right" )
	timer.Simple( 0.5, function() ply:ConCommand( "-right; +left" ) end )
	timer.Simple( 1.5, function() ply:ConCommand( "-left; +right" ) end )
	timer.Simple( 2, function() ply:ConCommand( "-right" ) end )
end
if (Gimp == "Simon says BLOW UP!") then
	local Pos = ply:GetPos() + Vector(0,0,50)
	util.BlastDamage( ply, ply, Pos , 100, 9001 )
	local effectdata = EffectData()
	effectdata:SetOrigin( Pos )
	util.Effect( "Explosion", effectdata, true, true )
end
end