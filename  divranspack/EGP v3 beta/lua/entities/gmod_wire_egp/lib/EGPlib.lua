EGP = {}

--------------------------------------------------------
-- Objects
--------------------------------------------------------

EGP.Objects = {}
EGP.Objects.Names = {}

-- This object is not used. It's only a base
EGP.Objects.Base = {}
EGP.Objects.Base.ID = 0
EGP.Objects.Base.x = 0
EGP.Objects.Base.y = 0
EGP.Objects.Base.w = 0
EGP.Objects.Base.h = 0
EGP.Objects.Base.r = 255
EGP.Objects.Base.g = 255
EGP.Objects.Base.b = 255
EGP.Objects.Base.a = 255


function EGP:NewObject( Name )
	self.Objects[Name] = {}
	table.Inherit( self.Objects[Name], self.Objects.Base )
	local ID = table.Count(self.Objects)
	self.Objects[Name].ID = ID
	self.Objects.Names[Name] = ID 
	return self.Objects[Name]
end

function EGP:GetObjectByID( ID )
	for k,v in pairs( EGP.Objects ) do
		if (v.ID == ID) then return table.Copy( v ) end
	end
end

local folder = "entities/gmod_wire_egp/lib/objects/"
local files = file.FindInLua(folder.."*.lua")
for _,v in pairs( files ) do
	include(folder..v)
	if (SERVER) then AddCSLuaFile(folder..v) end
end

--------------------------------------------------------
-- e2function Helper functions
--------------------------------------------------------

function EGP:HasObject( Ent, index )
	if (!EGP:ValidEGP( Ent )) then return false end
	index = math.Round(math.Clamp(index or 1,1,255))
	for k,v in ipairs( Ent.RenderTable ) do
		if (v.index == index) then
			return true, k, v
		end
	end
	return false
end

function EGP:CreateObject( Ent, ObjID, Settings )
	if (!EGP:ValidEGP( Ent )) then return false end
	
	Settings.index = math.Round(math.Clamp(Settings.index or 1, 1, 255))
	
	local bool, k, v = self:HasObject( Ent, Settings.index )
	if (bool) then -- Already exists. Change settings:
		if (v.ID != ObjID) then -- Not the same kind of object, create new
			local Obj = {}
			Obj = EGP:GetObjectByID( ObjID )
			EGP:EditObject( Obj, Settings )
			Obj.index = Settings.index
			Ent.RenderTable[k] = Obj
			return true, Obj
		else
			return EGP:EditObject( v, Settings ), v
		end
	else -- Did not exist. Create:
		local Obj = EGP:GetObjectByID( ObjID )
		EGP:EditObject( Obj, Settings )
		Obj.index = Settings.index
		table.insert( Ent.RenderTable, Obj )
		return true, Obj
	end
end

function EGP:EditObject( Obj, Settings )
	local ret = false
	for k,v in pairs( Settings ) do
		if (Obj[k] and Obj[k] != v) then
			Obj[k] = v
			ret = true
		end
	end
	return ret
end

--------------------------------------------------------
-- Transmitting / Receiving helper functions
--------------------------------------------------------
function EGP:SendPosSize( obj )
	umsg.Float( obj.w )
	umsg.Float( obj.h )
	umsg.Float( obj.x )
	umsg.Float( obj.y )
end

function EGP:SendColor( obj )
	umsg.Char( obj.r - 128 )
	umsg.Char( obj.g - 128 )
	umsg.Char( obj.b - 128 )
	if (obj.a) then umsg.Char( obj.a - 128 ) end
end

function EGP:ReceivePosSize( tbl, um ) -- Used with SendPosSize (But can also be used in other cases)
	tbl.w = um:ReadFloat()
	tbl.h = um:ReadFloat()
	tbl.x = um:ReadFloat()
	tbl.y = um:ReadFloat()
end

function EGP:ReceiveColor( tbl, obj, um ) -- Used with SendColor
	tbl.r = um:ReadChar() + 128
	tbl.g = um:ReadChar() + 128
	tbl.b = um:ReadChar() + 128
	if (obj.a) then tbl.a = um:ReadChar() + 128 end
end

