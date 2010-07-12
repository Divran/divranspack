EGP = {}
local EGP = EGP

EGP.ConVars = {}
EGP.ConVars.MaxObjects = CreateConVar( "wire_egp_max_objects", 300, { FCVAR_NOTIFY, FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE } )
EGP.ConVars.MaxPerInterval = CreateConVar( "wire_egp_max_objects_per_interval", 30, { FCVAR_NOTIFY, FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE }  )
EGP.ConVars.Interval = CreateConVar( "wire_egp_interval", 1, { FCVAR_NOTIFY, FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE }  )

EGP.ConVars.AllowEmitter = CreateConVar( "wire_egp_allow_emitter", 1, { FCVAR_NOTIFY, FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE  }  )
EGP.ConVars.AllowHUD = CreateConVar( "wire_egp_allow_hud", 1, { FCVAR_NOTIFY, FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE  }  )
EGP.ConVars.AllowScreen = CreateConVar( "wire_egp_allow_screen", 1, { FCVAR_NOTIFY, FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE  }  )

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
EGP.Objects.Base.material = ""
EGP.Objects.Base.parent = 0
EGP.Objects.Base.Transmit = function( self )
	EGP:SendPosSize( self )
	EGP:SendColor( self )
	EGP:SendMaterial( self )
	EGP.umsg.Short( self.parent )
end
EGP.Objects.Base.Receive = function( self, um )
	local tbl = {}
	EGP:ReceivePosSize( tbl, um )
	EGP:ReceiveColor( tbl, self, um )
	EGP:ReceiveMaterial( tbl, um )
	tbl.parent = um:ReadShort()
	return tbl
end
EGP.Objects.Base.DataStreamInfo = function( self )
	return { x = self.x, y = self.y, w = self.w, h = self.h, r = self.r, g = self.g, b = self.b, a = self.a }
end

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
----------------------------
-- IsAllowed check
----------------------------
function EGP:IsAllowed( E2, Ent )
	if (!EGP:ValidEGP( Ent )) then return end
	if (E2 and E2.entity and E2.entity:IsValid()) then
		if (!E2Lib.isOwner(E2,Ent)) then
			return E2Lib.isFriend(E2.player,E2Lib.getOwner(Ent))
		else
			return true
		end
	end
	return false
end

