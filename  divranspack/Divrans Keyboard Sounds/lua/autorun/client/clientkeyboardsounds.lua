local function ChatKeyboardSounds( )
	RunConsoleCommand( "ChatChanged" )
end
hook.Add( "ChatTextChanged", "ChatKeyboardSounds", ChatKeyboardSounds )

local function ChatKeyboardSoundsEnter( )
	RunConsoleCommand( "ChatChangedEnter" )
end
hook.Add( "OnPlayerChat", "ChatKeyboardSoundsEnter", ChatKeyboardSoundsEnter )