-------------------------------------------------------------------------------------------------------------------------
-- The Menu
-------------------------------------------------------------------------------------------------------------------------
local DmodPlugin = {}
DmodPlugin.ChatCommand = "menu" -- The chat command you need to use this plugin
DmodPlugin.Name = "menu" -- The name of the plugin
DmodPlugin.Description = "Open the menu." -- The description shown in the Menu
DmodPlugin.ShowInMenu = false -- Do you want this plugin to be shown in the menu at all?
DmodPlugin.Type = "other" -- Where in the Menu will it show?
DmodPlugin.Creator = "Divran" -- Who created it?
DmodPlugin.RequiredRank = "Guest" -- The rank required to use this command. Can be "Guest", "Respected", "Admin", "Super Admin", or "Owner".
if SERVER then Dmod_AddPlugin(DmodPlugin) end

-------------------------------------------------------------------------------------------------------------------------
-- Menu
-------------------------------------------------------------------------------------------------------------------------

if CLIENT then

	----------------------- Usermessages
	-- Fill the map and gamemode tables
	local MapsTable = { }
	local GamemodesTable = { }
	local function Dmod_MapTable( um ) -- Maps
		table.insert( MapsTable, um:ReadString() )
	end
	usermessage.Hook( "dmod_addmap", Dmod_MapTable )
	local function Dmod_GamemodeTable( um ) -- Gamemodes
		table.insert( GamemodesTable, um:ReadString() )
	end
	usermessage.Hook( "dmod_addgamemode", Dmod_GamemodeTable )
	----------------------- Usermessages
	
	-- Fill the map and gamemode lists
	local function Dmod_FillMapList( List )
		for _, L in pairs(MapsTable) do
			List:AddLine( L )
		end
	end
	local function Dmod_FillGamemodeList( List )
		for _, L in pairs(GamemodesTable) do
			if (L != "base") then
				List:AddLine( L )
			end
		end
	end
	
	-- Fill the plugin lists
	local function Dmod_FillList(List, Type, Bool)
		if (Type and Type != "") then
			if (Type == "administration" or Type == "punishment" or Type == "other") then
				for _, v in pairs( Dmod.Plugins ) do
					if (v.ShowInMenu == true) then
						if (v.Type == Type) then
							if (Bool) then
								List:AddLine(v.Name, v.Description, v.Creator, v.ChatCommand, v.RequiredRank)
							else
								List:AddLine(v.Name, v.Description, v.Creator, v.ChatCommand)
							end
						end
					end
				end
			elseif (Type == "Guest" or Type == "Respected" or Type == "Admin" or Type == "Super Admin" or Type == "Owner") then
				for _, v in pairs( Dmod.Plugins ) do
						if (v.RequiredRank == Type) then
							List:AddLine(v.Name, v.Description, v.Creator, v.ChatCommand, v.RequiredRank)
						end
				end
			end
		else
			for _, v in pairs( Dmod.Plugins ) do
				List:AddLine( v.Name, v.Description, v.Creator, v.ChatCommand, v.RequiredRank )
			end
		end
	end

	local function Dmod_Menu()
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
					
				if (LocalPlayer():IsUserGroup("respected") or LocalPlayer():IsUserGroup("superadmin") or LocalPlayer():IsAdmin()) then	
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
							Dmod_FillList(AdminList, "administration", false)
							
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
							Dmod_FillList(PunishList, "punishment", false)
							
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
							Dmod_FillList(OtherList, "other", false)
							
						
							-- Add the tab
							PlayerTab:AddSheet( v:Nick(), Tab, "gui/silkicons/user", false, false, "Do stuff to "..v:Nick() )
						end
					else -- Non-Super Admins aren't allowed to use this tab
						local Text = vgui.Create( "DLabel", PlayerTab )
						Text:SetPos(100,100)
						Text:SetText( "Only Respected users (or higher) are allowed to use this tab." )
						Text:SetTextColor(Color(0,0,0,255))
						Text:SizeToContents()
					end
					MainTab:AddSheet( "Players", PlayerTab, "gui/silkicons/group", false, false, "NOTE: Not all commands show up in the lists! Some require the use of the chat!" )
					
					-- Maps
					local Maps = vgui.Create( "DPanel" )
					Maps.Paint = function() end
					
					if (LocalPlayer():IsUserGroup("admin") or LocalPlayer():IsUserGroup("superadmin") or LocalPlayer():IsAdmin()) then	
					
						local MapList = vgui.Create( "DListView" )
						MapList:SetParent( Maps )
						MapList:SetPos( 1, 1 )
						MapList:SetSize( w/2 - 15, h - (h/3) )
						MapList:SetMultiSelect( false )
						MapList:AddColumn("Maps")
							Dmod_FillMapList( MapList )
						MapList:SelectFirstItem()
						
						local GamemodeList = vgui.Create( "DListView" )
						GamemodeList:SetParent( Maps )
						GamemodeList:SetPos( MapList:GetWide() + 5, 1 )
						GamemodeList:SetSize( w/2 - 12, h - (h/3) )
						GamemodeList:SetMultiSelect( false )
						GamemodeList:AddColumn("Gamemodes")
							Dmod_FillGamemodeList( GamemodeList )
						GamemodeList:SelectFirstItem()
						
						-- Apply Button
						local ApplyButton = vgui.Create( "DButton", Maps )
						ApplyButton:SetWide( 200 )
						ApplyButton:SetTall( 20 )
						ApplyButton:SetText( "Go" )
						ApplyButton:SetPos( (w-20)/2 - ApplyButton:GetWide()/2, (h-100)- ApplyButton:GetTall() )
						function ApplyButton:DoClick( )
							RunConsoleCommand( "Dmod", "changelevel", MapList:GetLine(MapList:GetSelectedLine()):GetValue(1), GamemodeList:GetLine(GamemodeList:GetSelectedLine()):GetValue(1) )
						end
					
					else -- Non-Super Admins aren't allowed to use this tab
						local Text = vgui.Create( "DLabel", Maps )
						Text:SetPos(100,100)
						Text:SetText( "Only Admins (or higher) are allowed to use this tab." )
						Text:SetTextColor(Color(0,0,0,255))
						Text:SizeToContents()
					end
					MainTab:AddSheet( "Maps", Maps, "gui/silkicons/map", false, false, "Change the map and gamemode" )
					
					-- Server Tab
					local ServerTab = vgui.Create( "DPanel" )
					ServerTab.Paint = function( ) end
					
					if (LocalPlayer():IsUserGroup("superadmin") or LocalPlayer():IsSuperAdmin()) then	
					
						local Lbl = vgui.Create( "DLabel", ServerTab )
						Lbl:SetText( "Run a console command on the server:" )
						Lbl:SetPos( 5, 40 )
						Lbl:SetTextColor(Color(0,0,0,255))
						Lbl:SizeToContents()
						
						local Text = vgui.Create( "DTextEntry", ServerTab )
						Text:SetSize( 200, 20 )
						Text:SetPos( 5, 60 )
						Text.OnEnter = function() RunConsoleCommand( "Dmod", "rcon", Text:GetValue() ) end
					
						-- Sbox Commands
						SboxComs = vgui.Create( "DMultiChoice", ServerTab )
						SboxComs:SetPos( 5, 20 )
						SboxComs:SetSize( 200, 20 )
						SboxComs:AddChoice( "Sbox (limits) Commands" )
						SboxComs:AddChoice( "props" )
						SboxComs:AddChoice( "ragdolls" )
						SboxComs:AddChoice( "vehicles" )
						SboxComs:AddChoice( "effects" )
						SboxComs:AddChoice( "balloons" )
						SboxComs:AddChoice( "npcs" )
						SboxComs:AddChoice( "dynamite" )
						SboxComs:AddChoice( "lamps" )
						SboxComs:AddChoice( "lights" )
						SboxComs:AddChoice( "wheels" )
						SboxComs:AddChoice( "thrusters" )
						SboxComs:AddChoice( "hoverballs" )
						SboxComs:AddChoice( "buttons" )
						SboxComs:AddChoice( "emitters" )
						SboxComs:AddChoice( "spawners" )
						SboxComs:AddChoice( "turrets" )
						SboxComs:ChooseOptionID( 1 )
						SboxComs:SetEditable( false )
						
						SboxComs.OnSelect = function()
							if (SboxComs.TextEntry:GetValue() == "Sbox (limits) Commands") then
								Text:SetValue( "" )
							else
								Text:SetValue( "sbox_max"..SboxComs.TextEntry:GetValue() )
							end
						end
					else -- Non-Super Admins aren't allowed to use this tab
						local Text = vgui.Create( "DLabel", ServerTab )
						Text:SetPos(100,100)
						Text:SetText( "Only Super Admins (or higher) are allowed to use this tab." )
						Text:SetTextColor(Color(0,0,0,255))
						Text:SizeToContents()
					end
					MainTab:AddSheet( "Server", ServerTab, "gui/silkicons/server", false, false, "Change server settings" )
					
					-- Plugin List Tab	
					local Plugins = vgui.Create( "DPanel" )
					Plugins.Paint = function() end
					
					local PluginList = vgui.Create( "DListView" )
					PluginList:SetParent( Plugins )
					PluginList:SetPos( 1, 30 )
					PluginList:SetSize( w - 40, h - 145 )
					PluginList:SetMultiSelect( false )
					-- Add the columns
					local Name = PluginList:AddColumn("Name")
					Name:SetWide(20)
					local Desc = PluginList:AddColumn("Description")
					Desc:SetWide(w*0.65)
					local Creator = PluginList:AddColumn("Creator")
					Creator:SetWide(15)
					local ChatCmd = PluginList:AddColumn("Chat Cmd")
					ChatCmd:SetWide(15)
					local Rank = PluginList:AddColumn("Rank Needed")
					Rank:SetWide(20)
					-- Fill the list with commands
					Dmod_FillList(PluginList)
					
					local PluginCats = vgui.Create( "DMultiChoice", Plugins )
					PluginCats:SetPos( (w-40)/2-160, 5 )
					PluginCats:SetSize( 150, 20 )
					PluginCats:AddChoice( "All" )
					PluginCats:AddChoice( "Administration" )
					PluginCats:AddChoice( "Punishment" )
					PluginCats:AddChoice( "Other" )
					PluginCats:ChooseOptionID( 1 )
					PluginCats:SetEditable( false )
					
					function PluginCats:OnSelect( id, value, data )
						PluginList:Clear()
						if (id == 1) then Dmod_FillList( PluginList ) end
						if (id == 2) then Dmod_FillList( PluginList, "administration", true ) end
						if (id == 3) then Dmod_FillList( PluginList, "punishment", true ) end
						if (id == 4) then Dmod_FillList( PluginList, "other", true ) end
					end
					
					local PluginSort = vgui.Create( "DMultiChoice", Plugins )
					PluginSort:SetPos( (w-40)/2, 5 )
					PluginSort:SetSize( 150, 20 )
					PluginSort:AddChoice( "All" )
					PluginSort:AddChoice( "Guest" )
					PluginSort:AddChoice( "Respected" )
					PluginSort:AddChoice( "Admin" )
					PluginSort:AddChoice( "Super Admin" )
					PluginSort:AddChoice( "Owner" )
					PluginSort:ChooseOptionID( 1 )
					PluginSort:SetEditable( false )
					
					function PluginSort:OnSelect( id, value, data )
						PluginList:Clear()
						if (id == 1) then Dmod_FillList( PluginList ) end
						if (id == 2) then Dmod_FillList( PluginList, "Guest", true ) end
						if (id == 3) then Dmod_FillList( PluginList, "Respected", true ) end
						if (id == 4) then Dmod_FillList( PluginList, "Admin", true ) end
						if (id == 5) then Dmod_FillList( PluginList, "Super Admin", true ) end
						if (id == 6) then Dmod_FillList( PluginList, "Owner", true ) end
					end
					MainTab:AddSheet( "Plugin List", Plugins, "gui/silkicons/text_list_numbers", false, false, "A list of all plugins on the server" )
	end -- End of Menu
	concommand.Add( "Dmod_Menu", Dmod_Menu )	
end -- End of if CLIENT

-------------------------------------------------------------------------------------------------------------------------
-- Run the menu on the client
-------------------------------------------------------------------------------------------------------------------------

local function Dmod_RunMenu( ply, Args )
	if SERVER then ply:ConCommand("Dmod_Menu") end
	if CLIENT then RunConsoleCommand("Dmod_Menu") end
end
hook.Add( DmodPlugin.Name, DmodPlugin.Name, Dmod_RunMenu)