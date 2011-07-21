local function internal_Call( hookname, canBlock, blockArg, ... )
	if canBlock then
		local ret = hook.Call( hookname, ... )
		
		for i=1, #ret do
			if ret[i] == false and blockArg.SetReturn then
				blockArg:SetReturn( 255 )
			elseif type(ret[i]) == "string" and blockArg.SetMessage then
				blockArg:SetMessage( ret[i] )
			end
		end
	else
		hook.Call( hookname, ... )
	end
end

function OnScriptStart()
	-- Special files that needs to be loaded first
	dofile( "lua/luadriver/debug.lua" )
	dofile( "lua/luadriver/hook.lua" )
	
	-- Load main files
	dofile( "lua/luadriver/loader.lua" )
	
	-- Load libraries
	
	
	-- Load extensions
	dofile( "lua/luadriver/math.lua" )
	dofile( "lua/luadriver/string.lua" )
	dofile( "lua/luadriver/table.lua" )
	
	internal_Call( "Initialize", false )
end

function OnPlayerDeath(Player)
	internal_Call( "OnPlayerDeath", false, nil, Player )
end

function OnPlayerItemPickup(Item)
	internal_Call( "OnPlayerItemPickup", true, Item, Item:GetPlayer(), Item )
end

function OnPlayerPlaceSign(Sign)
	internal_Call( "OnPlayerPlaceSign", false, nil, Sign )
end

function OnPlayerBreakBlock(Block)
	if Block:GetStatus() == 0 then
		internal_Call( "OnPlayerHitBlock", true, Block, Block:GetUser(), Block )
	else
		internal_Call( "OnPlayerBreakBlock", true, Block, Block:GetUser(), Block )
	end
end

function CommandHandler(Command)
	internal_Call( "CommandHandler", true, Command, Command:GetUser(), Command )
end

function OnPlayerChat(Chat)
	internal_Call( "OnPlayerChat", true, Chat, Chat:GetUser(), Chat )
end

function OnPlayerPlaceBlock(Block)
	internal_Call( "OnPlayerPlaceBlock", true, Block, Block:GetUser(), Block )
end

function OnPlayerRespawn(Player)
	internal_Call( "OnPlayerRespawn", false, nil, Player )
end

function OnPlayerDisconnect(Player)
	internal_Call( "OnPlayerDisconnect", false, nil, Player )
end

function OnPlayerConnect(Player)
	internal_Call( "OnPlayerConnect", false, nil, Player )
end

function GameTick(arg)
	--internal_Call( "Tick", false, nil, arg )
end