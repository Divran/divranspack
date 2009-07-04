-------------------------------------------------------------------------------------------------------------------------
-- Health
-------------------------------------------------------------------------------------------------------------------------
local DmodPlugin = {}
DmodPlugin.ChatCommand = "hp" -- The chat command you need to use this plugin
DmodPlugin.Name = "Health" -- The name of the plugin
DmodPlugin.Description = "Set the health of someone." -- The description shown in the Menu
DmodPlugin.ShowInMenu = true -- Do you want this plugin to be shown in the menu at all?
DmodPlugin.Creator = "Divran" -- Who created it?
DmodPlugin.RequiredRank = "admin" -- The rank required to use this command. Can be "guest", "admin", "super admin", or "owner".
if SERVER then Dmod_AddPlugin(DmodPlugin) else Dmod_ClientAddPlugin(DmodPlugin) end


local function Dmod_Health( ply, Args )
if (Dmod_CheckRequiredRank(ply, DmodPlugin.RequiredRank)) then
	if (Args[2]) then
		if (Dmod_FindPlayer(Args[2])) then
			local T = Dmod_FindPlayer(Args[2])
			local Value = 100
			if (Args[3]) then Value = math.Clamp(tonumber(Args[3]), 1, 99999) end
			T:SetHealth(Value)
			Dmod_Message(true, ply, ply:Nick() .. " set " .. T:Nick() .. "'s health to " .. Value )
		else
			Dmod_Message(false, ply, "No player named '".. Args[2].."' found.")
		end
	else
		Dmod_Message(false, ply, "You must enter a name!" )
	end
end
end
hook.Add( DmodPlugin.Name, DmodPlugin.Name, Dmod_Health)