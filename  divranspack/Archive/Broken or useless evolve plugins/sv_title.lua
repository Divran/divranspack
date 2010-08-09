/*-------------------------------------------------------------------------------------------------------------------------
	Custom Title
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = { }
PLUGIN.Title = "Custom Title"
PLUGIN.Description = "Custom Title."
PLUGIN.Author = "Divran"
PLUGIN.ChatCommand = "title"
PLUGIN.Usage = "[title]"

function PLUGIN:Call( ply, args )
	local title = string.Trim(table.concat(args, " "))
	if (title) then
		if (string.len(title) > 25) then title = string.Left(title,23) .. ".." end
		ply:SetProperty( "Title", title)
		ply:SetNWString( "EV_Title", title )
		evolve:SavePlayerInfo()
		if (string.Trim(title) != "") then
			evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " changed their title to ", evolve.colors.blue, title, evolve.colors.white, "." )
		else
			evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " removed their title." )
		end
	else
		evolve:Notify( ply, evolve.colors.red, "No title specified." )
	end
end

function PLUGIN:PlayerInitialSpawn( ply )
	local title = ply:GetProperty( "Title" )
	ply:SetNWString( "EV_Title", title)
end

evolve:RegisterPlugin( PLUGIN )