-------------------------------------------------------------------------------------------------------------------------
-- Kick
-------------------------------------------------------------------------------------------------------------------------
local DmodPlugin = {}
DmodPlugin.ChatCommand = "kick"
DmodPlugin.Name = "kick"
Dmod_AddPlugin(DmodPlugin)


local function Dmod_Kick( ply, Args )
	if (Args[2]) then
		if (Dmod_FindPlayer(Args[2])) then
			local T = Dmod_FindPlayer(Args[2])
			local Reason = Dmod_GetReason(Args)
			T:Kick(Reason)
			Dmod_Message(true, ply, ply:Nick() .. " kicked " .. T:Nick() .. " with the reason '" .. Reason .. "'.")
		else
			Dmod_Message(false, ply, "No player named '"..Args[2].."' found.")
		end
	else
		Dmod_Message( false, ply, "You must enter a name!")
	end
end
hook.Add( DmodPlugin.Name, DmodPlugin.Name, Dmod_Kick)

local function Dmod_GetReason( Args )
	local Rsn = ""
	if (Args[3] and Args[3] != "") then
		for i = 1, table.Count(Args) do
			if (i > 2) then
				Rsn = Rsn .. Args[i] .. " "
			end
		end
	end
	if (Rsn == " ") then Rsn = "No reason" end
	return Rsn
end