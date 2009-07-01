-------------------------------------------------------------------------------------------------------------------------
-- Bring
-------------------------------------------------------------------------------------------------------------------------
local DmodPlugin = {}
DmodPlugin.ChatCommand = "bring"
DmodPlugin.Name = "bring"
Dmod_AddPlugin(DmodPlugin)


local function Dmod_Bring( ply, Args )
	if (Args[2]) then
		if (Dmod_FindPlayer(Args[2])) then
			local T = Dmod_FindPlayer(Args[2])
			T:SetPos( ply:GetPos() + ply:GetForward() * 100 )
			T:SetLocalVelocity( Vector( 0,0,0 ) )
			if (ply != T) then T:SnapEyeAngles( (ply:GetPos() - T:GetPos()):Angle() ) end
			Dmod_Message(true, ply, ply:Nick() .. " brought " .. T:Nick() .. ".")
		else
			Dmod_Message(false, ply, "No player named '"..Args[2].."' found.")
		end
	else
		Dmod_Message( false, ply, "You must enter a name!")
	end
end
hook.Add( DmodPlugin.Name, DmodPlugin.Name, Dmod_Bring)