--Unlimited everything for admins!! Yay!
function D_UnlimitedProps( ply, Model, Entity )
	if (ply:IsAdmin()) then
	--Con( "You spawned a prop" )
	end
end
hook.Add("PlayerSpawnedProp", "D_UnlimitedProps", D_UnlimitedProps)

function D_UnlimitedVehicles( ply, Entity )
	if (ply:IsAdmin()) then
	--Con( "You spawned a vehicle" )
	end
end
hook.Add("PlayerSpawnedVehicle", "D_UnlimitedVehicles", D_UnlimitedVehicles)

function D_UnlimitedSENTS( ply, Entity )
	if (ply:IsAdmin()) then
	--Con( "You spawned an entity" )
	end
end
hook.Add("PlayerSpawnedSENT", "D_UnlimitedSENTS", D_UnlimitedSENTS)