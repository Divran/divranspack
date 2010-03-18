/*-------------------------------------------------------------------------------------------------------------------------
	Maps tab
-------------------------------------------------------------------------------------------------------------------------*/

local TAB = {}
TAB.Title = "Maps"
TAB.Description = "Change Map."
TAB.Author = "Divran"

function TAB:Update() end

function TAB:ChangeLevel( what )
	local map = self.MapList:GetLine(self.MapList:GetSelectedLine()):GetValue(1)
	local gamemode = self.GamemodeList:GetLine(self.GamemodeList:GetSelectedLine()):GetValue(1)
	if (map and map != "" and gamemode and gamemode != "") then
		if (what == "both") then			
			RunConsoleCommand( "ev_changemapandgamemode", map, gamemode )
		elseif (what == "map") then
			RunConsoleCommand( "ev_changemapandgamemode", map, GAMEMODE.Name)
		elseif (what == "gamemode") then
			RunConsoleCommand( "ev_changemapandgamemode", game.GetMap(), gamemode )
		end
	end
end

function TAB:Initialize()
	self.Container = vgui.Create( "DPanel", evolve.menuContainer )
	self.Container:SetSize( evolve.menuw - 10, evolve.menuh )
	self.Container.Paint = function() end
	evolve.menuContainer:AddSheet( self.Title, self.Container, "gui/silkicons/world", false, false, self.Description )

	self.MapList = vgui.Create( "DListView" )
	self.MapList:SetParent( self.Container )
	self.MapList:SetPos( 0, 2 )
	self.MapList:SetSize( self.Container:GetWide() / 2 - 2, self.Container:GetTall() - 58 )
	self.MapList:SetMultiSelect( false )
	self.MapList:AddColumn("Maps")
	for _, filename in pairs(evolve.Maps) do
		self.MapList:AddLine( filename )
	end
	self.MapList:SelectFirstItem()
	
	self.GamemodeList = vgui.Create("DListView")
	self.GamemodeList:SetParent( self.Container )
	self.GamemodeList:SetPos( self.Container:GetWide() / 2 + 2, 2 )
	self.GamemodeList:SetSize( self.Container:GetWide() / 2 - 4, self.Container:GetTall() - 58 )
	self.GamemodeList:SetMultiSelect( false )
	self.GamemodeList:AddColumn("Gamemodes")
	for _, foldername in pairs(evolve.Gamemodes) do
		self.GamemodeList:AddLine( foldername )
	end
	self.GamemodeList:SelectFirstItem()
	
	self.BothButton = vgui.Create("DButton", self.Container )
	self.BothButton:SetWide( self.Container:GetWide() / 3 - 2 )
	self.BothButton:SetTall( 20 )
	self.BothButton:SetPos( self.Container:GetWide() * (1/3) , self.Container:GetTall() - 52 )
	self.BothButton:SetText( "Change Map And Gamemode" )
	function self.BothButton:DoClick()
		TAB:ChangeLevel( "both" )
	end
	
	self.MapButton = vgui.Create("DButton", self.Container )
	self.MapButton:SetWide( self.Container:GetWide() / 3 - 2 )
	self.MapButton:SetTall( 20 )
	self.MapButton:SetPos( 0 , self.Container:GetTall() - 52 )
	self.MapButton:SetText( "Change Map" )
	function self.MapButton:DoClick()
		TAB:ChangeLevel( "map" )
	end
	
	self.GamemodeButton = vgui.Create("DButton", self.Container )
	self.GamemodeButton:SetWide( self.Container:GetWide() / 3 - 2 )
	self.GamemodeButton:SetTall( 20 )
	self.GamemodeButton:SetPos( self.Container:GetWide() * (2/3) , self.Container:GetTall() - 52 )
	self.GamemodeButton:SetText( "Change Gamemode" )
	function self.GamemodeButton:DoClick()
		TAB:ChangeLevel( "gamemode" )
	end
	
	
	self.Block = vgui.Create( "DFrame", self.Container )
	self.Block:SetDraggable( false )
	self.Block:SetTitle( "" )
	self.Block:ShowCloseButton( false )
	self.Block:SetPos( 0, 0 )
	self.Block:SetSize( self.Container:GetWide(), self.Container:GetTall() )
	self.Block.Paint = function()
		surface.SetDrawColor( 46, 46, 46, 255 )
		surface.DrawRect( 0, 0, self.Block:GetWide(), self.Block:GetTall() )
		
		draw.SimpleText( "You need the Maps List Plugin ('sh_mapslist.lua') for this tab to work.", "ScoreboardText", self.Block:GetWide() / 2, self.Block:GetTall() / 2 - 20, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
	end
	
	if ( table.Count(evolve.Maps) ) then self.Block:SetPos( self.Block:GetWide(), 0 ) end
end

evolve:RegisterMenuTab( TAB )