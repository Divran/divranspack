pewpew.DamageLog = {}

function pewpew:AddDamageLog( TargetEntity, Damage, DamageDealer )
	local Time = os.date( "%c", os.time() )
	
	local DealerName = "-Error-"
	local Weapon = "-Unknown-"
	if (DamageDealer and ValidEntity( DamageDealer )) then
		if (type(DamageDealer) == "Player") then
			DealerName = DamageDealer:Nick()
		elseif ((DamageDealer:GetClass() == "pewpew_base_cannon" or DamageDealer:GetClass() == "pewpew_base_bullet") and DamageDealer.Owner and DamageDealer.Owner:IsValid()) then
			DealerName = DamageDealer.Owner:Nick()
			if (DamageDealer.Bullet) then
				Weapon = DamageDealer.Bullet.Name
			end
		end
	end
	
	local VicOwner = "-Error-"
	if (CPPI and TargetEntity:CPPIGetOwner()) then
		VicOwner = TargetEntity:CPPIGetOwner():Nick() or "-Error-"
	end
	
	local Died = false
	if (!TargetEntity:IsValid() or self:GetHealth( TargetEntity ) < Damage) then
		Died = true
	end
	
	if (#self.DamageLog > 0) then
		if (self.DamageLog[1] and self.DamageLog[1][4] and self.DamageLog[1][4] == TargetEntity:EntIndex()) then
			self.DamageLog[1][1] = Time
			self.DamageLog[1][6] = self.DamageLog[1][6] + Damage
			self.DamageLog[1][6] = Weapon
			self.DamageLog[1][2] = DealerName
			self.DamageLog[1][7] = Died
		else
			table.insert( self.DamageLog, 1, { Time, DealerName, VicOwner, TargetEntity, Weapon, Damage, Died } )
		end
	else
		table.insert( self.DamageLog, 1, { Time, DealerName, VicOwner, TargetEntity, Weapon, Damage, Died } )
	end
end
hook.Add("PewPew_Damage","PewPew_DamageLog",AddDamageLog)


require("datastream")
function pewpew:PopDamageLogStack()
	if (!pewpew:GetConVar( "DamageLogSending" )) then return end
	if (#self.DamageLog > 0) then
		datastream.StreamToClients( player.GetAll(), "PewPew_Option_Tool_SendLog", self.DamageLog )
		self.DamageLog = {}
	end
end

timer.Create( "PewPew_DamageLog_PopStack", 5, 0, function()
	pewpew:PopDamageLogStack()
end)
