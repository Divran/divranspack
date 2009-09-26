-------------------------------------------------------------------------------------------------------------------------
--	Team Colors
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = { }
PLUGIN.Title = "Team Colors"
PLUGIN.Description = "Gives the teams colors."
PLUGIN.Author = "Overv & Divran"
PLUGIN.ChatCommand = nil
PLUGIN.Usage = nil


if SERVER then
	-- Default team colors
	PLUGIN.Teams = {}
	PLUGIN.Teams[1] = {Name="Owner",Color=Vector(50,50,50)} -- Almost Black
	PLUGIN.Teams[2] = {Name="Super Admin",Color=Vector(255,200,0)} -- Gold
	PLUGIN.Teams[3] = {Name="Admin",Color=Vector(200,80,80)} -- Dark Red
	PLUGIN.Teams[4] = {Name="Respected",Color=Vector(100,200,100)} -- Dark Green
	PLUGIN.Teams[5] = {Name="Guest",Color=Vector(100,100,255)} -- Dark Blue

if !glon then require"glon" end


function PLUGIN:EV_PlayerRankChanged(ply)
	local TeamName = ply:EV_GetRank()
	if 		(TeamName == "owner") then 		ply:SetTeam(1)
	elseif 	(TeamName == "superadmin") then ply:SetTeam(2)
	elseif 	(TeamName == "admin") then 		ply:SetTeam(3)
	elseif 	(TeamName == "respected") then 	ply:SetTeam(4)
	else									ply:SetTeam(5) end
end

function PLUGIN:PlayerInitialSpawn(ply)
	self:load()
	self:TeamSetup( self.Teams )
	self:SendUsermessage( self.Teams )
	local TeamName = ply:EV_GetRank()
	if 		(TeamName == "owner") then 		ply:SetTeam(1)
	elseif 	(TeamName == "superadmin") then ply:SetTeam(2)
	elseif 	(TeamName == "admin") then 		ply:SetTeam(3)
	elseif 	(TeamName == "respected") then 	ply:SetTeam(4)
	else									ply:SetTeam(5) end
end

function PLUGIN:load()
	if (file.Exists("evolve/teamcolors.txt")) then
		self.Teams = glon.decode(file.Read("evolve/teamcolors.txt"))
	else
		local GlonCode = glon.encode(self.Teams)
		file.Write("evolve/teamcolors.txt",GlonCode)
		print("Evolve Team Colors file didn't exist! Created.")
	end
end

function PLUGIN:TeamSetup( Table )
	for Nr, Tbl in pairs( Table ) do
		Col = Tbl.Color
		team.SetUp( Nr, Tbl.Name, Color(Col.x, Col.y, Col.z, 255))
	end
end

function PLUGIN:SendUsermessage(Table)
	local rp = RecipientFilter()
	rp:AddAllPlayers()
	umsg.Start("EVColors",rp)
		umsg.Long( table.Count(Table) )
		for k, v in pairs(Table) do
			umsg.String( v.Name )
			umsg.Vector( v.Color )
		end
	umsg.End()
end

end -- "if SERVER" end

if CLIENT then

-- Recieve Usermessage
usermessage.Hook( "EVColors", function(um)
	local Nr = um:ReadLong()
	print("RECIEVED NR: " .. Nr )
	for I=1, Nr do
		local Str = um:ReadString()
		print("RECIEVED STRING: " .. Str )
		local Col = um:ReadVector()
		print("RECIEVED VECTOR: " .. tostring(Col))
		team.SetUp(I, Str, Color( Col.x, Col.y, Col.z, 255 ) )
	end
end )

end -- "if CLIENT" end

evolve:registerPlugin( PLUGIN )