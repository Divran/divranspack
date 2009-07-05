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
			print( "[D] User: '" .. ply:Nick() .. "' Message: " .. Txt )
		end
	else
		ply:PrintMessage( HUD_PRINTTALK, "[D] (Silent) " .. Txt )
		print( "[D] (Silent) User: '" .. ply:Nick() .. "' Message: " .. Txt )
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
-- Initial Spawn
-------------------------------------------------------------------------------------------------------------------------
function Dmod_InitialSpawn( ply )
	ply.Jailed = false
	ply.Spec = false
	
	Dmod_Message( true, ply, ply:Nick() .. " has spawned!" )
end
hook.Add( "PlayerInitialSpawn", "", Dmod_InitialSpawn )


	
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
-- A table of weapons & the Arm function
-------------------------------------------------------------------------------------------------------------------------

local Wpns = {}
function AddWeapons()
	for k, v in pairs(ents.GetAll()) do
		if v:IsWeapon() and !table.HasValue( Wpns, v:GetClass() ) then
			table.insert( Wpns, v:GetClass() )
		end
	end
end
if SERVER then hook.Add("Think", "AddWeapons", AddWeapons) end

function Dmod_GiveWpns( ply )
	for _, v in pairs(Wpns) do
		ply:Give( v )
	end
	ply:SelectWeapon("weapon_physgun")
end

-------------------------------------------------------------------------------------------------------------------------
-- Jail & Cage Control
-------------------------------------------------------------------------------------------------------------------------

function Dmod_ControlJail( TargetPly, Bool, Pos, Cage )
		TargetPly.JailPos = Pos
		TargetPly.Jailed = Bool
		
		if (Bool == true) then
			TargetPly:StripWeapons()
			TargetPly:SetPos( Pos )
		else
			Dmod_GiveWpns( TargetPly )
		end
	if (Cage == true) then
		Dmod_SpawnCage( TargetPly )
	end
	if (TargetPly:GetMoveType() == MOVETYPE_NOCLIP) then TargetPly:SetMoveType( MOVETYPE_WALK ) end
			
end

local function Dmod_TeleToJail( ply )
	-- Jail control:
	if (ply.Jailed == true) then
		timer.Simple( 0.05, function() 
		ply:SetPos( ply.JailPos )
		ply:StripWeapons()
		end)
	end
	
	-- Godmode control:
	if (ply.GodOn == true) then
		ply:GodEnable()
	end
end
hook.Add( "PlayerSpawn", "", Dmod_TeleToJail )

local function Dmod_BlockStuff( ply )
	if (ply.Jailed == true) then 
		Dmod_Message( false, ply, "You are caged or jailed!" )
		return false 
	end
	return true
end
hook.Add( "PlayerSpawnProp", "", Dmod_BlockStuff )
hook.Add( "PlayerSpawnSENT", "", Dmod_BlockStuff )
hook.Add( "PlayerSpawnNPC", "", Dmod_BlockStuff )
hook.Add( "PlayerSpawnSWEP", "", Dmod_BlockStuff )
hook.Add( "PlayerSpawnVehicle", "", Dmod_BlockStuff )
hook.Add( "CanTool", "", Dmod_BlockStuff )

local function Dmod_BlockWeapons( ply )
	timer.Simple( 0.05, function() if (ply.JailOn == true) then ply:StripWeapons() end end )
	return true
end
hook.Add( "PlayerCanPickupWeapon", "", Dmod_BlockWeapons )


function Dmod_SpawnCage( ply )
	if (ply.Jailed == true) then
		ply.CageLeft = ents.Create("prop_physics")
		ply.CageLeft:SetModel("models/props_wasteland/interior_fence002c.mdl")
		ply.CageLeft:SetPos( ply:GetPos() + Vector(0,-65,60) )
		ply.CageLeft:SetAngles(Angle(0,90,0))
		ply.CageLeft:Spawn()
		
		ply.CageRight = ents.Create("prop_physics")
		ply.CageRight:SetModel("models/props_wasteland/interior_fence002c.mdl")
		ply.CageRight:SetPos( ply:GetPos() + Vector(0,65,60) )
		ply.CageRight:SetAngles(Angle(0,90,0))
		ply.CageRight:Spawn()
		
		ply.CageFront = ents.Create("prop_physics")
		ply.CageFront:SetModel("models/props_wasteland/interior_fence002c.mdl")
		ply.CageFront:SetPos( ply:GetPos() + Vector(65,0,60) )
		ply.CageFront:SetAngles(Angle(0,0,0))
		ply.CageFront:Spawn()
		
		ply.CageBack = ents.Create("prop_physics")
		ply.CageBack:SetModel("models/props_wasteland/interior_fence002c.mdl")
		ply.CageBack:SetPos( ply:GetPos() + Vector(-65,0,60) )
		ply.CageBack:SetAngles(Angle(0,0,0))
		ply.CageBack:Spawn()
		
		ply.CageAbove = ents.Create("prop_physics")
		ply.CageAbove:SetModel("models/props_wasteland/interior_fence002c.mdl")
		ply.CageAbove:SetPos( ply:GetPos() + Vector(0,0,125) )
		ply.CageAbove:SetAngles(Angle(90,0,0))
		ply.CageAbove:Spawn()
		
		ply.CageBelow = ents.Create("prop_physics")
		ply.CageBelow:SetModel("models/props_wasteland/interior_fence002c.mdl")
		ply.CageBelow:SetPos( ply:GetPos() + Vector(0,0,-5) )
		ply.CageBelow:SetAngles(Angle(90,0,0))
		ply.CageBelow:Spawn()
		
		local PT = ply.CageLeft:GetPhysicsObject()
		PT:EnableMotion(false)
		PT:Wake()
		local PT = ply.CageRight:GetPhysicsObject()
		PT:EnableMotion(false)
		PT:Wake()
		local PT = ply.CageFront:GetPhysicsObject()
		PT:EnableMotion(false)
		PT:Wake()
		local PT = ply.CageBack:GetPhysicsObject()
		PT:EnableMotion(false)
		PT:Wake()
		local PT = ply.CageAbove:GetPhysicsObject()
		PT:EnableMotion(false)
		PT:Wake()
		local PT = ply.CageBelow:GetPhysicsObject()
		PT:EnableMotion(false)
		PT:Wake()
	else
			if (ValidEntity(ply.CageLeft)) then ply.CageLeft:Remove() end
			if (ValidEntity(ply.CageRight)) then ply.CageRight:Remove() end
			if (ValidEntity(ply.CageFront)) then ply.CageFront:Remove() end
			if (ValidEntity(ply.CageBack)) then ply.CageBack:Remove() end
			if (ValidEntity(ply.CageAbove)) then ply.CageAbove:Remove() end
			if (ValidEntity(ply.CageBelow)) then ply.CageBelow:Remove() end
	end
end


-------------------------------------------------------------------------------------------------------------------------
-- Admin Noclip Control
-------------------------------------------------------------------------------------------------------------------------

function Dmod_ServerAdminNoclip( ply )
	if AdminNoclip then AdminNoclip = false else AdminNoclip = true end
	if (AdminNoclip) then Dmod_Message( true, ply, ply:Nick() .. " enabled Admin Only Noclip." ) end
	if (!AdminNoclip) then Dmod_Message( true, ply, ply:Nick() .. " disabled Admin Only Noclip." ) end
end

local function Dmod_DisableNoclip( ply )
	if ((AdminNoclip == true and !Dmod_CheckRequiredRank( ply, "admin", false )) or ply.Jailed == true) then
		if (ply.Jailed == true) then Dmod_Message( false, ply, "You are caged or jailed!" ) end
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