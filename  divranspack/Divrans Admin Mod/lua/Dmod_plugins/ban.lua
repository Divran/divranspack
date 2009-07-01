-------------------------------------------------------------------------------------------------------------------------
-- Ban
-------------------------------------------------------------------------------------------------------------------------
local DmodPlugin = {}
DmodPlugin.ChatCommand = "ban"
DmodPlugin.Name = "ban"
Dmod_AddPlugin(DmodPlugin)


local function Dmod_Ban( ply, Args )
	if (Args[2]) then
		if (Dmod_FindPlayer(Args[2])) then
			local T = Dmod_FindPlayer(Args[2])
			local Time = tonumber(Args[3])
			local Reason = Dmod_GetReason(Args)
			T:Ban(Time, Reason)
			T:Kick("You've been banned. Reason: '" .. Reason .. "', for " .. Time .. " minutes.")		
			Dmod_Message(true, ply, ply:Nick() .. " banned " .. T:Nick() .. " with the reason '" .. Reason .. "' for " .. Time .. " minutes.")
		else
			Dmod_Message(false, ply, "No player named '"..Args[2].."' found.")
		end
	else
		Dmod_Message( false, ply, "You must enter a name!")
	end
end
hook.Add( DmodPlugin.Name, DmodPlugin.Name, Dmod_Ban)

local function Dmod_GetReason( Args )
	local Rsn = " "
	if (Args[4] and Args[4] != "") then
		for i = 1, table.Count(Args) do
			if (i > 3) then
				Rsn = Rsn .. Args[i] .. " "
			end
		end
	end
	if (Rsn == " ") then Rsn = "No Reason" end
	return Rsn
end