------------------------------------------------------------------------------------------------------------
-- Hook module
-- Made by Divran

-- Adds Gmod-like hooks
------------------------------------------------------------------------------------------------------------

local table_remove = table.remove
local tostring = tostring
local pairs = pairs
local pcall = pcall
local type = type

hook = {}

local hooks = {}

function hook.Call( hookname, ... )
	PrintToConsole( "info", "hook.Call hookname: " .. tostring(hookname))
	if hooks[hookname] then
		for k,v in pairs( hooks[hookname] ) do
			PrintToConsole( "info", "hook.Call calling hook: " .. tostring(k))
			local ret = {pcall( v, ... )}
			if not ret[1] then
				PrintToConsole( "warning", "Hook error in hook '" .. k .. "' (Hook: '" .. hookname .. "')! Error is: " .. tostring(ret[2]) )
			else
				table_remove( ret, 1 )
				return ret
			end
		end
	end
end

function hook.Add( hookname, uniquename, func )
	if not hooks[hookname] then hooks[hookname] = {} end
	
	hooks[hookname][uniquename] = func
end

function hook.Remove( hookname, uniquename )
	if hooks[hookname] and hooks[hookname][uniquename] then
		hooks[hookname][uniquename] = nil
	end
end

function hook.Get()
	return hooks
end