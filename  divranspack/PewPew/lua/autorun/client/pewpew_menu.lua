-- PewPew Use Menu

-- Use Menu
local function CreateMenu()
	pewpew_frame = vgui.Create("DFrame")
	pewpew_frame:SetPos( ScrW()/2-400,ScrH()/2+155 )
	pewpew_frame:SetSize( 800, 300 )
	pewpew_frame:SetTitle( "PewPew Cannon Information" )
	pewpew_frame:SetVisible( false )
	pewpew_frame:SetDraggable( true )
	pewpew_frame:ShowCloseButton( true )
	pewpew_frame:SetDeleteOnClose( false )
	pewpew_frame:SetScreenLock( true )
	pewpew_frame:MakePopup()
	
	pewpew_list = vgui.Create( "DListView", pewpew_frame )
	pewpew_list:StretchToParent( 2, 23, 2, 2 )
	local a = pewpew_list:AddColumn( "" )
	a:SetWide(pewpew_frame:GetWide()*(1.5/8))
	local b = pewpew_list:AddColumn( "" )	
	b:SetWide(pewpew_frame:GetWide()*(6.5/8))
end
timer.Simple( 0.5, CreateMenu )

local list = {}		
local function SetTable( Bullet )
	list[1] = 	{"Name", 				Bullet.Name}
	list[2] = 	{"Author", 				Bullet.Author}
	list[3] = 	{"Description", 		Bullet.Description}
	list[4] = 	{"Category", 			Bullet.Category }
	list[5] = 	{"Damage",	 			Bullet.Damage}
	list[6] = 	{"Radius", 				Bullet.Radius}
	list[7] = 	{"PlayerDamage", 		Bullet.PlayerDamage}
	list[8] = 	{"PlayerDamageRadius", 	Bullet.PlayerDamageRadius}
	list[9] = 	{"Speed", 				Bullet.Speed}
	list[10] = 	{"PitchChange", 		Bullet.PitchChange}
	list[11] =	{"RecoilForce", 		Bullet.RecoilForce}
	list[12] = 	{"Spread",				Bullet.Spread}
	list[13] = 	{"Reloadtime", 			Bullet.Reloadtime}
	list[14] = 	{"Ammo", 				Bullet.Ammo}
	list[15] = 	{"AmmoReloadtime", 		Bullet.AmmoReloadtime}
end

local function OpenUseMenu( bulletname )
	local Bullet = pewpew:GetBullet( bulletname )
	if (Bullet) then
		pewpew_list:Clear()
		SetTable( Bullet )
		for _, value in ipairs( list ) do
			pewpew_list:AddLine( value[1], tostring(value[2] or "- none -") or "- none -" )
		end
		pewpew_frame:SetVisible( true )
	else
		LocalPlayer():ChatPrint("Bullet not found!")
	end
end

concommand.Add("PewPew_UseMenu", function( ply, cmd, arg )
	OpenUseMenu( table.concat(arg, " ") )
end)

-- Weapons Menu
local function CreateMenu2()
	-- Main frame
	pewpew_weaponframe = vgui.Create("DFrame")
	pewpew_weaponframe:SetPos( ScrW()-300,ScrH()/2-450/2 )
	pewpew_weaponframe:SetSize( 250, 450 )
	pewpew_weaponframe:SetTitle( "PewPew Weapons" )
	pewpew_weaponframe:SetVisible( false )
	pewpew_weaponframe:SetDraggable( true )
	pewpew_weaponframe:ShowCloseButton( true )
	pewpew_weaponframe:SetDeleteOnClose( false )
	pewpew_weaponframe:SetScreenLock( true )
	pewpew_weaponframe:MakePopup()
	
	local label = vgui.Create("DLabel", pewpew_weaponframe)
	label:SetText("Left click to select, right click for info.")
	label:SetPos( 6, 23 )
	label:SizeToContents()
	
	-- Panel List 1
	local list1 = vgui.Create("DPanelList", pewpew_weaponframe)
	list1:StretchToParent( 4, 40, 4, 4 )
	list1:SetAutoSize( false )
	list1:SetSpacing( 1 )
	list1:EnableHorizontal( false ) 
	list1:EnableVerticalScrollbar( true )

	-- Loop through all categories
	for key, value in pairs( pewpew.Categories ) do
		-- Create a Collapsible Category for each
		local cat = vgui.Create( "DCollapsibleCategory" )
		cat:SetSize( 146, 50 )
		cat:SetExpanded( 0 )
		cat:SetLabel( key )
		
		-- Create a list inside each collapsible category
		local list = vgui.Create("DPanelList")
		list:SetAutoSize( true )
		list:SetSpacing( 2 )
		list:EnableHorizontal( false ) 
		list:EnableVerticalScrollbar( true )
		
		-- Loop through all weapons in each category
		for key2, value2 in pairs( pewpew.Categories[key] ) do
			-- Create a button for each list
			local btn = vgui.Create("DButton")
			btn:SetSize( 48, 20 )
			btn:SetText( value2 )
			-- Set bullet, change weapon, and close menu
			btn.DoClick = function()
				RunConsoleCommand("pewpew_bulletname", value2)
				RunConsoleCommand("gmod_tool", "pewpew")
				pewpew_weaponframe:SetVisible( false )
				pewpew_frame:SetVisible( false )
			end
			btn.DoRightClick = function()
				RunConsoleCommand("PewPew_UseMenu", value2)
			end
			list:AddItem( btn )
		end
		
		cat:SetContents( list )
		list1:AddItem( cat )
	end
end
timer.Simple(0.5, CreateMenu2)

concommand.Add("pewpew_weaponmenu", function( ply, cmd, arg )
	-- Open weapons menu and close Q menu and Context menu
	pewpew_weaponframe:SetVisible( true )	
	RunConsoleCommand("-menu")
	RunConsoleCommand("-menu_context")
end)