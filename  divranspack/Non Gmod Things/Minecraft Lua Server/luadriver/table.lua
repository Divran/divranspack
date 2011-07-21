local setmetatable = setmetatable
local getmetatable = getmetatable
local type = type
local pairs = pairs
local table_copy

------------------------------------------------------------------------------
-- table.copy
-- Author: Divran
-- Desc: Copies a table and all subtables
-- Just like Gmod's
------------------------------------------------------------------------------
function table.copy( tbl, lookup_tbl )
	if not tbl then return end
	
	lookup_tbl = lookup_tbl or {}

	local ret = {}
	
	for k,v in pairs( tbl ) do
		if type( v ) == "table" then
			if not lookup_tbl[v] then
				lookup_tbl[v] = table_copy( v, lookup_tbl )
			end
			
			ret[k] = lookup_tbl[v]
		else
			ret[k] = v
		end
	end
	
	setmetatable( ret, getmetatable( tbl ) )
	
	return ret
end
table_copy = table.copy