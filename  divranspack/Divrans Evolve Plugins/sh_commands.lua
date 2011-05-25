/*-------------------------------------------------------------------------------------------------------------------------
	Display all chat commands
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Chatcommands"
PLUGIN.Description = "Display all available chat commands."
PLUGIN.Author = "Divran"
PLUGIN.ChatCommand = "commands"
PLUGIN.Usage = "[1/0 (all/yours)]"
PLUGIN.plugs = {}

function PLUGIN:Initialize()
	self.plugs = table.Copy( evolve.plugins )
	table.SortByMember( self.plugs, "ChatCommand", function( a, b ) 
		local tempa, tempb
		if type(a) == "table" then tempa = a[1] else tempa = a end
		if type(b) == "table" then tempb = b[1] else tempb = b end
		return a > b
	end )
end

function PLUGIN:Call( ply, args )
	if ( ply:IsValid() ) then
		local printall = false
		if (args[1] and args[1] == "1") then printall = true end

		if (printall) then
			umsg.Start( "EV_CommandStart", ply ) umsg.End()
		
			for _, plug in ipairs( self.plugs ) do
				if ( plug.ChatCommand ) then
					umsg.Start( "EV_Command", ply )
						umsg.String( (type(plug.ChatCommand) == "table" and table.concat( plug.ChatCommand, ", " ) or plug.ChatCommand) )
						umsg.String( tostring( plug.Usage ) )
						umsg.String( plug.Description )
					umsg.End()
				end
			end
		else
			umsg.Start( "EV_CommandStart", ply ) umsg.String( ply:EV_GetRank() ) umsg.End()
			
			for _, plug in ipairs( self.plugs ) do
				if ( plug.ChatCommand and plug.Privileges ) then
					for k,v in ipairs( plug.Privileges ) do
						if ( ply:EV_HasPrivilege(v) ) then
							umsg.Start( "EV_Command", ply )
								umsg.String( (type(plug.ChatCommand) == "table" and table.concat( plug.ChatCommand, ", " ) or plug.ChatCommand) )
								umsg.String( plug.Usage or "" )
								umsg.String( plug.Description )
							umsg.End()
							break
						end
					end
				end
			end
		end
		
		umsg.Start( "EV_CommandEnd", ply ) umsg.End()
		evolve:Notify( ply, evolve.colors.white, "All chat commands have been printed to your console." )
	else
		for _, plugin in ipairs( self.plugs ) do
			if ( plugin.ChatCommand ) then
				if ( plugin.Usage ) then
					print( "!" .. (type(plug.ChatCommand) == "table" and table.concat( plug.ChatCommand, ", " ) or plug.ChatCommand) .. " " .. plugin.Usage .. " - " .. plugin.Description )
				else
					print( "!" .. (type(plug.ChatCommand) == "table" and table.concat( plug.ChatCommand, ", " ) or plug.ChatCommand) .. " - " .. plugin.Description )
				end
			end
		end
	end
end

usermessage.Hook( "EV_CommandStart", function( um )
	local rank = um:ReadString()
	if (rank and #rank > 0) then
		print( "\n============ Available chat commands for the rank " .. rank .. " ============\n" )
	else
		print( "\n============ Available chat commands for Evolve ============\n" )
	end
end )

usermessage.Hook( "EV_CommandEnd", function( um )
	print( "" )
end )

usermessage.Hook( "EV_Command", function( um )
	local com = um:ReadString()
	local usage = um:ReadString()
	local desc = um:ReadString()
	
	if ( usage and #usage > 0 ) then
		print( "!" .. com .. " " .. usage .. " - " .. desc )
	else
		print( "!" .. com .. " - " .. desc )
	end
end )

evolve:RegisterPlugin( PLUGIN )