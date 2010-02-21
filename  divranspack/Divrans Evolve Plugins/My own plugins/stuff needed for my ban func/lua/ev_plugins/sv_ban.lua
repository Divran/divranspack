/*-------------------------------------------------------------------------------------------------------------------------
	Ban a player
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Ban"
PLUGIN.Description = "Ban a player."
PLUGIN.Author = "Divran"
PLUGIN.ChatCommand = "ban"
PLUGIN.Usage = "<player> [time=5] [reason]"
evolve.Bans = {}

if (!datastream) then require("datastream") end

resource.AddFile("materials/gui/silkicons/lock.vmt")
resource.AddFile("materials/gui/silkicons/lock.vtf")

function PLUGIN:Call( ply, args )
	if (ply:EV_IsAdmin()) then
		-- Find players
		local pl = evolve:FindPlayer( args[1] )
		
		-- Check amount
		if ( #pl > 1 ) then
			evolve:Notify( ply, evolve.colors.white, "Did you mean ", evolve.colors.red, evolve:CreatePlayerList( pl, true ), evolve.colors.white, "?" )
		elseif ( #pl == 0 ) then
			local SteamID = args[1]
			local Time = math.abs( tonumber( args[2] ) or 5 )
			local Reason = table.concat( args, " ", 3 )
			if (#Reason == 0) then Reason = "No reason specified." end
			
			game.ConsoleCommand( "banid " .. Time .. " " .. SteamID .. "\n" )
			
			local endtime = os.time() + Time * 60
			if (Time == 0) then
				local endtime = 0
			end
			
			local name = evolve:GetProperty( evolve:UniqueIDByProperty( "SteamID", SteamID, true ) , "Nick", nil )
			print("NAME: " .. (name or "shit..."))
			
			evolve:AddBan( { name or "-Unknown-", SteamID, os.time(), endtime, Reason } )
			evolve:WriteBans()
			
			evolve:Notify( evolve.colors.red, ply:Nick(), evolve.colors.white, " banned the SteamID '", evolve.colors.blue, SteamID, evolve.colors.white, "' for " .. Time .. " minutes (" .. Reason .. ")." )
		else
			-- Remove that player's props
			for _, v in ipairs( ents.GetAll() ) do
				if ( v:EV_GetOwner() == pl[1] ) then v:Remove() end
			end
			
			-- Get vars
			local Time = math.abs( tonumber( args[2] ) or 5 )
			local Reason = table.concat( args, " ", 3 )
			local SteamID = pl[1]:SteamID()
			if (!SteamID or SteamID == "") then 
				evolve:Notify( evolve.colors.red, "Ban error. Target player has no SteamID!" ) 
				return 
			end
			if (#Reason == 0) then Reason = "No reason specified." end
			
			-- Ban the player
			game.ConsoleCommand( "banid " .. Time .. " " .. SteamID .. "\n" )
			
			local endtime = os.time() + Time * 60
			if (Time == 0) then
				local endtime = 0
			end
			
			-- Table syntax: { Ply,        SteamID,Start Time, End Time,Reason }
			evolve:AddBan( { pl[1]:Nick(), SteamID, os.time(), endtime, Reason } )
			evolve:WriteBans()
			
			if (Time == 0) then
				evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " banned ", evolve.colors.red, pl[1]:Nick(), evolve.colors.white, " permanently (" .. Reason .. ")." )
				pl[1]:Kick( "Permanently banned (" .. Reason .. ")" )
			else
				evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " banned ", evolve.colors.red, pl[1]:Nick(), evolve.colors.white, " for " .. Time.. " minutes (" .. Reason .. ")." )
				pl[1]:Kick( "Banned for " .. Time .. " minutes (" .. Reason .. ")" )
			end
		end
	else
		evolve:Notify( ply, evolve.colors.red, evolve.constants.notallowed )
	end
end

function PLUGIN:Menu( arg, players )
	if ( arg ) then
		RunConsoleCommand( "ev", "ban", players[1], arg )
	else
		return "Ban", evolve.category.administration, {
			{ "5 minutes", "5" },
			{ "10 minutes", "10" },
			{ "15 minutes", "15" },
			{ "30 minutes", "30" },
			{ "1 hour", "60" },
			{ "2 hours", "120" },
			{ "4 hours", "240" },
			{ "12 hours", "720" },
			{ "One day", "1440" },
			{ "Two days", "2880" },
			{ "One week", "10080" },
			{ "Two weeks", "20160" },
			{ "One month", "43200" },
			{ "One year", "525600" },
			{ "Permanently", "0" }
		}
	end
end

-- Check if the player is no longer banned
function PLUGIN:PlayerInitialSpawn( ply )
	if (!evolve:BanFileExists()) then return end
	for key, tbl in pairs( evolve.Bans or evolve:GetBans() ) do
		if (tbl[2] == ply:SteamID()) then
			if (os.time() < tbl[4] and tbl[4] != 0) then
				evolve:RemoveBan( tbl[2] )
				evolve:WriteBans()
			else
				game.ConsoleCommand( "banid " .. tbl[4] .. " " .. tbl[5] .. "\n" )
				ply:Kick("You're supposed to be banned! Stop hacking to get in. Ban time extended.")
				print("[EV] Banned " .. ply:Nick() .. " again. Reason: " .. tbl[5] .. ". Player was banned at " .. os.date( "%c", tbl[3] ) .. " for " .. tbl[4] .. " minutes. Time left is: " .. tbl[4] .. " minutes.")
			end
		end
	end
	
	-- is the player still here...?
	if (ply and ply:IsValid() and ply:IsPlayer()) then
		timer.Simple( 5, function() evolve:SendBans( ply ) end)
	end
end

-- Check if the file exists. If not, create it
function evolve:BanFileExists()
	if (!file.Exists("ev_bans.txt")) then
		file.Write("ev_bans.txt","")
		return false
	end
	return true
end

-- Write to the bans file
function evolve:WriteBans()
	if (self.Bans and #self.Bans > 0) then
		file.Write("ev_bans.txt", glon.encode( self.Bans ))
	else
		file.Write("ev_bans.txt", "")
	end
end

-- Find a ban
function evolve:FindBan( SteamID, Bool )
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

-- Add a ban to the table
function evolve:AddBan( Table )
	local key, FoundBan = self:FindBan( Table[2], false )
	if (!(key and FoundBan and #FoundBan > 0)) then
		table.insert( self.Bans, Table )
	else
		if (key) then
			self.Bans[key] = Table
		end
	end
	self:SendBans()
end

-- Remove a ban
function evolve:RemoveBan( SteamID )
	local key, FoundBan = self:FindBan( SteamID, false )
	if (key and FoundBan and #FoundBan > 0) then
		table.remove( self.Bans, key )
	end
	self:SendBans()
end

-- Get the bans in the file
function evolve:GetBans()
	if (!self:BanFileExists()) then return {} end
	local String = file.Read("ev_bans.txt")
	if (String and String != "") then
		return glon.decode( String )
	end
	return {}
end

-- Automatically reban all players at server start
local function Reban()
	evolve:BanFileExists()
	local temp = evolve:GetBans()
	if (temp and #temp > 0) then
		for key, tbl in pairs( temp ) do
			local timeleft = (tbl[4] - os.time()) / 60
			if (tbl[4] == 0) then
				timeleft = 0
			end
			if (os.time() < tbl[4] or tbl[4] != 0) then
				if (SERVER) then game.ConsoleCommand( "banid " .. timeleft .. " " .. tbl[2] .. "\n" ) end
				table.insert( evolve.Bans, tbl )
				print("[EV] Banned " .. tbl[1] .. " again. Reason: '" .. tbl[5] .. "'. Player was banned at " .. os.date( "%c", tbl[3] ) .. " for " .. (tbl[4]-tbl[4]) .. " minutes. Time left is: " .. math.Round(timeleft) .. " minutes.")
			else
				evolve:RemoveBan( tbl[2] )
				evolve:WriteBans()
				print("[EV] Player " .. tbl[1] .. " is no longer banned.")
			end
		end
	end
end
timer.Simple( 2, Reban )

function evolve:SendBans( ply )
	if (ply) then
		datastream.StreamToClients(ply, "evolve_sendbanlist", evolve.Bans )
	else
		datastream.StreamToClients(player.GetAll(), "evolve_sendbanlist", evolve.Bans )
	end
end

local function Resend( ply, cmd, args )
	if (ply:EV_IsAdmin()) then
		evolve:SendBans( ply )
	end
end
concommand.Add("ev_resendbanlist", Resend)

evolve:RegisterPlugin( PLUGIN )