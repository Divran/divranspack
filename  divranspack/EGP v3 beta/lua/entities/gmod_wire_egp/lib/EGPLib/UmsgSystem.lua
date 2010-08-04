--------------------------------------------------------
-- Custom umsg System
--------------------------------------------------------
local EGP = EGP

EGP.CurrentCost = 0
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
	EGP.CurrentCost = 0
	umsg.Start( name, repicient )
end
-- End
function EGP.umsg.End()
	EGP.CurrentCost = 0
	umsg.End()
end
-- Angle
function EGP.umsg.Angle( data )
	EGP.CurrentCost = EGP.CurrentCost + 12
	umsg.Angle( data )
end
-- Boolean
function EGP.umsg.Bool( data )
	EGP.CurrentCost = EGP.CurrentCost + 1
	umsg.Bool( data )
end
-- Char
function EGP.umsg.Char( data )
	EGP.CurrentCost = EGP.CurrentCost + 1
	umsg.Char( data )
end
-- Entity
function EGP.umsg.Entity( data )
	EGP.CurrentCost = EGP.CurrentCost + 2
	umsg.Entity( data )
end
-- Float
function EGP.umsg.Float( data )
	EGP.CurrentCost = EGP.CurrentCost + 4
	umsg.Float( data )
end
-- Long
function EGP.umsg.Long( data )
	EGP.CurrentCost = EGP.CurrentCost + 4
	umsg.Long( data )
end
-- Short
function EGP.umsg.Short( data )
	EGP.CurrentCost = EGP.CurrentCost + 2
	umsg.Short( data )
end
-- String
function EGP.umsg.String( data )
	EGP.CurrentCost = EGP.CurrentCost + #data
	umsg.String( data )
end
-- Vector
function EGP.umsg.Vector( data )
	EGP.CurrentCost = EGP.CurrentCost + 12
	umsg.Vector( data )
end
-- VectorNormal
function EGP.umsg.VectorNormal( data )
	EGP.CurrentCost = EGP.CurrentCost + 12
	umsg.VectorNormal( data )
end