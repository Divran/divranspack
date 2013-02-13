ENT.Type 			= "anim"  
ENT.Base 			= "base_wire_entity"
if (CAF and CAF.GetAddon("Resource Distribution") and CAF.GetAddon("Life Support")) or Environments then
	if(!Environments) then
	ENT.Base 		= "base_rd3_entity"
	else
	ENT.Base 		= "base_env_entity"
	end
end
ENT.PrintName		= "PewPew Base Cannon"  
ENT.Author			= "Divran"  
ENT.Contact			= ""  
ENT.Purpose			= ""  
ENT.Instructions	= ""  
ENT.Spawnable			= false
ENT.AdminSpawnable		= false

