-------------------------------------------------------------------------------------------------------------------------
-- Custom Vote
-------------------------------------------------------------------------------------------------------------------------
local DmodPlugin = {}
DmodPlugin.ChatCommand = "vote" -- The chat command you need to use this plugin
DmodPlugin.Name = "Custom Vote" -- The name of the plugin
DmodPlugin.Description = "" -- The description shown in the Menu
DmodPlugin.ShowInMenu = false -- Do you want this plugin to be shown in the menu at all?
DmodPlugin.Type = "" -- Where in the Menu will it show?
DmodPlugin.Creator = "Divran" -- Who created it?
DmodPlugin.RequiredRank = "admin" -- The rank required to use this command. Can be "guest", "admin", "super admin", or "owner".
if SERVER then Dmod_AddPlugin(DmodPlugin) else Dmod_ClientAddPlugin(DmodPlugin) end


local function Dmod_Plugin( ply, Args )
if (Dmod_CheckRequiredRank(ply, DmodPlugin.RequiredRank)) then
	local SendString = table.concat( string.Explode( ",", table.concat( Args, " ", 2, table.Count(Args)) ), "_" )
	Dmod_StartCustomVote( SendString, ply )
end
end
hook.Add( DmodPlugin.Name, DmodPlugin.Name, Dmod_Plugin )

if SERVER then 

	function Dmod_StartCustomVote( Txt, ply )
	
		if (!Voting) then
			local VoteStrings = string.Explode( "_", Txt )
					local rf = RecipientFilter()
					rf:AddAllPlayers()
				umsg.Start( "Dmod_ClientStartVote", rf )
					umsg.Long( table.Count( VoteStrings ) )
					for K, S in pairs(VoteStrings) do
						umsg.String( S )
					end
				umsg.End()
				Dmod_Message( true, ply, ply:Nick() .. " started a custom vote!", "normal" )	
		else
			Dmod_Message( false, ply, "You are already voting!", "warning" )
		end
	end
	
end

	