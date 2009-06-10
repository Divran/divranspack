-- Well, this wasn't so hard, was it? :D
function ChatSound( ply, Msg, Teamchat, Dead )
		chat.PlaySound("sound/common/talk.wav")
end
hook.Add( "OnPlayerChat", "ChatSound", ChatSound )