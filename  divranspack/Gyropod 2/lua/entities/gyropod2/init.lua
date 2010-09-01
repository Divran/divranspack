AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

util.PrecacheSound( "ambient/atmosphere/outdoor2.wav" )
util.PrecacheSound( "ambient/atmosphere/indoor1.wav" )
util.PrecacheSound( "buttons/button1.wav" )
util.PrecacheSound( "buttons/button18.wav" )
util.PrecacheSound( "buttons/button6.wav" )
util.PrecacheSound( "buttons/combine_button3.wav" )
util.PrecacheSound( "buttons/combine_button2.wav" )
util.PrecacheSound( "buttons/lever7.wav" )

function ENT:Initialize()
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetMaterial( "spacebuild/SBLight5" )
	
	self.Inputs = WireLib.CreateInputs( self, { "Activate", 
												"Movement Force World [VECTOR]", 
												"Movement Force Local [VECTOR]",
												"Fly To Vector [VECTOR]", 
												"Aim To Vector [VECTOR]", 
												"Aim To Angle [ANGLE]", 
												"Angular Force [ANGLE]", 
												"Freeze", 
												"Level", 
												"Base Entity [ENTITY]" } )
	self.Outputs = WireLib.CreateOutputs( self, { 	"On", 
													"Frozen", 
													"MPH", 
													"KMH", 
													"Total Mass", 
													"Nr Of Props Linked", 
													"Props Linked [ARRAY]" } )
	
	self.phys = self:GetPhysicsObject()
	
	self.DirForce = Vector(0,0,0)
	self.DirMode = 0 -- 0 = Local, 1 = World, 2 = "Fly To Vector" force
	
	self.AimMode = 0 -- 0 = regular angle force, 1 = "Aim To Vector" force, 2 = "Aim To Angle" force
	self.AngForce = Angle(0,0,0)
	
	self.LevelOut = false
	
	self.Entities = {}
	self.AllEntities = {}
	self.NumOfEntities = 0
	self:GetConstrainedEntities()
	
	self.TotalMass = self.phys:GetMass()
	self.Activated = false
	
	self.Multipliers = { forward = 0, back = 0, right = 0, left = 0 }
	
	self.CheckConstrainedEntsTimer = 0
	
	self.On = false
	self.Frozen = false
	self.Gravity = false
end

------------------------------------------------------------------------
-- Wire Inputs
------------------------------------------------------------------------

function ENT:TriggerInput( name, value )
	if (name == "Activate") then
		if (value != 0) then
			self:TurnOn( true )
		else	
			self:TurnOn( false )
		end
	elseif (name == "Movement Force World") then
		self.DirForce = value
		self.DirMode = 1
	elseif (name == "Movement Force Local") then
		self.DirForce = value
		self.DirMode = 0
	elseif (name == "Fly To Vector") then
		self.DirForce = value
		self.DirMode = 2
	elseif (name == "Aim To Vector") then
		self.AimMode = 1
		self.AngForce = value
	elseif (name == "Aim To Angle") then
		self.AimMode = 2
		self.AngForce = value
	elseif (name == "Angular Force") then
		self.AimMode = 0
		self.AngForce = value
	elseif (name == "Freeze") then
		if (value != 0) then
			self:FreezeAll( true )
		else
			self:FreezeAll( false )
		end
	elseif (name == "Level") then
		if (value != 0) then
			self.LevelOut = true
		else
			self.LevelOut = false
		end
	elseif (name == "Base Entity") then
		if (value and value:IsValid()) then
			if (value == self) then
				self.BaseEnt = nil
			else
				self.BaseEnt = value
			end
		else
			self.BaseEnt = nil
		end
	end
end

------------------------------------------------------------------------
-- TurnOn
------------------------------------------------------------------------

function ENT:TurnOn( bool )
	if (self.On != bool) then
		self.On = bool
		self:GravityAll( bool )
		WireLib.TriggerOutput( self, "On", bool and 1 or 0 )
	end
end

------------------------------------------------------------------------
-- FreezeAll
------------------------------------------------------------------------

