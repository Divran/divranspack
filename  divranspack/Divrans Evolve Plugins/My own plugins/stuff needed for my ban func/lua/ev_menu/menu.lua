/*-------------------------------------------------------------------------------------------------------------------------
	Evolve GUI clientside
-------------------------------------------------------------------------------------------------------------------------*/

evolve.menuw = 600
evolve.menuh = 400
evolve.menutabs = {}

function evolve:RegisterMenuTab( tab )
	table.insert( self.menutabs, tab )
end

function evolve:LoadMenuTabs()
	for _, v in pairs( file.FindInLua( "ev_menu/tab_*.lua" ) ) do
		include( "ev_menu/" .. v )
	end
end

function evolve:BuildMenu()	
	self.menu = vgui.Create( "DFrame" )
	self.menu:SetSize( self.menuw, self.menuh )
	self.menu:SetPos( ScrW() / 2 - self.menuw / 2, ScrH() / 2 - self.menuh / 2 )
	self.menu:SetDraggable( false )
	self.menu:ShowCloseButton( false )
	self.menu:SetTitle( "" )
	self.menu.Paint = function() end
	self.menu:MakePopup()
	
	self.menuContainer = vgui.Create( "DPropertySheet", self.menu )
	self.menuContainer:SetPos( 0, 0 )
	self.menuContainer:SetSize( self.menuw, self.menuh )
	
	include( "ev_menu/control_toolbutton.lua" )
	include( "ev_menu/control_logitem.lua" )
	for _, v in pairs( file.FindInLua( "ev_menu/tab_*.lua" ) ) do
		include( "ev_menu/" .. v )
		
		self.menutabs[ #self.menutabs ]:Initialize()
	end
end

function evolve:OpenMenu( ply )
	if ( CLIENT ) then
		if ( !LocalPlayer():EV_IsAdmin() ) then
			chat.AddText( evolve.colors.red, evolve.constants.notallowed )
			return false
		end
		if ( !self.menu ) then self:BuildMenu() end
		
		for _, tab in ipairs( self.menutabs ) do
			tab:Update()
		end
		
		self.menu:SetVisible( true )
	else
		umsg.Start( "EV_OpenMenu", ply )
		umsg.End()
	end
end

function evolve:CloseMenu( ply )
	if ( CLIENT ) then
		if ( self.menu and !evolve.MenuLocked ) then self.menu:SetVisible( false ) end
	else
		umsg.Start( "EV_CloseMenu", ply )
		umsg.End()
	end
end

concommand.Add( "+ev_menu", function( ply )
	evolve:OpenMenu( ply )
end )

if (CLIENT) then evolve.MenuLocked = false end

concommand.Add( "-ev_menu", function( ply )
	evolve:CloseMenu( ply )
end )

usermessage.Hook( "EV_OpenMenu", function()
	evolve:OpenMenu()
end )

usermessage.Hook( "EV_CloseMenu", function()
	evolve:CloseMenu()
end )