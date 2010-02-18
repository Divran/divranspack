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
	print("Added PewPew Bullet: " .. bullet.Name)
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


if (SERVER) then

	-- Toggle Damage
	local function ToggleDamage( ply, command, arg )
		if ( !ply or !ply:IsValid() ) then return end
		if ( !ply:IsAdmin() ) then return end
		pewpew.PewPewDamage = !pewpew.PewPewDamage
		if (pewpew.PewPewDamage) then
			for _, v in pairs( player.GetAll() ) do
				v:ChatPrint( ply:Nick() .. " has toggled PewPew Damage and it is now ON!")
			end
		else
			for _, v in pairs( player.GetAll() ) do
				v:ChatPrint( ply:Nick() .. " has toggled PewPew Damage and it is now OFF!")
			end
		end
	end
	
	-- Toggle Firing
	local function ToggleFiring( ply, command, arg )
		if ( !ply or !ply:IsValid() ) then return end
		if ( !ply:IsAdmin() ) then return end
		pewpew.PewPewFiring = !pewpew.PewPewFiring
		if (pewpew.PewPewFiring) then
			for _, v in pairs( player.GetAll() ) do
				v:ChatPrint( ply:Nick() .. " has toggled PewPew Firing and it is now ON!")
			end
		else
			for _, v in pairs( player.GetAll() ) do
				v:ChatPrint( ply:Nick() .. " has toggled PewPew Firing and it is now OFF!")
			end
		end
	end
	
end

concommand.Add("PewPew_ToggleDamage", ToggleDamage)
concommand.Add("PewPew_ToggleFiring", ToggleFiring)
