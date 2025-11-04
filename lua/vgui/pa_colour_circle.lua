local COLOUR_CIRCLE = {}
function COLOUR_CIRCLE:Init()
	local H = attachHCvar:GetInt()
	local S = attachSCvar:GetInt()
	self:SetColor( H, S )
end

function COLOUR_CIRCLE:TranslateValues( x, y )
	-- Modified version of default TranslateValues function - so it won't print to console all the damn time
	x = x - 0.5
	y = y - 0.5
	local angle = math.atan2( x, y )
	local length = math.sqrt( x * x + y * y )
	length = math.Clamp( length, 0, 0.5 )
	x = 0.5 + math.sin( angle ) * length
	y = 0.5 + math.cos( angle ) * length

	self.H = math.deg( angle ) + 270
	self.S = length * 2

	self:OnChange( self.H, self.S )

	return x, y
end

function COLOUR_CIRCLE:GetColor()
	return self.H, self.S
end

function COLOUR_CIRCLE:SetColor( H, S )
	self.H, self.S = H, S

	local length = S / 2
	local angle = math.rad( H - 270 )

	local x = 0.5 + math.sin( angle ) * length
	local y = 0.5 + math.cos( angle ) * length

	--self:SetSlideX( x )
	--self:SetValue( y )

	self:OnChange( self.H, self.S )

	return x, y
end

function COLOUR_CIRCLE:OnChange()
	-- Overwrite in main body
end

vgui.Register("PA_ColourCircle", COLOUR_CIRCLE, "DColorCube")