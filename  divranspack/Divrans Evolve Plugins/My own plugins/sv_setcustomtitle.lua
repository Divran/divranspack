/*-------------------------------------------------------------------------------------------------------------------------
	Set Custom Title
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = { }
PLUGIN.Title = "Set Custom Title"
PLUGIN.Description = "Set Custom title shown beneath the player's name."
PLUGIN.Author = "Divran"
PLUGIN.ChatCommand = "settitle"
PLUGIN.Usage = "<title>"

function PLUGIN:Call( ply, args )
	local pl = evolve:FindPlayer( args[1], ply )[1]
	if (pl) then
		table.remove( args, 1)
		local title = table.concat( args, " " )
		if (pl != ply and !ply:IsAdmin()) then
			evolve:Notify( ply, evolve.colors.red, "You are not allowed to set the title of other players.")
		elseif (ply == ply and !ply:IsAdmin()) then
			pl:SetNWString( "EV_Title", title )
			evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " changed their own title to ", evolve.colors.red, title, evolve.colors.white, ".")
		else
			if (title != " " and title and string.len(title) > 0) then
				pl:SetNWString( "EV_Title", title )
				if (pl == ply) then
					evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " changed their own title to ", evolve.colors.red, title, evolve.colors.white, ".")
				else
					evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " changed the title of ", evolve.colors.red, pl:Nick(), evolve.colors.white, " to ", evolve.colors.red, title, evolve.colors.white, ".")
				end
			else
				pl:SetNWString( "EV_Title", " " )
				if (pl == ply) then
					evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " removed their own title." )
				else
					evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " removed ", evolve.colors.red, pl:Nick(), evolve.colors.white, "'s title.")
				end
			end
		end
	else
		evolve:Notify( ply, evolve.colors.red, "No matching players found." )
	end
end

function PLUGIN:PlayerInitialSpawn( ply )
	ply:SetNWString( "EV_Title", " ")
end

evolve:RegisterPlugin( PLUGIN )