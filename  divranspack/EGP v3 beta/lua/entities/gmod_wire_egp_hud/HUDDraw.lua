local tbl = {}

		
local function EGP_Use( um )
	local ent = um:ReadEntity()
	if (ent.On == true) then
		ent.On = nil
		LocalPlayer():ChatPrint("[EGP] EGP HUD Disconnected.")
	else
		ent.On = true
		LocalPlayer():ChatPrint("[EGP] EGP HUD Connected.")
	end
end
usermessage.Hook( "EGP_HUD_Use", EGP_Use )		

function EGP:AddHUDEGP( Ent )
	table.insert( tbl, Ent )
end

function EGP:RemoveHUDEGP( Ent )
	for k,v in ipairs( tbl ) do
		if (v == Ent) then
			table.remove( tbl, k )
			return
		end
	end
end

hook.Add("HUDPaint","EGP_HUDPaint",function()
	for k,v in ipairs( tbl ) do
		if (!v or !v:IsValid()) then
			table.remove( tbl, k )
			break
		else
			if (v.On == true) then
				if (v.RenderTable and #v.RenderTable > 0) then
					for k2,v2 in ipairs( v.RenderTable ) do 
						EGP:SetMaterial( v2.material )
						v2:Draw() 
					end
				end
			end
		end
	end
end)