ENT.Type 			= "anim"  
if WireLib then
	ENT.Base 			= "base_wire_entity"
else
	ENT.Base			= "base_gmodentity"
end
if (CAF and CAF.GetAddon("Resource Distribution") and CAF.GetAddon("Life Support")) then
	ENT.Base 		= "base_rd3_entity"
end
ENT.PrintName		= "PewPew Base Cannon"  
ENT.Author			= "Divran"  
ENT.Contact			= ""  
ENT.Purpose			= ""  
ENT.Instructions	= ""  
ENT.Spawnable			= false
ENT.AdminSpawnable		= false