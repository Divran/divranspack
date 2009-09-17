/*-------------------------------------------------------------------------------------------------------------------------
	Chat Ranks
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = { }
PLUGIN.Title = "Chat Ranks"
PLUGIN.Description = "Display the rank in chat"
PLUGIN.Author = "Divran"
PLUGIN.ChatCommand = "chatranks"
PLUGIN.Usage = "1/0"

function PLUGIN:Call( ply, args )
	if ( ply:EV_IsAdmin( ) and ply:IsValid( ) ) then
		PrintTable( args )
		local Doit = 0
		if args[1] == "1" then Doit = 1 end
			for num, ply in pairs( player.GetAll() ) do
				ply:ConCommand( "EV_ChatRanks " .. Doit )
			end
		local M = " disabled "
		if Doit == 1 then M = " enabled " end
		evolve:notify( evolve.colors.red, ply:Nick(), evolve.colors.white, M .. "the chat ranks.")
	else
		evolve:notify( ply, evolve.colors.red, evolve.constants.notallowed )
	end
end

if (CLIENT) then
	local ChatRanksConvar = CreateClientConVar( "EV_ChatRanks", "0", false, false ) -- Convar
	local function ChatRanks( Ply, Txt, TeamChat, IsDead )
		local On = ChatRanksConvar:GetBool() -- Get Bool
		if (On and Ply:EV_IsAdmin()) then
			local Msg = {}
			
			-- Dead?
			if (IsDead) then
				table.insert( Msg, Color( 255, 30, 40 ))
				table.insert( Msg, "*DEAD* " )
			end
			
			-- Team Chat
			if (TeamChat) then
				table.insert( Msg, Color( 30, 160, 40 ) )
				table.insert( Msg, "(TEAM) " )
			end
			
			-- Rank
			table.insert( Msg, evolve.colors.blue )
			table.insert( Msg, "["..evolve:getPlugin("Ranking"):getRealName( Ply:EV_GetRank() ).."] ")
				
			-- Console?
			if ( IsValid( Ply ) ) then 
				table.insert( Msg, team.GetColor( Ply:Team() ) )
				table.insert( Msg, Ply:Nick() )
			else
				table.insert( Msg, Color( 100, 100, 100) )
				table.insert( Msg, "Console")
			end
			
			-- The message
			table.insert( Msg, evolve.colors.white )
			table.insert( Msg, ": " .. Txt )
			
			chat.AddText( unpack(Msg) )
			return true
		end
	end
	hook.Add("OnPlayerChat","ChatRanks",ChatRanks)
end

function PLUGIN:Menu( arg, players )
	if ( arg ) then
		RunConsoleCommand( "ev", "chatranks", arg )
	else
		return "Chat Ranks", evolve.category.administration, {{ "On" , "1"}, {"Off", "0"}}
	end
end

evolve:registerPlugin( PLUGIN )