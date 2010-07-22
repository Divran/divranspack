-- Pewpew ConVars
-- These functions manage convars
------------------------------------------------------------------------------------------------------------

pewpew.ConVars = {}

function pewpew:CreateConVar( ConVar, Type, Value, Message, MessageOn, MessageOff )
	if (type(Value) == "boolean") then
		if (Value == true) then Value = "1" else Value = "0" end
	end
	if (type(Value) != "string") then Value = tostring(Value) end
	print("Created convar","PewPew_"..ConVar,"with value:",Value,"and type:",Type)
	self.ConVars[ConVar] = {}
	--if (ConVarExists("PewPew_"..ConVar)) then
	--	self.ConVars[ConVar].Var = GetConVar( "PewPew_" .. ConVar )
	--else
		self.ConVars[ConVar].Var = CreateConVar( "PewPew_" .. ConVar, Value, { FCVAR_ARCHIVE, FCVAR_SERVER_CAN_EXECUTE, FCVAR_GAMEDLL } )
	--end
	self.ConVars[ConVar].Type = Type
	cvars.AddChangeCallback( "PewPew_" .. ConVar, function( CVar, PreviousValue, NewValue )
		PrintTable(CVar)
		for _,v in ipairs( player.GetAll() ) do
			v:ChatPrint("[PewPew] '" .. ConVar .. "' changed from " .. PreviousValue .. " to " .. NewValue .. ".")
		end
	end)
end

--function pewpew:CreateConVar( ConVar, Value, Message, MessageOn, MessageOff )
--	self.ConVars[ConVar] = { Val = Value, Message = Message, MessageOn = MessageOn, MessageOff = MessageOff }	
--end

function pewpew:GetConVar( ConVar )
	print("Trying to get convar:",ConVar)
	if (self.ConVars[ConVar]) then
		print("It exists")
		if (!self.ConVars[ConVar].Var) then error("[PewPew] ConVar error. Var is nil!") end
		local Type = self.ConVars[ConVar].Type
		if (Type == "bool") then
			print("It was a bool")
			return self.ConVars[ConVar].Var:GetBool()
		elseif (Type == "int") then
			print("It was an int")
			return self.ConVars[ConVar].Var:GetInt()
		elseif (Type == "float") then
			print("It was a float")
			return self.ConVars[ConVar].Var:GetFloat()
		end
	end
	print("It does not exist")
	--if (self.ConVars[ConVar]) then
	--	return self.ConVars[ConVar].Val
	--end
	--return false
end

pewpew:CreateConVar( "Damage", "bool", true )
pewpew:CreateConVar( "Firing", "bool", true )
pewpew:CreateConVar( "Numpads", "bool", true )
pewpew:CreateConVar( "DamageMul", "float", 1 )
pewpew:CreateConVar( "RepairToolHeal", "float", 75 )
pewpew:CreateConVar( "EnergyUsage", "bool", ((CAF and CAF.GetAddon("Life Support") and CAF.GetAddon("Resource Distribution")) == true) )
pewpew:CreateConVar( "WeaponDesigner", "bool", false )


--[[

pewpew:GetConVar( "Numpads" ) = true
pewpew:GetConVar( "DamageMul" ) = 1
pewpew:GetConVar( "CoreDamageMul" ) = 1
pewpew:GetConVar( "CoreDamageOnly" ) = false
pewpew:GetConVar( "RepairToolHeal" ) = 75
pewpew:GetConVar( "RepairToolHealCores" ) = 200
pewpew:GetConVar( "EnergyUsage" ) = false
pewpew:GetConVar( "PropProtDamage" ) = false
pewpew:GetConVar( "WeaponDesigner" ) = false

if (CAF and CAF.GetAddon("Resource Distribution") and CAF.GetAddon("Life Support")) then
	pewpew:GetConVar( "EnergyUsage" ) = true
end
]]

