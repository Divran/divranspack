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
	local PlayerRank = 4
	if (ply:IsAdmin()) then PlayerRank = 3 end
	if (ply:IsSuperAdmin()) then PlayerRank = 2 end
	if (ply:Team() == 1) then PlayerRank = 1 end
	local Nr = 4
	Rank = string.lower( Rank )
	if (Rank == "admin") then Nr = 3 elseif
	(Rank == "super admin") then Nr = 2 elseif
	(Rank == "owner") then Nr = 1 end
	
	if (PlayerRank <= Nr) then 
		return true 
	else 
		if (MessageBool == true or MessageBool == nil) then Dmod_Message( false, ply, "You are a(n) '" .. team.GetName( ply:Team() ) .. "' and that command requires a rank of '" .. Rank .. "' or higher.", "warning" ) end
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
	
	Dmod_Message( true, ply, ply:Nick() .. " has spawned!", "normal" )
end
hook.Add( "PlayerInitialSpawn", "", Dmod_InitialSpawn )

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


local function Dmod_DisableNoclip( ply )
	if ((AdminNoclip == true and !Dmod_CheckRequiredRank( ply, "admin", false )) or ply.Jailed == true) then
		if (ply.Jailed == true) then Dmod_Message( false, ply, "You are caged or jailed!", "warning" ) end
		return false
	end
		return true
end
hook.Add("PlayerNoClip", "", Dmod_DisableNoclip)