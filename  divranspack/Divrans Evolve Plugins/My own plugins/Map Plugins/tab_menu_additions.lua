local function Stuff()
	local OldFunc = evolve.MENU.Think
	function evolve.MENU:Think()
		OldFunc(evolve.MENU)
		
		local activeTab = evolve.MENU:GetActiveTab()
	
		if ( evolve.MENU.ActiveTab != activeTab ) then
			evolve.MENU.ActiveTab = activeTab
			evolve.MENU:TabSelected( activeTab )
		end
		
		local targetheight = activeTab.Height or 450
		local h = evolve.MENU.TabContainer:GetTall() + ( targetheight - evolve.MENU.TabContainer:GetTall() ) / 5
		if ( math.abs( h - targetheight ) < 5 ) then h = targetheight end
		evolve.MENU.Panel:SetTall( h )
		evolve.MENU.TabContainer:SetTall( h )
		evolve.MENU.Panel:SetPos( evolve.MENU.Panel:GetPos(), ScrH() / 2 - h / 2 )
	end
	
	local OldFunc = evolve.MENU.Hide
	function evolve.MENU:Hide()
		if (self.MenuLocked) then return end
		OldFunc(evolve.MENU)
	end
end

if (evolve.MENU) then
	Stuff()
else
	timer.Simple(1,Stuff)
end