--------------------------------------------------------
-- Transmitting / Receiving
--------------------------------------------------------
function EGP:Transmit( Ent )
	if (#Ent.RenderTable == 0) then -- Remove all objects
		Ent.OldRenderTable = {}
		
		umsg.Start("EGP_Transmit_Data")
			umsg.Entity( Ent )
			umsg.Short( -1 )
		umsg.End()
	
	else
	
		local DataToSend = {}
		for k,v in ipairs( Ent.RenderTable ) do
			if (v.remove == true) then -- Remove object
				table.insert( DataToSend, { index = v.index, remove = true, index2 = k } )
			elseif (!Ent.OldRenderTable[k] or Ent.OldRenderTable[k] != v or Ent.OldRenderTable[k].ID != v.ID) then -- Check for differences
				table.insert( DataToSend, v )
			else
				for k2,v2 in pairs( v ) do
					if (!Ent.OldRenderTable[k][k2] or Ent.OldRenderTable[k][k2] != v2) then -- Check for differences
						table.insert( DataToSend, v )
					end
				end
			end
		end
		
		for k,v in ipairs( DataToSend ) do if (v.remove == true) then table.remove( Ent.RenderTable, v.index2 ) end end -- Remove object
	
		Ent.OldRenderTable = table.Copy( Ent.RenderTable )
		
		print("DataToSend:")
		PrintTable(DataToSend)
	
		umsg.Start( "EGP_Transmit_Data" )
			umsg.Entity( Ent )
			umsg.Short( #DataToSend )
			for k,v in ipairs( DataToSend ) do
				umsg.Short( v.index )
				if (v.remove == true) then -- Remove object
					umsg.Char( -128 )
				else
					umsg.Char( v.ID - 128 )
					v:Transmit()
				end
			end
		umsg.End()
	
	end
end

function EGP:Receive( um )
	local Ent = um:ReadEntity()
	local Nr = um:ReadShort()
	if (Nr == -1) then  -- Remove all objects
		Ent.RenderTable = {} 
	else
		for i=1,Nr do
			local index = um:ReadShort()
			local ID = um:ReadChar()
			if (ID == -128) then -- Remove object
				local bool, k, v = EGP:HasObject( Ent, index )
				if (bool) then
					table.remove( Ent.RenderTable, k )
				end
			else
				ID = ID + 128
				local obj = self:GetObjectByID( ID )
				local data = obj:Receive( um )
				
				local bool, k, v = EGP:HasObject( Ent, index )
				if (bool) then -- Object already exists.
					if (v.ID != ObjID) then -- Not the same kind of object, create new
						EGP:EditObject( obj, data )
						Ent.RenderTable[k] = obj
					else
						EGP:EditObject( v, data )
					end
				else -- Object does not exist. Create new
					EGP:EditObject( obj, data )
					obj.index = index
					table.insert( Ent.RenderTable, obj )
				end
			end
		end
	end
	
	if (Ent:GetClass() == "gmod_wire_egp") then
		Ent.GPU:RenderToGPU( function()
			render.Clear( 0, 0, 0, 0 )
			surface.SetDrawColor(0,0,0,255)
			surface.DrawRect(0,0,512,512)
			if (#Ent.RenderTable > 0) then
				for k,v in ipairs( Ent.RenderTable ) do 
					if (v.material and #v.material>0) then EGP:SetMaterial( v.material ) else EGP:SetMaterial() end
					v.Draw(v) 
				end
			end
		end)
	elseif (Ent:GetClass() == "gmod_wire_egp_emitter") then
		Ent.GPU:RenderToWorld( 200, 200, function()
			render.Clear( 0, 0, 0, 0 )
			surface.SetDrawColor(0,0,0,255)
			surface.DrawRect(0,0,512,512)
			for k,v in ipairs( EGP.HomeScreen ) do 
				if (v.material and #v.material>0) then EGP:SetMaterial( v.material ) else EGP:SetMaterial() end
				v.Draw(v) 
			end
		end, 250 )
	end
end
usermessage.Hook( "EGP_Transmit_Data", function(um) EGP:Receive( um ) end )

require("datastream")

if (SERVER) then

	-- TODO: Optimize this function
	function EGP:SpawnFunc( ply )
		timer.Simple(2,function(ply)
			if (ply and ply:IsValid()) then -- In case the player crashed
				local tbl = {}
				local en = ents.FindByClass("gmod_wire_egp")
				for k,v in pairs( en ) do
					if (v.RenderTable and #v.RenderTable>0) then
						local DataToSend = {}
						for k2,v2 in pairs( v.RenderTable ) do 
							if (type(v2) != "function") then 
								table.insert( DataToSend, v2 )
							end 
						end
						table.insert( tbl, { entid = v:EntIndex(), Settings = DataToSend } )
					end
				end
				if (tbl and #tbl>0) then
					print("DATA TO SEND:")
					PrintTable(tbl)
					datastream.StreamToClients( ply,"EGP_PlayerSpawn_Transmit", tbl )
				end
			end
		end,ply)
	end
	hook.Add("PlayerInitialSpawn","EGP_SpawnFunc",function(ply) EGP:SpawnFunc( ply ) end )

else

	function EGP:ReceiveSpawn( decoded )
		for k,v in ipairs( decoded ) do
			local Ent = Entity(v.entid)
			if (Ent and Ent:IsValid()) then
				for k2,v2 in pairs( v.Settings ) do
					local Obj = EGP:GetObjectByID(v2.ID)
					EGP:EditObject( Obj, v2 )
					Obj.index = v2.index
					table.insert( Ent.RenderTable, Obj )
				end
				Ent.GPU:RenderToGPU( function()
					render.Clear( 0, 0, 0, 0 )
					surface.SetDrawColor(0,0,0,255)
					surface.DrawRect(0,0,512,512)
					if (#Ent.RenderTable > 0) then
						for k,v in ipairs( Ent.RenderTable ) do 
							if (v.material and #v.material>0) then EGP:SetMaterial( v.material ) else EGP:SetMaterial() end
							v.Draw(v) 
						end
					end
				end)
			end
		end
	end
	datastream.Hook("EGP_PlayerSpawn_Transmit", function(_,_,_,decoded) EGP:ReceiveSpawn( decoded ) end )

end

--------------------------------------------------------
-- Useful functions
--------------------------------------------------------

-- Valid fonts table
EGP.ValidFonts = {}
EGP.ValidFonts[0] = "WireGPU_ConsoleFont"
EGP.ValidFonts[1] = "Coolvetica"
EGP.ValidFonts[2] = "Arial"
EGP.ValidFonts[3] = "Lucida Console"
EGP.ValidFonts[4] = "Trebuchet"
EGP.ValidFonts[5] = "Courier New"
EGP.ValidFonts[6] = "Times New Roman"
EGP.ValidFonts[7] = "ChatFont"
EGP.ValidFonts[8] = "Marlett"

function EGP:ValidEGP( Ent )
	return (Ent and Ent:IsValid() and (Ent:GetClass() == "gmod_wire_egp" or Ent:GetClass() == "gmod_wire_egp_emitter"))
end

EGP.Materials = {}

function EGP:CacheMaterial( Mat )
	if (!Mat or #Mat == 0) then return end
	if (!self.Materials[Mat]) then
		local temp
		if (#file.Find("../materials/"..Mat..".*") > 0) then
			 temp = surface.GetTextureID(Mat)
		end
		self.Materials[Mat] = temp
	end
	return self.Materials[Mat]
end

function EGP:SetMaterial( Mat )
	if (!Mat) then
		surface.SetTexture()
	else
		surface.SetTexture( self:CacheMaterial( Mat ) )
	end
end

--------------------------------------------------------
--  Homescreen
--------------------------------------------------------

EGP.HomeScreen = {}

-- Create table
local tbl = {
	{ ID = EGP.Objects.Names["Box"], Settings = { x = 78, y = 78, h = 356, w = 356, material = "expression 2/cog", r = 255, g = 0, b = 0, a = 255 } },
	{ ID = EGP.Objects.Names["Text"], Settings = {x = 256, y = 228, text = "EGP 3", fontid = 0, align = 1, size = 50, r = 135, g = 135, b = 135, a = 255 } }
}
	
	
--[[ Old homescreen (EGP v2 home screen design contest winner)
local tbl = {
	{ ID = EGP.Objects.Names["BoxAngle"], Settings = {		x = 256, y = 256, w = 362, h = 362, material = "", angle = 135, 					r = 75,  g = 75, b = 200, a = 255 } },
	{ ID = EGP.Objects.Names["BoxAngle"], Settings = {		x = 256, y = 256, w = 340, h = 340, material = "", angle = 135, 					r = 10,  g = 10, b = 10,  a = 255 } },
	{ ID = EGP.Objects.Names["Text"], Settings = {			x = 229, y = 28,  text =   "E", 	size = 100, fontid = 4, 						r = 200, g = 50, b = 50,  a = 255 } },
	{ ID = EGP.Objects.Names["Text"], Settings = {	 		x = 50,  y = 200, text =   "G", 	size = 100, fontid = 4, 						r = 200, g = 50, b = 50,  a = 255 } },
	{ ID = EGP.Objects.Names["Text"], Settings = {			x = 400, y = 200, text =   "P", 	size = 100, fontid = 4, 						r = 200, g = 50, b = 50,  a = 255 } },
	{ ID = EGP.Objects.Names["Text"], Settings = {			x = 228, y = 375, text =   "2", 	size = 100, fontid = 4, 						r = 200, g = 50, b = 50,  a = 255 } },
	{ ID = EGP.Objects.Names["BoxAngle"], Settings = {		x = 256, y = 256, w = 256, h = 256, material = "expression 2/cog", angle = 45, 		r = 255, g = 50, b = 50,  a = 255 } },
	{ ID = EGP.Objects.Names["Box"], Settings = {			x = 128, y = 241, w = 256, h = 30, 	material = "", 									r = 10,  g = 10, b = 10,  a = 255 } },
	{ ID = EGP.Objects.Names["Box"], Settings = {			x = 241, y = 128, w = 30,  h = 256, material = "", 									r = 10,  g = 10, b = 10,  a = 255 } },
	{ ID = EGP.Objects.Names["Circle"], Settings = {		x = 256, y = 256, w = 70,  h = 70, 	material = "", 									r = 255, g = 50, b = 50,  a = 255 } },
	{ ID = EGP.Objects.Names["BoxAngle"], Settings = {	 	x = 256, y = 256, w = 362, h = 362, material = "gui/center_gradient", angle = 135, 	r = 75,  g = 75, b = 200, a = 75  } },
	{ ID = EGP.Objects.Names["BoxAngle"], Settings = {		x = 256, y = 256, w = 362, h = 362, material = "gui/center_gradient", angle = 135, 	r = 75,  g = 75, b = 200, a = 75  } }
}
]]

-- Convert table
for k,v in pairs( tbl ) do
	local obj = EGP:GetObjectByID( v.ID )
	obj.index = k
	for k2,v2 in pairs( v.Settings ) do
		if (obj[k2]) then obj[k2] = v2 end
	end
	table.insert( EGP.HomeScreen, obj )
end