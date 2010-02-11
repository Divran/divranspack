-- PewPew Weapon Handler
-- Takes care of adding and managing all the available bullets

-- Load all the bullet files
function pewpew:LoadBullets()
	pewpew.bullets = {}
	
	local bulletlist = file.FindInLua("PewPewBullets/*.lua")
	for _, blt in ipairs( bulletlist ) do
		include( "PewPewBullets/" .. blt )
		if (SERVER) then AddCSLuaFile( "PewPewBullets/" .. blt ) end
	end
end

-- Add the bullets to the bullet list
function pewpew:AddBullet( bullet )
	table.insert( self.bullets, bullet )
end

-- Allows you to find a bullet
function pewpew:GetBullet( BulletName )
	for _, blt in pairs( self.bullets ) do
		if (string.lower(blt.Name) == string.lower(BulletName)) then
			return blt
		end
	end
end