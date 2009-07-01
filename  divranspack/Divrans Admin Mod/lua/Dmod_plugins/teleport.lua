-------------------------------------------------------------------------------------------------------------------------
-- Teleport
-------------------------------------------------------------------------------------------------------------------------
local DmodPlugin = {}
DmodPlugin.ChatCommand = "tp"
DmodPlugin.Name = "Teleport"
if SERVER then Dmod_AddPlugin(DmodPlugin) end


local function Dmod_Teleport( ply, Args )
	if (Args[2]) then
		if (Dmod_FindPlayer(Args[2])) then
			local T = Dmod_FindPlayer(Args[2])
			local Pos = ply:GetEyeTrace()
			T:SetPos( Pos.HitPos + Vector(0,0,1) )
			T:SetLocalVelocity( Vector( 0,0,0 ) )
			Dmod_Message(true, ply, ply:Nick() .. " teleported " .. T:Nick() .. ".")
		else
			Dmod_Message(false, ply, "No player named '"..Args[2].."' found.")
		end
	else
		local Pos = ply:GetEyeTrace()
		ply:SetPos( Pos.HitPos + Vector(0,0,1) )
		ply:SetLocalVelocity( Vector( 0,0,0 ) )
		Dmod_Message( true, ply, ply:Nick() .. " teleported.")
	end
end
hook.Add( DmodPlugin.Name, DmodPlugin.Name, Dmod_Teleport)