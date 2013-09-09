/*-------------------------------------------------------------------------------------------------------------------------
	Maps tab
-------------------------------------------------------------------------------------------------------------------------*/

local TAB = {}
TAB.Title = "Mapcycle"
TAB.Description = "Automatic map cycle."
TAB.Author = "Divran"
TAB.Width = 520
TAB.Icon = "world"

function TAB:Update()
	local maps = evolve:MapCyclePlugin_GetMaps()
	if (maps) then
		-- Get selected line and value
		local line = self.CycleList:GetSelectedLine()
		local lineval
		if (line) then
			lineval = self.CycleList:GetLine(line):GetValue(1)
		end
		
		-- Re-fill list
		self.CycleList:Clear()
		for _, filename in pairs( maps ) do
			self.CycleList:AddLine( filename )
		end
		
		-- Select the correct line
		if (line and lineval) then
			local line1 = self.CycleList:GetLine(line)
			local line2 = self.CycleList:GetLine(line-1)
			local line3 = self.CycleList:GetLine(line+1)
			if (line1 and line1:GetValue(1) and line1:GetValue(1) == lineval) then
				self.CycleList:SelectItem( line1 )
			elseif (line2 and line2:GetValue(1) and line2:GetValue(1) == lineval) then
				self.CycleList:SelectItem( line2 )
			elseif (line3 and line3:GetValue(1) and line3:GetValue(1) == lineval) then
				self.CycleList:SelectItem( line3 )
			else
				if (line2 and line2:GetValue(1)) then
					self.CycleList:SelectItem( line2 )
				else
					self.CycleList:SelectFirstItem()
				end
			end		
		else
			self.CycleList:SelectFirstItem()
		end
	end
end

function evolve:MapCyclePlugin_UpdateTab() TAB:Update() end

function TAB:Initialize( pnl )

	local w,h = self.Width, pnl:GetParent():GetTall()

	self.MapList = vgui.Create( "DListView", pnl )
	self.MapList:SetPos( 0, 2 )
	self.MapList:SetSize( w / 2 - 2, h - 58 )
	self.MapList:SetMultiSelect( false )
	self.MapList:AddColumn("Maps")
	local maps, _ = evolve:MapPlugin_GetMaps()
	if (#maps>0) then
		for _, filename in pairs(maps) do
			self.MapList:AddLine( filename )
		end
		self.MapList:SelectFirstItem()
	else
		timer.Simple( 5, function()
			for _, filename in pairs(maps) do
				self.MapList:AddLine( filename )
			end
			self.MapList:SelectFirstItem()
		end )
	end
	
	self.CycleList = vgui.Create("DListView",pnl)
	self.CycleList:SetPos( w / 2 + 2, 2 )
	self.CycleList:SetSize( w / 2 - 4, h - 58 )
	self.CycleList:SetMultiSelect( false )
	self.CycleList:AddColumn("Cycle")
	
	local nrbuttons = 6

	self.AddButton = vgui.Create("DButton", pnl )
	self.AddButton:SetSize( w / nrbuttons - 2, 20 )
	self.AddButton:SetPos( 0 , h - 52 )
	self.AddButton:SetText( "Add Map" )
	function self.AddButton:DoClick()
		RunConsoleCommand( "ev", "mapcycle", "add", TAB.MapList:GetLine(TAB.MapList:GetSelectedLine()):GetValue(1) )
	end
	
	self.RemoveButton = vgui.Create("DButton", pnl )
	self.RemoveButton:SetSize( w / nrbuttons - 2, 20 )
	self.RemoveButton:SetPos( w * (1/nrbuttons) , h - 52 )
	self.RemoveButton:SetText( "Remove Map" )
	function self.RemoveButton:DoClick()
		RunConsoleCommand( "ev", "mapcycle", "remove", TAB.CycleList:GetSelectedLine() )
	end
	
	self.MoveUpButton = vgui.Create("DButton", pnl )
	self.MoveUpButton:SetWide( w / nrbuttons - 2 )
	self.MoveUpButton:SetTall( 20 )
	self.MoveUpButton:SetPos( w * (2/nrbuttons) , h - 52 )
	self.MoveUpButton:SetText( "Move Up" )
	function self.MoveUpButton:DoClick()
		RunConsoleCommand( "ev", "mapcycle", "moveup", TAB.CycleList:GetSelectedLine() )
	end
	
	self.MoveDownButton = vgui.Create("DButton", pnl )
	self.MoveDownButton:SetSize( w / nrbuttons - 2, 20 )
	self.MoveDownButton:SetPos( w * (3/nrbuttons) , h - 52 )
	self.MoveDownButton:SetText( "Move Down" )
	function self.MoveDownButton:DoClick()
		RunConsoleCommand( "ev", "mapcycle", "movedown", TAB.CycleList:GetSelectedLine() )
	end
	
	self.TimeList = vgui.Create( "DComboBox", pnl )
	self.TimeList:SetSize( w / nrbuttons - 2, 20 )
	self.TimeList:SetPos( w * (4/nrbuttons), h - 52 )
	--self.TimeList:SetEditable( false )
	self.TimeList.Times = 	{ 	{ "5 minutes", "5" },
								{ "15 minutes", "15" },
								{ "30 minutes", "30" },
								{ "1 hour", "60" },
								{ "2 hours", "120" },
								{ "4 hours", "240" },
								{ "6 hours", "360" },
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
	
	self.MoveDownButton = vgui.Create("DButton", pnl )
	self.MoveDownButton:SetSize( w / nrbuttons - 2, 20 )
	self.MoveDownButton:SetPos( w * (5/nrbuttons) , h - 52 )
	self.MoveDownButton:SetText( "Toggle" )
	function self.MoveDownButton:DoClick()
		RunConsoleCommand( "ev", "mapcycle", "toggle" )
	end
	
	self.Block = vgui.Create( "DFrame", pnl )
	self.Block:SetDraggable( false )
	self.Block:SetTitle( "" )
	self.Block:ShowCloseButton( false )
	self.Block:SetPos( 0, 0 )
	self.Block:SetSize( w, h )
	self.Block.Paint = function()
		surface.SetDrawColor( 46, 46, 46, 255 )
		surface.DrawRect( 0, 0, self.Block:GetWide(), self.Block:GetTall() )
		
		draw.SimpleText( "You need the Maps List Plugin ('sh_mapslist.lua') for this tab to work.", "ScoreboardText", self.Block:GetWide() / 2, self.Block:GetTall() / 2 - 20, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
	end
	
	if ( table.Count(maps) ) then self.Block:SetPos( self.Block:GetWide(), 0 ) end
end

evolve:RegisterTab( TAB )