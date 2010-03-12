-------------------------------------------------------------------------------------------------------------------------
-- Custom Spawn Point
-- Made by Divran
-------------------------------------------------------------------------------------------------------------------------
local MapList = {}
-------------------------------------------------------------------------------------------------------------------------
-- How to add your own custom spawn point:
-- Copy this (Without the "/*" and "*/"!!)
/*
local Map1 = {}
Map1.Name = "gm_flatgrass"
Map1.DefaultPos = Vector(0,0,0)
Map1.SuperAdminPos = nil
Map1.AdminPos = nil
Map1.GuestPos = nil
table.insert( MapList, Map1 )
*/
-- Paste it below.
-- Change the number 1 in "Map1", and change the map name and the Vectors.
-- A good way to get the vectors is by going ingame and typing "getpos" in console.
-- If you set a Vector to "nil", it will cause the players of that rank to spawn at the DefaultPos position instead.
-------------------------------------------------------------------------------------------------------------------------
-- Example level. Sets Super Admins to spawn on Coruscant, Admins on Kobol, and guests in the bunker on Hiigara.
local Map1 = {}
Map1.Name = "sb_gooniverse"
Map1.DefaultPos = nil
Map1.SuperAdminPos = Vector(-233, 367, 4688)
Map1.AdminPos = Vector(10577, 11032, 4672)
Map1.GuestPos = Vector(-11241, -2505, -8030)
table.insert( MapList, Map1 )


function CustomSpawnPoint( ply )
	for k,v in pairs(MapList) do
		if (string.find( string.lower(game.GetMap()), MapList[k].Name )) then
			-- Check if Super Admin
			if (ply:IsSuperAdmin()) then
				if (MapList[k].SuperAdminPos == nil) then
					-- Spawn at DefaultPos if it isn't nil. If it is nil, spawn at the MAP'S Default spawn point.
					if (MapList[k].DefaultPos != nil) then ply:SetPos( MapList[k].DefaultPos ) end
				else
					-- Spawn at SuperAdminPos
					ply:SetPos( MapList[k].SuperAdminPos )
				end
			-- Check if Admin
			elseif (ply:IsAdmin()) then
				if (MapList[k].AdminPos == nil) then
					-- Spawn at DefaultPos if it isn't nil. If it is nil, spawn at the MAP'S Default spawn point.
					if (MapList[k].DefaultPos != nil) then ply:SetPos( MapList[k].DefaultPos ) end
				else
					-- Spawn at AdminPos
					ply:SetPos( MapList[k].AdminPos )
				end
			-- Else if Guest
			else
				if (MapList[k].GuestPos == nil) then
					-- Spawn at DefaultPos if it isn't nil. If it is nil, spawn at the MAP'S Default spawn point.
					if (MapList[k].DefaultPos != nil) then ply:SetPos( MapList[k].DefaultPos ) end
				else
					-- Spawn at GuestPos
					ply:SetPos( MapList[k].GuestPos )
				end
			end
		end
	end
end
hook.Add( "PlayerSpawn", "CustomSpawnPoint", CustomSpawnPoint )