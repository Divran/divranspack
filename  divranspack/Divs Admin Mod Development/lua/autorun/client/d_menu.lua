function CreateDmenu( ply )
	--Window
	local w, h = 600, 600
	local Menu = vgui.Create( "DFrame" )
	Menu:SetPos( ScrW() / 2 - w / 2, ScrH() / 2 - h / 2 )
	Menu:SetSize( w, h )
	Menu:SetTitle( "[D] Menu" )
	Menu:SetVisible( true )
	Menu:SetDraggable( false )
	Menu:ShowCloseButton( false )
	Menu:MakePopup()
	
	--Close Button
	local CloseButton = vgui.Create( "DButton", Menu )
	CloseButton:SetWide( 570 )
	CloseButton:SetTall( 20 )
	CloseButton:SetText( "Close Menu" )
	CloseButton:SetPos( Menu:GetWide() / 2 - CloseButton:GetWide() / 2, Menu:GetTall() - CloseButton:GetTall() - 5 )
	function CloseButton:DoClick( )
		Menu:Remove()
	end
	
	--Player List
	local PlayerList = vgui.Create( "DListView" )
	PlayerList:SetParent( Menu )
	PlayerList:SetPos( 5, 30 )
	PlayerList:SetSize( w / 2 - 5, h - 60 )
	PlayerList:SetMultiSelect( false )
	PlayerList:AddColumn("Name")
	PlayerList:AddColumn("Rank")
	PlayerList:AddColumn("Props")
	for k, v in pairs(player.GetAll()) do
		PlayerList:AddLine(v:Nick(), team.GetName(v:Team()), v:GetCount( "props" ) )
	end
	
		--Tabs
		local Tabs = vgui.Create( "DPropertySheet" )
		Tabs:SetParent( Menu )
		Tabs:SetPos( w / 2 + 5, 30 )
		Tabs:SetSize( w / 2 - 10, h - 60 )
		
		--Tab nr 1
		local TeleTab = vgui.Create( "DPanel" )
		TeleTab.Paint = function( ) end
		
		local GotoButton = vgui.Create( "DButton", TeleTab )
		GotoButton:SetWide( 80 )
		GotoButton:SetTall( 30 )
		GotoButton:SetText( "Goto" )
		GotoButton:SetPos( 30, 30 )
		function GotoButton:DoClick( )
			local ListSel = PlayerList:GetSelected()[1]:GetValue( 1 )
			if (ListSel and ListSel != "") then
				RunConsoleCommand( "D", "Goto", ListSel )
				ply:PrintMessage( HUD_PRINTTALK, "[D] ListSel: " .. ListSel )
			else
				ply:PrintMessage( HUD_PRINTTALK, "[D] (Silent) You must select a player in the list!" )
			end
		end
		
	Tabs:AddSheet( "Teleportation", TeleTab, "gui/silkicons/lightning", false, false, "Teleportation Tab" )
end
concommand.Add("d_menu", CreateDmenu )