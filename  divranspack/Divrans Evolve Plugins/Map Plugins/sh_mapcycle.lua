/*-------------------------------------------------------------------------------------------------------------------------
	Automatic map cycle
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Map Cycle"
PLUGIN.Description = "Automatically cycle maps."
PLUGIN.Author = "Divran"
PLUGIN.ChatCommand = "mapcycle"
PLUGIN.Usage = "[add/remove/toggle/moveup/movedown/interval] [mapname/interval]"
PLUGIN.Privileges = { "Map Cycle" }

-- Variables
PLUGIN.Enabled = true
PLUGIN.Cycle = {}
PLUGIN.MapChangeInterval = 1
PLUGIN.MapChangeAt = -1
PLUGIN.NextMap = ""
PLUGIN.Maps = {}
evolve.MapCycle = {}

if !datastream then require"datastream" end

if (SERVER) then
	function PLUGIN:Call( ply, args )
		if (ply:EV_HasPrivilege( "Map Cycle" )) then
			if (args[1] and args[1] != "") then
				local what = args[1]
				if (what == "add") then
					if (!self:MapExists( args[2] )) then
						evolve:Notify( ply, evolve.colors.red, "That map does not exist." )
					else
						self:AddMap( args[2] )
						self:SendMapInfo( nil, true )
						evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " added the map ", evolve.colors.red, args[2], evolve.colors.white, " to the map cycle list." )
					end
				elseif (what == "remove") then
					local nr = tonumber(args[2])
					if (!nr or nr == 0) then
						if (!self:MapExists( args[2] )) then
							evolve:Notify( ply, evolve.colors.red, "That map does not exist." )
						else
							local bool, index = self:HasMap( args[2] )
							if (bool) then
								self:RemoveMap( index )
								self:SendMapInfo( nil, true )
								evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " removed the map ", evolve.colors.red, args[2], evolve.colors.white, " from the map cycle list." )
							else
								evolve:Notify( ply, evolve.colors.red, "That map is not on the cycle list." )
							end
						end
					else
						if (nr > 0 and nr <= #self.Cycle) then
							local mapname = self.Cycle[nr]
							if (self:HasMap( mapname )) then
								self:RemoveMap( nr )
								self:SendMapInfo( nil, true )
								evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " removed the map ", evolve.colors.red, mapname, evolve.colors.white, " from the map cycle list." )
							else
								evolve:Notify( ply, evolve.colors.red, "That map is not on the cycle list." )
							end
						end
					end
				elseif (what == "toggle") then
					self.Enabled = !self.Enabled
					self.MapChangeAt = RealTime() + self.MapChangeInterval * 60
					self:SaveCycle()
					self:SendMapInfo( nil, false )
					if (self.Enabled) then
						evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " has enabled the map cycle." )
					else
						evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " has disabled the map cycle." )
					end
				elseif (what == "moveup") then
					local nr = tonumber(args[2])
					if (!nr or nr == 0) then
						if (!self:MapExists( args[2] )) then
							evolve:Notify( ply, evolve.colors.red, "That map does not exist." )
						else
							local bool, index = self:HasMap( args[2] )
							if (bool) then
								local bool2 = self:MoveUp( index )
								self:SendMapInfo( nil, true )
								if (bool2) then
									evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " moved the map ", evolve.colors.red, args[2], evolve.colors.white, " one step up in the list." )
								else
									evolve:Notify( ply, evolve.colors.red, "That map cannot be moved up." )
								end
							else
								evolve:Notify( ply, evolve.colors.red, "That map is not on the cycle list." )
							end
						end
					else
						if (nr > 0 and nr <= #self.Cycle) then
							local mapname = self.Cycle[nr]
							local bool = self:MoveUp( nr )
							self:SendMapInfo( nil, true )
							if (bool) then
								evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " moved the map ", evolve.colors.red, mapname, evolve.colors.white, " one step up in the list." )
							else
								evolve:Notify( ply, evolve.colors.red, "That map cannot be moved up." )
							end
						end
					end
				elseif (what == "movedown") then
					local nr = tonumber(args[2])
					if (!nr or nr == 0) then
						if (!self:MapExists( args[2] )) then
							evolve:Notify( ply, evolve.colors.red, "That map does not exist." )
						else
							local bool, index = self:HasMap( args[2] )
							if (bool) then
								local bool2 = self:MoveDown( index )
								self:SendMapInfo( nil, true )
								if (bool2) then
									evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " moved the map ", evolve.colors.red, args[2], evolve.colors.white, " one step down in the list." )
								else
									evolve:Notify( ply, evolve.colors.red, "That map cannot be moved down." )
								end
							else
								evolve:Notify( ply, evolve.colors.red, "That map is not on the cycle list." )
							end
						end
					else
						if (nr > 0 and nr <= #self.Cycle) then
							local mapname = self.Cycle[nr]
							local bool = self:MoveDown( nr )
							self:SendMapInfo( nil, true )
							if (bool) then
								evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " moved the map ", evolve.colors.red, mapname, evolve.colors.white, " one step down in the list." )
							else
								evolve:Notify( ply, evolve.colors.red, "That map cannot be moved down." )
							end
						end
					end
				elseif (what == "interval") then
					local int = args[2]
					if (int) then
						self.MapChangeInterval = math.max( int, 0.25 )
						self.MapChangeAt = RealTime() + self.MapChangeInterval * 60
						self:SaveCycle()
						self:SendMapInfo( nil, false )
						if (args[3]) then
							evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " changed the map cycle interval to ", evolve.colors.red, tostring(self.MapChangeInterval), evolve.colors.white, " minutes.", evolve.colors.red, " (" .. args[3] .. ")" )
						else
							evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " changed the map cycle interval to ", evolve.colors.red, tostring(self.MapChangeInterval), evolve.colors.white, " minutes." )
						end
					end
				end
			end
		end
	end
	
	-----------------
	-- Add and remove
	
	function PLUGIN:AddMap( mapname )
		if (!self.Cycle) then self.Cycle = {} end
		if (#self.Cycle == 0) then
			self.MapChangeAt = RealTime() + self.MapChangeInterval * 60
		end
		self.Cycle[#self.Cycle+1] = mapname
		self:SaveCycle()
	end
	
	function PLUGIN:RemoveMap( mapnameorindex )
		if (type(mapnameorindex) == "string") then
			local bool, index = self:HasMap( mapnameorindex )
			if (bool) then
				table.remove( self.Cycle, index )
				self:SaveCycle()
			end
		elseif (type(mapnameorindex) == "number") then
			table.remove( self.Cycle, mapnameorindex )
			self:SaveCycle()
		end	
	end
	
	-----------------
	-- Edit list order
	
	function PLUGIN:MoveUp( index )
		local from = self.Cycle[index]
		local to = self.Cycle[index-1] or ""
		if (to and to != "") then
			self.Cycle[index] = to
			self.Cycle[index-1] = from
			self:SaveCycle()
			return true
		end
		return false
	end
	
	function PLUGIN:MoveDown( index )
		local from = self.Cycle[index]
		local to = self.Cycle[index+1] or ""
		if (to and to != "") then
			self.Cycle[index] = to
			self.Cycle[index+1] = from
			self:SaveCycle()
			return true
		end
		return false
	end
	
	-----------------
	-- Useful functions

	-- Is the map in the cycle list?
	function PLUGIN:HasMap( mapname )
		if (self.Cycle) then
			for index, mapn in pairs( self.Cycle ) do
				if (mapn == mapname) then
					return true, index
				end
			end
		end
		return false, 0
	end
	
	-- Does the map exist on the server?
	function PLUGIN:MapExists( mapname )
		for index, mapn in pairs( self.Maps ) do
			if (mapn == mapname) then
				return true, index
			end
		end
		return false, 0
	end
	
	-- Does the cycle file exist? if not, create it
	function PLUGIN:MapCycleFileExists()
		if (!file.Exists("evolve/ev_mapcycle.txt")) then
			file.Write("evolve/ev_mapcycle.txt","")
			return false
		end
		return true
	end
	
	-----------------
	-- Main
	
	-- Save the cycle to the file
	function PLUGIN:SaveCycle()
		file.Write( "evolve/ev_mapcycle.txt", glon.encode( { self.Enabled, self.MapChangeInterval, self.Cycle } ))
	end
	
	-- Load the cycle from the file
	function PLUGIN:GetCycle()
		if (self:MapCycleFileExists()) then
			local str = file.Read( "evolve/ev_mapcycle.txt" )
			if (str and str != "") then
				local tbl = glon.decode( str )
				self.Enabled = tbl[1]
				self.MapChangeInterval = tbl[2]
				self.Cycle = tbl[3]
			end
		end
	end

	-- Change map at the right time
	function PLUGIN:Think()
		local nextmap = self.Cycle[1] or ""
	
		-- Check if the next map exists
		if (nextmap and nextmap != "" and self.Enabled) then
			-- Check if the time has run out
			if (RealTime() > self.MapChangeAt and self.MapChangeAt != -1) then
				if (self:MapExists( nextmap )) then
					self:RemoveMap( 1 )
					self:AddMap( nextmap )
					self:SaveCycle()
					RunConsoleCommand( "changelevel", nextmap )
					return
				else
					evolve:Notify( evolve.colors.red, "Map Cycle Plugin error: Map '" .. nextmap .. "' does not exist!" )
				end
			end
		end
		
		if (self.NextMap != nextmap) then		-- if the nextmap has changed, re-send info to all players
			self.NextMap = nextmap
			self:SendMapInfo( nil, true )
		end
	end
	
	-- Send map info
	function PLUGIN:SendMapInfo( ply, sendall )
		if (sendall) then
			datastream.StreamToClients( ply or player.GetAll(), "evolve_cyclemaplist", { sendall, self.MapChangeAt, RealTime(), self.Enabled, self.Cycle } )
		else
			datastream.StreamToClients( ply or player.GetAll(), "evolve_cyclemaplist", { sendall, self.MapChangeAt, RealTime(), self.Enabled } )
		end
	end
	
	-- Send the info when the player spawns
	function PLUGIN:PlayerInitialSpawn( ply )
		if (!self.Cycle) then
			self:GetCycle()
		end
		if (!self.NextMap) then
			self:GetNextMap()
		end
		timer.Create( "ev_sendmapinfo_delay"..CurTime(), 1, 1, function( ply )
			self:SendMapInfo( ply, true )
		end, ply )
	end

	-- Get map list from the map list plugin
	function PLUGIN:GetMapList()
		for _, plugin in pairs( evolve.plugins ) do
			if (plugin.Title == "Get Maps") then
				self.Maps = plugin.Maps
				return
			end
		end
		evolve:Notify( "MAP CYCLE WILL NOT WORK WITHOUT THE MAPLIST PLUGIN." )
	end
	
	-- Initialization
	timer.Simple( 0.5, function()
		PLUGIN:GetMapList()
		PLUGIN:GetCycle()
		if (PLUGIN.Enabled) then
			PLUGIN.MapChangeAt = RealTime() + PLUGIN.MapChangeInterval * 60
		end
	end)
	
	-- Update the time for all players every 10 minutes
	timer.Create( "Evolve_UpdateMapTime", 600, 0, function() PLUGIN:SendMapInfo( nil, false ) end )
else
	function PLUGIN:RecieveCycle( crap, stuff, decoded )
		local sendall = decoded[1]
		if (sendall) then
			PLUGIN.MapChangeAt = decoded[2]
			PLUGIN.TimeDiff = decoded[3] - RealTime()
			PLUGIN.Enabled = decoded[4]
			evolve.MapCycle = decoded[5]
		else
			PLUGIN.MapChangeAt = decoded[2]
			PLUGIN.TimeDiff = decoded[3] - RealTime()
			PLUGIN.Enabled = decoded[4]
		end
	end
	datastream.Hook( "evolve_cyclemaplist", PLUGIN.RecieveCycle )
	
	function PLUGIN:HUDPaint()
		if (self.Enabled) then
			local nextmap = evolve.MapCycle[1] or ""
			if (nextmap and self.MapChangeAt) then
				if (nextmap != "" and self.MapChangeAt != -1) then
					local w, h = 250, 40
					local x, y = ScrW() / 2 - w / 2, ScrH() - 44 - h / 2
					
					local t = math.max(self.MapChangeAt-RealTime()-(self.TimeDiff or 0),0)
					local hour = math.floor(t/3600)
					local minute = math.floor(t/60)-(60*hour)
					local second = math.floor(t - hour * 3600 - minute*60)
					
					local r = 0
					if (t < 300) then
						r = 127.5 + math.cos(RealTime() * 3) * 127.5
					end
					
					draw.RoundedBox( 4, x, y, w, h, Color(r, 0, 0, 200) )
					draw.SimpleText( "Next map: " .. nextmap, "ScoreboardText", x + 12, y + 6, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT )
					draw.SimpleText( "Time left: [" .. hour .. ":" .. minute .. ":" .. second .. "]", "ScoreboardText", x + 12, y + 18, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT )
				end
			end
		end
	end
end

evolve:RegisterPlugin( PLUGIN )