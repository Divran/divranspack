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
			local w, h = 900, 300
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
				
				
					-- Player Tab Sheet
					local PlayerTab = vgui.Create( "DPropertySheet" )
					PlayerTab:SetParent( PlayerTab )
					PlayerTab:SetPos( 1, 40 )
					PlayerTab:SetSize( w - 20, h - 70 )
				
					for k, v in pairs(player.GetAll()) do
						local Tab = vgui.Create( "DPanel" )
						
						-- Plugin List
						local PluginList = vgui.Create( "DListView" )
						PluginList:SetParent( Tab )
						PluginList:SetPos( 1, 1 )
						PluginList:SetSize( w/2-20, 180	)
						PluginList:SetMultiSelect( false )
						local Name = PluginList:AddColumn("Name")
						Name:SetWide(w/5)
						local Desc = PluginList:AddColumn("Description")
						Desc:SetWide(w/3)
						local Creator = PluginList:AddColumn("Creator")
						Creator:SetWide(w/5)

						Dmod_FillList(PluginList)
						
						
						/*local X, Y = 0, 0
						
						-- Goto Button
						local GotoButton = vgui.Create( "DButton", Tab )
						GotoButton:SetWide( 80 )
						GotoButton:SetTall( 30 )
						GotoButton:SetText( "Goto" )
						GotoButton:SetPos( 5 + 90 * X, 5 + 40 * Y )
						function GotoButton:DoClick()
								RunConsoleCommand( "Dmod", "Goto", v:Nick() )
						end
						
						-- Bring Button
						X, Y = 0, 1
						local BringButton = vgui.Create( "DButton", Tab )
						BringButton:SetWide( 80 )
						BringButton:SetTall( 30 )
						BringButton:SetText( "Bring" )
						BringButton:SetPos( 5 + 90 * X, 5 + 40 * Y )
						function BringButton:DoClick( )
								RunConsoleCommand( "Dmod", "Bring", v:Nick() )
						end
						
						-- Respawn Button
						X, Y = 0, 2
						local RespawnButton = vgui.Create( "DButton", Tab )
						RespawnButton:SetWide( 80 )
						RespawnButton:SetTall( 30 )
						RespawnButton:SetText( "Bring" )
						RespawnButton:SetPos( 5 + 90 * X, 5 + 40 * Y )
						function RespawnButton:DoClick( )
								RunConsoleCommand( "Dmod", "Respawn", v:Nick() )
						end
						
						-- Slay Button
						X, Y = 1, 0
						local SlayButton = vgui.Create( "DButton", Tab )
						SlayButton:SetWide( 80 )
						SlayButton:SetTall( 30 )
						SlayButton:SetText( "Slay" )
						SlayButton:SetPos( 5 + 90 * X, 5 + 40 * Y )
						function SlayButton:DoClick( )
								RunConsoleCommand( "Dmod", "Slay", v:Nick() )
						end
						
						-- God Button
						X, Y = 2, 0
						local GodButton = vgui.Create( "DButton", Tab )
						GodButton:SetWide( 80 )
						GodButton:SetTall( 30 )
						GodButton:SetText( "God" )
						GodButton:SetPos( 5 + 90 * X, 5 + 40 * Y )
						function GodButton:DoClick( )
								RunConsoleCommand( "Dmod", "God", v:Nick() )
						end
						
						-- UnGod Button
						X, Y = 2, 1
						local UnGodButton = vgui.Create( "DButton", Tab )
						UnGodButton:SetWide( 80 )
						UnGodButton:SetTall( 30 )
						UnGodButton:SetText( "Ungod" )
						UnGodButton:SetPos( 5 + 90 * X, 5 + 40 * Y )
						function UnGodButton:DoClick( )
								RunConsoleCommand( "Dmod", "Ungod", v:Nick() )
						end
						
						-- Kick Button
						X, Y = 3, 0
						local KickButton = vgui.Create( "DButton", Tab )
						KickButton:SetWide( 80 )
						KickButton:SetTall( 30 )
						KickButton:SetText( "Kick" )
						KickButton:SetPos( 5 + 90 * X, 5 + 40 * Y )
						function KickButton:DoClick( )
								RunConsoleCommand( "Dmod", "Kick", v:Nick() )
						end

						-- Ban Button
						X, Y = 3, 1
						local BanButton = vgui.Create( "DButton", Tab )
						BanButton:SetWide( 80 )
						BanButton:SetTall( 30 )
						BanButton:SetText( "Ban" )
						BanButton:SetPos( 5 + 90 * X, 5 + 40 * Y )
						function BanButton:DoClick( )
								RunConsoleCommand( "Dmod", "Ban", v:Nick() )
						end*/
						
						PlayerTab:AddSheet( v:Nick(), Tab, "gui/silkicons/user", false, false, "Do stuff to "..v:Nick() )
					end
					MainTab:AddSheet( "Players", PlayerTab, "gui/silkicons/group", false, false, nil )
		else
			Dmod_Message( false, LocalPlayer(), "You are not an admin!" )
		end
	end
	concommand.Add("Dmod_Menu", Dmod_Menu)

	
	function Dmod_FillList(List)
		for _, v in pairs( Dmod.Plugins ) do
			if (v.ShowInMenu == true) then
				Dmod_Message(false, LocalPlayer(), v.Name .. ", " .. v.Description .. ", " .. v.Creator)
					List:AddLine(v.Name, v.Description, v.Creator)
			end
		end
		List:SelectFirstItem()
	end

end

-------------------------------------------------------------------------------------------------------------------------
-- Run the menu on the client
-------------------------------------------------------------------------------------------------------------------------

local function Dmod_RunMenu( ply, Args )
	if SERVER then ply:ConCommand("Dmod_Menu") end
	if CLIENT then RunConsoleCommand("Dmod_Menu") end
end
hook.Add( DmodPlugin.Name, DmodPlugin.Name, Dmod_RunMenu)

