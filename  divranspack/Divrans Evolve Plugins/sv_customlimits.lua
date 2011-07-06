/*-------------------------------------------------------------------------------------------------------------------------
	Custom limits for each prop model
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Custom Limits"
PLUGIN.Description = "Custom Limits"
PLUGIN.Author = "Divran"

-- Enter part of the model to block all models containing this string
-- Or enter the full model path to block that specific model
-- You can use Lua Pattners to narrow the parameters even more.
--[[ Table format:
	{ 	model/class = <string> Model file path,
		limit = <number> Max nr of props with this model per player
		saveas = <string> All limits with the same "saveas" will share max limit. If it has a limit of 0 or -1, this info isn't necessary
		ranks = <table> List ranks this limit should affect
	},
]]

-- rank shortcuts
local RANKS_GUEST = { { ["guest"] = true }
local RANKS_ALL = { ["guest"] = true, ["admin"] = true, ["superadmin"] = true, ["owner"] = true }
local RANKS_ADMINS = { ["admin"] = true, ["superadmin"] = true, ["owner"] = true }

-- Limits shortcuts
local LIMITS_EXPLOSIVE = 3
local LIMITS_BIGPROPS = 5

-- What to save it as shortcuts
local SAVEAS_EXPLOSIVE = "explosives"
local SAVEAS_BIGPROPS = "big props"

local BlockedModels = { -- Props, ragdolls & effects
	{ 	model = "explosive", 
		limit = LIMITS_EXPLOSIVE,
		saveas = SAVEAS_EXPLOSIVE,
		ranks = RANKS_GUEST }, 
	
	{ 	model = "models/props_phx/huge/evildisc_corp.mdl", 
		limit = LIMITS_EXPLOSIVE,
		saveas = SAVEAS_BIGPROPS,
		ranks = RANKS_GUEST },
	
	-- Now to block all other explosive props which don't have "explosive" in them..
	{	model = "models/props_phx/misc/flakshell_big.mdl",
		limit = LIMITS_BIGPROPS, 
		saveas = SAVEAS_EXPLOSIVE,
		ranks = RANKS_GUEST },
	{	model = "models/props_phx/ball.mdl",
		limit = LIMITS_EXPLOSIVE, 
		saveas = SAVEAS_EXPLOSIVE,
		ranks = RANKS_GUEST },
	{	model = "models/props_phx/amraam.mdl",
		limit = LIMITS_EXPLOSIVE, 
		saveas = SAVEAS_EXPLOSIVE,
		ranks = RANKS_GUEST },
	{	model = "models/props_phx/ww2bomb.mdl",
		limit = LIMITS_EXPLOSIVE, 
		saveas = SAVEAS_EXPLOSIVE,
		ranks = RANKS_GUEST },
	{	model = "models/props_phx/torpedo.mdl",
		limit = LIMITS_EXPLOSIVE, 
		saveas = SAVEAS_EXPLOSIVE,
		ranks = RANKS_GUEST },
		
	{	model = "models/Effects/splode.mdl", -- Block the explode effect (just an example)
		limit = 0, -- 0 to block it completely
		ranks = RANKS_GUEST },
	
	{	model = "models/props_phx/amraam.mdl", -- Infinite amraams for admins, yay (just an example)
		limit = -1, -- -1 to allow infinite spawns
		ranks = RANKS_ADMINS },
	 
}

-- Enter part of the entity class to block all entities containing that string
-- Or enter the full model path to block that specific model
-- You can use Lua Patterns to narrow the parameters even more. For example,
-- "^gmod_wire" will block all entities whose class begin with "gmod_wire" (because the "^" symbol makes it find the string at the beginning only)
local BlockedClasses = { -- Entities, weapons, & vehicles
	{ 	class = "jeep", -- Block both jeeps (both the HL2 & EP2 ones) (just an example)
		limit = 0,
		ranks = RANKS_GUEST },
		
		
	{	class = "sent_ball", -- custom limit for balls (just an example)
		limit = 5,
		saveas = "ballz :D",
		ranks = RANKS_ALL, }
}

-------------------------------------------------------------------------------------------------------------------------------------------------
-- Don't modify anything below here unless you know what you're doing.


local Limits = {}

local string_find = string.find

local function Find( tbl, str )
	for _,v in pairs( tbl ) do
		local model = v.model or v.class
		if string_find( str, model ) then
			return v
		end
	end
end

local function Check( ply, tbl, str )
	local data = Find( tbl, str )
	if data then
		local ranks = data.ranks
		if ranks[ply:EV_GetRank()] then
			local limit = data.limit
			if limit == -1 then
				return true
			elseif limit == 0 then
				evolve:Notify( ply, evolve.colors.red, "This object has been blocked ('" .. (data.saveas or str) .. "')!" )
				return false
			else
				local saveas = data.saveas
				
				local uid = ply:UniqueID()
				
				if not Limits[uid] then Limits[uid] = {} end
				if not Limits[uid][saveas] then Limits[uid][saveas] = 0 end
				
				if Limits[uid][saveas] >= limit then
					evolve:Notify( ply, evolve.colors.red, "You have reached the limit for this object (Limit: " .. limit .. " Object: '" .. saveas .. "')!" )
					return false
				end
				
				Limits[uid][saveas] = Limits[uid][saveas] + 1
			end
		end
	end
end

local function CheckObjects( ply, mdl )
	local ret = Check( ply, BlockedModels, mdl )
	return ret
end

local function CheckEntities( ply, class )
	local ret = Check( ply, BlockedClasses, class )
	return ret
end

local function CheckVehicles( ply, class, name, vehtbl )
	local ret = Check( ply, BlockedClasses, vehtbl.Class )
	return ret
end

hook.Add( "PlayerSpawnSENT", "EV_CustomLimits_SpawnSENT", CheckEntities ) -- Entities
hook.Add( "PlayerSpawnSWEP", "EV_CustomLimits_SpawnSWEP", CheckEntities ) -- Weapons
hook.Add( "PlayerSpawnVehicle", "EV_CustomLimits_SpawnVehicle", CheckVehicles ) -- Vehicles
hook.Add( "PlayerSpawnObject", "EV_CustomLimits_SpawnObject", CheckObjects ) -- Props, ragdolls, & effects

local function CheckRemoving( ent )
	if not ent.EV_Owner then return end
	
	if ent:GetClass() == "prop_physics" or ent:GetClass() == "prop_effect" then
		local data = Find( BlockedModels, ent:GetModel() )
		if data and data.limit ~= 0 and data.limit ~= -1 and data.saveas then
			if Limits[ent.EV_Owner] then
				local plylimit = Limits[ent.EV_Owner]
				if plylimit[data.saveas] then
					plylimit[data.saveas] = plylimit[data.saveas] - 1
					
					if plylimit[data.saveas] <= 0 then plylimit[data.saveas] = nil end
				end
			end
		end
	else
		local data = Find( BlockedClasses, ent:GetClass() )
		if data and data.limit ~= 0 and data.limit ~= -1 and data.saveas then
			if Limits[ent.EV_Owner] then
				local plylimit = Limits[ent.EV_Owner]
				if plylimit[data.saveas] then
					plylimit[data.saveas] = plylimit[data.saveas] - 1
					
					if plylimit[data.saveas] <= 0 then plylimit[data.saveas] = nil end
				end
			end
		end
	end
end 

hook.Add( "EntityRemoved", "EV_CustomLimits_Remove", CheckRemoving ) -- Removing stuff

evolve:RegisterPlugin( PLUGIN )