--[[
function pewpew:FindConVar( Index )
	for k,v in pairs( self.ConVars ) do
		if (string.lower(k) == string.lower(Index)) then
			return v
		end
	end
end


local function CheckConVar( ply, cmd, args )
	if (!ply:IsValid() or ply:IsAdmin()) then
		local command = args[1]
		if (command) then
			local conv = (pewpew.ConVars[command] or pewpew:FindConVar( command )) or false
			if (conv) then
				local nr = args[2]
				if (nr) then
					local bool = util.tobool(nr)
					local OldSetting = conv.Val
					conv.Val = bool
					if (OldSetting != conv.Val) then
						local name = "Console"
						if (ply:IsValid()) then name = ply:Nick() end
						local msg = conv.Message
						local onoff
						if (type(conv.MessageOn) == "function") then
							onoff = conv.MessageOn()
						else
							onoff = conv.MessageOn
							if (bool == false) then onoff = conv.MessageOff end
						end
						for _,v in ipairs( player.GetAll() ) do
							v:ChatPrint( "[PewPew] " .. name .. " " .. msg .. " " .. onoff )
							v:ConCommand( "pewpew_cl_" .. command .. " " .. nr )
						end
					end
				end
			end
		end
	else
		ply:ChatPrint( "[PewPew] You are not allowed to do that." )
	end
end
concommand.Add("PewPew",CheckConVar)
]]

