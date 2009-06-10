-- Fix view
function CameraFix( ply, origin, angles, fov)
	local view = {}
		if (ply:InVehicle()) then
			if (ply:GetVehicle():GetModel() == "models/vehicle.mdl") then
				view.origin = origin + Vector(0,0,10)
				return view
			end
		end
	
	
end
hook.Add("CalcView", "CameraFix", CameraFix)
