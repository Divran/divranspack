local function CheckValidResource( res )
	local resources = CAF.GetAddon("Resource Distribution").GetAllRegisteredResources()
	if (resources[res]) then return true end
	return false			
end

e2function void entity:burnResource( string resourcetype, number amount )
	if (!this:IsValid()) then return end
	if (!isOwner(self, this)) then return end
	resourcetype = string.lower( resourcetype )
	if (CheckValidResource( resourcetype )) then
		local storage = this:GetResourceAmount(resourcetype)
		if (storage) then
			this:ConsumeResource( resourcetype, math.min( math.abs(amount), storage ) )
		end
	end
end