/*-------------------------------------------------------------------------------------------------------------------------
	Set Custom Title
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = { }
PLUGIN.Title = "Set Custom Title"
PLUGIN.Description = "Set Custom Title."
PLUGIN.Author = "Divran"
PLUGIN.ChatCommand = "settitle"
PLUGIN.Usage = "<player> [title]"

function PLUGIN:Call( ply, args )
	if ( ply:EV_IsAdmin() ) then
		local pl = evolve:FindPlayer( args[1] )
		if ( #pl > 1 ) then
			evolve:Notify( ply, evolve.colors.white, "Did you mean ", evolve.colors.red, evolve:CreatePlayerList( pl, true ), evolve.colors.white, "?" )
		elseif ( #pl == 1 ) then
			table.remove(args, 1)
			local title = string.Trim(table.concat(args, " "))
			if (title) then
			if (string.len(title) > 25) then title = string.Left(title,23) .. ".." end
				pl[1]:SetProperty( "Title", title)
				pl[1]:SetNWString( "EV_Title", title )
				pl[1]:CommitProperties()
				if (string.Trim(title) != "") then
					evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " changed the title of ", evolve.colors.red, pl[1]:Nick(), evolve.colors.white, " to ", evolve.colors.blue, title, evolve.colors.white, "." )
				else
					evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " removed ", evolve.colors.red, pl[1]:Nick(), evolve.colors.white, "'s title." )
				end
			else
				evolve:Notify( ply, evolve.colors.red, "No title specified." )
			end
		else
			evolve:Notify( ply, evolve.colors.red, "No matching players found." )
		end
	else
		evolve:Notify( ply, evolve.colors.red, evolve.constants.notallowed )
	end
end

evolve:RegisterPlugin( PLUGIN )