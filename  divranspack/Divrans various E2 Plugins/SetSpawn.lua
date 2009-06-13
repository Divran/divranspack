AddCSLuaFile("SetSpawn.lua")
//Made by ZeikJT
registerFunction("setSpawn", "v", "", function(self,args)
    if !self.player or !self.player:IsValid() then return end
    local op1 = args[2]
    local rv1 = op1[1](self, op1)
    self.player.customspawn = {self.entity, Vector(rv1[1], rv1[2], rv1[3])}
end)

registerFunction("removeSpawn", "", "", function(self,args)
    if !self.player or !self.player:IsValid() or !self.player.customspawn then return end
    self.player.customspawn = nil
end)

registerCallback("destruct", function(self)
	if self.player:IsValid() and self.player.customspawn and self.player.customspawn[1]==self.entity then
		self.player.customspawn = nil
	end
end)

if SERVER then
    hook.Add("PlayerSpawn", "E2CustomSpawn", function(ply)
        if !ply:IsValid() or !ply.customspawn or !ply.customspawn[1]:IsValid() or !util.IsInWorld(ply.customspawn[2]) then return end
        ply:SetPos( ply.customspawn[2] )
    end)
end