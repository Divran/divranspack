AddCSLuaFile("DivransE2Stuff.lua")

/*
	Hello and thank you for using my E2 plugin! :D
	
	Here are all the syntaxes:
	
		E:freeze(N)		"E:N"
	- if N != 1, unfreezes entity E. If N == 1, freezes entity E.
	- You can only target your own props.
	- You cannot target players or NPCs.
	
		E:setHealth(N)	"E:N"
	- Sets player E's health to N. Is admin only. (It's esentially a Godmode)
	
		E:setArmor(N)	"E:N"
	- Sets player E's armor to N. Is admin only.
	
		E:setSpeed(N)	"E:N"
	- Sets player E's movement speed to N. Is admin only.
	- If N is 0 or lower, it will reset that player's movement speed to deafult instead of making it 0 or negative.
	
		E:setJump(N)	"E:N"
	- Sets player E's jump strength to N. Is admin only.
	- If N is 0 or lower, it will reset that player's jump strength to deafult instead of making it 0 or negative.
	
		E:kill()		"E:"
	- Kills the player or NPC. Is admin only (Obviously).
	
		boom(V,N1,N2)	"VNN"
	- Creates an explosion at position V, dealing N1 damage with a radius of N2. Is admin only (Obviously).
	
		E:setPos(V)		"EV"
	- Instantly teleports entity E to position V. Is admin only.
	
		E:setAngle(A)	"E:A"
		E:setAngle(V)	"E:V"
	- Instantly sets the entity E's angle to A or V. (Basically, a Wire Facer)
	
		chatPrint(N,S)	"NS"
	- Prints the message S in chat for everyone to see. N can be 0, or 1 or 2.
	- If N is 0, it will print the exact message.
	- If N is 1, it will print "[E2] " + Message.
	- If N is 2, it will print "[ " + Owner of Expression's Name + "'s E2]" + Message
		chatPrint(S)	"S"
	- Same as chatPrint(0,S)
		E:chatPrint(N,S)	"E:NS"
	- Prints the message S in chat for E to see. N is the same as in chatPrint(N,S)
		E:chatPrint(S)	"E:S"
	- Same as E:chatPrint(0,S)
*/



//SET FRAGS
registerFunction("setFrags", "e:n", "", function(self,args)
	local op1, op2 = args[2], args[3]
	local rv1, rv2 = op1[1](self,op1), op2[1](self,op2)
	if (!validEntity(rv1)) then return end
	if (!rv1:IsPlayer()) then return end
	local Target = rv1
	local Number = rv2
	if (Number < 0) then Number = 0 end
	Target:SetFrags( Number )
end)
//SET FRAGS END
//SET DEATHS
registerFunction("setDeaths", "e:n", "", function(self,args)
	local op1, op2 = args[2], args[3]
	local rv1, rv2 = op1[1](self,op1), op2[1](self,op2)
	if (!validEntity(rv1)) then return end
	if (!rv1:IsPlayer()) then return end
	local Target = rv1
	local Number = rv2
	if (Number < 0) then Number = 0 end
	Target:SetDeaths( Number )
end)
//SET DEATHS END

