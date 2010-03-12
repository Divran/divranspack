-- Well, this wasn't so hard, was it? :D
function ChatThing( ply, Msg, Teamchat, Dead )
	if (Teamchat) then
		if (LocalPlayer():Team() == ply:Team()) then
			if (Dead) then
				chat.AddText(Color(255,0,0,255), "*DEAD* ", Color(0,150,0,255), "(TEAM) ", team.GetColor(ply:Team()), ply:Nick(), Color(255,255,255,255),": " .. Msg)
			else
				chat.AddText(Color(0,150,0,255), "(TEAM) ", team.GetColor(ply:Team()), ply:Nick(), Color(255,255,255,255),": " .. Msg)
			end
		end
	else
		if (Dead) then
			chat.AddText(Color(255,0,0,255), "*DEAD* ", team.GetColor(ply:Team()), ply:Nick(), Color(255,255,255,255),": " .. Msg)
		else
			chat.AddText(team.GetColor(ply:Team()), ply:Nick(), Color(255,255,255,255),": " .. Msg)
		end
	end
end
hook.Add( "OnPlayerChat", "ChatThing", ChatThing )