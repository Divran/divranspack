/*-------------------------------------------------------------------------------------------------------------------------
	Give admins unlimited everything
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = { }
PLUGIN.Title = "Admin Unlimited"
PLUGIN.Description = "Give Admins unlimited everything."
PLUGIN.Author = "Divran"
PLUGIN.ChatCommand = "adminu"
PLUGIN.Usage = "[1/0]"
PLUGIN.AdminUnlimited = 0
function PLUGIN:Call( ply, args )
	if ( ply:EV_IsAdmin( ) ) then
		if (args[1] == "0") then 
			self.AdminUnlimited = 0
			evolve:notify( evolve.colors.blue, ply:Nick( ), evolve.colors.red, " disabled", evolve.colors.white, " unlimited everything for admins." )
		else
			self.AdminUnlimited = 1
			evolve:notify( evolve.colors.blue, ply:Nick( ), evolve.colors.red, " enabled", evolve.colors.white, " unlimited everything for admins." )
		end
	else
		evolve:notify( ply, evolve.colors.red, evolve.constants.notallowed )
	end
end

-- Limit Checker
local function EV_LimitCheck( ply, String )
	local Count = server_settings.Int( "sbox_max"..String, -1 )
	if ( ply:EV_IsAdmin( ) and PLUGIN.AdminUnlimited == 1) then
		return true
	elseif (ply:GetCount(String) < Count or Count == -1) then 
		return true 
	else
		ply:LimitHit(String)
		return false
	end
end


timer.Simple( 1, function()
	-- The spawn functions
	local function GAMEMODE:PlayerSpawnProp( ply, mdl ) return EV_LimitCheck( ply, "props" ) end
	local function GAMEMODE:PlayerSpawnVehicle( ply, mdl ) return EV_LimitCheck( ply, "vehicles" ) end
	local function GAMEMODE:PlayerSpawnNPC( ply, mdl ) return EV_LimitCheck( ply, "npcs" ) end
	local function GAMEMODE:PlayerSpawnEffect( ply, mdl ) return EV_LimitCheck( ply, "effects" ) end
	local function GAMEMODE:PlayerSpawnRagdoll( ply, mdl ) return EV_LimitCheck( ply, "ragdolls" ) end 
	--function GAMEMODE:PlayerSpawnSENT( ply, name ) return EV_LimitCheck( ply, "sents") end
	-- Override the CheckLimit function
	local meta = FindMetaTable("Player")
	if (meta) then
		function meta:CheckLimit( String )
			local Count = server_settings.Int( "sbox_max"..String, -1 )
			if (self:EV_IsAdmin() and PLUGIN.AdminUnlimited == 1) then
				return true
			elseif (Count == -1) then 
				return true 
			elseif (self:GetCount( String ) > Count - 1) then 
				self:LimitHit( String )
				return false
			end
		end
	end
end)

function PLUGIN:Menu( arg, players )
	if ( arg ) then
		table.insert( players, arg )
		RunConsoleCommand( "ev", "adminu", unpack( players ) )
	else
		return "Admin Unlimited", evolve.category.administration, { { "Enable", "1" }, { "Disable", "0" } }
	end
end

evolve:registerPlugin( PLUGIN )