include('shared.lua')
include("HUDDraw.lua")

--[[
function ENT:ChangePositions( Obj )
	local w, h = ScrW(), ScrH()
	if (Obj.x) then Obj.x = Obj.x/512*w end
	if (Obj.y) then Obj.y = Obj.y/512*h end
	if (Obj.x2) then Obj.x2 = Obj.x2/512*w end
	if (Obj.y2) then Obj.y2 = Obj.y2/512*h end
	if (Obj.x3) then Obj.x3 = Obj.x3/512*w end
	if (Obj.y3) then Obj.y3 = Obj.y3/512*h end
	if (Obj.vertices) then
		for k,v in ipairs( Obj.vertices ) do
			v.x = v.x/512*w
			v.y = v.y/512*h
		end
	end
	if (Obj.size and Obj.ID != EGP.Objects.Names["Text"]) then Obj.size = Obj.size/512*math.sqrt(w^2+h^2) end
	if (Obj.w) then Obj.w = Obj.w/512*w end
	if (Obj.h) then Obj.h = Obj.h/512*h end
end
]]

function ENT:Initialize()
	self.RenderTable = {}
	
	EGP:AddHUDEGP( self )
end

function ENT:EGP_Update() 
	for k,v in ipairs( self.RenderTable ) do
		if (v.parent and v.parent != 0) then
			local x, y, angle = EGP:GetGlobalPos( self, v.index )
			EGP:EditObject( v, { x = x, y = y, angle = angle } )
		end
	end
end

function ENT:OnRemove()
	EGP:RemoveHUDEGP( self )
end

function ENT:Draw()
	self.Entity.DrawEntityOutline = function() end
	self.Entity:DrawModel()
	Wire_Render(self.Entity)
end