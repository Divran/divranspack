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
			local found = false
			for k,v in ipairs( LastItem.Args ) do
				if (v.index == Object.index) then
					found = true
					self:EditObject( v, Object )
				end
			end
			if (!found) then
				table.insert( LastItem.Args, Object )
			end
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
end

function EGP:InsertQueueObjects( Ent, ply, Function, Objects )
	if (!EGP.Queue[ply]) then EGP.Queue[ply] = {} end
	local n = #EGP.Queue[ply]
	if (n > 0) then
		local FirstItem = EGP.Queue[ply][1]
		if (FirstItem.Ent == Ent and FirstItem.Function == Function) then
			local Args = FirstItem.Args
			for k,v in ipairs( Objects ) do
				table.insert( Args, v )
			end
		else
			self:InsertQueue( Ent, ply, Function, Objects )
		end
	else
		self:InsertQueue( Ent, ply, Function, Objects )
	end
end

function EGP:InsertQueue( Ent, ply, Function, ... )
	if (!EGP.Queue[ply]) then EGP.Queue[ply] = {} end
	table.insert( EGP.Queue[ply], 1, { Function = Function, Ent = Ent, Args = ... } )
end

function EGP:GetNextItem( ply )
	if (!EGP.Queue[ply]) then return false end
	if (#EGP.Queue[ply] <= 0) then return false end
	return table.remove( EGP.Queue[ply], 1 )
end

local AlreadyChecking = 0

function EGP:SendQueueItem( ply )
	if (!ply or !ply:IsValid()) then self:StopQueueTimer( ply ) end
	local NextAction = self:GetNextItem( ply )
	if (NextAction == false) then 
		self:StopQueueTimer( ply ) 
	else
		local Func = NextAction.Function
		local Ent = NextAction.Ent
		local Args = NextAction.Args
		if (Args and #Args>0) then
			Func( Ent, ply, Args )
		else
			Func( Ent, ply )
		end
		
		if (CurTime() != AlreadyChecking) then -- Had to use this hacky way of checking, because the E2 triggered 4 times for some strange reason. If anyone can figure out why, go ahead and tell me.
			AlreadyChecking = CurTime()
			
			-- Check if the queue has no more items for this screen
			local Items = self:GetQueueItemsForScreen( ply, Ent )
			if (Items and #Items == 0) then
				EGP.RunByEGPQueue = 1
				EGP.RunByEGPQueue_Ent = Ent
				EGP.RunByEGPQueue_ply = ply
				for k,v in ipairs( ents.FindByClass( "gmod_wire_expression2" ) ) do -- Find all E2s
					local context = v.context
					if (context) then	
						local owner = context.player
						 -- Check if friends, whether or not the E2 is already executing, and if the E2 wants to be triggered by the queue system regarding the screen in question.
						if (E2Lib.isFriend( ply, owner ) and context.data and context.data.EGP and context.data.EGP.RunOnEGP and context.data.EGP.RunOnEGP[Ent] == true) then
							v:Execute()
						end
					end
				end
				EGP.RunByEGPQueue_ply = nil
				EGP.RunByEGPQueue_Ent = nil
				EGP.RunByEGPQueue = nil	
			end
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
end

function EGP:GetQueueItemsForScreen( ply, Ent )
	if (!EGP.Queue[ply]) then return {} end
	local ret = {}
	for k,v in ipairs( EGP.Queue[ply] ) do
		if (v.Ent == Ent) then
			table.insert( ret, v )
		end
	end
	return ret
end