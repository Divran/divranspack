-------------------------------------------------------------------------------------------------------------------------
-- The Menu
-------------------------------------------------------------------------------------------------------------------------
local DmodPlugin = {}
DmodPlugin.ChatCommand = "menu"
DmodPlugin.Name = "menu"
DmodPlugin.ShowInMenu = false
DmodPlugin.RequiredRank = "admin" -- The rank required to use this command. Can be "guest", "admin", "super admin", or "owner".
if SERVER then Dmod_AddPlugin(DmodPlugin) end

-------------------------------------------------------------------------------------------------------------------------
-- Menu
-------------------------------------------------------------------------------------------------------------------------

if CLIENT then

	local function Dmod_Menu()
		if (LocalPlayer():IsAdmin()) then
			-- Main Window
			local w, h = 1200, 400
				if (w > ScrW()) then w = ScrW() - 20 end
				local Menu = vgui.Create( "DFrame" )
				Menu:SetPos( ScrW() / 2 - w / 2, ScrH() / 2 - h / 2 )
				Menu:SetSize( w, h )
				Menu:SetTitle( "[D] Menu" )
				Menu:SetVisible( true )
				Menu:SetDraggable( true )
				Menu:ShowCloseButton( false )
				Menu:MakePopup()
				
				-- Close Button
				local CloseButton = vgui.Create( "DButton", Menu )
				CloseButton:SetWide( w - 10 )
				CloseButton:SetTall( 20 )
				CloseButton:SetText( "Close Menu" )
				CloseButton:SetPos( Menu:GetWide() / 2 - CloseButton:GetWide() / 2, Menu:GetTall() - CloseButton:GetTall() - 5 )
				function CloseButton:DoClick( )
					Menu:Remove()
				end
				
				-- Main Tab
				local MainTab = vgui.Create( "DPropertySheet" )
				MainTab:SetParent( Menu )
				MainTab:SetPos( 5, 28 )
				MainTab:SetSize( w - 10, h - 60 )
				
				
					-- Players Tab
					local PlayerTab = vgui.Create( "DPropertySheet" )
					PlayerTab:SetParent( PlayerTab )
					PlayerTab:SetPos( 1, 45 )
					PlayerTab:SetSize( w - 20, h - 100 )
				
					for k, v in pairs(player.GetAll()) do
						local Tab = vgui.Create( "DPanel" )
						Tab.Paint = function( ) end
						
						-- Plugin Lists
						local AdminList = vgui.Create( "DListView" )
						AdminList:SetParent( Tab )
						AdminList:SetPos( 1, 1 )
						AdminList:SetSize( (w-40) / 3, h - 130 )
						AdminList:SetMultiSelect( false )
						-- Add the columns
						local Name = AdminList:AddColumn("Name")
						Name:SetWide(50)
						local Desc = AdminList:AddColumn("Administration -- Description")
						Desc:SetWide(150)
						local Creator = AdminList:AddColumn("Creator")
						Creator:SetWide(50)
						local ChatCmd = AdminList:AddColumn("Chat Cmd")
						ChatCmd:SetWide(30)
						-- When you click on a command in the list, run it.
						AdminList.OnClickLine = function(P,Line,I) RunConsoleCommand("Dmod", Line:GetValue(4), v:Nick()) end
						-- Fill the list with commands
						Dmod_FillList(AdminList, "administration")
						
						local PunishList = vgui.Create( "DListView" )
						PunishList:SetParent( Tab )
						PunishList:SetPos( AdminList:GetWide() + 5, 1 )
						PunishList:SetSize( (w-40) / 3, h - 130 )
						PunishList:SetMultiSelect( false )
						-- Add the columns
						local Name = PunishList:AddColumn("Name")
						Name:SetWide(50)
						local Desc = PunishList:AddColumn("Punishment -- Description")
						Desc:SetWide(150)
						local Creator = PunishList:AddColumn("Creator")
						Creator:SetWide(50)
						local ChatCmd = PunishList:AddColumn("Chat Cmd")
						ChatCmd:SetWide(30)
						-- When you click on a command in the list, run it.
						PunishList.OnClickLine = function(P,Line,I) RunConsoleCommand("Dmod", Line:GetValue(4), v:Nick()) end
						-- Fill the list with commands
						Dmod_FillList(PunishList, "punishment")
						
						local OtherList = vgui.Create( "DListView" )
						OtherList:SetParent( Tab )
						OtherList:SetPos( AdminList:GetWide() + PunishList:GetWide() + 10, 1 )
						OtherList:SetSize( (w-40) / 3, h - 130 )
						OtherList:SetMultiSelect( false )
						-- Add the columns
						local Name = OtherList:AddColumn("Name")
						Name:SetWide(50)
						local Desc = OtherList:AddColumn("Other -- Description")
						Desc:SetWide(150)
						local Creator = OtherList:AddColumn("Creator")
						Creator:SetWide(50)
						local ChatCmd = OtherList:AddColumn("Chat Cmd")
						ChatCmd:SetWide(30)
						-- When you click on a command in the list, run it.
						OtherList.OnClickLine = function(P,Line,I) RunConsoleCommand("Dmod", Line:GetValue(4), v:Nick()) end
						-- Fill the list with commands
						Dmod_FillList(OtherList, "other")
						
					
						-- Add the tab
						PlayerTab:AddSheet( v:Nick(), Tab, "gui/silkicons/user", false, false, "Do stuff to "..v:Nick() )
					end
					MainTab:AddSheet( "Players", PlayerTab, "gui/silkicons/group", false, false, "NOTE: Not all commands show up in the lists! Some require the use of the chat!" )
					
					-- Maps
					local Maps = vgui.Create( "DPanel" )
					Maps.Paint = function() end
					
					local MapList = vgui.Create( "DListView" )
					MapList:SetParent( Maps )
					MapList:SetPos( 1, 1 )
					MapList:SetSize( w/2 - 15, h - (h/3) )
					MapList:SetMultiSelect( false )
					MapList:AddColumn("Maps")
						usermessage.Hook( "dmod_addmap", function( msg ) MapList:AddLine( msg:ReadString( ) ) end )
					MapList:SelectFirstItem()
					
					local GamemodeList = vgui.Create( "DListView" )
					GamemodeList:SetParent( Maps )
					GamemodeList:SetPos( MapList:GetWide() + 5, 1 )
					GamemodeList:SetSize( w/2 - 12, h - (h/3) )
					GamemodeList:SetMultiSelect( false )
					GamemodeList:AddColumn("Gamemodes")
						usermessage.Hook( "dmod_addgamemode", function( msg ) GamemodeList:AddLine( msg:ReadString( ) ) end )
					GamemodeList:SelectFirstItem()
					
					-- Apply Button
					local ApplyButton = vgui.Create( "DButton", Maps )
					ApplyButton:SetWide( 200 )
					ApplyButton:SetTall( 20 )
					ApplyButton:SetText( "Go" )
					ApplyButton:SetPos( (w-20)/2 - ApplyButton:GetWide()/2, (h-100)- ApplyButton:GetTall() )
					function ApplyButton:DoClick( )
						RunConsoleCommand( "Dmod", "changelevel", MapList:GetLine(1), GamemodeList:GetLine(1) )
					end
					MainTab:AddSheet( "Maps", Maps, "gui/silkicons/map", false, false, "Change the map and gamemode" )
					
					-- Server Tab
					local ServerTab = vgui.Create( "DPanel" )
					ServerTab.Paint = function( ) end
					
					if (LocalPlayer():IsSuperAdmin()) then	
						local Lbl = vgui.Create( "DLabel", ServerTab )
						Lbl:SetText( "Run a console command on the server:" )
						Lbl:SetPos( 5, 10 )
						Lbl:SetTextColor(Color(0,0,0,255))
						Lbl:SizeToContents()
						
						local Text = vgui.Create( "DTextEntry", ServerTab )
						Text:SetSize( 200, 20 )
						Text:SetPos( 5, 30 )
						Text.OnEnter = function() RunConsoleCommand( "Dmod", "rcon", Text:GetValue() ) end
					else -- Non-Super Admins aren't allowed to use this tab
						local Text = vgui.Create( "DLabel", ServerTab )
						Text:SetText( "Only Super Admins are allowed to use this tab." )
						Text:SizeToContents()
						Text:SetPos( ServerTab:GetWide()/2-Text:GetWide()/2, ServerTab:GetTall()/2-Text:GetTall()/2)
					end
					MainTab:AddSheet( "Server", ServerTab, "gui/silkicons/server", false, false, "Change server settings" )
				
		else
			Dmod_Message( false, LocalPlayer(), "You are not an admin!" )
		end
	end
	concommand.Add("Dmod_Menu", Dmod_Menu)

	-- Fill the list with commands
	function Dmod_FillList(List, Type)
		for _, v in pairs( Dmod.Plugins ) do
			if (v.ShowInMenu == true) then
				if (v.Type == Type) then
					List:AddLine(v.Name, v.Description, v.Creator, v.ChatCommand)
				end
			end
		end
	end
end -- End of Menu

-------------------------------------------------------------------------------------------------------------------------
-- Run the menu on the client
-------------------------------------------------------------------------------------------------------------------------

local function Dmod_RunMenu( ply, Args )
if (Dmod_CheckRequiredRank(ply, DmodPlugin.RequiredRank)) then
	if SERVER then ply:ConCommand("Dmod_Menu") end
	if CLIENT then RunConsoleCommand("Dmod_Menu") end
end
end
hook.Add( DmodPlugin.Name, DmodPlugin.Name, Dmod_RunMenu)