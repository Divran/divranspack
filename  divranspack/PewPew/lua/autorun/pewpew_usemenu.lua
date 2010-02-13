-- PewPew Use Menu

if (CLIENT) then
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
		list[4] = 	{"Damage",	 			Bullet.Damage}
		list[5] = 	{"Radius", 				Bullet.Radius}
		list[6] = 	{"PlayerDamage", 		Bullet.PlayerDamage}
		list[7] = 	{"PlayerDamageRadius", 	Bullet.PlayerDamageRadius}
		list[8] = 	{"Speed", 				Bullet.Speed}
		list[9] = 	{"PitchChange", 		Bullet.PitchChange}
		list[10] =	{"RecoilForce", 		Bullet.RecoilForce}
		list[11] = 	{"Spread",				Bullet.Spread}
		list[12] = 	{"Reloadtime", 			Bullet.Reloadtime}
		list[13] = 	{"Ammo", 				Bullet.Ammo}
		list[14] = 	{"AmmoReloadtime", 		Bullet.AmmoReloadtime}
	end
	
	usermessage.Hook( "PewPew_OpenMenu", function( um )
		local Bullet = pewpew:GetBullet( um:ReadString() )
		if (Bullet) then
			pewpew_list:Clear()
			SetTable( Bullet )
			for _, value in ipairs( list ) do
				pewpew_list:AddLine( value[1], tostring(value[2]) or "- none -" )
			end
			pewpew_frame:SetVisible( true )
		end
	end)
else
	hook.Add( "PlayerUse", "PewPewPlayerUse", function( ply, ent )
		if (!ply.LastUse) then ply.LastUse = 0 end
		if (ply.LastUse > CurTime()) then return end
		ply.LastUse = CurTime() + 2
		if (ent:GetClass() == "pewpew_base_cannon") then
			if (ent.Bullet) then
				umsg.Start( "PewPew_OpenMenu", ply )
					umsg.String(ent.Bullet.Name)
				umsg.End()
			end
		end
	end)
end