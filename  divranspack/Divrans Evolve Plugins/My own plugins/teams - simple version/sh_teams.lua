-------------------------------------------------------------------------------------------------------------------------
--	Simplified Team Colors
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = { }
PLUGIN.Title = "Simplified Team Colors"
PLUGIN.Description = "Gives the teams colors."
PLUGIN.Author = "Divran"
PLUGIN.ChatCommand = nil
PLUGIN.Usage = nil
PLUGIN.Teams = {}

	-- Change the settings here
	PLUGIN.Teams[1] = {
		Name = "Owner",
		Color = Color(50,50,50,255) -- Almost Black
	} 
	PLUGIN.Teams[2] = {
		Name = "Super Admin",
		Color = Color(255,200,0,255)  -- Gold
	}
	PLUGIN.Teams[3] = {
		Name = "Admin",
		Color = Color(200,80,80,255)  -- Dark Red
	}
	PLUGIN.Teams[4] = {
		Name = "Respected",
		Color = Color(100,200,100,255)  -- Dark Green
	}
	PLUGIN.Teams[5] = {
		Name="Guest",
		Color = Color(100,100,255,255) -- Dark Blue
	} 
	
	---------------------------------------------------------------------
	-- Don't change anything below here unless you know what you're doing
	
	for Nr, Tbl in pairs(PLUGIN.Teams) do
		team.SetUp( Nr, Tbl.Name, Tbl.Color )
	end
	
	if (SERVER) then
		function PLUGIN:EV_PlayerRankChanged(ply)
			self:SetTeam( ply, ply:EV_GetRank() )
		end

		function PLUGIN:PlayerInitialSpawn(ply)
			self:SetTeam( ply, ply:EV_GetRank() )
		end
		
		function PLUGIN:SetTeam( ply, TeamName )
			if 		(TeamName == "owner") then 		ply:SetTeam(1)
			elseif 	(TeamName == "superadmin") then ply:SetTeam(2)
			elseif 	(TeamName == "admin") then 		ply:SetTeam(3)
			elseif 	(TeamName == "respected") then 	ply:SetTeam(4)
			else									ply:SetTeam(5) end
		end
	end

evolve:RegisterPlugin( PLUGIN )