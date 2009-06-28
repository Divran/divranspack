-- This checks if entity 1 can see entity 2 (or the vector)
-- in other words, returns 1 of the way is clear to the entity (or vector)
-- and returns 0 if a prop or the World is in the way.

e2function number visible(entity Entity, entity Target)
	if (!validEntity(Entity) or !validEntity(Target)) then return 0 end
	return Entity:Visible(Target)
end

e2function number visible(entity Entity, vector Target)
	if (!validEntity(Entity)) then return 0 end
	local Tar = Vector(Target[1], Target[2], Target[3])
	return Entity:VisibleVec(Tar)
end