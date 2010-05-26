--[[
dataSignal
Made by Divran

dataSignals are a combination of signals and gvars. 
Instead of using one to trigger the E2, and the other
to send the data, dataSignals can both trigger the E2 AND
send the data at the same time.

Have fun!
]]

E2Lib.RegisterExtension("datasignal", true)

---------------------------------------------
-- Lua helper functions

local signalname = ""
local data = nil
local sender = nil
local datatype = nil
local runbydatasignal = 0

local groups = {}
groups.default = {}
local queue = {}

-----------------
-- Check if the signal should be allowed
local function IsAllowed( fromscope, froment, toscope, toent )
	if (fromscope == 0) then -- If scope is 0, only send to E2s you own
		return E2Lib.isOwner( froment, toent )
	elseif (fromscope == 1) then -- If scope is 1, send to friends and E2s you own
		return (E2Lib.isOwner( froment, toent ) or E2Lib.isFriend( froment.player, toent.player ))
	elseif (fromscope == 2) then -- If scope is 2, send to everyone
		if (E2Lib.isOwner( froment, toent )) then -- If you are the owner, go ahead
			return true
		else
			return toscope == 2 -- Check if the recieving E2 allows you to send signals to it
		end
	end
	return false
end

local E2toE2

--------------
-- Queue (Thanks to Syranide for helping)
local QueueBusy = false
local QueueIndex = 0