----------------------------
-- Object existance check
----------------------------
function EGP:HasObject( Ent, index )
	if (!EGP:ValidEGP( Ent )) then return false end
	index = math.Round(math.Clamp(index or 1, 1, self.ConVars.MaxObjects:GetInt()))
	if (!Ent.RenderTable or #Ent.RenderTable == 0) then return false end
	for k,v in ipairs( Ent.RenderTable ) do
		if (v.index == index) then
			return true, k, v
		end
	end
	return false
end

----------------------------
-- Object order changing
----------------------------
function EGP:SetOrder( Ent, from, to )
	if (!Ent.RenderTable or #Ent.RenderTable == 0) then return false end
	if (Ent.RenderTable[from]) then
		to = math.Clamp(to,1,#Ent.RenderTable)
		local temp = Ent.RenderTable[from]
		table.remove( Ent.RenderTable, from )
		table.insert( Ent.RenderTable, to, temp )
		if (SERVER) then Ent.RenderTable[to].ChangeOrder = {from,to} end
		return true
	end
	return false
end

----------------------------
-- Object per second allowance checks
----------------------------
EGP.IntervalCheck = {}

function EGP:PlayerDisconnect( ply ) EGP.IntervalCheck[ply] = nil end
hook.Add("PlayerDisconnect","EGP_PlayerDisconnect",function( ply ) EGP:PlayerDisconnect( ply ) end)


function EGP:CheckInterval( ply, bool )
	if (!self.IntervalCheck[ply]) then self.IntervalCheck[ply] = { objects = 0, time = 0 } end
	
	local interval = self.ConVars.Interval:GetFloat()
	local maxcount = self.ConVars.MaxPerInterval:GetInt()
	
	local tbl = self.IntervalCheck[ply]
	
	if (bool) then
		return (tbl.objects < maxcount)
	else
	
		if (tbl.time < CurTime()) then
			tbl.objects = 1
			tbl.time = CurTime() + interval
		else
			tbl.objects = tbl.objects + 1
			if (tbl.objects >= maxcount) then
				return false
			end
		end
		
	end
	
	return true
end
----------------------------
-- Create / edit objects
----------------------------

function EGP:CreateObject( Ent, ObjID, Settings, ply )
	if (!self:ValidEGP( Ent )) then return false end
	
	if (SERVER) then
		if (ply and ply:IsValid() and ply:IsPlayer()) then
			if (!self:CheckInterval( ply )) then
				return false
			end
		end
	end

	Settings.index = math.Round(math.Clamp(Settings.index or 1, 1, self.ConVars.MaxObjects:GetInt()))
	
	local bool, k, v = self:HasObject( Ent, Settings.index )
	if (bool) then -- Already exists. Change settings:
		if (v.ID != ObjID) then -- Not the same kind of object, create new
			local Obj = {}
			Obj = self:GetObjectByID( ObjID )
			self:EditObject( Obj, Settings )
			Obj.index = Settings.index
			Ent.RenderTable[k] = Obj
			return true, Obj
		else
			return self:EditObject( v, Settings ), v
		end
	else -- Did not exist. Create:
		local Obj = self:GetObjectByID( ObjID )
		self:EditObject( Obj, Settings )
		Obj.index = Settings.index
		table.insert( Ent.RenderTable, Obj )
		return true, Obj
	end
end

function EGP:EditObject( Obj, Settings, ply )
	if (SERVER) then
		if (ply and ply:IsValid() and ply:IsPlayer()) then
			if (!self:CheckInterval( ply )) then
				return false
			end
		end
	end
	local ret = false
	for k,v in pairs( Settings ) do
		if (Obj[k] and Obj[k] != v) then
			Obj[k] = v
			ret = true
		end
	end
	return ret
end

----------------------------
-- Parenting functions
----------------------------
function EGP:GetGlobalPos( Ent, index )
	local bool, k, v = self:HasObject( Ent, index )
	if (bool) then
		if (v.parent and v.parent != 0) then
			local x, y, ang = self:GetGlobalPos( Ent, v.parent )
			local vec, ang = LocalToWorld( Vector( v.x or 0, v.y or 0, 0 ), Angle( 0, v.angle or 0, 0 ), Vector( x or 0, y or 0, 0 ), Angle( 0, -ang or 0, 0 ) )
			return vec.x, vec.y, ang.y
		end
		return v.x, v.y, v.angle
	end
end

--[[ I have not yet found a use for this, but I'll keep it just in case
function EGP:GetLocalPos( Ent, index )
	local bool, k, v = self:HasObject( Ent, index )
	if (bool) then
		if (v.parent and v.parent != 0) then
			local x, y, ang = self:GetLocalPos( Ent, v.parent )
			local vec, ang = WorldToLocal( Vector( v.x or 0, v.y or 0, 0 ), Angle( 0, v.angle or 0, 0 ), Vector( x or 0, y or 0, 0 ), Angle( 0, -ang or 0, 0 ) )
			return vec.x, vec.y, ang.y
		end
		return v.x, v.y, v.angle
	end
end
]]

function EGP:SetParent( Ent, index, parentindex )
	local bool, k, v = self:HasObject( Ent, index )
	if (bool) then
		local bool2, k2, v2 = self:HasObject( Ent, parentindex )
		if (bool2) then
			if (self:EditObject( v, { parent = parentindex }, Ent:GetPlayer() )) then return true end
		end
	end
end

function EGP:UnParent( Ent, index )
	local bool, k, v = self:HasObject( Ent, index )
	if (bool) then
		local x, y = self:GetGlobalPos( Ent, index )
		if (self:EditObject( v, { x = x, y = y, parent = 0 }, Ent:GetPlayer() )) then return true end
	end
end

--------------------------------------------------------
-- Transmitting / Receiving helper functions
--------------------------------------------------------
-----------------------
-- Material
-----------------------
EGP.SavedMaterials = {}
function EGP:GetSavedMaterial( Mat )
	if (!table.HasValue( self.SavedMaterials, Mat )) then
		self:SaveMaterial( Mat )
		return "?" .. Mat
	else
		local str
		for k,v in ipairs( self.SavedMaterials ) do
			if (v == Mat) then
				str = k
				break
			end
		end
		return "." .. str
	end
end

function EGP:SaveMaterial( Mat )
	if (!Mat or #Mat == 0) then return end
	if (!table.HasValue( self.SavedMaterials, Mat )) then
		table.insert( self.SavedMaterials, Mat )
	end
end

function EGP:SendMaterial( obj ) -- ALWAYS use this when sending material
	local str
	
	-- "!" = entity
	-- "?" = string
	-- "." = number
	
	if (type(obj.material) == "Entity") then
		if (!obj.material:IsValid()) then 
			str = ""
		else
			str = "!" .. obj.material:EntIndex()
		end
	elseif (type(obj.material) == "string") then
		if (obj.material == "") then
			str = ""
		else
			str = self:GetSavedMaterial( obj.material )
		end
	end
	EGP.umsg.String( str )
end

function EGP:ReceiveMaterial( tbl, um ) -- ALWAYS use this when receiving material
	local mat = um:ReadString()
	local first = mat:Left(1)
	if (first == "!" or first == "?" or first == ".") then
		mat = mat:Right(-2)
		if (first == "!") then
			mat = Entity(tonumber(mat))
		elseif (first == ".") then
			for k,v in pairs( self.SavedMaterials ) do
				if (mat == tostring(k)) then
					mat = v
					break
				end
			end
		elseif (first == "?") then
			self:SaveMaterial( mat )
		end
	end
	tbl.material = mat
end

-----------------------
-- Other
-----------------------
function EGP:SendPosSize( obj )
	EGP.umsg.Float( obj.w )
	EGP.umsg.Float( obj.h )
	EGP.umsg.Float( obj.x )
	EGP.umsg.Float( obj.y )
end

function EGP:SendColor( obj )
	EGP.umsg.Char( obj.r - 128 )
	EGP.umsg.Char( obj.g - 128 )
	EGP.umsg.Char( obj.b - 128 )
	if (obj.a) then EGP.umsg.Char( obj.a - 128 ) end
end

function EGP:ReceivePosSize( tbl, um ) -- Used with SendPosSize
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
----------------------------
-- Custom umsg system
----------------------------
local CurrentCost = 0
--[[ Transmit Sizes:
	Angle = 12
	Bool = 1
	Char = 1
	Entity = 2
	Float = 4
	Long = 4
	Short = 2
	String = string length
	Vector = 12
	VectorNormal = 12
]]
	
EGP.umsg = {}
-- Start
function EGP.umsg.Start( name, repicient )
	CurrentCost = 0
	umsg.Start( name, repicient )
end
-- End
function EGP.umsg.End()
	CurrentCost = 0
	umsg.End()
end
-- Angle
function EGP.umsg.Angle( data )
	CurrentCost = CurrentCost + 12
	umsg.Angle( data )
end
-- Boolean
function EGP.umsg.Bool( data )
	CurrentCost = CurrentCost + 1
	umsg.Bool( data )
end
-- Char
function EGP.umsg.Char( data )
	CurrentCost = CurrentCost + 1
	umsg.Char( data )
end
-- Entity
function EGP.umsg.Entity( data )
	CurrentCost = CurrentCost + 2
	umsg.Entity( data )
end
-- Float
function EGP.umsg.Float( data )
	CurrentCost = CurrentCost + 4
	umsg.Float( data )
end
-- Long
function EGP.umsg.Long( data )
	CurrentCost = CurrentCost + 4
	umsg.Long( data )
end
-- Short
function EGP.umsg.Short( data )
	CurrentCost = CurrentCost + 2
	umsg.Short( data )
end
-- String
function EGP.umsg.String( data )
	CurrentCost = CurrentCost + #data
	umsg.String( data )
end
-- Vector
function EGP.umsg.Vector( data )
	CurrentCost = CurrentCost + 12
	umsg.Vector( data )
end
-- VectorNormal
function EGP.umsg.VectorNormal( data )
	CurrentCost = CurrentCost + 12
	umsg.VectorNormal( data )
end

----------------------------
-- Transmit functions
----------------------------

function EGP:SendQueue( Ent, Queue )
	if (CurrentCost != 0) then 
		ErrorNoHalt("[EGP] Umsg error. Another umsg is already sending!")
		return
	end
	local Done = 0
	EGP.umsg.Start( "EGP_Transmit_Data" )
		EGP.umsg.Entity( Ent )
		EGP.umsg.Short( #Queue )
		for k,v in ipairs( Queue ) do
			EGP.umsg.Short( v.index )
			
			if (v.remove == true) then -- Remove object
				EGP.umsg.Char( -128 )
			else
				EGP.umsg.Char( v.ID - 128 )
				
				if (v.ChangeOrder) then
					-- Change order
					EGP.umsg.Short( v.ChangeOrder[1] )
					EGP.umsg.Short( v.ChangeOrder[2] )
				else
					EGP.umsg.Short( 0 )
				end
				
				v:Transmit()
			end
			
			Done = Done + 1
			if (CurrentCost > 200) then -- Getting close to the max size! Start over!
				if (Done == 1 and CurrentCost > 255) then -- The object was too big
					ErrorNoHalt("[EGP] Umsg error. An object was too big to send!")
					table.remove( Queue, 1 )
					EGP.umsg.End()
					return
				end
				EGP.umsg.End()
				for i=1,Done do table.remove( Queue, 1 ) end
				self:SendQueue( Ent, Queue )
				return
			end
		end
	EGP.umsg.End()
end

function EGP:Transmit( Ent, E2 )
	if (#Ent.RenderTable == 0 and #Ent.OldRenderTable > 0) then -- Remove all objects
		Ent.OldRenderTable = {}
		
		umsg.Start("EGP_Transmit_Data")
			umsg.Entity( Ent )
			umsg.Short( -1 )
		umsg.End()
	
	else
	
		local DataToSend = {}
		for k,v in ipairs( Ent.RenderTable ) do
			if (!Ent.OldRenderTable[k] or Ent.OldRenderTable[k] != v or Ent.OldRenderTable[k].ID != v.ID) then -- Check for differences
				table.insert( DataToSend, v )
			else
				for k2,v2 in pairs( v ) do
					if (!Ent.OldRenderTable[k][k2] or Ent.OldRenderTable[k][k2] != v2) then -- Check for differences
						table.insert( DataToSend, v )
					end
				end
			end
		end
		
		-- Check if any object was removed
		for k,v in ipairs( Ent.OldRenderTable ) do
			if (!Ent.RenderTable[k]) then
				table.insert( DataToSend, { index = v.index, remove = true} )
			end
		end
		
		if (E2 and E2.entity and E2.entity:IsValid()) then
			E2.prf = E2.prf + #DataToSend * 150
		end
		
		self:SendQueue( Ent, DataToSend )
		
		for k,v in ipairs( Ent.RenderTable ) do
			if (v.ChangeOrder) then v.ChangeOrder = nil end
		end
		
		Ent.OldRenderTable = table.Copy( Ent.RenderTable )
		
		if (Ent.EGP_FrameSave != nil) then
			if (Ent.RenderTable and #Ent.RenderTable > 0) then
				local ply = Ent.EGP_FrameSave.ply
				local index = Ent.EGP_FrameSave.index
				umsg.Start("EGP_SaveFrame")
					umsg.Entity( ply )
					umsg.Entity( Ent )
					umsg.String( index )
				umsg.End()

				if (!EGP.Frames[ply]) then EGP.Frames[ply] = {} end
				EGP.Frames[ply][index] = Ent.RenderTable
			end
			
			Ent.EGP_FrameSave = nil
		end
		if (Ent.EGP_FrameLoad != nil) then
			local ply = Ent.EGP_FrameLoad.ply
			local index = Ent.EGP_FrameLoad.index
			if (!EGP.Frames[ply]) then EGP.Frames[ply] = {} end
			local frame = EGP.Frames[ply][index]
			if (frame) then
				umsg.Start("EGP_LoadFrame")
					umsg.Entity( ply )
					umsg.Entity( Ent )
					umsg.String( index )
				umsg.End()
				Ent.RenderTable = frame
				Ent.OldRenderTable = frame
			end
			
			Ent.EGP_FrameLoad = nil
		end
	end
end

function EGP:Receive( um )

	
	local Ent = um:ReadEntity()
	local Nr = um:ReadShort() -- Estimated amount
	
	if (Nr == -1) then  -- Remove all objects
		Ent.RenderTable = {} 
	else
		for i=1,Nr do
			local index = um:ReadShort()
			local ID = um:ReadChar()
			if (ID == -128) then -- Remove object
				local bool, k, v = EGP:HasObject( Ent, index )
				if (bool) then
					if (v.OnRemove) then v:OnRemove() end
					table.remove( Ent.RenderTable, k )
				end
			else
			
				-- Change Order
				local ChangeOrder_From = um:ReadShort()
				local ChangeOrder_To
				if (ChangeOrder_From != 0) then
					ChangeOrder_To = um:ReadShort()
				end
				
				if (index == 0) then break end -- In case the umsg had to abort early
				ID = ID + 128
				local bool, k, v = self:HasObject( Ent, index )
				if (bool) then -- Object already exists
					if (v.ID != ID) then -- Not the same kind of object, create new
						if (v.OnRemove) then v:OnRemove() end
						local Obj = self:GetObjectByID( ID )
						local data = Obj:Receive( um )
						self:EditObject( Obj, data )
						Obj.index = index
						Ent.RenderTable[k] = Obj
						if (Obj.OnCreate) then Obj:OnCreate() end
					else -- Edit
						self:EditObject( v, v:Receive( um ) )
					end
				else -- Object does not exist. Create new
					local Obj = self:GetObjectByID( ID )
					self:EditObject( Obj, Obj:Receive( um ) )
					Obj.index = index
					if (Obj.OnCreate) then Obj:OnCreate() end
					table.insert( Ent.RenderTable, Obj )
				end
				
				-- Change Order
				if (ChangeOrder_From and ChangeOrder_To) then
					local b = self:SetOrder( Ent, ChangeOrder_From, ChangeOrder_To )
				end
			end
		end
	end
	
	if (Ent.EGP_Update) then -- this..
		Ent:EGP_Update()
	else
		 -- ..and this is because it bugs on dupe (EGP_Update does not exist at first)
		timer.Simple(1,function(Ent) 
			if (Ent and Ent:IsValid() and Ent.EGP_Update) then 
				Ent:EGP_Update() 
			end 
		end,Ent)
	end
end
usermessage.Hook( "EGP_Transmit_Data", function(um) EGP:Receive( um ) end )

require("datastream")

if (SERVER) then

	function EGP:SpawnFunc( ply )
		timer.Simple(2,function(ply)
			if (ply and ply:IsValid()) then -- In case the player crashed
				local tbl = {}
				local en = ents.FindByClass("gmod_wire_egp")
				table.Merge( en, ents.FindByClass("gmod_wire_egp_hud") )
				table.Merge( en, ents.FindByClass("gmod_wire_egp_emitter") )
				for k,v in pairs( en ) do
					if (v.RenderTable and #v.RenderTable>0) then
						local DataToSend = {}
						for k2,v2 in pairs( v.RenderTable ) do 
							table.insert( DataToSend, { ID = v2.ID, index = v2.index, Settings = v2:DataStreamInfo() } )
						end
						table.insert( tbl, { entid = v:EntIndex(), Objects = DataToSend } )
					end
				end
				if (tbl and #tbl>0) then
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
				for k2,v2 in pairs( v.Objects ) do
					local Obj = EGP:GetObjectByID(v2.ID)
					EGP:EditObject( Obj, v2.Settings )
					Obj.index = v2.index
					table.insert( Ent.RenderTable, Obj )
				end
				Ent:GPU_Update()
			end
		end
	end
	datastream.Hook("EGP_PlayerSpawn_Transmit", function(_,_,_,decoded) EGP:ReceiveSpawn( decoded ) end )

end

--------------------------------------------------------
-- Useful functions
--------------------------------------------------------

-- Valid fonts table
EGP.ValidFonts_Lookup = {}
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
if (CLIENT) then
	local new = {}
	for k,v in ipairs( EGP.ValidFonts ) do
		local font = "WireEGP_18_"..k
		surface.CreateFont(v,18,800,true,false,font)
		EGP.ValidFonts_Lookup[font] = true
		table.insert( new, font )
	end
	for k,v in ipairs( new ) do
		table.insert( EGP.ValidFonts, v )
	end
end

function EGP:ValidEGP( Ent )
	return (Ent and Ent:IsValid() and (Ent:GetClass() == "gmod_wire_egp" or Ent:GetClass() == "gmod_wire_egp_hud" or Ent:GetClass() == "gmod_wire_egp_emitter"))
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
	elseif (type(Mat) == "string") then
		surface.SetTexture( self:CacheMaterial( Mat ) )
 	elseif (type(Mat) == "Entity") then
		if (!Mat:IsValid() or !Mat.GPU or !Mat.GPU.RT) then return end
		local OldTex = WireGPU_matScreen:GetMaterialTexture("$basetexture")
		WireGPU_matScreen:SetMaterialTexture("$basetexture", Mat.GPU.RT)
		surface.SetTexture(WireGPU_texScreen)
		return OldTex
 	end
 end
 
function EGP:FixMaterial( OldTex )
	if (!OldTex) then return end
	WireGPU_matScreen:SetMaterialTexture("$basetexture", OldTex)
end

--[[
if (CLIENT) then
	EGP.FakeMat = Material("egp_ignore_this_error")
	EGP.FakeTex = surface.GetTextureID("egp_ignore_this_error")
end

function EGP:SetMaterial( Mat )
	if (!Mat) then
		surface.SetTexture()
	elseif (type(Mat) == "string") then
		surface.SetTexture( self:CacheMaterial( Mat ) )
 	elseif (type(Mat) == "Entity") then
		if (!Mat:IsValid() or !Mat.GPU or !Mat.GPU.RT) then return end
		local OldTex = EGP.FakeMat:GetMaterialTexture("$basetexture")
		EGP.FakeMat:SetMaterialTexture("$basetexture", Mat.GPU.RT)
		surface.SetTexture(EGP.FakeTex)
		return OldTex
 	end
 end
 
function EGP:FixMaterial( OldTex )
	if (!OldTex) then return end
	EGP.FakeMat:SetMaterialTexture("$basetexture", OldTex)
end
]]
--------------------------------------------------------
--  Frame Saving & Loading
--------------------------------------------------------
EGP.Frames = {}

function EGP:SaveFrame( ply, Ent, index )
	if (!EGP.Frames[ply]) then EGP.Frames[ply] = {} end
	if (SERVER) then
		if (!self:CheckInterval( ply )) then return end
		Ent.EGP_FrameSave = { ply = ply, index = index }
	else	
		EGP.Frames[ply][index] = Ent.RenderTable
	end
end

function EGP:LoadFrame( ply, Ent, index )
	if (!EGP.Frames[ply]) then EGP.Frames[ply] = {} return end
	if (SERVER) then
		if (!self:CheckInterval( ply )) then return end
		Ent.EGP_FrameLoad = { ply = ply, index = index }
	else
		local frame = EGP.Frames[ply][index]
		if (!frame) then return end
		Ent.RenderTable = frame
		Ent:EGP_Update()
	end
end

if (CLIENT) then
	usermessage.Hook( "EGP_SaveFrame",function( um )
		local ply = um:ReadEntity()
		local ent = um:ReadEntity()
		local index = um:ReadString()
		if (!ply or !ply:IsValid()) then return end
		if (!ent or !ent:IsValid()) then return end
		if (!index or index == "") then return end
		EGP:SaveFrame( ply, ent, index )
	end)
	
	usermessage.Hook( "EGP_LoadFrame",function( um ) 
		local ply = um:ReadEntity()
		local ent = um:ReadEntity()
		local index = um:ReadString()
		if (!ply or !ply:IsValid()) then return end
		if (!ent or !ent:IsValid()) then return end
		if (!index or index == "") then return end
		EGP:LoadFrame( ply, ent, index )
	end)
end
--------------------------------------------------------
--  Homescreen
--------------------------------------------------------

EGP.HomeScreen = {}

-- Create table
local tbl = {
	{ ID = EGP.Objects.Names["Box"], Settings = { x = 256, y = 256, h = 356, w = 356, material = "expression 2/cog", r = 150, g = 34, b = 34, a = 255 } },
	{ ID = EGP.Objects.Names["Text"], Settings = {x = 256, y = 256, text = "EGP 3", fontid = 0, valign = 1, halign = 1, size = 50, r = 135, g = 135, b = 135, a = 255 } }
}
	
--[[ Old homescreen (EGP v2 home screen design contest winner)
local tbl = {
	{ ID = EGP.Objects.Names["Box"], Settings = {		x = 256, y = 256, w = 362, h = 362, material = "", angle = 135, 					r = 75,  g = 75, b = 200, a = 255 } },
	{ ID = EGP.Objects.Names["Box"], Settings = {		x = 256, y = 256, w = 340, h = 340, material = "", angle = 135, 					r = 10,  g = 10, b = 10,  a = 255 } },
	{ ID = EGP.Objects.Names["Text"], Settings = {			x = 229, y = 28,  text =   "E", 	size = 100, fontid = 4, 						r = 200, g = 50, b = 50,  a = 255 } },
	{ ID = EGP.Objects.Names["Text"], Settings = {	 		x = 50,  y = 200, text =   "G", 	size = 100, fontid = 4, 						r = 200, g = 50, b = 50,  a = 255 } },
	{ ID = EGP.Objects.Names["Text"], Settings = {			x = 400, y = 200, text =   "P", 	size = 100, fontid = 4, 						r = 200, g = 50, b = 50,  a = 255 } },
	{ ID = EGP.Objects.Names["Text"], Settings = {			x = 228, y = 375, text =   "2", 	size = 100, fontid = 4, 						r = 200, g = 50, b = 50,  a = 255 } },
	{ ID = EGP.Objects.Names["Box"], Settings = {		x = 256, y = 256, w = 256, h = 256, material = "expression 2/cog", angle = 45, 		r = 255, g = 50, b = 50,  a = 255 } },
	{ ID = EGP.Objects.Names["Box"], Settings = {			x = 128, y = 241, w = 256, h = 30, 	material = "", 									r = 10,  g = 10, b = 10,  a = 255 } },
	{ ID = EGP.Objects.Names["Box"], Settings = {			x = 241, y = 128, w = 30,  h = 256, material = "", 									r = 10,  g = 10, b = 10,  a = 255 } },
	{ ID = EGP.Objects.Names["Circle"], Settings = {		x = 256, y = 256, w = 70,  h = 70, 	material = "", 									r = 255, g = 50, b = 50,  a = 255 } },
	{ ID = EGP.Objects.Names["Box"], Settings = {	 	x = 256, y = 256, w = 362, h = 362, material = "gui/center_gradient", angle = 135, 	r = 75,  g = 75, b = 200, a = 75  } },
	{ ID = EGP.Objects.Names["Box"], Settings = {		x = 256, y = 256, w = 362, h = 362, material = "gui/center_gradient", angle = 135, 	r = 75,  g = 75, b = 200, a = 75  } }
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