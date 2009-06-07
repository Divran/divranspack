//This admin mod was made by Divran. I know it sucks, but so what
function Speak( ply, text, toall )
	if (ply:IsAdmin()) then
		local Msg = string.Explode(" ", text)
		local Dis = false
		
		//Tele
		if (string.lower(Msg[1]) == "!tp") then
		Tele( ply, Msg[2] )
		Dis = true
		end
		
		//Goto
		if (string.lower(Msg[1]) == "!goto") then
		Goto( ply, Msg[2] )
		Dis = true
		end
		
		//Bring
		if (string.lower(Msg[1]) == "!bring") then
		Bring( ply, Msg[2] )
		Dis = true
		end
		
		//Send
		if (string.lower(Msg[1]) == "!send") then
		Send( ply, Msg[2], Msg[3] )
		Dis = true
		end
		
		//Slay
		if (string.lower(Msg[1]) == "!slay") then
		Slay( ply, Msg[2] )
		Dis = true
		end
		
		//Health
		if (string.lower(Msg[1]) == "!hp") then
		Health( ply, Msg[2], Msg[3] )
		Dis = true
		end
		
		//Armor
		if (string.lower(Msg[1]) == "!armor") then
		Armor( ply, Msg[2], Msg[3] )
		Dis = true
		end
		
		//Speed
		if (string.lower(Msg[1]) == "!speed") then
		Speed( ply, Msg[2], Msg[3] )
		Dis = true
		end
		
		//Jump
		if (string.lower(Msg[1]) == "!jump") then
		Jump( ply, Msg[2], Msg[3] )
		Dis = true
		end
		
		//Godmode
		if (string.lower(Msg[1]) == "!god") then
		God( ply, Msg[2] )
		Dis = true
		end
		
		//Ungodmode
		if (string.lower(Msg[1]) == "!ungod") then
		Ungod( ply, Msg[2] )
		Dis = true
		end
		
		//Explode
		if (string.lower(Msg[1]) == "!explode") then
		Explode( ply, Msg[2] )
		Dis = true
		end
		
		//Burn
		if (string.lower(Msg[1]) == "!burn") then
		Burn( ply, Msg[2] )
		Dis = true
		end
		
		//unburn
		if (string.lower(Msg[1]) == "!unburn") then
		Unburn( ply, Msg[2] )
		Dis = true
		end
		
		//Help
		if (string.lower(Msg[1]) == "!help") then
		Help( ply )
		Dis = true
		end
		
		//Decals
		if (string.lower(Msg[1]) == "!decals") then
		Decals( ply )
		Dis = true
		end
		
		//Kick
		if (string.lower(Msg[1]) == "!kick") then
		local Num = table.Count(Msg)
		local Rsn = ""
		for i = 1, Num do
			if (i > 2) then
				Rsn = Rsn .. Msg[i] .. " "
			end
		end
		Kick( ply, Msg[2], Rsn )
		Dis = true
		end
		
		//Ban
		if (string.lower(Msg[1]) == "!ban") then
		local Num = table.Count(Msg)
		local Rsn = ""
		for i = 1, Num do
			if (i > 3) then
				Rsn = Rsn .. Msg[i] .. " "
			end
		end
		Ban( ply, Msg[2], Msg[3], Rsn )
		Dis = true
		end
		
		//Freeze
		if (string.lower(Msg[1]) == "!freeze") then
		Freeze( ply, Msg[2] )
		end
		
		//Unfreeze
		if (string.lower(Msg[1]) == "!unfreeze") then
		Unfreeze( ply, Msg[2] )
		end

		if (Dis == true) then
			return ""
		end
	else
		local C = false
		if string.lower(Msg[1]) == "!tp" then C = true end
		if string.lower(Msg[1]) == "!bring" then C = true end
		if string.lower(Msg[1]) == "!goto" then C = true end
		if string.lower(Msg[1]) == "!send" then C = true end
		if string.lower(Msg[1]) == "!slay" then C = true end
		if string.lower(Msg[1]) == "!hp" then C = true end
		if string.lower(Msg[1]) == "!armor" then C = true end
		if string.lower(Msg[1]) == "!speed" then C = true end
		if string.lower(Msg[1]) == "!jump" then C = true end
		if string.lower(Msg[1]) == "!god" then C = true end
		if string.lower(Msg[1]) == "ungod" then C = true end
		if string.lower(Msg[1]) == "!burn" then C = true end
		if string.lower(Msg[1]) == "!unburn" then C = true end
		if string.lower(Msg[1]) == "!help" then C = true end
		if string.lower(Msg[1]) == "!decals" then C = true end
		if string.lower(Msg[1]) == "!kick" then C = true end
		if string.lower(Msg[1]) == "!ban" then C = true end
		if string.lower(Msg[1]) == "!freeze" then C = true end
		if string.lower(Msg[1]) == "!unfreeze" then C = true end
		if C == true then return "", Con("[D] You are not an admin!") end
	end
