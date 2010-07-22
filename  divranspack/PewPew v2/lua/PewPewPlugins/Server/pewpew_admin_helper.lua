local function JoinCmds( ply )
	-- 1/0
	local val = "0"
	if (pewpew:GetConVar( "Damage" )) then val = "1" end
	ply:ConCommand( "pewpew_cltgldamage " .. val )
	local val = "0"
	if (pewpew:GetConVar( "Firing" )) then val = "1" end
	ply:ConCommand( "pewpew_cltglfiring " .. val )
	local val = "0"
	if (pewpew:GetConVar( "Numpads" )) then val = "1" end
	ply:ConCommand( "pewpew_cltglnumpads " .. val )
	local val = "0"
	if (pewpew:GetConVar( "EnergyUsage" )) then val = "1" end
	ply:ConCommand( "pewpew_cltglenergyusage " .. val )
	local val = "0"
	if (pewpew:GetConVar( "CoreDamageOnly" )) then val = "1" end
	ply:ConCommand( "pewpew_cltglcoredamageonly " .. val )
	local val = "0"
	if (pewpew.DamageLogSend) then val = "1" end
	ply:ConCommand( "pewpew_cltgldamagelog " .. val )
	local val = "0"
	if (pewpew:GetConVar( "PropProtDamage" )) then val = "1" end
	ply:ConCommand( "pewpew_cltglppdamage " .. val )
	
	-- Vars
	ply:ConCommand( "pewpew_cldmgmul " .. pewpew:GetConVar( "DamageMul" ) )
	ply:ConCommand( "pewpew_cldmgcoremul " .. pewpew:GetConVar( "CoreDamageMul" ) )
	ply:ConCommand( "pewpew_clrepairtoolheal " .. pewpew:GetConVar( "RepairToolHeal" ) )
	ply:ConCommand( "pewpew_clrepairtoolhealcores " .. pewpew:GetConVar( "RepairToolHealCores" ) )
end
hook.Add("PlayerInitialSpawn","PewPew_Convars_at_spawn",JoinCmds)