function ENT:FreezeAll( bool )
	if (self.Frozen != bool) then
		self.Frozen = bool
		self:Foreach( self.AllEntities, function( ent )
			local phys = ent:GetPhysicsObject()
			phys:EnableMotion( bool )
			phys:Wake()
		end)
		WireLib.TriggerOutput( self, "Frozen", bool and 1 or 0 )
	end
end

------------------------------------------------------------------------
-- GravityAll
------------------------------------------------------------------------

function ENT:GravityAll( bool )
	if (self.Gravity != bool) then
		self.Gravity = bool
		self:Foreach( self.AllEntities, function( ent )
			local phys = ent:GetPhysicsObject()
			phys:EnableDrag( false )
			phys:EnableGravity( !bool )
		end)
	end
end

------------------------------------------------------------------------
-- Foreach
-- Do something to every entity in a table safely
------------------------------------------------------------------------

function ENT:Foreach( tbl, func, ipairsbool )
	local temp = ipairs
	if (ipairsbool == false) then temp = pairs end
	
	local removetable = {}
	
	for k,v in temp( tbl ) do
		if (v and v:IsValid()) then
			func( v )
		else
			table.insert( removetable, k )
		end
	end
	
	for k,v in ipairs( removetable ) do
		table.remove( tbl, v )
	end
end

------------------------------------------------------------------------
-- CalculateAimToVector
------------------------------------------------------------------------

function ENT:CalculateAimToVector( TargetVec, ent )
	local Target = ent:GetPos() + (TargetVec - ent:GetPos()):Normalize() * 500
	local Pitch = (Target:Distance( ent:LocalToWorld(Vector(0,0,500)) ) - Target:Distance( ent:LocalToWorld(Vector(0,0,-500)) )) * 0.001
	local Yaw = (Target:Distance( ent:LocalToWorld(Vector(0,500,0)) ) - Target:Distance( ent:LocalToWorld(Vector(0,-500,0)) )) * 0.001
	local n = self.NumOfEntities
	if (n > 1) then n = n * 2 end
	return Angle(Pitch * n,Yaw * -n,0)--ent:GetAngles().r * 0.01)
end

------------------------------------------------------------------------
-- GetConstrainedEntities
------------------------------------------------------------------------

function ENT:GetConstrainedEntities()
	local temp = constraint.GetAllConstrainedEntities( self )
	
	self.TotalMass = self.phys:GetMass()
	self.AllEntities = {}
	self.Multipliers = { forward = math.huge, back = math.huge, right = math.huge, left = math.huge }
	
	local pos = self:GetPos()
	local forward =  pos + self:GetForward() * 5000
	local back =	 pos - self:GetForward() * 5000
	local right =	 pos + self:GetRight() * 5000
	local left =	 pos - self:GetRight() * 5000
	
	local forwardent, backent, rightent, leftent
	local heaviest = 0
	
	for k,v in pairs( temp ) do
		if (v and v:IsValid()) then
			local phys = v:GetPhysicsObject()
			local mass = phys:GetMass()
			self.TotalMass = self.TotalMass + mass
			if (mass > 10 and !(v:GetParent() and v:GetParent():IsValid())) then
				
				local pos = v:GetPos()
				-- forward mul
				local temp = pos:Distance(forward)
				if (temp < self.Multipliers.forward) then
					self.Multipliers.forward = temp
					forwardent = v
				end
				
				-- back mul
				local temp = pos:Distance(back)
				if (temp < self.Multipliers.back) then
					self.Multipliers.back = temp
					backent = v
				end
				
				-- right mul
				local temp = pos:Distance(right)
				if (temp < self.Multipliers.right) then
					self.Multipliers.right = temp
					rightent = v
				end
				
				-- left mul
				local temp = pos:Distance(left)
				if (temp < self.Multipliers.left) then
					self.Multipliers.left = temp
					leftent = v
				end
				
				local mass = math.Round(mass)
				if (mass > heaviest) then
					heaviest = mass
				end
			end
			
			if (v != self) then
				table.insert( self.AllEntities, v )
			end
		end
	end
	table.insert( self.AllEntities, 1, self )
	
	self.Entities = { self, forwardent, backent, rightent, leftent }
	
	for k,v in pairs( temp ) do
		if (math.Round(mass) == heaviest and !table.HasValue( self.Entities, v )) then
			local mass = v:GetPhysicsObject():GetMass()
			table.insert( self.Entities, v )
		end
	end
	
	self.NumOfEntities = #self.AllEntities
	WireLib.TriggerOutput( self, "Nr Of Props Linked", self.NumOfEntities )
	WireLib.TriggerOutput( self, "Props Linked", self.AllEntities )
	WireLib.TriggerOutput( self, "Total Mass", self.TotalMass )
