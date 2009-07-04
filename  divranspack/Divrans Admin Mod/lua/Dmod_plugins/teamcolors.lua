-------------------------------------------------------------------------------------------------------------------------
-- Team Colors
-------------------------------------------------------------------------------------------------------------------------
local DmodPlugin = {}
DmodPlugin.ChatCommand = "" -- The chat command you need to use this plugin
DmodPlugin.Name = "" -- The name of the plugin
DmodPlugin.Description = "" -- The description shown in the Menu
DmodPlugin.ShowInMenu = false -- Do you want this plugin to be shown in the menu at all?
DmodPlugin.Creator = "Divran" -- Who created it?
DmodPlugin.RequiredRank = "" -- The rank required to use this command. Can be "guest", "admin", "super admin", or "owner".
if SERVER then Dmod_AddPlugin(DmodPlugin) else Dmod_ClientAddPlugin(DmodPlugin) end

if SERVER then
	--Player Spawn
	function Dmod_TeamColors( ply )
		timer.Simple( 0.2, function()
		-- PUT YOUR STEAM ID HERE TO BECOME OWNER:
			if (ply:SteamID() == "STEAM_0:0:9583907") then
				ply:SetTeam(1)
			elseif (ply:IsSuperAdmin()) then
				ply:SetTeam(2)
			elseif (ply:IsAdmin()) then
				ply:SetTeam(3)
			else
				ply:SetTeam(4)
			end
		end)
	end
	hook.Add( "PlayerSpawn", "Dmod_TeamColors", Dmod_TeamColors )
end
	
	-- Change color and Name in Scoreboard here, if you want.
team.SetUp(1, "Owner", Color( 50, 50, 50, 255 )) -- Black (Well, almost)
team.SetUp(2, "Super Admin", Color( 255, 200, 0, 255 )) -- Gold
team.SetUp(3, "Admin", Color(200, 80, 80, 255 )	) -- Dark Red
team.SetUp(4, "Guest", Color( 100, 100, 255, 255 )) -- Dark Blue