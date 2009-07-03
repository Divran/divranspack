-------------------------------------------------------------------------------------------------------------------------
-- Ban
-------------------------------------------------------------------------------------------------------------------------
local DmodPlugin = {}
DmodPlugin.ChatCommand = "ban" -- The chat command you need to use this plugin
DmodPlugin.Name = "Ban" -- The name of the plugin
DmodPlugin.Description = "" -- The description shown in the Menu
DmodPlugin.ShowInMenu = false -- Do you want this plugin to be shown in the menu at all?
DmodPlugin.Creator = "Divran" -- Who created it?
if SERVER then Dmod_AddPlugin(DmodPlugin) else Dmod_ClientAddPlugin(DmodPlugin) end


local function Dmod_Ban( ply, Args )
	if (Args[2]) then
		if (Dmod_FindPlayer(Args[2])) then
			if (Args[3] and tonumber(Args[3])) then
				local T = Dmod_FindPlayer(Args[2])
				local Time = tonumber(Args[3])
				local Reason = Dmod_GetReason(Args, 4)
				T:Ban(Time, Reason)
				T:Kick("You've been banned. Reason: '" .. Reason .. "', for " .. Time .. " minutes.")		
				Dmod_Message(true, ply, ply:Nick() .. " banned " .. T:Nick() .. " with the reason '" .. Reason .. "' for " .. Time .. " minutes.")
			else
				Dmod_Message(false, ply, "You must enter a time!")
			end
		else
			Dmod_Message(false, ply, "No player named '"..Args[2].."' found.")
		end
	else
		Dmod_Message( false, ply, "You must enter a name!")
	end
end
hook.Add( DmodPlugin.Name, DmodPlugin.Name, Dmod_Ban )