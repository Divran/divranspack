-------------------------------------------------------------------------------------------------------------------------
-- Goto
-------------------------------------------------------------------------------------------------------------------------
local DmodPlugin = {}
DmodPlugin.ChatCommand = "goto"
DmodPlugin.Name = "goto"
Dmod_AddPlugin(DmodPlugin)


local function Dmod_Goto( ply, Args )
	if (Args[2]) then
		if (Dmod_FindPlayer(Args[2])) then
			local T = Dmod_FindPlayer(Args[2])
			local Pos = T:GetPos() + T:GetForward() * 100
			ply:SetPos( Pos )
			ply:SetLocalVelocity( Vector( 0,0,0 ) )
			if (ply != T) then ply:SnapEyeAngles( (T:GetPos() - ply:GetPos()):Angle() ) end
			Dmod_Message(true, ply, ply:Nick() .. " went to " .. T:Nick() .. ".")
		else
			Dmod_Message(false, ply, "No player named '"..Args[2].."' found.")
		end
	else
		Dmod_Message( false, ply, "You must enter a name.")
	end
end
hook.Add( DmodPlugin.Name, DmodPlugin.Name, Dmod_Goto)