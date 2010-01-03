/*-------------------------------------------------------------------------------------------------------------------------
	Wire Limits Tab
-------------------------------------------------------------------------------------------------------------------------*/

local TAB = {}
TAB.Title = "Wire Limits"
TAB.Description = "Wire Limits."
TAB.Author = "Divran"

TAB.Limits = {
	{ "sbox_maxwire_deployers", "Deployers" },
	{ "sbox_maxwire_hoverdrives", "Hoverdrives" },
	{ "sbox_maxwire_waypoints", "Waypoints" },
	{ "sbox_maxwire_watersensors", "Water Sensors" },
	{ "sbox_maxwire_vehicles", "Vehicles" },
	{ "sbox_maxwire_values", "Values" },
	{ "sbox_maxwire_users", "Users" },
	{ "sbox_maxwire_twoway_radioes", "Two Way Radioes" },
	{ "sbox_maxwire_textreceivers", "Text Recievers"} ,
	{ "sbox_maxwire_target_finders", "Target Finders" },
	{ "sbox_maxwire_spawners", "Prop Spawners" },
	{ "sbox_maxwire_sensors", "Sensors" },
	{ "sbox_maxwire_relays", "Relays" },
	{ "sbox_maxwire_rangers", "Rangers" },
	{ "sbox_maxwire_radioes", "Radioes"} ,
	{ "sbox_maxwire_pods", "Pod Controllers" },
	{ "sbox_maxwire_sockets", "Sockets" },
	{ "sbox_maxwire_plugs", "Plugs" },
	{ "sbox_maxwire_outputs", "Numpad Outputs" },
	{ "sbox_maxwire_numpads", "Numpads" },
	{ "sbox_maxwire_nailers", "Nailers" },
	{ "sbox_maxwire_locators", "Locator Beacons" },
	{ "sbox_maxwire_las_receivers", "Laser Pointer Recievers" },
	{ "sbox_maxwire_keyboards", "Keyboards" },
	{ "sbox_maxwire_hdds", "Hard Drives" },
	{ "sbox_maxwire_gyroscopes", "Gyroscopes"} ,
	{ "sbox_maxwire_graphics_tablets", "Graphic Tablets" },
	{ "sbox_maxwire_gpus", "GPUs"}, 
	{ "sbox_maxwire_gpss", "GPSs" },
	{ "sbox_maxwire_fx_emitter", "Effects Emitter" },
	{ "sbox_maxwire_eyepods", "EyePods" },
	{ "sbox_maxwire_expressions", "Expressions" },
	{ "sbox_maxwire_explosive", "Explosives" },
	{ "sbox_maxwire_emarkers", "Entity Markers" },
	{ "sbox_maxwire_data_transferers", "Data Transferers" },
	{ "sbox_maxwire_data_stores", "Data Stores" },
	{ "sbox_maxwire_data_satellitedishs", "Sattelite Dishes" },
	{ "sbox_maxwire_datarates", "Data Rates" },
	{ "sbox_maxwire_dataports", "Data Ports" },
	{ "sbox_maxwire_datasockets", "Data Sockets" },
	{ "sbox_maxwire_dataplugs", "Data Plugs" },
	{ "sbox_maxwire_damage_detectors", "Damage Detectors" },
	{ "sbox_maxwire_cpus", "CPUs" },
	{ "sbox_maxwire_colorers", "Colorers" },
	{ "sbox_maxwire_cd_locks", "CD Locks" },
	{ "sbox_maxwire_cd_rays", "CD Rays" },
	{ "sbox_maxwire_cd_disks", "CD Disks" },
	{ "sbox_maxwire_cams", "Camera Controllers" },
	{ "sbox_maxwire_addressbuss", "Adress Busses"} ,
	{ "sbox_maxwire_thrusters", "Thrusters" },
	{ "sbox_maxwire_trails", "Trails" },
	{ "sbox_maxwire_igniters", "Igniters" },
	{ "sbox_maxwire_hoverballs", "Hoverballs" },
	{ "sbox_maxwire_grabbers" , "Grabbers" },
	{ "sbox_maxwire_detonators", "Detonators" },
	{ "sbox_maxwire_forcers", "Forcers" },
	{ "sbox_maxwire_turrets", "Turrets" },
	{ "sbox_maxwire_wheels", "Wheels" },
	{ "sbox_maxwire_simple_explosive", "Simple Esplosives" },
	{ "sbox_maxwire_weights", "Weights" },
	{ "sbox_maxwire_inputs", "Numpad Inputs" },
	{ "sbox_maxwire_dual_inputs", "Dual Numpad Inputs" },
	{ "sbox_maxwire_buttons", "Buttons" },
	{ "sbox_maxwire_adv_inputs", "Adv Numpad Inputs" },
	{ "sbox_maxwire_hologrids", "Holo Emitter Grids" },
	{ "sbox_maxwire_holoemitters", "Holo Emitters" },
	{"sbox_maxwire_textscreens", "Text screens"},
	{"sbox_maxwire_emitters", "Emitters"},
	{"sbox_maxwire_screens", "Screens"},
	{"sbox_maxwire_pixels", "Pixels"},
	{"sbox_maxwire_panels", "Panels"},
	{"sbox_maxwire_oscilloscope", "Oscilloscopes"},
	{"sbox_maxwire_lights", "Lights"},
	{"sbox_maxwire_lamps", "Lamps"},
	{"sbox_maxwire_digitalscreens", "Digital Screens"},
	{"sbox_maxwire_consolescreens", "Console Screens"},
	{"sbox_maxwire_indicators", "Indicators"},
	{"sbox_maxwire_speedometers", "Speedometers"},
	{"sbox_maxwire_gate_trigs", "Gate - Trig"},
	{ "sbox_maxwire_gate_times", "Gate - Time" },
	{ "sbox_maxwire_gate_selections", "Gate - Selection" },
	{ "sbox_maxwire_gate_memorys", "Gate - Memory" },
	{ "sbox_maxwire_gate_logics", "Gate - Logic" },
	{ "sbox_maxwire_gate_duplexer", "Gate - Duplexer" },
	{ "sbox_maxwire_gate_comparisons", "Gate - Comparison"},
	{ "sbox_maxwire_gates", "Gates"}
}
TAB.ConVars = {}
TAB.ConVarSliders = {}
TAB.ConVarCheckboxes = {}

