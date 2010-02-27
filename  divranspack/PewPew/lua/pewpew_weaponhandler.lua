-- PewPew Weapon Handler
-- Takes care of adding and managing all the available bullets

-- Load all the bullet files
function pewpew:LoadBullets()
	self.bullets = {}
	self.Categories = {}
	
	local bulletlist = file.FindInLua("PewPewBullets/*.lua")
	for _, blt in ipairs( bulletlist ) do
		include( "PewPewBullets/" .. blt )
		if (SERVER) then AddCSLuaFile( "PewPewBullets/" .. blt ) end
	end
end

-- Add the bullets to the bullet list
function pewpew:AddBullet( bullet )
	if (SERVER) then print("Added PewPew Bullet: " .. bullet.Name) end
	table.insert( self.bullets, bullet )
	if (!self.Categories[bullet.Category]) then
		self.Categories[bullet.Category] = {}
	end
	table.insert( self.Categories[bullet.Category], bullet.Name )
end

-- Allows you to find a bullet
function pewpew:GetBullet( BulletName )
	for _, blt in pairs( self.bullets ) do
		if (string.lower(blt.Name) == string.lower(BulletName)) then
			return blt
		end
	end
	return nil
end

------------------------------------------------------------------------------------------------------------

