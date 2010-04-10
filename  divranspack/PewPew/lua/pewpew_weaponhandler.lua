-- PewPew Weapon Handler
-- Takes care of adding and managing all the available bullets

-- Load all the bullet files
function pewpew:LoadBullets()
	self.bullets = {}
	self.Categories = {}
	
	self:LoadDirectory( "../lua/PewPewBullets" )
end

local CurrentCategory = ""

function pewpew:LoadDirectory( Dir )
	-- Get the dir used by include and AddCSLuaFile
	local includedir = string.sub( Dir, 7, -1 )
	
	-- Get the category
	CurrentCategory = string.Right( Dir, string.find( string.reverse( Dir ), "/", 1, true ) - 1 )
	if (CurrentCategory == "PewPewBullets") then CurrentCategory = "Other" end
	CurrentCategory = string.gsub( CurrentCategory, "_", " " )
	
	-- Load all files inside this directory
	local files = file.FindInLua( Dir .. "/*.lua" )
	for _, file in ipairs( files ) do
		if (SERVER) then AddCSLuaFile( includedir .. "/" .. file ) end
		include( includedir .. "/" .. file )
	end
	
	-- Load all folders inside this directory
	local folders = file.FindDir( Dir .. "/*" )
	for _, folder in ipairs( folders ) do
		self:LoadDirectory( Dir .. "/" .. folder )
	end
end

-- Add the bullets to the bullet list
function pewpew:AddBullet( bullet )
	if (SERVER) then print("Added PewPew Bullet: " .. bullet.Name) end
	table.insert( self.bullets, bullet )
	if (!self.Categories[CurrentCategory]) then
		self.Categories[CurrentCategory] = {}
	end
	bullet.Category = CurrentCategory
	table.insert( self.Categories[CurrentCategory], bullet.Name )
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

-- Development number (this function doesn't quite work correctly yet)
function pewpew:DevNum( BulletName )
	local bullet = self:GetBullet( BulletName )
	if (bullet) then
		-- Basics
		local dmg = bullet.Damage or 0
		local rld = bullet.Reloadtime or 1
		if (rld == 0) then rld = 1 end
		local ammo = bullet.Ammo or 0
		local rldammo = bullet.AmmoReloadtime or 1
		if (rldammo == 0) then rldammo = 1 end
		local ret = (dmg * (1/rld)) - (ammo * (1/rldammo)) * 15
		
		-- Special
		local special = 0
		special = special - (bullet.Spread or 0) * 10
		special = special - (bullet.Gravity or 0) * 20
		special = special + (bullet.Speed or 0)
		if (bullet.Lifetime) then
			special = special - (((bullet.Lifetime[1] or 0)+(bullet.Lifetime[2] or 0))/2) * 10
			if (bullet.ExplodeAfterDeath) then special = special + 25 end
		end
		
		
		-- Damage Types
		if (bullet.DamageType == "BlastDamage") then
			special = special + dmg * (bullet.RangeDamageMul or 0) / 5
			special = special + (bullet.Radius or 0) / 6
		elseif (bullet.DamageType == "SliceDamage") then
			special = special + (bullet.NumberOfSlices or 1) * 35
		elseif (bullet.DamageType == "EMPDamage") then
			special = special + (bullet.Duration or 0) * 25
			special = special + (bullet.Radius or 0) / 8
		end
			
		ret = ret + special
		return ret
	end
	return 0
end

------------------------------------------------------------------------------------------------------------

