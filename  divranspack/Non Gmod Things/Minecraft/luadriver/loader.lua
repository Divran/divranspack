------------------------------------------------------------------------------------------------------------
-- File loader
-- Made by Divran

-- Loads all files in the autorun folder
------------------------------------------------------------------------------------------------------------

--[[ This didn't work properly
local function FindFiles( dir )
	local fh = io.popen( dir )
	
	if not fh then return {} end
	
	
	local dir = fh:read("*a")
	
	local tbl = {}
	local lastpos
	for str, pos in dir:match( ".-\n()" ) do
		tbl[#tbl+1] = str
		lastpos = pos
	end
	tbl[#tbl+1] = str:sub(lastpos)
	 
	local files = {}
	for k, line in pairs(tbl) do
		if line:match("[%d%p]%s([%w%p]+)") then
			files[#files+1] = line:match( "[%d%p]%s([%w%p]+)")
		end
	end
	
	files[#files] = nil
	files[#files] = nil
	 
	return files
end
]]

hook.Add( "Initialize", "FileLoaderInitialize", function()
	-- D:
end)