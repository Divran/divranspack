-------------------------------------------------------------------------------------------------------------------------
-- Gimp
-------------------------------------------------------------------------------------------------------------------------
local DmodPlugin = {}
DmodPlugin.ChatCommand = "gimp" -- The chat command you need to use this plugin
DmodPlugin.Name = "Gimp" -- The name of the plugin
DmodPlugin.Description = "Gimp someone" -- The description shown in the Menu
DmodPlugin.ShowInMenu = true -- Do you want this plugin to be shown in the menu at all?
DmodPlugin.Type = "punishment" -- Where in the Menu will it show?
DmodPlugin.Creator = "Divran" -- Who created it?
DmodPlugin.RequiredRank = "Admin" -- The rank required to use this command. Can be "Guest", "Respected", "Admin", "Super Admin", or "Owner".
if SERVER then Dmod_AddPlugin(DmodPlugin) else Dmod_ClientAddPlugin(DmodPlugin) end

local function Dmod_Plugin( ply, Args )
if (Dmod_CheckRequiredRank(ply, DmodPlugin.RequiredRank)) then
	if (Args[2]) then
		if (Dmod_FindPlayer(Args[2])) then
			local T = Dmod_FindPlayer(Args[2])
			T.Gimped = true
			Dmod_Message(true, ply, ply:Nick() .. " gimped " .. T:Nick() .. ".","punish")
		else
			Dmod_Message(false, ply, "No player named '"..Args[2].."' found.","warning")
		end
	else
		Dmod_Message( false, ply, "You must enter a name!","warning")
	end
end
end
hook.Add( DmodPlugin.Name, DmodPlugin.Name, Dmod_Plugin )

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