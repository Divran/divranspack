-------------------------------------------------------------------------------------------------------------------------
-- Jump Power
-------------------------------------------------------------------------------------------------------------------------
local DmodPlugin = {}
DmodPlugin.ChatCommand = "jump" -- The chat command you need to use this plugin
DmodPlugin.Name = "Jump" -- The name of the plugin
DmodPlugin.Description = "Change the jump power of someone." -- The description shown in the Menu
DmodPlugin.ShowInMenu = true -- Do you want this plugin to be shown in the menu at all?
DmodPlugin.Creator = "Divran" -- Who created it?
if SERVER then Dmod_AddPlugin(DmodPlugin) else Dmod_ClientAddPlugin(DmodPlugin) end


local function Dmod_Jump( ply, Args )
	if (Args[2]) then
		if (Dmod_FindPlayer(Args[2])) then
			local T = Dmod_FindPlayer(Args[2])
			local Value = 160
			if (Args[3]) then Value = math.Clamp(tonumber(Args[3]), 1, 1000000000) end
			T:SetJumpPower(Value)
			Dmod_Message(true, ply, ply:Nick() .. " set " .. T:Nick() .. "'s  jump power to " .. Value )
		else
			Dmod_Message(false, ply, "No player named '".. Args[2].."' found.")
		end
	else
		Dmod_Message(false, ply, "You must enter a name!" )
	end
end
hook.Add( DmodPlugin.Name, DmodPlugin.Name, Dmod_Jump)