-------------------------------------------------------------------------------------------------------------------------
-- The Menu
-------------------------------------------------------------------------------------------------------------------------
local DmodPlugin = {}
DmodPlugin.ChatCommand = "menu"
DmodPlugin.Name = "menu"
if SERVER then Dmod_AddPlugin(DmodPlugin) end

-------------------------------------------------------------------------------------------------------------------------
-- Menu
-------------------------------------------------------------------------------------------------------------------------

if CLIENT then

	local function Dmod_Menu()
		if (LocalPlayer():IsAdmin()) then
			-- Main Window
			local w, h = 900, 400
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
						
						-- Plugin List
						local PluginList = vgui.Create( "DListView" )
						PluginList:SetParent( Tab )
						PluginList:SetPos( 1, 1 )
						PluginList:SetSize( w-35, h - 130 )
						PluginList:SetMultiSelect( false )
						-- Add the columns
						local Name = PluginList:AddColumn("Name")
						Name:SetWide((w-15)/6)
						local Desc = PluginList:AddColumn("Description")
						Desc:SetWide((w-15)/2)
						local Creator = PluginList:AddColumn("Creator")
						Creator:SetWide((w-15)/6)
						local ChatCmd = PluginList:AddColumn("Chat Cmd")
						ChatCmd:SetWide((w-15)/8)
						-- When you click on a command in the list, run it.
						PluginList.OnClickLine = function(P,Line,I) RunConsoleCommand("Dmod", Line:GetValue(4), v:Nick()) end
						-- Fill the list with commands
						Dmod_FillList(PluginList)
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
					
					-- Server Commands
					local Sboxes = { "props", "ragdolls", "vehicles", "effects", "balloons", "npcs", "dynamite",
									"lamps", "lights", "wheels", "thrusters", "hoverballs", "buttons", "emitters",
									"spawners", "turrets" }
					
					-- Server Tab
					local ServerTab = vgui.Create( "DPanel" )
					ServerTab.Paint = function( ) end
						
					local SboxList = vgui.Create( "DPanelList", ServerTab )
					SboxList:SetPos( 1,1 )
					SboxList:SetSize( w/2 - 12, h - 100 )
					SboxList:SetSpacing( 1 )
					SboxList:EnableHorizontal( false )
					SboxList:EnableVerticalScrollbar( true )

					
					for k, v in pairs( Sboxes ) do
						local Slider = vgui.Create( "DNumSlider" )
						Slider:SetSize( SboxList:GetWide(), 50 )
						Slider:SetText( v )
						Slider:SetMin( 0 )
						Slider:SetMax( 1337 )
						Slider:SetDecimals( 0 )
						Slider:SetConVar( "Dmod", "sbox", v )
						SboxList:AddItem( Slider )
					end
					
					MainTab:AddSheet( "Server", ServerTab, "gui/silkicons/server", false, false, "Change server settings" )
				
		else
			Dmod_Message( false, LocalPlayer(), "You are not an admin!" )
		end
	end
	concommand.Add("Dmod_Menu", Dmod_Menu)

	-- Fill the list with commands
	function Dmod_FillList(List)
		for _, v in pairs( Dmod.Plugins ) do
			if (v.ShowInMenu == true) then
				List:AddLine(v.Name, v.Description, v.Creator, v.ChatCommand)
			end
		end
	end
end -- End of Menu

-------------------------------------------------------------------------------------------------------------------------
-- Run the menu on the client
-------------------------------------------------------------------------------------------------------------------------

local function Dmod_RunMenu( ply, Args )
	if SERVER then ply:ConCommand("Dmod_Menu") end
	if CLIENT then RunConsoleCommand("Dmod_Menu") end
end
hook.Add( DmodPlugin.Name, DmodPlugin.Name, Dmod_RunMenu)