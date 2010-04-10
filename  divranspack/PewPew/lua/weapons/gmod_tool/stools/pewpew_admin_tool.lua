-- Repair Tool
-- This tool repairs stuff

TOOL.Category = "PewPew"
TOOL.Name = "Admin Tool"
				
require("datastream")				
if (SERVER) then
	AddCSLuaFile("pewpew_repair_tool.lua")
else
	language.Add( "Tool_pewpew_admin_tool_name", "PewPew Admin Tool" )
	language.Add( "Tool_pewpew_admin_tool_desc", "Administrate your server!" )
	language.Add( "Tool_pewpew_admin_tool_0", "-nothing-" )
	

	pewpew.DamageLog = {}
	local pewpew_logframe
	local pewpew_loglist
	
	local function UpdateLogMenu()
		if (pewpew.DamageLog and #pewpew.DamageLog > 0) then
			pewpew_loglist:Clear()
			local tbl = {}
			for k,v in ipairs( pewpew.DamageLog ) do
				table.insert( tbl, 1, v )
			end
			for k,v in ipairs( tbl ) do
				local ent = v[2]
				if (type(ent) == "number") then
					if (Entity(ent):IsValid()) then
						ent = tostring(Entity(ent))
					else
						pewpew.DamageLog[k][2] = "- Died -"
						ent = "- Died -"
					end
				end
				pewpew_loglist:AddLine( v[1], v[5], v[6], ent, v[4], v[3], v[7] )
			end			
		end
	end
	
	local function OpenLogMenu()
		pewpew_logframe:SetVisible( true )
	end
	concommand.Add("PewPew_OpenLogMenu",OpenLogMenu)

	local function CreateLogMenu()
		pewpew_logframe = vgui.Create("DFrame")
		pewpew_logframe:SetPos( ScrW() - 750, 50 )
		pewpew_logframe:SetSize( 700, ScrH() - 100 )
		pewpew_logframe:SetTitle( "PewPew DamageLog" )
		pewpew_logframe:SetVisible( false )
		pewpew_logframe:SetDraggable( true )
		pewpew_logframe:ShowCloseButton( true )
		pewpew_logframe:SetDeleteOnClose( false )
		pewpew_logframe:SetScreenLock( true )
		pewpew_logframe:MakePopup()
		
		pewpew_loglist = vgui.Create( "DListView", pewpew_logframe )
		pewpew_loglist:StretchToParent( 2, 23, 2, 2 )
		local w = pewpew_loglist:GetWide()
		local a = pewpew_loglist:AddColumn( "Time" )
		a:SetWide(w*(1/6))
		local b = pewpew_loglist:AddColumn( "Damage Dealer" )
		b:SetWide(w*(1/6))
		local c = pewpew_loglist:AddColumn( "Victim Entity Owner" )
		c:SetWide(w*(1/6))
		local d = pewpew_loglist:AddColumn( "Victim Entity" )
		d:SetWide(w*(1/6))
		local e = pewpew_loglist:AddColumn( "Weapon" )
		e:SetWide(w*(1/6))
		local f = pewpew_loglist:AddColumn( "Damage" )
		f:SetWide(w*(0.5/6))
		local g = pewpew_loglist:AddColumn( "Died?" )
		g:SetWide(w*(0.5/6))
	end
	CreateLogMenu()
	
	function TOOL.BuildCPanel( CPanel )
		CPanel:AddControl( "Button", {Label="Log Menu",Description="Open the Log Menu",Text="Log Menu",Command="PewPew_OpenLogMenu"} )
		CPanel:AddControl( "Label", {Text="Changing these if you're not admin is pointless.",Description="Changing these if you're not admin is pointless."} )
		CPanel:AddControl( "CheckBox", {Label="Toggle Damage",Description="Toggle Damage",Command="pewpew_cl_toggledamage"} )
		CPanel:AddControl( "CheckBox", {Label="Toggle Firing",Description="Toggle Firing",Command="pewpew_cl_togglefiring"} )
		CPanel:AddControl( "CheckBox", {Label="Toggle Numpads",Description="Toggle Numpads",Command="pewpew_cl_togglenumpads"} )
		CPanel:AddControl( "CheckBox", {Label="Toggle Energy Usage",Description="Toggle Energy Usage",Command="pewpew_cl_toggleenergyusage"} )
		CPanel:AddControl( "CheckBox", {Label="Toggle Damage Log Sending",Description="Toggle Damage Log Sending",Command="pewpew_cl_toggledamagelog"} )
		CPanel:AddControl( "CheckBox", {Label="Toggle Core Damage Only",Description="Toggle Core Damage Only",Command="pewpew_cl_togglecoredamageonly"} )
		CPanel:AddControl( "CheckBox", {Label="Toggle Prop Prot. Dmg",Description="Toggle Prop Prot. Dmg",Command="pewpew_cl_toggleppdamage"} )
		CPanel:AddControl( "Slider", {Label="Damage Multiplier",Description="Damage Multiplier",Type="Float",Min="0.01",Max="10",Command="pewpew_cl_damagemul"} )
		CPanel:AddControl( "Slider", {Label="Damage Core Multiplier",Description="Damage Core Multiplier",Type="Float",Min="0.01",Max="10",Command="pewpew_cl_damagecoremul"} )
		CPanel:AddControl( "Slider", {Label="Repair Tool Heal Rate",Description="Repair Tool Heal Rate",Type="Integer",Min="20",Max="10000",Command="pewpew_cl_repairtoolheal"} )
		CPanel:AddControl( "Slider", {Label="Repair Tool Heal Rate vs Cores",Description="Repair Tool Heal Rate vs Cores",Type="Integer",Min="20",Max="10000",Command="pewpew_cl_repairtoolhealcores"} )
		CPanel:AddControl( "Button", {Label="Apply Changes",Description="Apply Changes",Text="Apply Changes",Command="pewpew_cl_applychanges"} )
	end
	
	local dmg = "1"
	local function Dmg( ply, cmd, args )
		dmg = args[1]
	end
	concommand.Add("pewpew_cl_toggledamage", Dmg)
	
	local firing = "1"
	local function Firing( ply, cmd, args )
		firing = args[1]
	end
	concommand.Add("pewpew_cl_togglefiring", Firing)
	
	local numpads = "1"
	local function Numpads( ply, cmd, args )
		numpads = args[1]
	end
	concommand.Add("pewpew_cl_togglenumpads", Numpads)
	
	local energy = "0"
	local function Energy( ply, cmd, args )
		energy = args[1]
	end
	concommand.Add("pewpew_cl_toggleenergyusage", Energy)
	
	local coreonly = "0"
	local function Core( ply, cmd, args )
		coreonly = args[1]
	end
	concommand.Add("pewpew_cl_togglecoredamageonly", Core )
	
	local damagemul = "1"
	local function DmgMul( ply, cmd, args )
		damagemul = args[1]
	end
	concommand.Add("pewpew_cl_damagemul",DmgMul)
	
	local damagemulcores = "1"
	local function DmgMulCores( ply, cmd, args )
		damagemulcores = args[1]
	end
	concommand.Add("pewpew_cl_damagecoremul",DmgMulCores)
	
	local repair = "75"
	local function Repair( ply, cmd, args )
		repair = args[1]
	end
	concommand.Add("pewpew_cl_repairtoolheal",Repair)
	
	local repaircores = "200"
	local function RepairCore( ply, cmd, args )
		repaircores = args[1]
	end
	concommand.Add("pewpew_cl_repairtoolhealcores",RepairCore)
	
	local damagelog = "1"
	local function DmgLog( ply, cmd, args )
		damagelog = args[1]
	end
	concommand.Add("pewpew_cl_toggledamagelog",DmgLog)
	
	local ppdamage = "1"
	local function PPDmg( ply, cmd, args )
		ppdamage = args[1]
	end
	concommand.Add("pewpew_cl_toggleppdamage",PPDmg)
	
	local function Apply( ply, cmd, args )
		RunConsoleCommand("pewpew_toggledamage",dmg)
		RunConsoleCommand("pewpew_togglefiring",firing)
		RunConsoleCommand("pewpew_togglenumpads",numpads)
		RunConsoleCommand("pewpew_toggleenergyusage",energyusage)
		RunConsoleCommand("pewpew_togglecoredamageonly",coreonly)
		RunConsoleCommand("pewpew_damagemul",damagemul)
		RunConsoleCommand("pewpew_coredamagemul",damagemulcores)
		RunConsoleCommand("pewpew_repairtoolheal",repair)
		RunConsoleCommand("pewpew_repairtoolhealcores",repaircores)
		RunConsoleCommand("pewpew_toggledamagelogsending",damagelog)
		RunConsoleCommand("PewPew_TogglePP",ppdmg)
	end
	concommand.Add("pewpew_cl_applychanges", Apply)

	usermessage.Hook( "PewPew_Admin_Tool_SendLog_Umsg", function( um )
		local Amount = um:ReadShort()
		for i=1,Amount do
			local Time = um:ReadString()
			local ID = um:ReadShort()
			local Damage = um:ReadLong()
			local Weapon = um:ReadString()
			local DealerName = um:ReadString()
			local VictimName = um:ReadString()
			local DiedB = um:ReadBool()
			local Died = "No"
			if (DiedB) then Died = "Yes" end
			tbl = { Time, ID, Damage, Weapon, DealerName, VictimName, Died }
			table.insert(pewpew.DamageLog,tbl)
		end
		UpdateLogMenu()
	end)
	
	function TOOL:DrawHUD()
		local cannons = ents.FindByClass("pewpew_base_cannon")
		local bullets = ents.FindByClass("pewpew_base_bullet")
		
		for k,v in ipairs( cannons ) do
			local pos = v:GetPos():ToScreen()
			local name = v:GetNWString("PewPew_OwnerName","- Error -")
			surface.SetFont("ScoreboardText")
			local w = surface.GetTextSize( name )
			draw.WordBox( 1, pos.x - w / 2, pos.y, name, "ScoreboardText", Color( 0,0,0,255 ), Color( 50,200,50,255 ) )
		end
		
		for k,v in ipairs( bullets ) do
			local pos = v:GetPos():ToScreen()
			local name = v:GetNWString("PewPew_OwnerName","- Error -")
			surface.SetFont("ScoreboardText")
			local w = surface.GetTextSize( name )
			draw.WordBox( 6, pos.x - w / 2, pos.y, name, "ScoreboardText", Color( 0,0,0,255 ), Color( 50,200,50,255 ) )
		end
		
	end
	
	
end