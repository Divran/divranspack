local string_gsub = string.gsub
local string_sub = string.sub
local string_gmatch = string.gmatch

------------------------------------------------------------------------------
-- string.explode
-- Author: Divran & TomyLobo
-- Desc: Splits a string into a table around the specified separator
-- Note that the arguments are flipped compared to Gmod (They are now in the CORRECT order)
-- This exact same one is in Gmod
------------------------------------------------------------------------------

function string.explode(str, separator, withpattern)
	-- Faster exploding for this specific separator
	if separator == "" then
		local ret = {}
		for i=1,#str do
			ret[i] = string_sub(str,i,i)
		end
		return ret
	end
     
    local ret = {}
    local index,lastPosition = 1,1
     
    -- Escape all magic characters in separator
    if not withpattern then separator = string_gsub( separator, "[%-%^%$%(%)%%%.%[%]%*%+%?]", "%%%1" ) end
     
    -- Find the parts
    for startPosition,endPosition in string_gmatch( str, "()" .. separator.."()" ) do
        ret[index] = string_sub( str, lastPosition, startPosition-1)
        index = index + 1
         
        -- Keep track of the position
        lastPosition = endPosition
    end
     
    -- Add last part by using the position we stored
    ret[index] = string_sub( str, lastPosition)
    return ret
end

------------------------------------------------------------------------------
-- string.replace
-- Author: Divran
-- Desc: Replaces all matches in a string with the specified replacement
-- Does NOT use patterns, unlike gsub
-- This exact same one is in Gmod
------------------------------------------------------------------------------
function string.replace( str, tofind, toreplace )
	tofind = tofind:gsub( "[%-%^%$%(%)%%%.%[%]%*%+%?]", "%%%1" )
	toreplace = toreplace:gsub( "%%", "%%%1" )
	return ( str:gsub( tofind, toreplace ) )
end

------------------------------------------------------------------------------
-- string.trim
-- Author: Unknown
-- Desc: Trims away spaces at the beginning and end of the string.
-- Optional second argument to specify any character to trim instead of spaces.
-- This exact same one is in Gmod
------------------------------------------------------------------------------
function string.trim( s, char )
	char = char or "%s"
	return ( string_gsub( s, "^" .. char .. "*(.-)" .. char .. "*$", "%1" ) )
end


------------------------------------------------------------------------------
-- string.trimRight
-- Author: Divran
-- Desc: Trims away spaces at the end of the string.
-- Optional second argument to specify any character to trim instead of spaces.
------------------------------------------------------------------------------

function string.trimRight( str, char )
	char = char or "%s"
	return ( string_gsub( str, "(" .. char .. "*)$", "" ) )
end

------------------------------------------------------------------------------
-- string.trimLeft
-- Author: Divran
-- Desc: Trims away spaces at the beginning of the string.
-- Optional second argument to specify any character to trim instead of spaces.
------------------------------------------------------------------------------
function string.trimLeft( str, char )
	char = char or "%s"
	return ( string_gsub( str, "^(" .. char .. "*)", "" ) )
end

