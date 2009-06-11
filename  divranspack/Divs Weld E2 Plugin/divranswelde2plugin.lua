AddCSLuaFile('divranswelde2plugin.lua')

-- Weld
-- Will weld two props together
-- Will return 1 if it successfully welds the props and 0 if it fails.

-- How to use:
-- weld(Entity1, Entity2)
registerFunction("weld", "ee","n", function(self, args)
    local op1, op2 = args[2], args[3]
    local rv1, rv2 = op1[1](self, op1), op2[1](self, op2)
	if (!validEntity(rv1) or !validEntity(rv2)) then return 0 end
	if (!isOwner(self, rv1) or !isOwner(self, rv2)) then return 0 end
	constraint.Weld(rv1,rv2,0,0,0,0)
	return 1
end)

-- How to use:
-- weld(Entity1, Entity2, Force Limit, NoCollide)
registerFunction("weld", "eenn","n", function(self, args)
    local op1, op2, op3, op4 = args[2], args[3], args[4], args[5]
    local rv1, rv2, rv3, rv4 = op1[1](self, op1), op2[1](self, op2), op3[1](self, op3), op4[1](self, op4)
	if (!validEntity(rv1) or !validEntity(rv2)) then return 0 end
	if (!isOwner(self, rv1) or !isOwner(self, rv2)) then return 0 end
	local Strength =  math.Clamp( rv3, 0, 1000000 )
	constraint.Weld(rv1,rv2,0,0,Strength,rv4)
	return 1
end)

-- Unweld
-- Will unweld the entity from all other entities.
-- Will return 1 if it successfully unwelds and 0 if it fails.

-- How to use:
-- unweld(Entity)
registerFunction("unweld", "e:","n", function(self, args)
    local op1 = args[2]
    local rv1 = op1[1](self, op1)
	if (!validEntity(rv1)) then return 0 end
	if (!isOwner(self, rv1)) then return 0 end
	constraint.RemoveConstraints( rv1, "Weld" )
	return 1
end)