end
hook.Add( "PlayerSay", "Speak", Speak )

----------Print to chat
function Con(Txt)
	for k,v in pairs ( player.GetAll() ) do
		v:PrintMessage( HUD_PRINTTALK, Txt );
	end
end
hook.Add( "Con", "Con", Con )

----------Find Player
function FindPlayer( Nick )
	if !Nick then return nil end
	Nick = string.lower( Nick )
	
	local Exact = false
	if string.Left( Nick, 1 ) == "\"" and string.Right( Nick, 1 ) == "\"" then
		Exact = true
		Nick = string.sub( Nick, 2, string.len(Nick) - 1 )
	end
	
	for _, pl in pairs(player.GetAll()) do
		local n = string.lower( pl:Nick() )
		
		if n == Nick then
			return pl
		elseif string.find( n, Nick ) and !Exact then
			return pl
		end
	end
end

----------Teleport
function Tele( ply, Target )
	if (Target and Target != "") then
		if (FindPlayer(Target)) then
			local T = FindPlayer(Target)
			local Pos = ply:GetEyeTrace()
			T:SetPos( Pos.HitPos + Vector(0,0,1) )
			T:SetLocalVelocity( Vector( 0,0,0 ) )
			Con("[D] " .. ply:Nick() .. " teleported " .. T:Nick() .. ".")
		else
			Con("[D] No player with the name '" .. Target .. "' found!")
		end
	else
		local Pos = ply:GetEyeTrace()
		ply:SetPos( Pos.HitPos + Vector(0,0,1) )
		ply:SetLocalVelocity( Vector( 0,0,0 ) )
		Con("[D] " .. ply:Nick() .. " teleported him/herself.")
	end
end
hook.Add( "Tele", "Tele", Tele )


----------Goto
function Goto( ply, Target )
	if (Target and Target != "") then
		if (FindPlayer(Target)) then
			local T = FindPlayer(Target)
			local Pos = T:GetPos() + T:GetForward() * 100
			ply:SetPos( Pos )
			ply:SetLocalVelocity( Vector( 0,0,0 ) )
			Con("[D] " .. ply:Nick() .. " sent him/herself to " .. T:Nick() .. ".")
		else
			Con("[D] No player with the name '" .. Target .. "' found!")
		end
	else
		Con("[D] You must enter a name!")
	end
end

----------Bring
function Bring( ply, Target )
	if (Target and Target != "") then
		if (FindPlayer(Target)) then
			local T = FindPlayer(Target)
			local Pos = ply:GetPos() + ply:GetForward() * 100
			T:SetPos( Pos )
			T:SetLocalVelocity( Vector( 0,0,0 ) )
			Con("[D] " .. ply:Nick() .. " brought " .. T:Nick() .. " to him/herself.")
		else
			Con("[D] No player with the name '" .. Target .. "' found!")
		end
	else
		Con("[D] You must enter a name!")
	end
end

----------Send
function Send( ply, Target, Target2 )
	if (Target and Target != "" and Target2 and Target2 != "") then
		if (FindPlayer(Target) and FindPlayer(Target2)) then
			local T = FindPlayer(Target)
			local T2 = FindPlayer(Target2)
			local Pos = T2:GetPos() + T2:GetForward() * 100
			T:SetPos( Pos )
			T:SetLocalVelocity( Vector( 0,0,0 ) )
			Con("[D] " .. ply:Nick() .. " sent " .. T:Nick() .. " to " .. T2:Nick() .. ".")
		else
			Con("[D] One or more of the players were not found!")
		end
	else
		Con("[D] You must enter two names!")
	end
end

----------Slay
function Slay( ply, Target )
	if (Target and Target != "") then
		if (FindPlayer(Target)) then
			local T = FindPlayer(Target)
			T:Kill()
			T:AddFrags(1)
			Con("[D] " .. ply:Nick() .. " slayed " .. T:Nick() .. ".")
		else
			Con("[D] No player with the name '" .. Target .. "' found!")
		end
	else
		Con("[D] You must enter a name!")
	end
end

