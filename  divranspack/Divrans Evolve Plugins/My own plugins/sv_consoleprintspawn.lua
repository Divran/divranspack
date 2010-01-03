/*-------------------------------------------------------------------------------------------------------------------------
	Prints a message to console whenever someone spawns something
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = { }
PLUGIN.Title = "Message Print"
PLUGIN.Description = "Prints a message to console whenever someone spawns something."
PLUGIN.Author = "Divran"
PLUGIN.ChatCommand = "!conmsg"
PLUGIN.Usage = "1/0"
PLUGIN.Enabled = true

function PLUGIN:Call( ply, args )
	if ( ply:EV_IsOwner() ) then
		self.Enabled = util.tobool( args[1] )
		evolve:Notify( ply, evolve.colors.blue, "Message print ", evolve.colors.white, "set to: ", evolve.colors.red, tostring(self.Enabled) )
	else
		evolve:Notify( ply, evolve.colors.red, evolve.constants.notallowed )
	end
end

function PLUGIN:PlayerSpawnedProp( ply, mdl ) if (self.Enabled) then print("[EV] " .. ply:Nick() .. " ("..ply:SteamID()..") spawned a prop. Model: " .. mdl) end end
function PLUGIN:PlayerSpawnedVehicle( ply, obj ) if (self.Enabled) then print("[EV] " .. ply:Nick() .. " ("..ply:SteamID()..") spawned a vehicle. Model: " .. obj:GetModel()) end end
function PLUGIN:PlayerSpawnedNPC( ply, npc ) if (self.Enabled) then print("[EV] " .. ply:Nick() .. " ("..ply:SteamID()..") spawned an NPC. Model: " .. npc:GetModel()) end end
function PLUGIN:PlayerSpawnedEffect( ply, mdl ) if (self.Enabled) then print("[EV] " .. ply:Nick() .. " ("..ply:SteamID()..") spawned an effect. Model: " .. mdl) end end
function PLUGIN:PlayerSpawnedRagdoll( ply, mdl ) if (self.Enabled) then print("[EV] " .. ply:Nick() .. " ("..ply:SteamID()..") spawned a ragdoll. Model: " .. mdl) end end
function PLUGIN:PlayerSpawnedSENT( ply, obj ) if (self.Enabled) then print("[EV] " .. ply:Nick() .. " ("..ply:SteamID()..") spawned an entity. Type: " .. obj:GetClass()) end end
	
evolve:RegisterPlugin( PLUGIN )