local math_pi = math.pi
local math_random = math.random
local math_floor = math.floor

------------------------------------------------------------------------------
-- math.rad2deg
-- math.deg2rad
-- Author: Divran
-- Desc: A number used to convert radians to degrees and vice versa
-- Multiply your rad or degree by this value to convert it.
-- Example: 
--		local degree math.pi * math.rad2deg
--		"degree" will now be 180.
------------------------------------------------------------------------------
math.rad2deg = 180 / math_pi
math.deg2rad = math_pi / 180

------------------------------------------------------------------------------
-- math.clamp
-- Author: Divran
-- Desc: Clamps a number between two numbers
------------------------------------------------------------------------------
function math.clamp( n, min, max )
	return n > max and max or n < min and min or n
end

------------------------------------------------------------------------------
-- math.randomfloat
-- Author: Divran
-- Desc: Returns a random float between the two specified numbers
------------------------------------------------------------------------------
function math.randomfloat( min, max )
	return min + (max-min) * math_random()
end

------------------------------------------------------------------------------
-- math.round
-- Author: http://lua-users.org/wiki/SimpleRound 
-- NOTE: Someone on that page says it'll fail if idp is negative, but it won't. I tried it, and it works fine
-- Desc: Rounds a number
-- Optional second argument to specify how many decimals to round to (Default: 0)
------------------------------------------------------------------------------
function math.round(num, idp)
	local mult = 10^(idp or 0)
	return math_floor(num * mult + 0.5) / mult
end