----------Health
function Health( ply, Target, Num )
	if (Target and Target != "") then
		if (FindPlayer(Target)) then
			local T = FindPlayer(Target)
			T:SetHealth( math.Clamp( tonumber(Num), 1, 99999 ) )
			Con("[D] " .. ply:Nick() .. " set " .. T:Nick() .. "'s health to " .. Num .. ".")
		else
			Con("[D] No player with the name '" .. Target .. "' found!")
		end
	else
		Con("[D] You must enter a name!")
	end
end

----------Armor
function Armor( ply, Target, Num )
	if (Target and Target != "") then
		if (FindPlayer(Target)) then
			local T = FindPlayer(Target)
			T:SetArmor( math.Clamp( tonumber(Num), 1, 99999 ) )
			Con("[D] " .. ply:Nick() .. " set " .. T:Nick() .. "'s armor to " .. Num .. ".")
		else
			Con("[D] No player with the name '" .. Target .. "' found!")
		end
	else
		Con("[D] You must enter a name!")
	end
end

----------Speed
function Speed( ply, Target, Num )
	if (Target and Target != "") then
		if (FindPlayer(Target)) then
			local T = FindPlayer(Target)
			if (Num != nil) then
				T:SetWalkSpeed( math.Clamp( tonumber(Num), 1, 1000000) )
				T:SetRunSpeed( math.Clamp( tonumber(Num+250), 1, 1000000) )
			else
				T:SetWalkSpeed( 250 )
				T:SetRunSpeed( 500 )
				Num = 250
			end
				Con("[D] " .. ply:Nick() .. " set " .. T:Nick() .. "'s movement speed to " .. Num .. ".")
		else
			Con("[D] No player with the name '" .. Target .. "' found!")
		end
	else
		Con("[D] You must enter a name!")
	end
end

----------Jump
function Jump( ply, Target, Num )
	if (Target and Target != "") then
		if (FindPlayer(Target)) then
			local T = FindPlayer(Target)
			if (Num != nil) then
				T:SetJumpPower( math.Clamp( tonumber(Num), 1, 1000000) )
			else
				T:SetJumpPower( 160 )
				Num = 160
			end
			Con("[D] " .. ply:Nick() .. " set " .. T:Nick() .. "'s jump strength to " .. Num .. ".")
		else
			Con("[D] No player with the name '" .. Target .. "' found!")
		end
	else
		Con("[D] You must enter a name!")
	end
end

----------Godmode
function God( ply, Target )
	if (Target and Target != "") then
		if (FindPlayer(Target)) then
			T = FindPlayer(Target)
			T:GodEnable( )
			Con("[D] " .. ply:Nick() .. " enabled godmode for " .. T:Nick() .. ".")
		else
			Con("[D] No player with the name '" .. Target .. "' found!")
		end
	else
		ply:GodEnable()
		Con("[D] " .. ply:Nick() .. " enabled godmode for him/herself.")
	end
end

----------UnGodmode
function Ungod( ply, Target )
	if (Target and Target != "") then
		if (FindPlayer(Target)) then
			local T = FindPlayer(Target)
			T:GodDisable( )
			Con("[D] " .. ply:Nick() .. " disabled godmode for " .. T:Nick() .. ".")
		else
			Con("[D] No player with the name '" .. Target .. "' found!")
		end
	else
		ply:GodDisable()
		Con("[D] " .. ply:Nick() .. " disabled godmode for him/herself.")
	end
end

----------Explode
function Explode( ply, Target )
	if (Target and Target != "") then
		if (FindPlayer(Target)) then
			local T = FindPlayer(Target)
			local Pos = T:GetPos() + Vector(0,0,50)
			util.BlastDamage( ply, ply, Pos , 200, 9001 )
			local effectdata = EffectData()
			effectdata:SetOrigin( Pos )
			util.Effect( "Explosion", effectdata, true, true )
			Con("[D] " .. ply:Nick() .. " blew " .. T:Nick() .. " up.")
		else
			Con("[D] No player with the name '" .. Target .. "' found!")
		end
	else
			local Pos = ply:GetPos() + Vector(0,0,50)
			util.BlastDamage( ply, ply, Pos, 200, 9001 )
			local effectdata = EffectData()
			effectdata:SetOrigin( Pos )
			util.Effect( "Explosion", effectdata, true, true )
		Con("[D] " .. ply:Nick() .. " blew him/herself up.")
	end
end

----------Ignite
function Burn( ply, Target )
	if (Target and Target != "") then
		if (FindPlayer(Target)) then
			T = FindPlayer(Target)
			T:Ignite( 35, 0 )
			Con("[D] " .. ply:Nick() .. " set " .. T:Nick() .. " on fire.")
		else
			Con("[D] No player with the name '" .. Target .. "' found!")
		end
	else
		ply:Ignite( 35, 0 )
		Con("[D] " .. ply:Nick() .. " set him/herself on fire.")
	end