local function CheckQueue( ent )
	if (QueueBusy) then return end
	QueueBusy = true

	while true do
		if (QueueIndex == #queue) then break end
		if (queue[QueueIndex] == nil) then break end -- :(
		local s = queue[QueueIndex]
		local ret = E2toE2( s.name, s.from, s.to, s.var, s.vartype, true ) -- Send it
		QueueIndex = QueueIndex + 1 
	end

	QueueBusy = false
	QueueIndex = 0
	queue = {}
end

registerCallback("postexecute",function(self)
	CheckQueue(self.entity)
end)

------------
-- Sending from one E2 to another

function E2toE2( name, from, to, var, vartype, skipthischeck ) -- For sending from an E2 to another E2
	if (!from or !from:IsValid() or from:GetClass() != "gmod_wire_expression2") then return 0 end -- Failed
	if (!to or !to:IsValid() or to:GetClass() != "gmod_wire_expression2") then return 0 end -- Failed
	if (!from.context or !to.context) then return 0 end -- OSHI-
	if (!IsAllowed( from.context.datasignal.scope, from, to.context.datasignal.scope, to )) then return 0 end -- Not allowed.
	if (!var or !vartype) then return 0 end -- Failed
	
	if (!skipthischeck) then -- if skipthischeck is not nil, then this function has been called from the queue check function
		queue[#queue] = { name = name, from = from, to = to, var = var, vartype = vartype } -- Add to queue
	end
	
	
	from.context.prf = from.context.prf + 80 -- Add 80 to ops
	
	signalname = name
	runbydatasignal = 1
	data = var
	datatype = vartype
	sender = from
	to:Execute()
	data = nil
	datatype = nil
	sender = nil
	runbydatasignal = 0
	signalname = ""
	
	return 1 -- Transfer successful
end

---------------------
-- Send from one E2 to an entire group of E2s
local function E2toGroup( signalname, from, groupname, scope, var, vartype ) -- For sending from an E2 to an entire group. Returns 0 if ANY of the sends failed
	if (groupname == nil) then groupname = from.context.datasignal.group end
	if (scope == nil) then scope = from.context.datasignal.scope end
	
	local ret = 1
	if (groups[groupname]) then
		for k,v in pairs( groups[groupname] ) do
			if (v.groupname == groupname) then -- Same group?
				local toent = Entity(k) -- Get the entity
				if (toent != from) then
					local tempret = E2toE2( signalname, from, toent, var, vartype ) -- Send the signal
					if (tempret == 0) then -- Did the send fail?
						ret = 0
					end
				end
			end
		end
	else
		return 0
	end
	return ret
end


-- Upperfirst, used by the E2 functions below
local function upperfirst( word )
	return word:Left(1):upper() .. word:Right(-2):lower()
end

---------------------------------------------
-- E2 functions

-- Add support for EVERY SINGLE type. Yeah!!
for k,v in pairs( wire_expression_types ) do
	if (k == "NORMAL") then k = "NUMBER" end
	k = string.lower(k)
	
	__e2setcost(10)

	-- Send a signal directly to another E2
	registerFunction("dsSendDirect","se"..v[1],"n",function(self,args)
		local op1, op2, op3 = args[2], args[3], args[4]
		local rv1, rv2, rv3 = op1[1](self, op1),op2[1](self, op2),op3[1](self,op3)
		return E2toE2( rv1, self.entity, rv2, rv3, k )
	end)
	
	__e2setcost(20)
	
	-- Send a ds to the E2s group in the E2s scope
	registerFunction("dsSend","s"..v[1],"n",function(self,args)
		local op1, op2 = args[2], args[3]
		local rv1, rv2 = op1[1](self, op1),op2[1](self, op2)
		return E2toGroup( rv1, self.entity, nil, nil, rv2, k )
	end)
	
	-- Send a ds to the E2s group in scope <rv2>
	registerFunction("dsSend","sn" .. v[1], "n", function(self,args)
		local op1, op2, op3 = args[2], args[3], args[4]
		local rv1, rv2, rv3 = op1[1](self, op1),op2[1](self, op2),op3[1](self,op3)
		return E2toGroup( rv1, self.entity, nil, rv2, rv3, k )
	end)
	
	-- Send a ds to the group <rv2> in the E2s scope
	registerFunction("dsSend","ss"..v[1],"n",function(self,args)
		local op1, op2, op3 = args[2], args[3], args[4]
		local rv1, rv2, rv3 = op1[1](self, op1),op2[1](self, op2),op3[1](self,op3)
		return E2toGroup( rv1, self.entity, rv2, nil, rv3, k )
	end)
	
	-- Send a ds to the group <rv2> in scope <rv3>
	registerFunction("dsSend","ssn"..v[1],"n",function(self,args)
		local op1, op2, op3, op4 = args[2], args[3], args[4], args[5]
		local rv1, rv2, rv3, rv4 = op1[1](self, op1),op2[1](self, op2),op3[1](self,op3),op4[1](self,op4)
		return E2toGroup( rv1, self.entity, rv2, rv3, rv4, k )
	end)
	
	__e2setcost(5)
	
	-- Get variable
	registerFunction("dsGet" .. upperfirst( k ), "", v[1], function(self,args)
		if (datatype != k) then return v[2] end -- If the type is not that type, return the type's default value
		return data
	end)
	
end

__e2setcost(5)

-- Set group
e2function void dsSetGroup( string groupname )
	groups[self.datasignal.group][self.entity:EntIndex()] = nil
	
	if (table.Count(groups[self.datasignal.group]) == 0) then
		groups[self.datasignal.group] = nil
	end
	
	self.datasignal.group = groupname
	if (!groups[groupname]) then
		groups[groupname] = {}
	end
	groups[groupname][self.entity:EntIndex()] = true
end

-- Get group
e2function string dsGetGroup()
	return self.datasignal.group
end

-- 0 = only you, 1 = only pp friends, 2 = everyone
e2function void dsSetScope( number scope )
	self.datasignal.scope = math.Clamp(math.Round(scope),0,2)
end

-- Get current scope
e2function number dsGetScope()
	return self.datasignal.scope
end

e2function void dsSetGroupScope( string groupname, number scope )
	-- group:
	groups[self.datasignal.group][self.entity:EntIndex()] = nil
	
	if (table.Count(groups[self.datasignal.group]) == 0) then
		groups[self.datasignal.group] = nil
	end
	
	self.datasignal.group = groupname
	if (!groups[groupname]) then
		groups[groupname] = {}
	end
	groups[groupname][self.entity:EntIndex()] = true
	
	-- scope:
	self.datasignal.scope = math.Clamp(math.Round(scope),0,2)
end

----------------
-- Get functions

__e2setcost(2)

-- Check if the current execution was caused by ANY datasignal
e2function number dsClk()
	return runbydatasignal
end

-- Check if the current execution was caused by a datasignal named <name>
e2function number dsClk( string name )
	if (signalname == name) then return 1 else return 0 end
end

-- Returns the name of the current signal
e2function string dsClkName()
	return signalname
end

-- Get the type of the current data
e2function string dsGetType()
	return datatype or ""
end

-- Get the which E2 sent the data
e2function entity dsGetSender()
	if (!sender or !sender:IsValid()) then return nil end
	return sender
end

__e2setcost(nil)

---------------------------------------------
-- When an E2 is removed, clear it from the groups table
registerCallback("destruct",function(self)
	groups[self.datasignal.group][self.entity:EntIndex()] = nil
end)

-- When an E2 is spawned, set its group and scope to the defaults
registerCallback("construct",function(self)
	self.datasignal = {}
	self.datasignal.group = "default"
	self.datasignal.scope = 0
	groups.default[self.entity:EntIndex()] = true
end)