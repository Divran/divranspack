local AvailableColors = {}
AvailableColors[1] = Color( 255, 0, 0 ) -- Red
AvailableColors[2] = Color( 0, 255, 0 ) -- Green
AvailableColors[3] = Color( 255, 255, 0 ) -- Yellow
AvailableColors[4] = Color( 0, 0, 255 ) -- Blue
AvailableColors[5] = Color( 0, 255, 255 ) -- Cyan
AvailableColors[6] = Color( 255, 0, 255 ) -- Pink
AvailableColors[7] = Color( 255, 255, 255 ) -- White
AvailableColors[8] = "teamcolor!" -- Default team color
AvailableColors[9] = "teamcolor!" -- Default team color
AvailableColors[0] = Color( 0, 0, 0 ) -- Black

local function ColorNames( ply, Txt, TeamChat, IsDead )
	-- Look for a ^
	if ( IsValid( ply ) ) then 
		local Msg = {}
		local Name = ply:Nick()
		if (string.find( Name, "%^" )) then
			
			-- Dead?
			if (IsDead) then
				table.insert( Msg, Color( 255, 30, 40 ))
				table.insert( Msg, "*DEAD* " )
			end
			
			-- Team Chat
			if (TeamChat) then
				table.insert( Msg, Color( 30, 160, 40 ) )
				table.insert( Msg, "(TEAM) " )
			end
				
			-- explode the name
			local Array = {}
			for v in string.gmatch(Name, "[^%^]+") do -- Thanks to Nevec for helping me with gmatch.
				table.insert( Array, v )
			end
			
			-- main code
			local checker
			for I, str in pairs(Array) do
					checker = tonumber(string.Left(str,1))
					if (checker) then
						if (AvailableColors[checker] == "teamcolor!") then
							table.insert( Msg, team.GetColor( ply:Team() ) )
						else
							table.insert( Msg, AvailableColors[checker] )
						end
						table.insert( Msg, string.Right(str, string.len(str)-1) )
					else
						table.insert( Msg, team.GetColor( ply:Team() ) )
						table.insert( Msg, string.Right(str, string.len(str)) )
					end
			end
			
			-- The message
			table.insert( Msg, Color( 255,255,255 ) )
			table.insert( Msg, ": " .. Txt )
			
			-- print it to chat
			chat.AddText( unpack(Msg) )
			return true
		end
	end
end
hook.Add("OnPlayerChat","ColorNames",ColorNames)