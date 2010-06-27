include('shared.lua')

function ENT:Initialize()
	self.RenderTable = {}
	self.GPU = GPULib.WireGPU( self )
	
	self.GPU:RenderToGPU( function()
		render.Clear( 0, 0, 0, 0 )
		surface.SetDrawColor(0,0,0,255)
		surface.DrawRect(0,0,512,512)
		for k,v in ipairs( EGP.HomeScreen ) do 
			EGP:SetMaterial( v.material )
			v:Draw() 
		end
	end)
end

function ENT:EGP_Update()
	if (self.RenderTable) then
		self.GPU:RenderToGPU( function()
			render.Clear( 0, 0, 0, 0 )
			surface.SetDrawColor(0,0,0,255)
			surface.DrawRect(0,0,512,512)
			for k,v in ipairs( self.RenderTable ) do 
				if (v.parent and v.parent != 0) then
					local x, y, angle = EGP:GetGlobalPos( self, v.index )
					EGP:EditObject( v, { x = x, y = y, angle = angle } )
				end
				EGP:SetMaterial( v.material )
				v:Draw() 
			end
		end)
	end
end

function ENT:Draw()
	self.Entity.DrawEntityOutline = function() end
	self.Entity:DrawModel()
	Wire_Render(self.Entity)
	self.GPU:Render()
end

function ENT:OnRemove()
	self.GPU:Finalize()
end