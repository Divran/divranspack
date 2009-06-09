function OpenHelpTab( ply )
	CreateDmenu( ply )
	Tabs:SetActiveTab( 4 )
end
concommand.Add("Dmod_help", OpenHelpTab)

function CreateDmenu( ply )
	if (ply:IsAdmin()) then
		--Window
		local w, h = 1400, 600
		if (w > ScrW()) then w = ScrW() - 20 end
		local Menu = vgui.Create( "DFrame" )
		Menu:SetPos( ScrW() / 2 - w / 2, ScrH() / 2 - h / 2 )
		Menu:SetSize( w, h )
		Menu:SetTitle( "[D] Menu" )
		Menu:SetVisible( true )
		Menu:SetDraggable( true )
		Menu:ShowCloseButton( false )
		Menu:MakePopup()
		
		--Close Button
		local CloseButton = vgui.Create( "DButton", Menu )
		CloseButton:SetWide( w - 10 )
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
		PlayerList:SetSize( w / 3 - 10, h - 60 )
		PlayerList:SetMultiSelect( false )
		local Name = PlayerList:AddColumn("Name")
		Name:SetWide(250)
		local Team = PlayerList:AddColumn("Team")
		Team:SetWide(200)
		local Props = PlayerList:AddColumn("Props")
		Props:SetWide(150)
		for k, v in pairs(player.GetAll()) do
			PlayerList:AddLine(v:Nick(), team.GetName(v:Team()), v:GetCount( "props" ) )
		end
		
		PlayerList:SelectFirstItem()
		
			--Tabs
			local Tabs = vgui.Create( "DPropertySheet" )
			Tabs:SetParent( Menu )
			Tabs:SetPos( 10 + PlayerList:GetWide(), 30 )
			Tabs:SetSize( w * (2/3) - 10, h - 60 )
			
			--Tab nr 1
			local TeleTab = vgui.Create( "DPanel" )
			TeleTab.Paint = function( ) end
			
			--Goto Button
			local GotoButton = vgui.Create( "DButton", TeleTab )
			GotoButton:SetWide( 80 )
			GotoButton:SetTall( 30 )
			GotoButton:SetText( "Goto" )
			GotoButton:SetPos( 30, 30 )
			function GotoButton:DoClick( )
				if (PlayerList:GetSelected()[1]:GetValue(1) != "") then
					local ListSel = PlayerList:GetSelected()[1]:GetValue( 1 )
					RunConsoleCommand( "Dmod", "Goto", ListSel )
				end
			end
			
			--Bring Button
			local BringButton = vgui.Create( "DButton", TeleTab )
			BringButton:SetWide( 80 )
			BringButton:SetTall( 30 )
			BringButton:SetText( "Bring" )
			BringButton:SetPos( 150, 30 )
			function BringButton:DoClick( )
				if (PlayerList:GetSelected()[1]:GetValue(1) != "") then
					local ListSel = PlayerList:GetSelected()[1]:GetValue( 1 )
					RunConsoleCommand( "Dmod", "Bring", ListSel )
				end
			end
			
			--Kick Button
			local KickButton = vgui.Create( "DButton", TeleTab )
			KickButton:SetWide( 80 )
			KickButton:SetTall( 30 )
			KickButton:SetText( "Kick" )
			KickButton:SetPos( 30, 70 )
			function KickButton:DoClick( )
				if (PlayerList:GetSelected()[1]:GetValue(1) != "") then
					local ListSel = PlayerList:GetSelected()[1]:GetValue( 1 )
					RunConsoleCommand( "Dmod", "Kick", ListSel )
				end
			end
			
			--Ban Button
			local BanButton = vgui.Create( "DButton", TeleTab )
			BanButton:SetWide( 80 )
			BanButton:SetTall( 30 )
			BanButton:SetText( "Ban (10 mins)" )
			BanButton:SetPos( 150, 70 )
			function BanButton:DoClick( )
				if (PlayerList:GetSelected()[1]:GetValue(1) != "") then
					local ListSel = PlayerList:GetSelected()[1]:GetValue( 1 )
					RunConsoleCommand( "Dmod", "Ban", ListSel )
				end
			end
			
		Tabs:AddSheet( "Tele and Administration", TeleTab, "gui/silkicons/lightning", false, false, "Teleportation commands and administration commands" )
		
			--Tab nr 2
			local PunishTab = vgui.Create( "DPanel" )
			PunishTab.Paint = function( ) end
			
			--Slay Button
			local SlayButton = vgui.Create( "DButton", PunishTab )
			SlayButton:SetWide( 80 )
			SlayButton:SetTall( 30 )
			SlayButton:SetText( "Slay" )
			SlayButton:SetPos( 30, 30 )
			function SlayButton:DoClick( )
				if (PlayerList:GetSelected()[1]:GetValue(1) != "") then
					local ListSel = PlayerList:GetSelected()[1]:GetValue( 1 )
					RunConsoleCommand( "Dmod", "Slay", ListSel )
				end
			end
			
			--Blow Button
			local BlowButton = vgui.Create( "DButton", PunishTab )
			BlowButton:SetWide( 80 )
			BlowButton:SetTall( 30 )
			BlowButton:SetText( "Blow" )
			BlowButton:SetPos( 150, 30 )
			function BlowButton:DoClick( )
				if (PlayerList:GetSelected()[1]:GetValue(1) != "") then
					local ListSel = PlayerList:GetSelected()[1]:GetValue( 1 )
					RunConsoleCommand( "Dmod", "Blow", ListSel )
				end
			end
			
			--Freeze Button
			local FreezeButton = vgui.Create( "DButton", PunishTab )
			FreezeButton:SetWide( 80 )
			FreezeButton:SetTall( 30 )
			FreezeButton:SetText( "Freeze" )
			FreezeButton:SetPos( 30, 70 )
			function FreezeButton:DoClick( )
				if (PlayerList:GetSelected()[1]:GetValue(1) != "") then
					local ListSel = PlayerList:GetSelected()[1]:GetValue( 1 )
					RunConsoleCommand( "Dmod", "Freeze", ListSel )
				end
			end
			
			--Unfreeze Button
			local UnFreezeButton = vgui.Create( "DButton", PunishTab )
			UnFreezeButton:SetWide( 80 )
			UnFreezeButton:SetTall( 30 )
			UnFreezeButton:SetText( "Unfreeze" )
			UnFreezeButton:SetPos( 150, 70 )
			function UnFreezeButton:DoClick( )
				if (PlayerList:GetSelected()[1]:GetValue(1) != "") then
					local ListSel = PlayerList:GetSelected()[1]:GetValue( 1 )
					RunConsoleCommand( "Dmod", "Unfreeze", ListSel )
				end
			end
			
			--Burn Button
			local BurnButton = vgui.Create( "DButton", PunishTab )
			BurnButton:SetWide( 80 )
			BurnButton:SetTall( 30 )
			BurnButton:SetText( "Burn" )
			BurnButton:SetPos( 30, 110 )
			function BurnButton:DoClick( )
				if (PlayerList:GetSelected()[1]:GetValue(1) != "") then
					local ListSel = PlayerList:GetSelected()[1]:GetValue( 1 )
					RunConsoleCommand( "Dmod", "Burn", ListSel )
				end
			end
			
			--UnBurn Button
			local UnBurnButton = vgui.Create( "DButton", PunishTab )
			UnBurnButton:SetWide( 80 )
			UnBurnButton:SetTall( 30 )
			UnBurnButton:SetText( "Unburn" )
			UnBurnButton:SetPos( 150, 110 )
			function UnBurnButton:DoClick( )
				if (PlayerList:GetSelected()[1]:GetValue(1) != "") then
					local ListSel = PlayerList:GetSelected()[1]:GetValue( 1 )
					RunConsoleCommand( "Dmod", "Unburn", ListSel )
				end
			end

		Tabs:AddSheet( "Punishment", PunishTab, "gui/silkicons/exclamation", false, false, "Punishment Tab" )
		
			--Tab nr 3
			local PowerTab = vgui.Create( "DPanel" )
			PowerTab.Paint = function( ) end
			
			--Hp Button
			local HealthButton = vgui.Create( "DButton", PowerTab )
			HealthButton:SetWide( 80 )
			HealthButton:SetTall( 30 )
			HealthButton:SetText( "Health (Reset)" )
			HealthButton:SetPos( 30, 30 )
			function HealthButton:DoClick( )
				if (PlayerList:GetSelected()[1]:GetValue(1) != "") then
					local ListSel = PlayerList:GetSelected()[1]:GetValue( 1 )
					RunConsoleCommand( "Dmod", "Health", ListSel )
				end
			end
			
			--Armor Button
			local ArmorButton = vgui.Create( "DButton", PowerTab )
			ArmorButton:SetWide( 80 )
			ArmorButton:SetTall( 30 )
			ArmorButton:SetText( "Armor (Reset)" )
			ArmorButton:SetPos( 150, 30 )
			function ArmorButton:DoClick( )
				if (PlayerList:GetSelected()[1]:GetValue(1) != "") then
					local ListSel = PlayerList:GetSelected()[1]:GetValue( 1 )
					RunConsoleCommand( "Dmod", "Armor", ListSel )
				end
			end
			
			--Speed Button
			local SpeedButton = vgui.Create( "DButton", PowerTab )
			SpeedButton:SetWide( 80 )
			SpeedButton:SetTall( 30 )
			SpeedButton:SetText( "Speed (Reset)" )
			SpeedButton:SetPos( 30, 70 )
			function SpeedButton:DoClick( )
				if (PlayerList:GetSelected()[1]:GetValue(1) != "") then
					local ListSel = PlayerList:GetSelected()[1]:GetValue( 1 )
					RunConsoleCommand( "Dmod", "Speed", ListSel )
				end
			end
			
			--Jump Button
			local JumpButton = vgui.Create( "DButton", PowerTab )
			JumpButton:SetWide( 80 )
			JumpButton:SetTall( 30 )
			JumpButton:SetText( "Jump (Reset)" )
			JumpButton:SetPos( 150, 70 )
			function JumpButton:DoClick( )
				if (PlayerList:GetSelected()[1]:GetValue(1) != "") then
					local ListSel = PlayerList:GetSelected()[1]:GetValue( 1 )
					RunConsoleCommand( "Dmod", "Jump", ListSel )
				end
			end
			
			--God Button
			local GodButton = vgui.Create( "DButton", PowerTab )
			GodButton:SetWide( 80 )
			GodButton:SetTall( 30 )
			GodButton:SetText( "God" )
			GodButton:SetPos( 30, 110 )
			function GodButton:DoClick( )
				if (PlayerList:GetSelected()[1]:GetValue(1) != "") then
					local ListSel = PlayerList:GetSelected()[1]:GetValue( 1 )
					RunConsoleCommand( "Dmod", "God", ListSel )
				end
			end
			
			--UnGod Button
			local UnGodButton = vgui.Create( "DButton", PowerTab )
			UnGodButton:SetWide( 80 )
			UnGodButton:SetTall( 30 )
			UnGodButton:SetText( "Ungod" )
			UnGodButton:SetPos( 150, 110 )
			function UnGodButton:DoClick( )
				if (PlayerList:GetSelected()[1]:GetValue(1) != "") then
					local ListSel = PlayerList:GetSelected()[1]:GetValue( 1 )
					RunConsoleCommand( "Dmod", "Ungod", ListSel )
				end
			end
			Tabs:AddSheet( "Admin Powers", PowerTab, "gui/silkicons/emoticon_smile", false, false, "A tab full of admin powers for you to play around with" )
			
			--Tab nr 4
			local HelpTab = vgui.Create( "DPanel" )
			HelpTab.Paint = function( ) end
			
			--List
			local HelpList = vgui.Create( "DPanelList", HelpTab )
			HelpList:SetPos( 5, 5 )
			HelpList:SetSize( Tabs:GetWide() - 10, Tabs:GetTall() - 10 )
			HelpList:SetSpacing( 5 )
			HelpList:EnableHorizontal( false )
			HelpList:EnableVerticalScrollbar( true )
			
				local HelpText1 = vgui.Create( "DLabel" )
				HelpText1:SetText([[Here is a list of all chat commands:
								On some of the commands, <name> is optional.
								If you do not enter a name in these chat commands, you will target yourself.
								<> = Target Player's Name
								[] = A number
								{} = A string (text)
								!tele <name> - Teleport to where you aim
								!goto <name> - Teleport to someone else
								!bring <name> - Teleport someone else to you
								!send <name1> <name2> - Teleport one person to another
								!slay <name> - Kill someone
								!blow <name> - Blow someone up
								!hp <name> [number] - Change someone's health
								!armor <name> [number] - Change someone's armor
								!speed <name> [number] - Change someone's movement speed
								!jump <name> [number] - Change someone's jump strength
								!god <name> - Make someone invurnable
								!ungod <name> - Make someone vurnable
								!burn <name> - Set someone on fire
								!unburn <name> - Unignite someone]])
				HelpText1:SizeToContents()
				HelpText1:SetTextColor(Color(0, 0, 0, 255))
			HelpList:AddItem( HelpText1 )

				local HelpText2 = vgui.Create( "DLabel" )
				HelpText2:SetText([[!decals - Clear all the decals (explosion marks, bullet holes, and such)
								!kick <name> {reason} - Kick someone
								!ban <name> [time] {reason} - Ban someone
								!freeze <name> - Freeze someone
								!unfreeze <name> - Unfreeze someone
								!spectate <name> - Spectate someone. Has two modes: "chase" and "firstperson"
								!unspectate - Stop spectating
								!noclip <name> - Force someone into or out of noclip, even if noclip is disabled]])
				HelpText2:SizeToContents()
				HelpText2:SetTextColor(Color(0, 0, 0, 255))
			HelpList:AddItem( HelpText2 )
			
		Tabs:AddSheet( "Help", HelpTab, "gui/silkicons/star", false, false, "A list of all chat commands." )
			
	else
		ply:PrintMessage( HUD_PRINTTALK, "[D] (Silent) You are not an admin!" )
	end
end
concommand.Add("Dmod_Menu", CreateDmenu )