//PRINT TO CHAT VERSION 1
registerFunction("chatPrint", "ns", "", function(self,args)
	local op1, op2 = args[2], args[3]
	local rv1, rv2 = op1[1](self,op1), op2[1](self,op2)
	if (!self.player:IsAdmin()) then return end
	local Msg = rv2
	local Number = rv1
	if (Number == 0) then
		Msg = Msg
	elseif (Number == 1) then
		Msg = "[E2] "..Msg
	elseif (Number == 2) then
		Msg = "[".. self.player:GetName() .."'s E2] ".. Msg
	else 
	self.player:PrintMessage( HUD_PRINTTALK, "You can only use 0, 1 or 2. This message tells you that you entered the wrong number. This cannot be seen by others." )
	return
	end
	for k,v in pairs ( player.GetAll() ) do
		v:PrintMessage( HUD_PRINTTALK, Msg );
	end

end)
//PRINT TO CHAT VERSION 1 END
//PRINT TO CHAT VERSION 2
registerFunction("chatPrint", "s", "", function(self,args)
	local op1 = args[2]
	local rv1 = op1[1](self,op1)
	if (!self.player:IsAdmin()) then return end
	local Msg = rv1
	for k,v in pairs ( player.GetAll() ) do
		v:PrintMessage( HUD_PRINTTALK, Msg );
	end

end)
//PRINT TO CHAT VERSION 2 END
//PRINT TO CHAT VERSION 3
registerFunction("chatPrint", "e:s", "", function(self,args)
	local op1, op2 = args[2], args[3]
	local rv1, rv2 = op1[1](self,op1), op2[1](self,op2)
	if (!self.player:IsAdmin()) then return end
	if (!validEntity(rv1)) then return end
		rv1:PrintMessage( HUD_PRINTTALK, rv2 );
end)
//PRINT TO CHAT VERSION 3 END
//PRINT TO CHAT VERSION 4
registerFunction("chatPrint", "e:ns", "", function(self,args)
	local op1, op2, op3 = args[2], args[3], args[4]
	local rv1, rv2, rv3 = op1[1](self,op1), op2[1](self,op2), op3[1](self,op3)
	if (!self.player:IsAdmin()) then return end
	if (!validEntity(rv1)) then return end
	local Number = rv2
	local Msg = rv3
	if (Number == 0) then
		Msg = Msg
	elseif (Number == 1) then
		Msg = "[E2] "..Msg
	elseif (Number == 2) then
		Msg = "[".. self.player:GetName() .."'s E2] ".. Msg
	else 
	self.player:PrintMessage( HUD_PRINTTALK, "You can only use 0, 1 or 2. This message tells you that you entered the wrong number. This message cannot be seen by others." )
	return
	end
		rv1:PrintMessage( HUD_PRINTTALK, Msg );
end)
//PRINT TO CHAT VERSION 4 END

//FREEZE
registerFunction("freeze", "e:n", "n", function(self,args)
	local op1, op2 = args[2], args[3]
	local rv1, rv2 = op1[1](self,op1), op2[1](self,op2)
	local FrzTrgt = rv1
	local Numbarz = rv2
		if (FrzTrgt:IsPlayer() or FrzTrgt:IsNPC() or !isOwner(self,rv1)) then return 0 end
		if (!validEntity(FrzTrgt)) then return 0 end
		if (CLIENT) then return end
		Numbarz = math.Round(Numbarz)
		local POb = FrzTrgt:GetPhysicsObject()
	if (Numbarz == 1) then
		if (POb:IsMoveable()) then
			POb:EnableMotion(false)
			POb:Wake( )
		end
	else
		if (!POb:IsMoveable()) then
			POb:EnableMotion(true)
			POb:Wake( )
		end
	end
	return 1
end)
//FREEZE END

//SET HEALTH
registerFunction("setHealth", "e:n", "n", function(self,args)
	local op1, op2 = args[2], args[3]
	local rv1, rv2 = op1[1](self,op1), op2[1](self,op2)
		if (!validEntity(rv1)) then return 0 end 
		if (!rv1:IsPlayer()) then return 0 end
		if (!self.player:IsAdmin()) then return 0 end
	local Target = rv1
	local Health = rv2
	
	if (CLIENT) then return end
	
	if(!Health) then return 0 end
		Target:SetHealth( math.Clamp(Health, 1, 99999) )
	return 1
end)
//SET HEALTH END

//SET ARMOR
registerFunction("setArmor", "e:n", "n", function(self,args)
	local op1, op2 = args[2], args[3]
	local rv1, rv2 = op1[1](self,op1), op2[1](self,op2)
		if (!validEntity(rv1)) then return 0 end 
		if (!rv1:IsPlayer()) then return 0 end
		if (!self.player:IsAdmin()) then return 0 end
	local Target = rv1
	local Armor = rv2
	
	if (CLIENT) then return end
	
	if(!Armor) then return 0 end
		Target:SetArmor( math.Clamp(Armor, 1, 99999) )
	return 1
end)
//SET ARMOR END