--[[
-- Toggle Damage
local function ToggleDamage( ply, command, arg )
	if ( (ply:IsValid() and ply:IsAdmin()) or !ply:IsValid() ) then
		if (!arg[1]) then return end
		local bool = false
		if (tonumber(arg[1]) != 0) then bool = true end
		local OldSetting = pewpew:GetConVar( "Damage" )
		pewpew:GetConVar( "Damage" ) = bool
		if (OldSetting != pewpew:GetConVar( "Damage" )) then
			local name = "Console"
			if (ply:IsValid()) then name = ply:Nick() end
			local msg = " has changed PewPew Damage and it is now "
			local onoff = "ON!"
			local cmd = "1"
			if (pewpew:GetConVar( "Damage" ) == false) then onoff = "OFF!" cmd = "0" end
			for _,v in ipairs( player.GetAll() ) do
				v:ChatPrint( "[PewPew] " .. name .. msg .. onoff )
				v:ConCommand( "pewpew_cltgldamage " .. cmd )
			end
		end
	end
end
concommand.Add("PewPew_ToggleDamage", ToggleDamage)

-- Toggle Firing
local function ToggleFiring( ply, command, arg )
	if ( (ply:IsValid() and ply:IsAdmin()) or !ply:IsValid() ) then
		if (!arg[1]) then return end
		local bool = false
		if (tonumber(arg[1]) != 0) then bool = true end
		local OldSetting = pewpew:GetConVar( "Firing" )
		pewpew:GetConVar( "Firing" ) = bool
		if (OldSetting != pewpew:GetConVar( "Firing" )) then
			local name = "Console"
			if (ply:IsValid()) then name = ply:Nick() end
			local msg = " has changed PewPew Firing and it is now "
			local onoff = "ON!"
			local cmd = "1"
			if (pewpew:GetConVar( "Firing" ) == false) then onoff = "OFF!" cmd = "0" end
			for _,v in ipairs( player.GetAll() ) do
				v:ChatPrint( "[PewPew] " .. name .. msg .. onoff )
				v:ConCommand( "pewpew_cltglfiring " .. cmd )
			end
		end
	end
end
concommand.Add("PewPew_ToggleFiring", ToggleFiring)

-- Toggle Numpads
local function ToggleNumpads( ply, command, arg )
	if ( (ply:IsValid() and ply:IsAdmin()) or !ply:IsValid() ) then
		if (!arg[1]) then return end
		local bool = false
		if (tonumber(arg[1]) != 0) then bool = true end
		local OldSetting = pewpew:GetConVar( "Numpads" )
		pewpew:GetConVar( "Numpads" ) = bool
		if (OldSetting != pewpew:GetConVar( "Numpads" )) then
			local name = "Console"
			if (ply:IsValid()) then name = ply:Nick() end
			local msg = " has changed PewPew Numpads and they are now "
			local onoff = "ENABLED!"
			local cmd = "1"
			if (pewpew:GetConVar( "Numpads" ) == false) then onoff = "DISABLED!" cmd = "0" end
			for _,v in ipairs( player.GetAll() ) do
				v:ChatPrint( "[PewPew] " .. name .. msg .. onoff )
				v:ConCommand( "pewpew_cltglnumpads " .. cmd )
			end
		end
	end
end
concommand.Add("PewPew_ToggleNumpads", ToggleNumpads)

-- Damage Multiplier
local function DamageMul( ply, command, arg )
	if ( (ply:IsValid() and ply:IsAdmin()) or !ply:IsValid() ) then
		if ( !arg[1] ) then return end
		local OldSetting = pewpew:GetConVar( "DamageMul" )
		pewpew:GetConVar( "DamageMul" ) = math.max( arg[1], 0.01 )
		if (OldSetting != pewpew:GetConVar( "DamageMul" )) then
			local name = "Console"
			local msg = " has changed the PewPew Damage Multiplier to "
			if (ply:IsValid()) then name = ply:Nick() end
			for _, v in pairs( player.GetAll() ) do
				v:ChatPrint( "[PewPew] " .. name .. msg .. pewpew:GetConVar( "DamageMul" ))
				v:ConCommand( "pewpew_cldmgmul " .. tostring(pewpew:GetConVar( "DamageMul" )) )
			end
		end
	end
end
concommand.Add("PewPew_DamageMul",DamageMul)

-- Damage Multiplier vs cores
local function CoreDamageMul( ply, command, arg )
	if ( (ply:IsValid() and ply:IsAdmin()) or !ply:IsValid() ) then
		if ( !arg[1] ) then return end
		local OldSetting = pewpew:GetConVar( "CoreDamageMul" )
		pewpew:GetConVar( "CoreDamageMul" ) = math.max( arg[1], 0.01 )
		if (OldSetting != pewpew:GetConVar( "CoreDamageMul" )) then
			local name = "Console"
			local msg = " has changed the PewPew Core Damage Multiplier to "
			if (ply:IsValid()) then name = ply:Nick() end
			for _, v in pairs( player.GetAll() ) do
				v:ChatPrint( "[PewPew] " .. name .. msg .. pewpew:GetConVar( "CoreDamageMul" ))
				v:ConCommand( "pewpew_cldmgcoremul " .. tostring(pewpew:GetConVar( "CoreDamageMul" )) )
			end
		end
	end
end
concommand.Add("PewPew_CoreDamageMul",CoreDamageMul)

-- Core Damage only
local function ToggleCoreDamageOnly( ply, command, arg )
	if ( (ply:IsValid() and ply:IsAdmin()) or !ply:IsValid() ) then
		if (!arg[1]) then return end
		local bool = false
		if (tonumber(arg[1]) != 0) then bool = true end
		local OldSetting = pewpew:GetConVar( "CoreDamageOnly" )
		pewpew:GetConVar( "CoreDamageOnly" ) = bool
		if (OldSetting != pewpew:GetConVar( "CoreDamageOnly" )) then
			local name = "Console"
			if (ply:IsValid()) then name = ply:Nick() end
			local msg = " has changed PewPew Core Damage Only and it is now "
			local onoff = "ON!"
			local cmd = "1"
			if (pewpew:GetConVar( "CoreDamageOnly" ) == false) then onoff = "OFF!" cmd = "0" end
			for _,v in ipairs( player.GetAll() ) do
				v:ChatPrint( "[PewPew] " .. name .. msg .. onoff )
				v:ConCommand( "pewpew_cltglcoredamageonly " .. cmd )
			end
		end
	end
end
concommand.Add("PewPew_ToggleCoreDamageOnly", ToggleCoreDamageOnly)

-- Repair tool rate
local function RepairToolHeal( ply, command, arg )
	if ( (ply:IsValid() and ply:IsAdmin()) or !ply:IsValid() ) then
		if ( !arg[1] ) then return end
		local OldSetting = pewpew:GetConVar( "RepairToolHeal" )
		pewpew:GetConVar( "RepairToolHeal" ) = math.max( arg[1], 20 )
		if (OldSetting != pewpew:GetConVar( "RepairToolHeal" )) then
			local name = "Console"
			if (ply:IsValid()) then name = ply:Nick() end
			local msg = " has changed the speed at which the Repair Tool heals to "
			for _, v in pairs( player.GetAll() ) do
				v:ChatPrint( "[PewPew] " .. name .. msg .. pewpew:GetConVar( "RepairToolHeal" ))
				v:ConCommand( "pewpew_clrepairtoolheal " .. tostring(pewpew:GetConVar( "RepairToolHeal" )) )
			end
		end
	end
end
concommand.Add("PewPew_RepairToolHeal",RepairToolHeal)

-- Repair tool rate vs cores
local function RepairToolHealCores( ply, command, arg )
	if ( (ply:IsValid() and ply:IsAdmin()) or !ply:IsValid() ) then
		if ( !arg[1] ) then return end
		local OldSetting = pewpew:GetConVar( "RepairToolHealCores" )
		pewpew:GetConVar( "RepairToolHealCores" ) = math.max( arg[1], 20 )
		if (OldSetting != pewpew:GetConVar( "RepairToolHealCores" )) then
			local name = "Console"
			if (ply:IsValid()) then name = ply:Nick() end
			local msg = " has changed the speed at which the Repair Tool heals cores to "
			for _, v in pairs( player.GetAll() ) do
				v:ChatPrint( "[PewPew] " .. name .. msg .. pewpew:GetConVar( "RepairToolHealCores" ))
				v:ConCommand( "pewpew_clrepairtoolhealcores " .. tostring(pewpew:GetConVar( "RepairToolHealCores" )) )
			end
		end
	end
end
concommand.Add("PewPew_RepairToolHealCores",RepairToolHealCores)

-- Toggle Life Support
local function ToggleEnergyUsage( ply, command, arg )
	if ( (ply:IsValid() and ply:IsAdmin()) or !ply:IsValid() ) then
		if (CAF and CAF.GetAddon("Resource Distribution") and CAF.GetAddon("Life Support")) then
			if (!arg[1]) then return end
			local bool = false
			if (tonumber(arg[1]) != 0) then bool = true end
			local OldSetting = pewpew:GetConVar( "EnergyUsage" )
			pewpew:GetConVar( "EnergyUsage" ) = bool
			if (OldSetting != pewpew:GetConVar( "EnergyUsage" )) then
				local name = "Console"
				if (ply:IsValid()) then name = ply:Nick() end
				local msg = " has changed PewPew Energy Usage and it is now "
				local onoff = "ENABLED!"
				local cmd = "1"
				if (pewpew:GetConVar( "EnergyUsage" ) == false) then onoff = "DISABLED!" cmd = "0" end
				for _,v in ipairs( player.GetAll() ) do
					v:ChatPrint( "[PewPew] " .. name .. msg .. onoff )
					v:ConCommand( "pewpew_cltglenergyusage " .. cmd )
				end
			end
		elseif (arg[1] != "0") then
			local msg = "You cannot enable Energy Usage, because the server does not have the required addons (Spacebuild 3 & co.)!"
			ply:ChatPrint( "[PewPew] " .. msg )
		end
	end
end
concommand.Add("PewPew_ToggleEnergyUsage", ToggleEnergyUsage)

-- Toggle Prop Protection
local function TogglePP( ply, command, arg )
	if ( (ply:IsValid() and ply:IsAdmin()) or !ply:IsValid() ) then
		if (CPPI) then
			if (!arg[1]) then return end
			local bool = false
			if (tonumber(arg[1]) != 0) then bool = true end
			local OldSetting = pewpew:GetConVar( "PropProtDamage" )
			pewpew:GetConVar( "PropProtDamage" ) = bool
			if (OldSetting != pewpew:GetConVar( "PropProtDamage" )) then
				local name = "Console"
				if (ply:IsValid()) then name = ply:Nick() end
				local msg = " has changed PewPew Prop Protection Damage and it is now "
				local onoff = "ENABLED!"
				local cmd = "1"
				if (pewpew:GetConVar( "PropProtDamage" ) == false) then onoff = "DISABLED!" cmd = "0" end
				for _,v in ipairs( player.GetAll() ) do
					v:ChatPrint( "[PewPew] " .. name .. msg .. onoff )
					v:ConCommand( "pewpew_cltglppdamage " .. cmd )
				end
			end
		elseif (arg[1] != "0") then
			local msg = "You cannot enable Prop Protection Damage, because the server does not have the required addon(s)!"
			ply:ChatPrint( "[PewPew] " .. msg )
		end
	end
end
concommand.Add("PewPew_TogglePP", TogglePP)

-- Weapon Designer
local function ToggleWeaponDesigner( ply, command, arg )
	if ( (ply:IsValid() and ply:IsAdmin()) or !ply:IsValid() ) then
		if (!arg[1]) then return end
		local bool = false
		if (tonumber(arg[1]) != 0) then bool = true end
		local OldSetting = pewpew:GetConVar( "WeaponDesigner" )
		pewpew:GetConVar( "WeaponDesigner" ) = bool
		if (OldSetting != pewpew:GetConVar( "WeaponDesigner" )) then
			local name = "Console"
			if (ply:IsValid()) then name = ply:Nick() end
			local msg = " has changed PewPew Weapon Designer and it is now "
			local onoff = "ENABLED!"
			local cmd = "1"
			if (pewpew:GetConVar( "WeaponDesigner" ) == false) then onoff = "DISABLED!" cmd = "0" end
			for _,v in ipairs( player.GetAll() ) do
				v:ChatPrint( "[PewPew] " .. name .. msg .. onoff )
				v:ConCommand( "pewpew_cltglweapondesigner " .. cmd )
			end
		end
	end
end
concommand.Add("PewPew_ToggleWeaponDesigner", ToggleWeaponDesigner)
]]