AddCSLuaFile( "autorun/client/clientkeyboardsounds.lua" )


local function ChatChanged( ply )
	local Rnd = math.Round(math.random(0,6))
	if (Rnd >= 1 and Rnd <= 6 and Rnd != 4) then
		ply:EmitSound( "ambient/machines/keyboard"..Rnd.."_clicks.wav", 65, 100 )
	end
end
concommand.Add( "ChatChanged", ChatChanged )


local function ChatChangedEnter( ply )
	local Rnd = math.Round(math.random(0,3))
	if (Rnd == 1 or Rnd == 2) then
		ply:EmitSound( "ambient/machines/keyboard7_clicks_enter.wav", 65, 100 )
	end
end
concommand.Add( "ChatChangedEnter", ChatChangedEnter )