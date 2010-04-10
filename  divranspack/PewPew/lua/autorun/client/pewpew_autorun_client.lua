-- PewPew Autorun
-- Initialize variables
pewpew = {}

include("pewpew_weaponhandler.lua")

pewpew:LoadBullets()


-- If the client does not have PewPew installed, send the weapon list with datastream instead.
local function RecieveWeaponsList( handler, id, encoded, decoded )
	pewpew.Categories = decoded	
end
datastream.Hook("PewPew_WeaponsList",RecieveWeaponsList)

timer.Simple(1,function()
	if (!pewpew.Categories or table.Count(pewpew.Categories) == 0) then
		print("Client does not have PewPew installed.")
		RunConsoleCommand("PewPew_RequestWeaponsList")
		print("Weapons List Requested.")
	end
end)