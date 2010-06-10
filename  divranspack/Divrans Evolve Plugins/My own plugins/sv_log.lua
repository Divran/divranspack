/*-------------------------------------------------------------------------------------------------------------------------
	Logs chat & errors etc
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Log"
PLUGIN.Description = "Log"
PLUGIN.Author = "Divran"
PLUGIN.ChatCommand = nil
PLUGIN.Usage = nil
PLUGIN.Privileges = nil
PLUGIN.CurrentFile = "evolve/logs/PLACEHOLDER.txt"

function PLUGIN:Append( str )
	if (!file.Exists(self.CurrentFile)) then
		self:GetCurrentFile()
	end
	
	local curstr = file.Read(self.CurrentFile)
	file.Write(self.CurrentFile,curstr..str)
end

function PLUGIN:Initialize()
	self:GetCurrentFile()
	timer.Create("evolve_log_check",600,0,function()
		PLUGIN:GetCurrentFile(true)
	end)
	
	self:Append("\n=====[ SERVER LAUNCHED ]====="..
				"\nDate: " .. os.date( "[%X] - (%d/%m/%Y) - (%A, %B)", os.time() ) ..
				"\nServer name: '" .. GetConVar("hostname"):GetString() .. "'\n")
	
	self.OldFunc = evolve.Notify
	function evolve:Notify( ... )
		local arg = {...}
		local ply
		if (type(arg[1]) == "Player") then ply = arg[1] end
		
		local time = os.date( "[%X]", os.time() )
		
		local str = ""
		for k,v in ipairs( arg ) do
			if (type(v) == "string") then
				str = str .. v
			end
		end
		
		if (ply) then str = ply:Nick() .. "(" .. ply:SteamID() .. ") -> " .. str end
		PLUGIN:Append("\n[EV] "..time.." "..str)
		
		PLUGIN.OldFunc( evolve, ... )
	end
end

function PLUGIN:ShutDown()
	self:Append("\n\nDate: " .. os.date( "[%X] - (%d/%m/%Y) - (%A, %B)", os.time() ) ..
				"\n=====[ SERVER SHUTTING DOWN ]====\n\n")
end
			

function PLUGIN:GetCurrentFile(NewDay)
	local monthyear = os.date( "%m-%Y", os.time() )
	local daymonth = os.date( "%d-%m", os.time() )
	if (!file.Exists("evolve/logs/"..monthyear.."/"..daymonth..".txt")) then
		file.Write("evolve/logs/"..monthyear.."/"..daymonth..".txt","\n=====[ LOG FILE CREATED ]=====\n")
	end
	local OldFile = self.CurrentFile
	self.CurrentFile = "evolve/logs/"..monthyear.."/"..daymonth..".txt"
	if (NewDay == true) then
		if (OldFile != self.CurrentFile) then
			self:Append("\n\n=====[ LOG CONTINUED FROM PREVIOUS DAY ]====\n"..
						"\nDate: " .. os.date( "[%X] - (%d/%m/%Y) - (%A, %B)", os.time() ) ..
						"\nServer name: '" .. GetConVar("hostname"):GetString() .. "'\n\n")
		end
	end
end

function PLUGIN:PlayerSay(ply,txt)
	local time = os.date( "[%X]", os.time() )
	self:Append("\n"..time.." "..ply:Nick().." (" .. ply:SteamID() .. "): "..txt)
end

function PLUGIN:SpawnedObj( ply, obj )
	local time = os.date( "[%X]", os.time() )
	self:Append("\n[EV] " .. time .. " " .. ply:Nick() .. " (" .. ply:SteamID() .. ") spawned (" .. obj:GetClass() .. ") " .. obj:GetModel() )
end

function PLUGIN:PlayerSpawnedProp( ply, mdl, obj ) self:SpawnedObj( ply, obj ) end
function PLUGIN:PlayerSpawnedVehicle( ply, obj ) self:SpawnedObj( ply, obj ) end
function PLUGIN:PlayerSpawnedNPC( ply, npc ) self:SpawnedObj( ply, npc ) end
function PLUGIN:PlayerSpawnedEffect( ply, mdl, obj ) self:SpawnedObj( ply, obj ) end
function PLUGIN:PlayerSpawnedRagdoll( ply, mdl, obj ) self:SpawnedObj( ply, obj ) end
function PLUGIN:PlayerSpawnedSENT( ply, obj ) self:SpawnedObj( ply, obj ) end

evolve:RegisterPlugin( PLUGIN )