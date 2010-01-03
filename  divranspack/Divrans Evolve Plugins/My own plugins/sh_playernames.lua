/*-------------------------------------------------------------------------------------------------------------------------
	Display player names above heads
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = { }
PLUGIN.Title = "Player Names"
PLUGIN.Description = "Displays player names above heads."
PLUGIN.Author = "Overv"

if ( SERVER ) then
	resource.AddFile( "materials/gui/silkicons/comments.vtf" )
	resource.AddFile( "materials/gui/silkicons/comments.vmt" )
	resource.AddFile( "materials/gui/silkicons/user_add.vtf" )
	resource.AddFile( "materials/gui/silkicons/user_add.vmt" )
	resource.AddFile( "materials/gui/silkicons/shield_add.vtf" )
	resource.AddFile( "materials/gui/silkicons/shield_add.vmt" )
	resource.AddFile( "materials/gui/silkicons/key.vtf" )
	resource.AddFile( "materials/gui/silkicons/key.vmt" )
	
	concommand.Add( "EV_SetChatState", function( ply, cmd, args )
		if ( tonumber( args[1] ) ) then
			ply:SetNWBool( "EV_Chatting", tonumber( args[1] ) > 0 )
		end
	end )
else
	PLUGIN.iconUser = surface.GetTextureID( "gui/silkicons/user" )
	PLUGIN.iconRespected = surface.GetTextureID( "gui/silkicons/user_add" )
	PLUGIN.iconAdmin = surface.GetTextureID( "gui/silkicons/shield" )
	PLUGIN.iconSuperAdmin = surface.GetTextureID( "gui/silkicons/shield_add" )
	PLUGIN.iconOwner = surface.GetTextureID( "gui/silkicons/key" )
	PLUGIN.iconChat = surface.GetTextureID( "gui/silkicons/comments" )

	function PLUGIN:HUDPaint()
		if ( !evolve.installed ) then return end
		
		for _, pl in ipairs( player.GetAll() ) do
			if ( pl != LocalPlayer() ) then
				local td = { }
				td.start = LocalPlayer():GetShootPos()
				td.endpos = pl:GetShootPos()
				local trace = util.TraceLine( td )
				
				if ( !trace.HitWorld and !pl:GetNWBool( "EV_Ghosted", false ) ) then
					surface.SetFont( "ScoreboardText" )
					local w = surface.GetTextSize( pl:Nick() ) + 8 + 20
					local h = 24
					
					local drawPos = pl:GetAttachment( pl:LookupAttachment( "eyes" ) ).Pos:ToScreen()
					local distance = LocalPlayer():GetShootPos():Distance( pl:GetShootPos() )
					drawPos.x = drawPos.x - w / 2
					drawPos.y = drawPos.y - h - 12
					
					local alpha = 128
					if ( distance > 512 ) then
						alpha = 128 - math.Clamp( ( distance - 512 ) / ( 2048 - 512 ) * 128, 0, 128 )
					end
					
					surface.SetDrawColor( 0, 0, 0, alpha )
					surface.DrawRect( drawPos.x, drawPos.y, w, h )
					
					surface.SetDrawColor( 255, 255, 255, math.Clamp( alpha * 2, 0, 255 ) )
					if ( pl:GetNWBool( "EV_Chatting", false ) ) then
						surface.SetTexture( self.iconChat )
					elseif ( pl:EV_IsOwner() ) then
						surface.SetTexture( self.iconOwner )
					elseif ( pl:EV_IsSuperAdmin() ) then
						surface.SetTexture( self.iconSuperAdmin )
					elseif ( pl:EV_IsAdmin() ) then
						surface.SetTexture( self.iconAdmin )
					elseif ( pl:EV_IsRespected() ) then
						surface.SetTexture( self.iconRespected)
					else
						surface.SetTexture( self.iconUser )
					end
					surface.DrawTexturedRect( drawPos.x + 4, drawPos.y + 4, 16, 16 )
					
					local teamColor = team.GetColor( pl:Team() )
					teamColor.a = math.Clamp( alpha * 2, 0, 255 )
					draw.DrawText( pl:Nick(), "ScoreboardText", drawPos.x + 24, drawPos.y + 4, teamColor, 0 )
				end
				
			end
		end
	end

	function PLUGIN:StartChat()
		RunConsoleCommand( "EV_SetChatState", 1 )
	end
	function PLUGIN:FinishChat()
		RunConsoleCommand( "EV_SetChatState", 0 )
	end
end

evolve:RegisterPlugin( PLUGIN )