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

local function E2toE2( name, from, to, var, vartype ) -- For sending from an E2 to another E2
	if (!from or !from:IsValid() or from:GetClass() != "gmod_wire_expression2") then return 0 end -- Failed
	if (!to or !to:IsValid() or to:GetClass() != "gmod_wire_expression2") then return 0 end -- Failed
	if (from == to) then return 0 end -- Failed
	if (!var) then return 0 end -- Failed
	if (!vartype) then return 0 end -- Failed
	
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

local function IsAllowed( fromscope, froment, toscope, toent )
	if (froment == toent) then return false end
	if (fromscope == 0) then -- If scope is 0, only send to E2s you own
		return E2Lib.isOwner( froment, toent )
	elseif (fromscope == 1) then -- If scope is 1, send to friends
		return E2Lib.isFriend( froment.player, toent.player )
	elseif (fromscope == 2) then -- If scope is 2, send to everyone
		if (E2Lib.isOwner( froment, toent )) then -- If you are the owner, go ahead
			return true
		else
			return toscope == 2 -- Check if the recieving E2 allows you to send signals to it
		end
	end
end

local function E2toGroup( signalname, from, groupname, scope, var, vartype ) -- For sending from an E2 to an entire group. Returns 0 if ANY of the sends failed
	if (groupname == nil) then groupname = groups[from:EntIndex()].groupname end
	if (scope == nil) then scope = groups[from:EntIndex()].scope end
	
	local ret = 1
	for k,v in pairs( groups ) do
		if (v.groupname == groupname) then -- Same group?
			local toent = Entity(k) -- Get the entity
			if (IsAllowed( scope, from, v.scope, toent )) then -- Same scope?
				local tempret = E2toE2( signalname, from, toent, var, vartype ) -- Send the signal
				from.context.prf = from.context.prf + 100 -- Add 50 to ops
				if (tempret == 0) then -- Did the send fail?
					ret = 0
				end
			end
		end
	end
	return ret
end

local function CreateTable( ent )
	if (!groups[ent:EntIndex()]) then
		groups[ent:EntIndex()] = {}
		groups[ent:EntIndex()].groupname = "default" -- Only recieve signals in the default group
		groups[ent:EntIndex()].scope = 0 -- Only recieve signals from your E2s
	end
end

local function upperfirst( word )
	return word:Left(1):upper() .. word:Right(-2):lower()
end


---------------------------------------------
-- E2 functions

-- Add support for EVERY SINGLE type. Yeah!!
for k,v in pairs( wire_expression_types ) do
	if (k == "NORMAL") then k = "NUMBER" end
	k = string.lower(k)
	
	__e2setcost(100)

	-- Send a signal directly to another E2
	registerFunction("dsSendDirect","se"..v[1],"n",function(self,args)
		local op1, op2, op3 = args[2], args[3], args[4]
		local rv1, rv2, rv3 = op1[1](self, op1),op2[1](self, op2),op3[1](self,op3)
		return E2toE2( rv1, self.entity, rv2, rv3, k )
	end)
	
	__e2setcost(1)

	-- Send a ds to the E2s group in the E2s scope
	registerFunction("dsSend","s"..v[1],"n",function(self,args)
		local op1, op2 = args[2], args[3]
		local rv1, rv2 = op1[1](self, op1),op2[1](self, op2)
		CreateTable(self.entity)
		return E2toGroup( rv1, self.entity, nil, nil, rv2, k )
	end)
	
	-- Send a ds to the E2s group in scope <rv2>
	registerFunction("dsSend","sn" .. v[1], "n", function(self,args)
		local op1, op2, op3 = args[2], args[3], args[4]
		local rv1, rv2, rv3 = op1[1](self, op1),op2[1](self, op2),op3[1](self,op3)
		CreateTable(self.entity)
		return E2toGroup( rv1, self.entity, nil, rv2, rv3, k )
	end)
	
	-- Send a ds to the group <rv2> in the E2s scope
	registerFunction("dsSend","ss"..v[1],"n",function(self,args)
		local op1, op2, op3 = args[2], args[3], args[4]
		local rv1, rv2, rv3 = op1[1](self, op1),op2[1](self, op2),op3[1](self,op3)
		CreateTable(self.entity)
		return E2toGroup( rv1, self.entity, rv2, nil, rv3, k )
	end)
	
	-- Send a ds to the group <rv2> in scope <rv3>
	registerFunction("dsSend","ssn"..v[1],"n",function(self,args)
		local op1, op2, op3, op4 = args[2], args[3], args[4], args[5]
		local rv1, rv2, rv3, rv4 = op1[1](self, op1),op2[1](self, op2),op3[1](self,op3),op4[1](self,op4)
		CreateTable(self.entity)
		return E2toGroup( rv1, self.entity, rv2, rv3, rv4, k )
	end)
	
	__e2setcost(5)
	
	-- Get variable
	registerFunction("dsGet" .. upperfirst( k ), "", v[1], function(self,args)
		if (datatype != k) then return v[2] end -- If the type is not that type, return the type's default value
		return data
	end)
	
end

__e2setcost(2)

-- Set group
e2function void dsSetGroup( string groupname )
	CreateTable(self.entity)
	groups[self.entity:EntIndex()].groupname = groupname
end

-- Get group
e2function string dsGetGroup()
	CreateTable(self.entity)
	return groups[self.entity:EntIndex()].groupname
end

-- 0 = only you, 1 = only pp friends, 2 = everyone
e2function void dsSetScope( number scope )
	CreateTable(self.entity)
	scope = math.Clamp(scope,0,2)
	groups[self.entity:EntIndex()].scope = scope
end

-- Get current scope
e2function number dsGetScope()
	CreateTable(self.entity)
	return groups[self.entity:EntIndex()].scope
end

----------------
-- Get functions

-- Check if the current execution was caused by ANY datasignal
e2function number dsClk()
	return runbydatasignal
end

-- Check if the current execution was caused by a datasignal named <name>
e2function number dsClk( name )
	if (signalname == name) then return 1 else return 0 end
end

-- Returns the name of the current signal
e2function string dsClkName()
	return signalname
end

-- Get the type of the current data
e2function string dsType()
	return datatype or ""
end

-- Get which E2 sent the data
e2function entity dsGetSender()
	if (!sender or !sender:IsValid()) then return nil end
	return sender
end

__e2setcost(nil)

---------------------------------------------
-- When an E2 is removed, clear it from the groups table
registerCallback("destruct",function(self)
	if (type(self) == "Entity") then -- not having this sometimes caused MAHOOSIVE error spam
		if (groups[self.entity:EntIndex()]) then
			table.remove( groups, self.entity:EntIndex() )
		end
	end
end)