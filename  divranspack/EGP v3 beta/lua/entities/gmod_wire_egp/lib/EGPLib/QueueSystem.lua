--------------------------------------------------------
-- EGP Queue System
--------------------------------------------------------
local EGP = EGP


EGP.Queue = {}

function EGP:AddQueueObject( Ent, ply, Function, Object )
	if (!EGP.Queue[ply]) then EGP.Queue[ply] = {} end
	local n = #EGP.Queue[ply]
	if (n > 0) then
		local LastItem = EGP.Queue[ply][n]
		if (LastItem.Ent == Ent and LastItem.Function == Function) then
			local Args = LastItem.Args
			table.insert( Args, Object )
		else
			self:AddQueue( Ent, ply, Function,  { Object } )
		end
	else
		self:AddQueue( Ent, ply, Function, { Object } )
	end
end

function EGP:AddQueue( Ent, ply, Function, ... )
	if (!EGP.Queue[ply]) then EGP.Queue[ply] = {} end
	table.insert( EGP.Queue[ply], { Function = Function, Ent = Ent, Args = ... } )
	--self:StartQueueTimer( ply:EntIndex() )
end

function EGP:InsertQueue( Ent, ply, Function, ... )
	if (!EGP.Queue[ply]) then EGP.Queue[ply] = {} end
	table.insert( EGP.Queue[ply], 1, { Function = Function, Ent = Ent, Args = ... } )
	--self:StartQueueTimer( ply:EntIndex() )
end

function EGP:GetNextItem( ply )
	if (!EGP.Queue[ply]) then return false end
	if (#EGP.Queue[ply] <= 0) then return false end
	local ret = table.remove( EGP.Queue[ply], 1 )
	return ret
end

function EGP:SendQueueItem( ply )
	if (!ply or !ply:IsValid()) then self:StopQueueTimer( ply ) end
	local NextAction = self:GetNextItem( ply )
	if (NextAction == false) then 
		self:StopQueueTimer( ply ) 
	else
		local Func = NextAction.Function
		if (!Func) then
			PrintTable(NextAction)
		end
		local Ent = NextAction.Ent
		local Args = NextAction.Args
		if (Args and #Args>0) then
			Func( Ent, ply, Args )
		else
			Func( Ent, ply )
		end
	end
end

function EGP:StartQueueTimer( ply )
	local TimerName = "EGP_Queue_"..ply:UniqueID()
	if (!timer.IsTimer(TimerName)) then
		timer.Create( TimerName, 1, 0, function( ply )
			self:SendQueueItem( ply )
		end, ply)
	end
end

function EGP:StopQueueTimer( ply )
	local TimerName = "EGP_Queue_"..ply:UniqueID()
	if (timer.IsTimer( TimerName )) then
		timer.Destroy( TimerName )
	end
	--[[ TODO: Make E2 run here
	timer.Simple( 0.1, function()
		for k,v in pairs( ents.FindByClass("gmod_wire_expression2") ) do
			if (v.context.data.EGP.RunByEGPQueue == true and E2Lib.isOwner( v, ply )) then
			
				
	timer.Simple( 0, function( Ent, E2 ) -- Run next tick
		if (E2 and E2.entity and E2.entity:IsValid()) then
			EGP.RunByEGPQueue = 1
			EGP.RunByEGPQueue_Ent = Ent
			E2.entity:Execute()
			EGP.RunByEGPQueue_Ent = nil
			EGP.RunByEGPQueue = nil
		end
	end, Ent, E2)
	]]
end