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
		function PLUGIN:EV_PlayerRankChanged( ply )
			self:Team( ply )
		end

		function PLUGIN:PlayerInitialSpawn( ply )
			self:Team( ply )
		end
		
		-- this is temporary until overv fixes PlayerRankChanged
		function PLUGIN:PlayerSpawn( ply )
			self:Team( ply )
		end
		
		function PLUGIN:Team( ply )
			timer.Create("ev_teamchange"..CurTime(),0.5,1,function(ply)
				local Rank = 5
				if (ply:EV_IsOwner()) then
					Rank = 1
				elseif (ply:EV_IsSuperAdmin()) then
					Rank = 2
				elseif (ply:EV_IsAdmin()) then
					Rank = 3
				elseif (ply:EV_IsRespected()) then
					Rank = 4
				end
				ply:SetTeam(Rank) 
			end, ply)
		end
	end

evolve:RegisterPlugin( PLUGIN )