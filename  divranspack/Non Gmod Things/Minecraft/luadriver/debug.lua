local table_concat = table.concat
local pairs = pairs
local type = type
local string_rep = string.rep

------------------------------------------------------------------------------
-- print
-- Author: Divran
-- Desc: Overrides print for easier debug printing
------------------------------------------------------------------------------
oldprint = print -- Store this here
function print( ... )
	PrintToConsole( "info", table_concat( {...}, "\t" ) )
end

local print = print

------------------------------------------------------------------------------
-- printTable
-- Author: Divran
-- Desc: Adds a function to more easily print tables to console for debugging
------------------------------------------------------------------------------
function printTable( tbl, lookup_tbl, indents )
	lookup_tbl = lookup_tbl or {}
	indents = indents or 0

	lookup_tbl[tbl] = true

	for k,v in pairs( tbl ) do
		if type( v ) == "table" then
			if not lookup_tbl[v] then
				print( string_rep( "\t", indents ) .. k .. ": (" .. tostring(v) .. ")" )
				printTable( v, lookup_tbl, indents + 1 )
			else
				print( string_rep( "\t", indents ) .. k, "=", v )
			end
		else
			print( string_rep( "\t", indents ) .. k, "=", v )
		end
	end
end