function TAB:ApplySettings()
	for _, v in pairs( self.ConVarSliders ) do
		if ( GetConVar( v.ConVar ):GetInt() != v:GetValue() ) then
			RunConsoleCommand( "ev", "convar", v.ConVar, v:GetValue() )
		end
	end
	
	for _, v in pairs( self.ConVarCheckboxes ) do
		if ( GetConVar( v.ConVar ):GetBool() != v:GetChecked() ) then
			RunConsoleCommand( "ev", "convar", v.ConVar, evolve:BoolToInt( v:GetChecked() ) * ( v.OnValue or 1 ) )
		end
	end
end

function TAB:Update()
	for _, v in pairs( self.ConVarCheckboxes ) do
		v:SetChecked( GetConVar( v.ConVar ):GetInt() > 0 )
	end
	
	if ( LocalPlayer():EV_IsAdmin() ) then
		self.Block:SetPos( self.Block:GetWide(), 0 )
	else
		self.Block:SetPos( 0, 0 )
	end
end


function TAB:Initialize()
	self.Container = vgui.Create( "DPanel", evolve.menuContainer )
	self.Container:SetSize( evolve.menuw - 10, evolve.menuh )
	self.Container.Paint = function() end
	evolve.menuContainer:AddSheet( self.Title, self.Container, "gui/silkicons/world", false, false, self.Description )
	
	self.LimitsContainer = vgui.Create( "DPanelList", self.Container )
	self.LimitsContainer:SetPos( 0, 2 )
	self.LimitsContainer:SetSize( self.Container:GetWide(), self.Container:GetTall() - 33 )
	self.LimitsContainer:SetSpacing( 9 )
	self.LimitsContainer:SetPadding( 10 )
	self.LimitsContainer:EnableHorizontal( true )
	self.LimitsContainer:EnableVerticalScrollbar( true )
	self.LimitsContainer.Think = function( self )
		if ( input.IsMouseDown( MOUSE_LEFT ) ) then
			self.applySettings = true
		elseif ( !input.IsMouseDown( MOUSE_LEFT ) and self.applySettings ) then
			TAB:ApplySettings()
			self.applySettings = false
		end
	end
	
	for i, cv in pairs( self.Limits ) do
		if ( ConVarExists( cv[1] ) ) then
			local cvSlider = vgui.Create( "DNumSlider", self.Container )
			cvSlider:SetText( cv[2] )
			cvSlider:SetWide( self.LimitsContainer:GetWide() / 2 - 20 )
			cvSlider:SetMin( 0 )
			cvSlider:SetMax( 200 )
			cvSlider:SetDecimals( 0 )
			cvSlider:SetValue( GetConVar( cv[1] ):GetInt() )
			cvSlider.ConVar = cv[1]
			self.LimitsContainer:AddItem( cvSlider )
		
			table.insert( self.ConVarSliders, cvSlider )
		end
	end
	
	-- these arent needed for this tab..
	/*
	self.Settings = vgui.Create( "DPanelList", self.Container )
	self.Settings:SetPos( self.LimitsContainer:GetPos() + self.LimitsContainer:GetWide() + 5, 2 )
	self.Settings:SetSize( 145, self.Container:GetTall() - 33 )
	self.Settings:SetSpacing( 9 )
	self.Settings:SetPadding( 10 )
	self.Settings:EnableHorizontal( true )
	self.Settings:EnableVerticalScrollbar( true )
	
	for i, cv in pairs( self.ConVars ) do
		if ( ConVarExists( cv[1] ) ) then
			local cvCheckbox = vgui.Create( "DCheckBoxLabel", self.Settings )
			cvCheckbox:SetText( cv[2] )
			cvCheckbox:SetWide( self.Settings:GetWide() - 15 )
			cvCheckbox:SetValue( GetConVar( cv[1] ):GetInt() > 0 )
			cvCheckbox.ConVar = cv[1]
			cvCheckbox.OnValue = cv[3]
			cvCheckbox.DoClick = function( self )
				TAB:ApplySettings()
			end
			self.Settings:AddItem( cvCheckbox )
			
			table.insert( self.ConVarCheckboxes, cvCheckbox )
		end
	end
	*/
	
	self.Block = vgui.Create( "DFrame", self.Container )
	self.Block:SetDraggable( false )
	self.Block:SetTitle( "" )
	self.Block:ShowCloseButton( false )
	self.Block:SetPos( 0, 0 )
	self.Block:SetSize( self.Container:GetWide(), self.Container:GetTall() )
	self.Block.Paint = function()
		surface.SetDrawColor( 46, 46, 46, 255 )
		surface.DrawRect( 0, 0, self.Block:GetWide(), self.Block:GetTall() )
		
		draw.SimpleText( "You need to be a super administrator to access this tab!", "ScoreboardText", self.Block:GetWide() / 2, self.Block:GetTall() / 2 - 20, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
	end
	if ( LocalPlayer():EV_IsAdmin() ) then self.Block:SetPos( self.Block:GetWide(), 0 ) end
end

evolve:RegisterMenuTab( TAB )