end

------------------------------------------------------------------------
-- Think
------------------------------------------------------------------------

function ENT:Think()
	
	-- Get constrained entities table
	if (self.CheckConstrainedEntsTimer < CurTime()) then
		self.CheckConstrainedEntsTimer = CurTime() + 3 -- Only do this every third second to minimize lag
		self:GetConstrainedEntities()
	end
	
	if (!self.On) then return end
	
	local ent
	
	-- If Base Entity is wired, use that
	if (self.BaseEnt and self.BaseEnt:IsValid()) then
		ent = self.BaseEnt
	else
		-- If the Gyropod is parented, use the entity it is parented to instead
		if (self:GetParent() and self:GetParent():IsValid()) then
			ent = self:GetParent()
		else
			ent = self
		end
	end
	
	local pos, vel = ent:GetPos(), ent:GetVelocity()
	local velL = ent:WorldToLocal( pos + vel )
	
	-- Speed
	local temp = velL:Length()
	local MPH = math.Round(temp * (3600 / 63360))
	local KMH = math.Round(temp * (3600 * 0.0000254))
	
	local Mul = 1
	if MPH > 75 then --increase pitch yaw during high speeds
		Mul = MPH / 75
	end	
	
	-- Movement force
	local Force = self.DirForce
	if (self.DirMode == 0) then
		Force = ent:LocalToWorld(Force)-ent:GetPos()
	elseif (self.DirMode == 2) then
		Force = ((Force - ent:GetPos()) * 10 - ent:GetVelocity() * 0.5)
	end
	
	-- Angular force
	local AngForce = self.AngForce
	if (self.AimMode == 1) then
		AngForce = self:CalculateAimToVector( self.AngForce, ent )
	elseif (self.AimMode == 2) then
		AngForce = self:CalculateAimToVector( ent:GetPos() + self.AngForce:Forward() * 500, ent )
	end
	
	if (self.LevelOut) then 
		local _ang = ent:GetAngles()
		local n = self.NumOfEntities/50
		AngForce.p = math.NormalizeAngle(_ang.p * -(0.05+n))
		AngForce.r = math.NormalizeAngle(_ang.r * -(0.05+n))
	end
	
	-- Apply force to all constrained props
	local mass, forward, right, up = self.TotalMass * 0.25, ent:GetForward(), ent:GetRight(), ent:GetUp()
	self:Foreach( self.Entities, function( ent )
		local phys = ent:GetPhysicsObject()
		phys:SetVelocity( Force )
		phys:AddAngleVelocity( phys:GetAngleVelocity() * -1 )
		
		phys:ApplyForceOffset( up * -AngForce.p * mass * Mul, pos + forward * self.Multipliers.forward )
		phys:ApplyForceOffset( up * AngForce.p * mass * Mul, pos + forward * -self.Multipliers.back )
			phys:ApplyForceOffset( right * -AngForce.y * mass * Mul, pos + forward * self.Multipliers.forward )
			phys:ApplyForceOffset( right * AngForce.y * mass * Mul, pos + forward * -self.Multipliers.back )
				phys:ApplyForceOffset( up * -AngForce.r * mass, pos + right * self.Multipliers.right )
				phys:ApplyForceOffset( up * AngForce.r * mass, pos + right * -self.Multipliers.left )		
	end)
	
	WireLib.TriggerOutput( self, "MPH", MPH )
	WireLib.TriggerOutput( self, "KMH", KMH )

	self:NextThink( CurTime() )
	return true
end

------------------------------------------------------------------------
-- OnRemove
------------------------------------------------------------------------