end

----------Unignite
function Unburn( ply, Target )
	if (Target and Target != "") then
		if (FindPlayer(Target)) then
			T = FindPlayer(Target)
			T:Extinguish()
			Con("[D] " .. ply:Nick() .. " unignited " .. T:Nick() .. ".")
		else
			Con("[D] No player with the name '" .. Target .. "' found!")
		end
	else
		ply:Extinguish()
		Con("[D] " .. ply:Nick() .. " unignited him/herself.")
	end
end

----------Help
function Help( ply )
	ply:PrintMessage( HUD_PRINTTALK, "[D] A list of all commands:" )
	ply:PrintMessage( HUD_PRINTTALK, "[D] !tp - Teleports you or someone else to where you aim." )
	ply:PrintMessage( HUD_PRINTTALK, "[D] !goto, !bring, !send - Go to someone, bring someone, send someone." )
	ply:PrintMessage( HUD_PRINTTALK, "[D] !slay, !god, !ungod - Slay someone, make someone invurnable, make someone vurnable." )
	ply:PrintMessage( HUD_PRINTTALK, "[D] !hp, !armor, !speed, !jump - Changes someones' health, armor, movement speed or jump strength." )
	ply:PrintMessage( HUD_PRINTTALK, "[D] !burn, !unburn, !explode - Ignite someone, unignite someone, make someone explode." )
	ply:PrintMessage( HUD_PRINTTALK, "[D] !kick, !ban - !kick <Name> <Reason>, !ban <name> <time (minutes)> <reason>." )
	ply:PrintMessage( HUD_PRINTTALK, "[D] !freeze, !unfreeze - Freeze and unfreeze someone." )
end

----------Decals
function Decals( ply )
	for k, v in pairs(player.GetAll()) do
		v:ConCommand("r_cleardecals 1")
	end
	Con("[D] " .. ply:Nick() .. " has cleared the decals.")
end

----------Kick
function Kick( ply, Target, Reason )
	if (Target and Target != "") then
		if (FindPlayer(Target)) then
			T = FindPlayer(Target)
			if (Reason and Reason != "") then
				T:Kick(Reason)
			else
				Reason = "No reason"
				T:Kick(Reason)
			end
				Con("[D] " .. ply:Nick() .. " has kicked " .. T:Nick() .. " with the reason '" .. Reason .. "'.")
		else
			Con("[D] No player with the name '" .. Target .. "' found!")
		end
	else
		Con("[D] You need to enter a name!")
	end
end

----------Ban
function Ban( ply, Target, Time, Reason )
	if (Target and Target != "") then
		if (Time and Time != "" and tonumber(Time)) then
			if (FindPlayer(Target)) then
				T = FindPlayer(Target)
				if (Reason and Reason != "") then
					T:Ban(tonumber(Time), Reason)
					T:Kick("You have been banned with the reason '" .. Reason .. "' for " .. Time .. " minutes.")
				else
					Reason = "No reason"
					T:Ban(tonumber(Time), Reason)
					T:Kick("You have been banned with the reason '" .. Reason .. "' for " .. Time .. " minutes.")
				end
					Con("[D] " .. ply:Nick() .. " has banned " .. T:Nick() .. " with the reason '" .. Reason .. "' for " .. Time .. " minutes.")
			else
				Con("[D] No player with the name '" .. Target .. "' found!")
			end
		else
			Con("[D] No/invalid time specified!")
		end
	else
		Con("[D] You need to enter a name!")
	end
end

----------Freeze
function Freeze( ply, Target )
	if (Target and Target != "") then
		if (FindPlayer(Target)) then
			local T = FindPlayer(Target)
			T:Lock()
			Con("[D] " .. ply:Nick() .. " froze " .. T:Nick() .. ".")
		else
			Con("[D] No player with the name '" .. Target .. "' found!")
		end
	else
		Con("[D] You must enter a name!")
	end
end

----------Unfreeze
function Unfreeze( ply, Target )
	if (Target and Target != "") then
		if (FindPlayer(Target)) then
			local T = FindPlayer(Target)
			T:UnLock()
			Con("[D] " .. ply:Nick() .. " unfroze " .. T:Nick() .. ".")
		else
			Con("[D] No player with the name '" .. Target .. "' found!")
		end
	else
		Con("[D] You must enter a name!")
	end
end