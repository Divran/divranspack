function OpenHelpTab( ply )
	CreateDmenu( ply )
	timer.Simple( 0.5, function() Tabs:SetActiveTab( 4 ) end)
end
concommand.Add("Dmod_help", OpenHelpTab)

function CreateDmenu( ply )
	if (ply:IsAdmin()) then
		--Window
		local w, h = 900, 600
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
		PlayerList:SetSize( w - 10, h / 3 - 10 )
		PlayerList:SetMultiSelect( false )
		local Name = PlayerList:AddColumn("Name")
		Name:SetWide(w/2)
		local Team = PlayerList:AddColumn("Team")
		Team:SetWide(w/4)
		local Props = PlayerList:AddColumn("Nr of things spawned")
		Props:SetWide(w/4)
		for k, v in pairs(player.GetAll()) do
			PlayerList:AddLine(v:Nick(), team.GetName(v:Team()), v:GetCount( "props" ) )
			line.Player = v
		end
		PlayerList:SelectFirstItem()
		
		local function GetName() return list.Player:Nick() end
		
			--Tabs
			Tabs = vgui.Create( "DPropertySheet" )
			Tabs:SetParent( Menu )
			Tabs:SetPos( 5, PlayerList:GetTall() + 40 )
			Tabs:SetSize( w - 10, h * (2/3) - 60 )



			
			--Tab nr 1
			local TeleTab = vgui.Create( "DPanel" )
			TeleTab.Paint = function( ) end
			
			--Goto Button
			local GotoButton = vgui.Create( "DButton", TeleTab )
			GotoButton:SetWide( 80 )
			GotoButton:SetTall( 30 )
			GotoButton:SetText( "Goto" )
			GotoButton:SetPos( 30 + 90 * 0, 30 + 40 * 0 )
			function GotoButton:DoClick( )
					RunConsoleCommand( "Dmod", "Goto", GetName() )
			end
			
			--Bring Button
			local BringButton = vgui.Create( "DButton", TeleTab )
			BringButton:SetWide( 80 )
			BringButton:SetTall( 30 )
			BringButton:SetText( "Bring" )
			BringButton:SetPos( 30 + 90 * 1, 30 + 40 * 0 )
			function BringButton:DoClick( )
					RunConsoleCommand( "Dmod", "Bring", GetName() )
			end
			
			--Kick Button
			local KickButton = vgui.Create( "DButton", TeleTab )
			KickButton:SetWide( 80 )
			KickButton:SetTall( 30 )
			KickButton:SetText( "Kick" )
			KickButton:SetPos( 30 + 90 * 0, 30 + 40 * 1 )
			function KickButton:DoClick( )
					RunConsoleCommand( "Dmod", "Kick", GetName() )
			end
			
			--Ban Button
			local BanButton = vgui.Create( "DButton", TeleTab )
			BanButton:SetWide( 80 )
			BanButton:SetTall( 30 )
			BanButton:SetText( "Ban (10 mins)" )
			BanButton:SetPos( 30 + 90 * 1, 30 + 40 * 1 )
			function BanButton:DoClick( )
					RunConsoleCommand( "Dmod", "Ban", GetName() )
			end
			
			--Spectate Chase Button
			local SpecButton = vgui.Create( "DButton", TeleTab )
			SpecButton:SetWide( 120 )
			SpecButton:SetTall( 30 )
			SpecButton:SetText( "Spectate (Chase)" )
			SpecButton:SetPos( 30 + 90 * 6, 30 + 40 * 0 )
			function SpecButton:DoClick( )
					RunConsoleCommand( "Dmod", "Spectate", GetName(), "chase" )
			end
			
			--Spectate First Person Button
			local SpecButton = vgui.Create( "DButton", TeleTab )
			SpecButton:SetWide( 120 )
			SpecButton:SetTall( 30 )
			SpecButton:SetText( "Spectate (First Person)" )
			SpecButton:SetPos( 30 + 90 * 6, 30 + 40 * 1 )
			function SpecButton:DoClick( )
					RunConsoleCommand( "Dmod", "Spectate", GetName(), "firstperson" )
			end
			
			--Unspectate Button
			local UnSpecButton = vgui.Create( "DButton", TeleTab )
			UnSpecButton:SetWide( 120 )
			UnSpecButton:SetTall( 30 )
			UnSpecButton:SetText( "Unspectate" )
			UnSpecButton:SetPos( 30 + 90 * 6, 30 + 40 * 2 )
			function UnSpecButton:DoClick( )
					RunConsoleCommand( "Dmod", "Unspectate" )
			end
			
			--Clear Decals Button
			local DecalButton = vgui.Create( "DButton", TeleTab )
			DecalButton:SetWide( 80 )
			DecalButton:SetTall( 30 )
			DecalButton:SetText( "Clear decals" )
			DecalButton:SetPos( 30 + 90 * 2, 30 + 40 * 0 )
			function DecalButton:DoClick( )
					RunConsoleCommand( "Dmod", "Decals" )
			end
			
		Tabs:AddSheet( "Administration", TeleTab, "gui/silkicons/lightning", false, false, "Teleportation commands and administration commands" )
		
			--Tab nr 2
			local PunishTab = vgui.Create( "DPanel" )
			PunishTab.Paint = function( ) end
			
			--Slay Button
			local SlayButton = vgui.Create( "DButton", PunishTab )
			SlayButton:SetWide( 80 )
			SlayButton:SetTall( 30 )
			SlayButton:SetText( "Slay" )
			SlayButton:SetPos( 30 + 90 * 0, 30 + 40 * 0 )
			function SlayButton:DoClick( )
					RunConsoleCommand( "Dmod", "Slay", GetName() )
			end
			
			--Blow Button
			local BlowButton = vgui.Create( "DButton", PunishTab )
			BlowButton:SetWide( 80 )
			BlowButton:SetTall( 30 )
			BlowButton:SetText( "Blow" )
			BlowButton:SetPos( 30 + 90 * 1, 30 + 40 * 0 )
			function BlowButton:DoClick( )
					RunConsoleCommand( "Dmod", "Blow", GetName() )
			end
			
			--Freeze Button
			local FreezeButton = vgui.Create( "DButton", PunishTab )
			FreezeButton:SetWide( 80 )
			FreezeButton:SetTall( 30 )
			FreezeButton:SetText( "Freeze" )
			FreezeButton:SetPos( 30 + 90 * 0, 30 + 40 * 1 )
			function FreezeButton:DoClick( )
					RunConsoleCommand( "Dmod", "Freeze", GetName() )
			end
			
			--Unfreeze Button
			local UnFreezeButton = vgui.Create( "DButton", PunishTab )
			UnFreezeButton:SetWide( 80 )
			UnFreezeButton:SetTall( 30 )
			UnFreezeButton:SetText( "Unfreeze" )
			UnFreezeButton:SetPos( 30 + 90 * 1, 30 + 40 * 1 )
			function UnFreezeButton:DoClick( )
					RunConsoleCommand( "Dmod", "Unfreeze", GetName() )
			end
			
			--Burn Button
			local BurnButton = vgui.Create( "DButton", PunishTab )
			BurnButton:SetWide( 80 )
			BurnButton:SetTall( 30 )
			BurnButton:SetText( "Burn" )
			BurnButton:SetPos( 30 + 90 * 0, 30 + 40 * 2 )
			function BurnButton:DoClick( )
					RunConsoleCommand( "Dmod", "Burn", GetName() )
			end
			
			--UnBurn Button
			local UnBurnButton = vgui.Create( "DButton", PunishTab )
			UnBurnButton:SetWide( 80 )
			UnBurnButton:SetTall( 30 )
			UnBurnButton:SetText( "Unburn" )
			UnBurnButton:SetPos( 30 + 90 * 1, 30 + 40 * 2 )
			function UnBurnButton:DoClick( )
					RunConsoleCommand( "Dmod", "Unburn", GetName() )
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
			HealthButton:SetPos( 30 + 90 * 0, 30 + 40 * 0 )
			function HealthButton:DoClick( )
					RunConsoleCommand( "Dmod", "Health", GetName() )
			end
			
			--Armor Button
			local ArmorButton = vgui.Create( "DButton", PowerTab )
			ArmorButton:SetWide( 80 )
			ArmorButton:SetTall( 30 )
			ArmorButton:SetText( "Armor (Reset)" )
			ArmorButton:SetPos( 30 + 90 * 1, 30 + 40 * 0 )
			function ArmorButton:DoClick( )
					RunConsoleCommand( "Dmod", "Armor", GetName() )
			end
			
			--Speed Button
			local SpeedButton = vgui.Create( "DButton", PowerTab )
			SpeedButton:SetWide( 80 )
			SpeedButton:SetTall( 30 )
			SpeedButton:SetText( "Speed (Reset)" )
			SpeedButton:SetPos( 30 + 90 * 0, 30 + 40 * 1 )
			function SpeedButton:DoClick( )
					RunConsoleCommand( "Dmod", "Speed", GetName() )
			end
			
			--Jump Button
			local JumpButton = vgui.Create( "DButton", PowerTab )
			JumpButton:SetWide( 80 )
			JumpButton:SetTall( 30 )
			JumpButton:SetText( "Jump (Reset)" )
			JumpButton:SetPos( 30 + 90 * 1, 30 + 40 * 1 )
			function JumpButton:DoClick( )
					RunConsoleCommand( "Dmod", "Jump", GetName() )
			end
			
			--God Button
			local GodButton = vgui.Create( "DButton", PowerTab )
			GodButton:SetWide( 80 )
			GodButton:SetTall( 30 )
			GodButton:SetText( "God" )
			GodButton:SetPos( 30 + 90 * 0, 30 + 40 * 2 )
			function GodButton:DoClick( )
					RunConsoleCommand( "Dmod", "God", GetName() )
			end
			
			--UnGod Button
			local UnGodButton = vgui.Create( "DButton", PowerTab )
			UnGodButton:SetWide( 80 )
			UnGodButton:SetTall( 30 )
			UnGodButton:SetText( "Ungod" )
			UnGodButton:SetPos( 30 + 90 * 1, 30 + 40 * 2 )
			function UnGodButton:DoClick( )
					RunConsoleCommand( "Dmod", "Ungod", GetName() )
			end
			
			--Noclip Button
			local NoclipButton = vgui.Create( "DButton", PowerTab )
			NoclipButton:SetWide( 80 )
			NoclipButton:SetTall( 30 )
			NoclipButton:SetText( "Noclip" )
			NoclipButton:SetPos( 30 + 90 * 0, 30 + 40 * 3 )
			function NoclipButton:DoClick( )
					RunConsoleCommand( "Dmod", "Noclip", GetName() )
			end
			Tabs:AddSheet( "Admin Powers", PowerTab, "gui/silkicons/emoticon_smile", false, false, "A tab full of admin powers for you to play around with" )
			
			--Tab nr 4
			local HelpTab = vgui.Create( "DPanel" )
			HelpTab.Paint = function( ) end
			
			--List
			local HelpList = vgui.Create( "DPanelList", HelpTab )
			HelpList.Paint = function( ) end
			HelpList:SetPos( 10, 20 )
			HelpList:SetSize( Tabs:GetWide() - 30, Tabs:GetTall() - 10 )
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
								!unburn <name> - Unignite someone	]])
				HelpText1:SizeToContents()
				HelpText1:SetTextColor(Color(0, 0, 0, 255))
			HelpList:AddItem( HelpText1 )

				local HelpText2 = vgui.Create( "DLabel" )
				HelpText2:SetText([[	!decals - Clear all the decals (explosion marks, bullet holes, and such)
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
		
			--Tab nr 5
			local ColorTab = vgui.Create( "DPanel" )
			ColorTab.Paint = function( ) end
			
			local Width = w / 5
			-- Owner Color
			local OwnerColorText = vgui.Create( "DLabel", ColorTab )
			OwnerColorText:SetText("Owner:")
			OwnerColorText:SizeToContents()
			OwnerColorText:SetPos( 40 + (Width+20) * 0, 10 )
			local OwnerColorRed = vgui.Create( "DNumSlider", ColorTab )
			OwnerColorRed:SetTall( 30 )
			OwnerColorRed:SetWide ( Width )
			OwnerColorRed:SetPos( 40 + (Width+20) * 0, 50 * 1 )
			OwnerColorRed:SetText( "R" )
			OwnerColorRed:SetMinMax( 0, 255 )
			OwnerColorRed:SetValue( 50 )
			local OwnerColorGreen = vgui.Create( "DNumSlider", ColorTab )
			OwnerColorGreen:SetTall( 30 )
			OwnerColorGreen:SetWide ( Width )
			OwnerColorGreen:SetPos( 40 + (Width+20) * 0, 50 * 2 )
			OwnerColorGreen:SetText( "G" )
			OwnerColorGreen:SetMinMax( 0, 255 )
			OwnerColorGreen:SetValue( 50 )
			local OwnerColorBlue = vgui.Create( "DNumSlider", ColorTab )
			OwnerColorBlue:SetTall( 30 )
			OwnerColorBlue:SetWide ( Width )
			OwnerColorBlue:SetPos( 40 + (Width+20) * 0, 50 * 3 )
			OwnerColorBlue:SetText( "B" )
			OwnerColorBlue:SetMinMax( 0, 255 )
			OwnerColorBlue:SetValue( 50 )
			function OwnerColorBlue:ValueChanged()
				TEAM_SetColor(1, Color( OwnerColorRed:GetValue(), OwnerColorGreen:GetValue(), OwnerColorBlue:GetValue() ))
			end
			function OwnerColorRed:ValueChanged()
				TEAM_SetColor(1, Color( OwnerColorRed:GetValue(), OwnerColorGreen:GetValue(), OwnerColorBlue:GetValue() ))
			end
			function OwnerColorGreen:ValueChanged()
				TEAM_SetColor(1, Color( OwnerColorRed:GetValue(), OwnerColorGreen:GetValue(), OwnerColorBlue:GetValue() ))
			end
			-- Super Admin Color
			local SuperAdminColorText = vgui.Create( "DLabel", ColorTab )
			SuperAdminColorText:SetText("SuperAdmin:")
			SuperAdminColorText:SizeToContents()
			SuperAdminColorText:SetPos( 40 + (Width+20) * 1, 50 * 0 )
			local SuperAdminColorRed = vgui.Create( "DNumSlider", ColorTab )
			SuperAdminColorRed:SetTall( 30 )
			SuperAdminColorRed:SetWide ( Width )
			SuperAdminColorRed:SetPos( 40 + (Width+20) * 1, 50 * 1 )
			SuperAdminColorRed:SetText( "R" )
			SuperAdminColorRed:SetMinMax( 0, 255 )
			SuperAdminColorRed:SetValue( 255 )
			local SuperAdminColorGreen = vgui.Create( "DNumSlider", ColorTab )
			SuperAdminColorGreen:SetTall( 30 )
			SuperAdminColorGreen:SetWide ( Width )
			SuperAdminColorGreen:SetPos( 40 + (Width+20) * 1, 50 * 2 )
			SuperAdminColorGreen:SetText( "G" )
			SuperAdminColorGreen:SetMinMax( 0, 255 )
			SuperAdminColorGreen:SetValue( 200 )
			local SuperAdminColorBlue = vgui.Create( "DNumSlider", ColorTab )
			SuperAdminColorBlue:SetTall( 30 )
			SuperAdminColorBlue:SetWide ( Width )
			SuperAdminColorBlue:SetPos( 40 + (Width+20) * 1, 50 * 3 )
			SuperAdminColorBlue:SetText( "B" )
			SuperAdminColorBlue:SetMinMax( 0, 255 )
			SuperAdminColorBlue:SetValue( 0 )
			function SuperAdminColorBlue:ValueChanged()
				TEAM_SetColor(1, Color( SuperAdminColorRed:GetValue(), SuperAdminColorGreen:GetValue(), SuperAdminColorBlue:GetValue() ))
			end
			function SuperAdminColorRed:ValueChanged()
				TEAM_SetColor(1, Color( SuperAdminColorRed:GetValue(), SuperAdminColorGreen:GetValue(), SuperAdminColorBlue:GetValue() ))
			end
			function SuperAdminColorGreen:ValueChanged()
				TEAM_SetColor(1, Color( SuperAdminColorRed:GetValue(), SuperAdminColorGreen:GetValue(), SuperAdminColorBlue:GetValue() ))
			end
			--Admin Color
			local AdminColorText = vgui.Create( "DLabel", ColorTab )
			AdminColorText:SetText("Admin:")
			AdminColorText:SizeToContents()
			AdminColorText:SetPos( 40 + (Width+20) * 2, 50 * 0 )
			local AdminColorRed = vgui.Create( "DNumSlider", ColorTab )
			AdminColorRed:SetTall( 30 )
			AdminColorRed:SetWide ( Width )
			AdminColorRed:SetPos( 40 + (Width+20) * 2, 50 * 1 )
			AdminColorRed:SetText( "R" )
			AdminColorRed:SetMinMax( 0, 255 )
			AdminColorRed:SetValue( 200 )
			local AdminColorGreen = vgui.Create( "DNumSlider", ColorTab )
			AdminColorGreen:SetTall( 30 )
			AdminColorGreen:SetWide ( Width )
			AdminColorGreen:SetPos( 40 + (Width+20) * 2, 50 * 2 )
			AdminColorGreen:SetText( "G" )
			AdminColorGreen:SetMinMax( 0, 255 )
			AdminColorGreen:SetValue( 80 )
			local AdminColorBlue = vgui.Create( "DNumSlider", ColorTab )
			AdminColorBlue:SetTall( 30 )
			AdminColorBlue:SetWide ( Width )
			AdminColorBlue:SetPos( 40 + (Width+20) * 2, 50 * 3 )
			AdminColorBlue:SetText( "B" )
			AdminColorBlue:SetMinMax( 0, 255 )
			AdminColorBlue:SetValue( 80 )
			function AdminColorBlue:ValueChanged()
				TEAM_SetColor(1, Color( AdminColorRed:GetValue(), AdminColorGreen:GetValue(), AdminColorBlue:GetValue() ))
			end
			function AdminColorRed:ValueChanged()
				TEAM_SetColor(1, Color( AdminColorRed:GetValue(), AdminColorGreen:GetValue(), AdminColorBlue:GetValue() ))
			end
			function AdminColorGreen:ValueChanged()
				TEAM_SetColor(1, Color( AdminColorRed:GetValue(), AdminColorGreen:GetValue(), AdminColorBlue:GetValue() ))
			end
			function TEAM_SetColor(num, tblColor) 
				team.SetUp(num,team.GetName(num),tblColor)
			end 
			--Guest Color
			local GuestColorText = vgui.Create( "DLabel", ColorTab )
			GuestColorText:SetText("Guest:")
			GuestColorText:SizeToContents()
			GuestColorText:SetPos( 40 + (Width+20) * 3, 50 * 0 )
			local GuestColorRed = vgui.Create( "DNumSlider", ColorTab )
			GuestColorRed:SetTall( 30 )
			GuestColorRed:SetWide ( Width )
			GuestColorRed:SetPos( 40 + (Width+20) * 3, 50 * 1 )
			GuestColorRed:SetText( "R" )
			GuestColorRed:SetMinMax( 0, 255 )
			GuestColorRed:SetValue( 100 )
			local GuestColorGreen = vgui.Create( "DNumSlider", ColorTab )
			GuestColorGreen:SetTall( 30 )
			GuestColorGreen:SetWide ( Width )
			GuestColorGreen:SetPos( 40 + (Width+20) * 3, 50 * 2 )
			GuestColorGreen:SetText( "G" )
			GuestColorGreen:SetMinMax( 0, 255 )
			GuestColorGreen:SetValue( 100 )
			local GuestColorBlue = vgui.Create( "DNumSlider", ColorTab )
			GuestColorBlue:SetTall( 30 )
			GuestColorBlue:SetWide ( Width )
			GuestColorBlue:SetPos( 40 + (Width+20) * 3, 50 * 3 )
			GuestColorBlue:SetText( "B" )
			GuestColorBlue:SetMinMax( 0, 255 )
			GuestColorBlue:SetValue( 255 )
			function GuestColorBlue:ValueChanged()
				TEAM_SetColor(1, Color( GuestColorRed:GetValue(), GuestColorGreen:GetValue(), GuestColorBlue:GetValue() ))
			end
			function GuestColorRed:ValueChanged()
				TEAM_SetColor(1, Color( GuestColorRed:GetValue(), GuestColorGreen:GetValue(), GuestColorBlue:GetValue() ))
			end
			function GuestColorGreen:ValueChanged()
				TEAM_SetColor(1, Color( GuestColorRed:GetValue(), GuestColorGreen:GetValue(), GuestColorBlue:GetValue() ))
			end
			function TEAM_SetColor(num, tblColor) 
				team.SetUp(num,team.GetName(num),tblColor)
			end 
		Tabs:AddSheet( "Team Color", ColorTab, "gui/silkicons/color_wheel", false, false, "Change the color of the teams." )
			
	else
		ply:PrintMessage( HUD_PRINTTALK, "[D] (Silent) You are not an admin!" )
	end
end
concommand.Add("Dmod_Menu", CreateDmenu )