//KILL
registerFunction("kill", "e:", "n", function(self,args)
	local op1 = args[2]
	local rv1 = op1[1](self,op1)
		if(!rv1:IsPlayer() and !Target:IsNPC()) then return 0 end
		if (!validEntity(rv1)) then return 0 end
		if (!self.player:IsAdmin()) then return 0 end
	local Target = rv1
	
	if (CLIENT) then return end

	Target:Kill()
	Target:AddFrags(1)
	return 1
end)
//KILL END

//SET SPEED
registerFunction("setSpeed", "e:n", "n", function(self,args)
	local op1, op2 = args[2], args[3]
	local rv1, rv2 = op1[1](self,op1), op2[1](self,op2)
		if(!rv1:IsPlayer()) then return 0 end
		if (!self.player:IsAdmin()) then return 0 end
	local Target = rv1
	local Speed = rv2
	
	if (CLIENT) then return end

	
	if (Speed < 1) then 
		Target:SetWalkSpeed(250)
		Target:SetRunSpeed(500)
	else
		if (Speed > 999999) then Speed = 999999 end
		Target:SetWalkSpeed(Speed)
		Target:SetRunSpeed(Speed+250)
	end
	return 1
end)
//SET SPEED END

//SET JUMP
registerFunction("setJump", "e:n", "n", function(self,args)
	local op1, op2 = args[2], args[3]
	local rv1, rv2 = op1[1](self,op1), op2[1](self,op2)
		if(!rv1:IsPlayer()) then return 0 end
		if (!self.player:IsAdmin()) then return 0 end
	local Target = rv1
	local Jump = rv2
	
	if (CLIENT) then return end

	if (Jump < 1) then 
		Target:SetJumpPower(160)
	else
		if (Jump > 999999) then Jump = 999999 end
		Target:SetJumpPower(Jump)
	end
	return 1
end)
//SET JUMP END

//BOOM
registerFunction("boom", "vnn", "", function(self,args)
    local op1, op2, op3 = args[2], args[3], args[4]
    local rv1, rv2, rv3 = op1[1](self, op1), op2[1](self, op2), op3[1](self, op3)
	local Positionz = Vector( rv1[1], rv1[2], rv1[3] )
	if (!self.player:IsAdmin() or !util.IsInWorld(Positionz)) then return end
	
	util.BlastDamage( self.entity, self.player, Positionz, math.Clamp( rv3, 1, 1000 ), math.Clamp( rv2 / 2, 1, 10000 ) )
	local effectdata = EffectData()
	effectdata:SetOrigin( Positionz )
	util.Effect( "Explosion", effectdata, true, true )
end)
//BOOM END

//Teleport
registerFunction("setPos", "e:v", "", function(self,args)
	local op1, op2 = args[2], args[3]
	local rv1, rv2 = op1[1](self, op1), op2[1](self, op2)
	local Pos = Vector( rv2[1], rv2[2], rv2[3] )
	if (!validEntity(rv1)) then return end
	if (!self.player:IsAdmin()) then
		if (rv1:IsPlayer() or !isOwner(self,rv1)) then return end
	end
	if (!util.IsInWorld(Pos)) then return end
	rv1:SetPos( Pos )
end)
//Teleport
//Set Angle
registerFunction("setAngle", "e:a", "", function(self,args)
	local op1, op2 = args[2], args[3]
	local rv1, rv2 = op1[1](self, op1), op2[1](self, op2)
	local Ang = Angle( rv2[1], rv2[2], rv2[3] )
	rv1:SetAngles( Ang )
end)
registerFunction("setAngle", "e:v", "", function(self,args)
	local op1, op2 = args[2], args[3]
	local rv1, rv2 = op1[1](self, op1), op2[1](self, op2)
	local Ang = (Vector( rv2[1], rv2[2], rv2[3] )):Angle()
	rv1:SetAngles( Ang )
end)
//Set Angle End