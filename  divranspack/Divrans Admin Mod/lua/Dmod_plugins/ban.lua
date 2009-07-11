-------------------------------------------------------------------------------------------------------------------------
-- Ban
-------------------------------------------------------------------------------------------------------------------------
local DmodPlugin = {}
DmodPlugin.ChatCommand = "ban" -- The chat command you need to use this plugin
DmodPlugin.Name = "Ban" -- The name of the plugin
DmodPlugin.Description = "Ban someone from the server. Syntax example: '!ban <name> <time> <reason>'" -- The description shown in the Menu
DmodPlugin.ShowInMenu = false -- Do you want this plugin to be shown in the menu at all?
DmodPlugin.Type = ""  -- Where in the Menu will it show?
DmodPlugin.Creator = "Divran" -- Who created it?
DmodPlugin.RequiredRank = "Admin" -- The rank required to use this command. Can be "Guest", "Respected", "Admin", "Super Admin", or "Owner".
if SERVER then Dmod_AddPlugin(DmodPlugin) else Dmod_ClientAddPlugin(DmodPlugin) end


local function Dmod_Plugin( ply, Args )
if (Dmod_CheckRequiredRank(ply, DmodPlugin.RequiredRank)) then
	if (Args[2]) then
		if (Dmod_FindPlayer(Args[2])) then
			if (Args[3] and tonumber(Args[3])) then
				local T = Dmod_FindPlayer(Args[2])
				local Time = tonumber(Args[3])
				local Reason = Dmod_GetReason(Args, 4)
				T:Ban(Time, Reason)
				T:Kick("You've been banned. Reason: '" .. Reason .. "', for " .. Time .. " minutes.")		
				Dmod_Message(true, ply, ply:Nick() .. " banned " .. T:Nick() .. " with the reason '" .. Reason .. "' for " .. Time .. " minutes.", "punish")
			else
				Dmod_Message(false, ply, "You must enter a time!","warning")
			end
		else
			Dmod_Message(false, ply, "No player named '"..Args[2].."' found.","warning")
		end
	else
		Dmod_Message( false, ply, "You must enter a name!","warning")
	end
end
end
hook.Add( DmodPlugin.Name, DmodPlugin.Name, Dmod_Plugin )