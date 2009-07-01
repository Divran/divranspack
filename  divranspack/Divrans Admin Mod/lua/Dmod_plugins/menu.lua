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
				
					-- Tab Sheet
					local Tabs = vgui.Create( "DPropertySheet" )
					Tabs:SetParent( Menu )
					Tabs:SetPos( 5, 28 )
					Tabs:SetSize( w - 10, h - 60 )
				
					for k, v in pairs(player.GetAll()) do
						local Tab = vgui.Create( "DPanel" )
						Tab.Paint = function( ) end
						
						local X, Y = 0, 0
						-- Only have a Goto button so far. Will add more later.
						local GotoButton = vgui.Create( "DButton", Tab )
						GotoButton:SetWide( 80 )
						GotoButton:SetTall( 30 )
						GotoButton:SetText( "Goto" )
						GotoButton:SetPos( 5 + 90 * X, 5 + 40 * Y )
						function GotoButton:DoClick()
								RunConsoleCommand( "Dmod", "Goto", v:Nick() )
						end
						
						Tabs:AddSheet( v:Nick(), Tab, "gui/silkicons/user", false, false, "Do stuff to "..v:Nick() )
					end
		else
			Dmod_Message( false, LocalPlayer(), "You are not an admin!" )
		end
	end
	concommand.Add("Dmod_Menu", Dmod_Menu)
end

-------------------------------------------------------------------------------------------------------------------------
-- Run the menu on the client
-------------------------------------------------------------------------------------------------------------------------

local function Dmod_RunMenu( ply, Args )
	if SERVER then ply:ConCommand("Dmod_Menu") end
	if CLIENT then RunConsoleCommand("Dmod_Menu") end
end
hook.Add( DmodPlugin.Name, DmodPlugin.Name, Dmod_RunMenu)
