-------------------------------------------------------------------------------------------------------------------------
-- Send
-------------------------------------------------------------------------------------------------------------------------
local DmodPlugin = {}
DmodPlugin.ChatCommand = "send"
DmodPlugin.Name = "send"
Dmod_AddPlugin(DmodPlugin)


local function Dmod_Send( ply, Args )
	if (Args[2] and Args[3]) then
		if (Dmod_FindPlayer(Args[2]) and Dmod_FindPlayer(Args[3])) then
			local T = FindPlayer(Args[2])
			local T2 = FindPlayer(Args[3])
			T:SetPos( T2:GetPos() + T2:GetForward() * 100 )
			T:SetLocalVelocity( Vector( 0,0,0 ) )
			Dmod_Message(true, ply, ply:Nick() .. " sent " .. T:Nick() .. " to " .. T2:Nick() .. ".")
			if (T != T) then T:SnapEyeAngles( (T2:GetPos() - T:GetPos()):Angle() ) end
		else
			Dmod_Message(false, ply, "One of the players were not found!")
		end
	else
		Dmod_Message( false, ply, "You must enter two names!")
	end
end
hook.Add( DmodPlugin.Name, DmodPlugin.Name, Dmod_Send)