function ENT:OnRemove()
	--[[
	if self.sound then
		self.HighEngineSound:Stop()
		self.LowDroneSound:Stop()
	end	
	local constrained = self.AllGyroConstraints
	for _, ents in pairs( constrained ) do
		if (!ents:IsValid()) then return end
		local linkphys = ents:GetPhysicsObject()
		linkphys:EnableDrag(true)
		linkphys:EnableGravity(true)
	end	
	]]
end

------------------------------------------------------------------------
-- Duplication
------------------------------------------------------------------------

function ENT:PreEntityCopy()
	local DI = {}
	
	if WireAddon then
		DI.WireData = WireLib.BuildDupeInfo( self.Entity )
	end
	
	duplicator.StoreEntityModifier(self, "SBEPGyro2", DI)
end
duplicator.RegisterEntityModifier( "SBEPGyro2" , function() end)

function ENT:PostEntityPaste(pl, Ent, CreatedEntities)

	if(Ent.EntityMods and Ent.EntityMods.SBEPGyro2.WireData) then
		WireLib.ApplyDupeInfo( pl, Ent, Ent.EntityMods.SBEPGyro2.WireData, function(id) return CreatedEntities[id] end)
	end

end


------------------------------------------------------------------------
-- Joystick
------------------------------------------------------------------------
--[[

local Gyrojcon = {}  --Joystick control stuff
local GyroJoystickControl = function()
	Gyrojcon.pitch = jcon.register{
		uid = "gyro_pitch",
		type = "analog",
		description = "Pitch",
		category = "Gyro-Pod",
	}
	Gyrojcon.yaw = jcon.register{
		uid = "gyro_yaw",
		type = "analog",
		description = "Yaw",
		category = "Gyro-Pod",
	}
	Gyrojcon.roll = jcon.register{
		uid = "gyro_roll",
		type = "analog",
		description = "Roll",
		category = "Gyro-Pod",
	}
	Gyrojcon.thrust = jcon.register{
		uid = "gyro_thrust",
		type = "analog",
		description = "Thrust",
		category = "Gyro-Pod",
	}
	Gyrojcon.accelerate = jcon.register{
		uid = "gyro_accelerate",
		type = "analog",
		description = "Accelerate/Decelerate",
		category = "Gyro-Pod",
	}
	Gyrojcon.up = jcon.register{
		uid = "gyro_strafe_up",
		type = "digital",
		description = "Strafe Up",
		category = "Gyro-Pod",
	}
	Gyrojcon.down = jcon.register{
		uid = "gyro_strafe_down",
		type = "digital",
		description = "Strafe Down",
		category = "Gyro-Pod",
	}
	Gyrojcon.right = jcon.register{
		uid = "gyro_strafe_right",
		type = "digital",
		description = "Strafe Right",
		category = "Gyro-Pod",
	}
	Gyrojcon.left = jcon.register{
		uid = "gyro_strafe_left",
		type = "digital",
		description = "Strafe Left",
		category = "Gyro-Pod",
	}
	Gyrojcon.launch = jcon.register{
		uid = "gyro_launch",
		type = "digital",
		description = "Launch",
		category = "Gyro-Pod",
	}
	Gyrojcon.switch = jcon.register{
		uid = "gyro_switch",
		type = "digital",
		description = "Yaw/Roll Switch",
		category = "Gyro-Pod",
	}
end
hook.Add("JoystickInitialize","GyroJoystickControl",GyroJoystickControl)

function ENT:UseJoystick()  --Joystick Controls (I've never tested this)
	if (joystick.Get(self.GyroDriver, "gyro_strafe_up")) then
		self.VSpeed = 50
	elseif (joystick.Get(self.GyroDriver, "gyro_strafe_down")) then
		self.VSpeed = -50
	end
	if (joystick.Get(self.GyroDriver, "gyro_strafe_right")) then
		self.HSpeed = 50
	elseif (joystick.Get(self.GyroDriver, "gyro_strafe_left")) then
		self.HSpeed = -50
	else
		self.HSpeed = 0
	end
	--Acceleration, greater than halfway accelerates, less than decelerates
	if (joystick.Get(self.GyroDriver, "gyro_accelerate")) then
		if (joystick.Get(self.GyroDriver, "gyro_accelerate") > 128) then
			self.GyroSpeed = math.Clamp(self.GyroSpeed + (joystick.Get(self.GyroDriver, "gyro_accelerate")/127.5-1)*5, -40, 2000)
		elseif (joystick.Get(self.GyroDriver, "gyro_accelerate") < 127) then
			self.GyroSpeed = math.Clamp(self.GyroSpeed + (joystick.Get(self.GyroDriver, "gyro_accelerate")/127.5-1)*10, -40, 2000)
		end
	end
	--Set the speed
	if (joystick.Get(self.GyroDriver, "gyro_thrust")) then
		if (joystick.Get(self.GyroDriver, "gyro_thrust") > 128) then
			self.TarSpeed = (joystick.Get(self.GyroDriver, "gyro_thrust")/127.5-1)*2000
		elseif (joystick.Get(self.GyroDriver, "gyro_thrust") < 127) then
			self.TarSpeed = (joystick.Get(self.GyroDriver, "gyro_thrust")/127.5-1)*40
		elseif (joystick.Get(self.GyroDriver, "gyro_thrust") < 128 && joystick.Get(self.GyroDriver, "gyro_thrust") > 127) then
			self.TarSpeed = 0
		end
		if (self.TarSpeed > self.GyroSpeed) then
			self.GyroSpeed = math.Clamp(self.GyroSpeed + 5, -40, 2000)
		elseif (self.TarSpeed < self.GyroSpeed) then
			self.GyroSpeed = math.Clamp(self.GyroSpeed - 10, -40, 2000)
		end
	end
	--forward is down on pitch, if you don't like it check the box on joyconfig to invert it
	if (joystick.Get(self.GyroDriver, "gyro_pitch")) then
		if (joystick.Get(self.GyroDriver, "gyro_pitch") > 128) then
			self.GyroPitch = -(joystick.Get(self.GyroDriver, "gyro_pitch")/127.5-1)*90
		elseif (joystick.Get(self.GyroDriver, "gyro_pitch") < 127) then
			self.GyroPitch = -(joystick.Get(self.GyroDriver, "gyro_pitch")/127.5-1)*90
		elseif (joystick.Get(self.GyroDriver, "gyro_pitch") < 128 && joystick.Get(self.GyroDriver, "gyro_pitch") > 127) then
			self.GyroPitch = 0
		end
	end
	--The control for inverting yaw and roll
	local yaw = ""
	local roll = ""
	if (joystick.Get(self.GyroDriver, "gyro_switch")) then
		yaw = "gyro_roll"
		roll = "gyro_yaw"
	else
		yaw = "gyro_yaw"
		roll = "gyro_roll"
	end
	--Yaw is negative because Paradukes says so
	--You could invert it, but the default configuration should be correct
	if (joystick.Get(self.GyroDriver, yaw)) then
		if (joystick.Get(self.GyroDriver, yaw) > 128) then
			self.GyroYaw = -(joystick.Get(self.GyroDriver, yaw)/127.5-1)*90
		elseif (joystick.Get(self.GyroDriver, yaw) < 127) then
			self.GyroYaw = -(joystick.Get(self.GyroDriver, yaw)/127.5-1)*90
		elseif (joystick.Get(self.GyroDriver, yaw) < 128 && joystick.Get(self.GyroDriver, yaw) > 127) then
			self.GyroYaw = 0
		end
	end
	if (joystick.Get(self.GyroDriver, roll)) then
		if (joystick.Get(self.GyroDriver, roll) > 128) then
			self.GyroRoll = (joystick.Get(self.GyroDriver, roll)/127.5-1)*90
		elseif (joystick.Get(self.GyroDriver, roll) < 127) then
			self.GyroRoll = (joystick.Get(self.GyroDriver, roll)/127.5-1)*90
		elseif (joystick.Get(self.GyroDriver, roll) < 128 && joystick.Get(self.GyroDriver, roll) > 127) then
			self.GyroRoll = 0
		end
	end
end
]]