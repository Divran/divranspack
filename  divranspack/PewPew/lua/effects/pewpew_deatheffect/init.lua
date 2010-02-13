function EFFECT:Init( data )
	local Pos = data:GetOrigin()
	local Size = math.Round(data:GetScale())
	local emitter = ParticleEmitter( Pos )
	local clr=VectorRand() * 255
	for I=1, math.max(math.Round(Size/50),4) do
		local pos = VectorRand() * Size / 5
		local vel = pos:GetNormal() * Size / 4
		local particle = emitter:Add( "effects/yellowflare", Pos + pos )
			particle:SetVelocity( vel )
			particle:SetDieTime( math.Rand( 1, 3 ) )
			particle:SetStartAlpha( 255 )
			particle:SetEndAlpha( 50 )
			particle:SetStartSize( math.max(Size / 3,50) )
			particle:SetEndSize( math.max(Size / 5,20) )
			particle:SetRoll( math.Rand(90, 360) )
			particle:SetColor( clr.r, clr.g, clr.b )
	end
	emitter:Finish()
end

function EFFECT:Think() return false end
function EFFECT:Render() end