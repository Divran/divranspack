/*-------------------------------------------------------------------------------------------------------------------------
	Bans tab
-------------------------------------------------------------------------------------------------------------------------*/

local TAB = {}
TAB.Title = "Bans"
TAB.Description = "Manage bans."
TAB.Author = "Divran"

TAB.Bans = {}

if (!datastream) then require("datastream") end

function TAB:RecieveData( handler, id, decoded )
	TAB.Bans = decoded
	TAB:Update()
end
datastream.Hook("evolve_sendbanlist", TAB.RecieveData)

function TAB:Update() 
	self.Container:RequestFocus()
	self.BanList:Clear()
	for _, tbl in pairs( self.Bans ) do
		self.BanList:AddLine( tbl[1], tbl[2], os.date( "%c", tbl[3]), os.date( "%c", tbl[4] ), math.Round((tbl[4]-os.time())/60) .. " / " .. math.Round((tbl[4]-tbl[3])/60), tbl[5] )
	end
end

-- Find a ban
function TAB:FindBan( SteamID, Bool )
if (#self.Bans == 0) then return nil, {} end
	if (!Bool) then
		-- Find by SteamID
		for key, tbl in pairs( self.Bans ) do
			if (tbl[2] == SteamID) then
				return key, tbl
			end
		end
	else
		-- Find by Name
		for key, tbl in pairs( self.Bans ) do
			if (string.find(string.lower(tbl[1]), SteamID)) then
				return key, tbl
			end
		end
	end
	return nil, {}
end

function TAB:Initialize()
	self.Container = vgui.Create( "DPanel", evolve.menuContainer )
	self.Container:SetSize( evolve.menuw - 10, evolve.menuh )
	self.Container.Paint = function() end
	evolve.menuContainer:AddSheet( self.Title, self.Container, "gui/silkicons/lock", false, false, self.Description )
	local w, h = self.Container:GetWide(), self.Container:GetTall()
	
	self.BanList = vgui.Create( "DListView", self.Container )
	self.BanList:SetPos( 0, 2 )
	self.BanList:SetSize( w - 2, h - 58 )
	self.BanList:SetMultiSelect( false )
	self.BanList:AddColumn("Name")
	self.BanList:AddColumn("SteamID")
	self.BanList:AddColumn("Date banned")
	self.BanList:AddColumn("Date unbanned")
	self.BanList:AddColumn("Minutes")
	self.BanList:AddColumn("Reason")	

	self.EditButton = vgui.Create("DButton", self.Container )
	self.EditButton:SetSize( w * (1/6) - 2, 20 )
	self.EditButton:SetPos( w * (1/6) , h - 52 )
	self.EditButton:SetText( "Edit Selected" )
	function self.EditButton:DoClick()
		if (TAB.BanList:GetSelectedLine()) then
			local Line = TAB.BanList:GetLine(TAB.BanList:GetSelectedLine())
			local SteamID = Line:GetValue(2)
			local Time = TAB.TimeBox:GetValue()
			local Reason = TAB.ReasonBox:GetValue()
			RunConsoleCommand( "ev","ban", SteamID, Time, Reason )
			TAB:Update()
		end
	end
	
	self.UnbanButton = vgui.Create("DButton", self.Container )
	self.UnbanButton:SetSize( w * (1/6) - 2, 20 )
	self.UnbanButton:SetPos( 0 , h - 52 )
	self.UnbanButton:SetText( "Unban Selected" )
	function self.UnbanButton:DoClick()
		if (TAB.BanList:GetSelectedLine()) then
			RunConsoleCommand( "ev", "unban", TAB.BanList:GetLine(TAB.BanList:GetSelectedLine()):GetValue(2) )
			TAB:Update()
		end
	end
	
	self.Label1 = vgui.Create( "DLabel", self.Container )
	self.Label1:SetText( "Time:" )
	self.Label1:SizeToContents()
	self.Label1:SetPos( w * (2/6) + 6, h - 48 )
	
	self.TimeBox = vgui.Create( "DTextEntry", self.Container )
	self.TimeBox:SetWide( w*(1/6) )
	self.TimeBox:SetPos( w*(2/6)+self.Label1:GetWide()+10, h-52 )
	
	self.Label2 = vgui.Create( "DLabel", self.Container )
	self.Label2:SetText( "Reason:" )
	self.Label2:SizeToContents()
	self.Label2:SetPos( w * (3/6)+40, h - 48 )
	
	self.ReasonBox = vgui.Create( "DTextEntry", self.Container )
	self.ReasonBox:SetWide( w*(1/6) )
	self.ReasonBox:SetPos( w*(3/6)+40+self.Label2:GetWide()+5, h-52 )
	
	function self.BanList:OnRowSelected( line )
		local key, tbl = TAB:FindBan( self:GetLine(line):GetValue(2) )
		TAB.TimeBox:SetValue( math.Round((tbl[4]-os.time())/60) )
		TAB.ReasonBox:SetValue( self:GetLine(line):GetValue(6) )
	end
	
	self.LockButton = vgui.Create( "DButton", self.Container )
	self.LockButton:SetSize( w*(1/6)/2, 20 )
	self.LockButton:SetPos( w*(5/6)-5, h-52 )
	self.LockButton:SetText( "Lock Menu" )
	function self.LockButton:DoClick()
		if (!evolve.MenuLocked) then
			self:SetText("Close Menu")
			evolve.MenuLocked = true
		else
			evolve.MenuLocked = false
			self:SetText("Lock Menu")
			evolve:CloseMenu()
		end
	end
	
	self.ResendButton = vgui.Create( "DButton", self.Container )
	self.ResendButton:SetSize( w*(1/6)/2, 20 )
	self.ResendButton:SetPos( w*(5/6)+self.LockButton:GetWide()+1, h-52 )
	self.ResendButton:SetText( "Update" )
	function self.ResendButton:DoClick()
		RunConsoleCommand("ev_resendbanlist")
	end
end

evolve:RegisterMenuTab( TAB )