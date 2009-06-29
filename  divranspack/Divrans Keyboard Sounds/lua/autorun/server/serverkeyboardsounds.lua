AddCSLuaFile( "autorun/client/clientkeyboardsounds.lua" )


local function ChatChanged( ply )
	local Rnd = math.Round(math.random(0,20))
	if (Rnd >= 1 and Rnd <= 6) then 
		ply:EmitSound( "ambient/machines/keyboard"..Rnd.."_clicks.wav", 65, 100 )
	end
end
concommand.Add( "ChatChanged", ChatChanged )


local function ChatChangedEnter( ply )
	local Rnd = math.Round(math.random(0,4))
	if (Rnd == 1 or Rnd == 2) then
		ply:EmitSound( "ambient/machines/keyboard7_clicks_enter.wav", 65, 100 )
	end
end
concommand.Add( "ChatChangedEnter", ChatChangedEnter )