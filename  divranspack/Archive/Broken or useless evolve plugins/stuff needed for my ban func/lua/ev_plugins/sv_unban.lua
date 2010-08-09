/*-------------------------------------------------------------------------------------------------------------------------
	Unban a player
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Unban"
PLUGIN.Description = "Unban a player."
PLUGIN.Author = "Divran"
PLUGIN.ChatCommand = "unban"
PLUGIN.Usage = "<steamid|nick>"

function PLUGIN:Call( ply, args )
	if ( ply:EV_IsAdmin() ) then
		if ( args[1] ) then
			local key, FoundBan = evolve:FindBan( args[1] )
			if (key and FoundBan and #FoundBan > 0) then
				evolve:RemoveBan( args[1] )
				evolve:WriteBans()
				game.ConsoleCommand( "removeid " .. args[1] .. "\n" )
				local pl = self:GetPlayerBySteamID( args[1] )
				if (pl) then
					evolve:Notify( evolve.colors.red, ply:Nick(), evolve.colors.white, " has unbanned ", evolve.colors.blue, pl:Nick(), evolve.colors.white, " (" .. pl:SteamID() .. ")." )
				else
					evolve:Notify( evolve.colors.red, ply:Nick(), evolve.colors.white, " has unbanned ", evolve.colors.blue, FoundBan[1], evolve.colors.white, " (" .. FoundBan[2] .. ")." )
				end
			else
				key, FoundBan = evolve:FindBan( string.lower(args[1]), true )
				if (key and FoundBan and #FoundBan > 0) then
					evolve:RemoveBan( FoundBan[2] )
					evolve:WriteBans()
					game.ConsoleCommand( "removeid " .. FoundBan[2] .. "\n" )
					local pl = self:GetPlayerBySteamID( args[1] )
					if (pl) then
						evolve:Notify( evolve.colors.red, ply:Nick(), evolve.colors.white, " has unbanned ", evolve.colors.blue, pl:Nick(), evolve.colors.white, " (" .. pl:SteamID() .. ")." )
					else
						evolve:Notify( evolve.colors.red, ply:Nick(), evolve.colors.white, " has unbanned ", evolve.colors.blue, FoundBan[1], evolve.colors.white, " (" .. FoundBan[2] .. ")." )
					end
				else
					evolve:Notify( ply, evolve.colors.red, "'" .. args[1] .. "' is not banned!" )
				end
			end
		else
			evolve:Notify( ply, evolve.colors.red, "You need to specify a SteamID or nickname!" )
		end
	else
		evolve:Notify( ply, evolve.colors.red, evolve.constants.notallowed )
	end
end

function PLUGIN:GetPlayerBySteamID( SteamID )
	if (!SteamID) then return end
	for _, ply in pairs( player.GetAll() ) do
		if (ply:SteamID() == SteamID) then return ply end
	end
	return
end

evolve:RegisterPlugin( PLUGIN )