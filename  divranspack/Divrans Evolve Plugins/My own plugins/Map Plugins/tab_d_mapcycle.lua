/*-------------------------------------------------------------------------------------------------------------------------
	Maps tab
-------------------------------------------------------------------------------------------------------------------------*/

local TAB = {}
TAB.Title = "Mapcycle"
TAB.Description = "Automatic map cycle."
TAB.Author = "Divran"

function TAB:Update()
	if (evolve.Maps) then
		self.MapList:Clear()
		for _, filename in pairs(evolve.Maps) do
			self.MapList:AddLine( filename )
		end
		self.MapList:SelectFirstItem()
	end
	
	if (evolve.MapCycle) then
		self.CycleList:Clear()
		for _, filename in pairs(evolve.MapCycle) do
			self.CycleList:AddLine( filename )
		end
		self.CycleList:SelectFirstItem()
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
	
	self.CycleList = vgui.Create("DListView")
	self.CycleList:SetParent( self.Container )
	self.CycleList:SetPos( self.Container:GetWide() / 2 + 2, 2 )
	self.CycleList:SetSize( self.Container:GetWide() / 2 - 4, self.Container:GetTall() - 58 )
	self.CycleList:SetMultiSelect( false )
	self.CycleList:AddColumn("Cycle")
	
	local nrbuttons = 6

	self.AddButton = vgui.Create("DButton", self.Container )
	self.AddButton:SetSize( self.Container:GetWide() / nrbuttons - 2, 20 )
	self.AddButton:SetPos( 0 , self.Container:GetTall() - 52 )
	self.AddButton:SetText( "Add Map" )
	function self.AddButton:DoClick()
		RunConsoleCommand( "ev", "mapcycle", "add", TAB.MapList:GetLine(TAB.MapList:GetSelectedLine()):GetValue(1) )
		timer.Simple( 0.1, function() TAB:Update() end)
	end
	
	self.RemoveButton = vgui.Create("DButton", self.Container )
	self.RemoveButton:SetSize( self.Container:GetWide() / nrbuttons - 2, 20 )
	self.RemoveButton:SetPos( self.Container:GetWide() * (1/nrbuttons) , self.Container:GetTall() - 52 )
	self.RemoveButton:SetText( "Remove Map" )
	function self.RemoveButton:DoClick()
		RunConsoleCommand( "ev", "mapcycle", "remove", TAB.CycleList:GetSelectedLine() )
		timer.Simple( 0.1, function() TAB:Update() end)
	end
	
	self.MoveUpButton = vgui.Create("DButton", self.Container )
	self.MoveUpButton:SetWide( self.Container:GetWide() / nrbuttons - 2 )
	self.MoveUpButton:SetTall( 20 )
	self.MoveUpButton:SetPos( self.Container:GetWide() * (2/nrbuttons) , self.Container:GetTall() - 52 )
	self.MoveUpButton:SetText( "Move Up" )
	function self.MoveUpButton:DoClick()
		RunConsoleCommand( "ev", "mapcycle", "moveup", TAB.CycleList:GetSelectedLine() )
		timer.Simple( 0.1, function() TAB:Update() end)
	end
	
	self.MoveDownButton = vgui.Create("DButton", self.Container )
	self.MoveDownButton:SetSize( self.Container:GetWide() / nrbuttons - 2, 20 )
	self.MoveDownButton:SetPos( self.Container:GetWide() * (3/nrbuttons) , self.Container:GetTall() - 52 )
	self.MoveDownButton:SetText( "Move Down" )
	function self.MoveDownButton:DoClick()
		RunConsoleCommand( "ev", "mapcycle", "movedown", TAB.CycleList:GetSelectedLine() )
		timer.Simple( 0.1, function() TAB:Update() end)
	end
	
	self.TimeList = vgui.Create( "DMultiChoice", self.Container )
	self.TimeList:SetSize( self.Container:GetWide() / nrbuttons - 2, 20 )
	self.TimeList:SetPos( self.Container:GetWide() * (4/nrbuttons), self.Container:GetTall() - 52 )
	self.TimeList:SetEditable( false )
	self.TimeList.Times = 	{ 	{ "5 minutes", "5" },
								{ "15 minutes", "15" },
								{ "30 minutes", "30" },
								{ "1 hour", "60" },
								{ "2 hours", "120" },
								{ "4 hours", "240" },
								{ "8 hours", "480" },
								{ "12 hours", "720" },
								{ "One day", "1440" },
								{ "1.5 days", "2700" },
								{ "Two days", "2880" }	}
	for i=1, #self.TimeList.Times do
		self.TimeList:AddChoice( self.TimeList.Times[i][1] )
	end
	function self.TimeList:OnSelect( index, value, data )
		RunConsoleCommand( "ev", "mapcycle", "interval", self.Times[index][2], self.Times[index][1] )
	end	
	
	self.MoveDownButton = vgui.Create("DButton", self.Container )
	self.MoveDownButton:SetSize( self.Container:GetWide() / nrbuttons - 2, 20 )
	self.MoveDownButton:SetPos( self.Container:GetWide() * (5/nrbuttons) , self.Container:GetTall() - 52 )
	self.MoveDownButton:SetText( "Toggle" )
	function self.MoveDownButton:DoClick()
		RunConsoleCommand( "ev", "mapcycle", "toggle" )
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