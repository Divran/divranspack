-------------------------------------------------------------------------------------------------------------------------
-- This admin mod was made by Divran.
-- Thanks to Overv and Nevec for helping me.
-- This is the server side file that is only loaded on servers.
-------------------------------------------------------------------------------------------------------------------------

AddCSLuaFile("autorun/Dmod_autorun.lua")
AddCSLuaFile("Dmod_clientsidefile.lua")
Dmod = { }
Dmod.Plugins = { }
entitymeta = FindMetaTable( "Entity" )
function entitymeta:Nick( ) if ( !self:IsValid( ) ) then return "Console" end end

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
	resource.AddFile( path .. "text_list_numbers.vtf" )
	resource.AddFile( path .. "text_list_numbers.vmt" )
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

function Dmod_Message( ToAll, ply, Txt, C )
local rf = RecipientFilter()
if (ToAll) then rf:AddAllPlayers() else	rf:AddPlayer( ply )	end
	umsg.Start( "Dmod_AddText", rf )
		umsg.String( C )
		umsg.Bool( ToAll )
		umsg.String( Txt )
	umsg.End()
print( "[D] User: '" .. ply:Nick() .. "' Message: " .. Txt )
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
		Dmod_Message( false, ply, "Unknown command!", "warning" )
	end
end

-------------------------------------------------------------------------------------------------------------------------
-- Chat Detection
-------------------------------------------------------------------------------------------------------------------------

local function ChatDetect( ply, Txt )
	if (string.Left(Txt, 1) == "!") then -- Check for the "!"
		local Txt = string.Right(Txt, string.len(Txt) - 1 ) -- Remove the "!"
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

	print( "Dmod Initialized." )
	
-------------------------------------------------------------------------------------------------------------------------
-- Check Required Rank
-------------------------------------------------------------------------------------------------------------------------
function Dmod_CheckRequiredRank( ply, Rank, MessageBool )
	if (ply:Nick() != "Console") then
		local PlayerRank = 5
		if (ply:IsUserGroup("respected")) then PlayerRank = 4 end
		if (ply:IsUserGroup("admin")) then PlayerRank = 3 end
		if (ply:IsUserGroup("superadmin")) then PlayerRank = 2 end
		if (ply:IsUserGroup("superadmin") and ply.Owner == true) then PlayerRank = 1 end
		local Nr = 5
		if (Rank == "Respected") then Nr = 4 elseif
		(Rank == "Admin") then Nr = 3 elseif
		(Rank == "Super Admin") then Nr = 2 elseif
		(Rank == "Owner") then Nr = 1 end
		
		if (PlayerRank <= Nr) then 
			return true 
		else
		local Group = "Guest"
		if (ply:IsUserGroup("respected")) then Group = "Respected" end
		if (ply:IsUserGroup("admin")) then Group = "Admin" end
		if (ply:IsUserGroup("superadmin")) then Group = "Super Admin" end
		if (ply:IsUserGroup("superadmin") and ply.Owner == true) then Group = "Owner" end
			if (MessageBool == true or MessageBool == nil) then Dmod_Message( false, ply, "You are a(n) '" .. Group .. "' and that command requires a rank of '" .. Rank .. "' or higher.", "warning" ) end
			return false 
		end
	elseif (ply:Nick() == "Console" and !ply:IsValid()) then
		return true
	end
end

-------------------------------------------------------------------------------------------------------------------------
-- Initial Spawn & Get Maps and Gamemodes. (Used for the Menu)
-- I didn't know how to use usermessages, so thanks Nevec!
-------------------------------------------------------------------------------------------------------------------------

function Dmod_InitialSpawn( ply )
	--- UserMessages
	local files = file.Find( "../maps/*.bsp" )
	for _, filename in pairs( files ) do
		umsg.Start( "dmod_addmap", ply )
			umsg.String( filename:gsub( "%.bsp$", "" ) )
		umsg.End( )
	end

	local Gamemodes = file.FindDir("../gamemodes/*")
	for _, filename in pairs( Gamemodes ) do
		umsg.Start( "dmod_addgamemode", ply )
				umsg.String( filename )
		umsg.End( )
	end
	
	-- Player Variables
	ply.Jailed = false
	ply.Spec = false
	ply.Ragdolled = false
	ply.GodOn = false
	ply.Cloaked = false
	ply.Gagged = false
	
	Dmod_Message( true, ply, ply:Nick() .. " has spawned!", "normal" )
end
hook.Add( "PlayerInitialSpawn", "", Dmod_InitialSpawn )

-------------------------------------------------------------------------------------------------------------------------
-- Several Jail, Cage and Noclip controls:
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