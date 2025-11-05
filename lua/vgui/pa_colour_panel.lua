local BGColor            = PrecisionAlign.TOOLMODE_BACKGROUND_COLOR
local BGColor_Disabled   = PrecisionAlign.TOOLMODE_BACKGROUND_COLOR_DISABLED

local COLOUR_PANEL = {}
function COLOUR_PANEL:Init()
	self.colour = BGColor_Disabled:Copy()
	self.setcolour = BGColor_Disabled
	local parent = self:GetParent()
	self:SetSize( 150, parent:GetTall() / 2 - 15 )
end

function COLOUR_PANEL:SetColour( colour )
	self.setcolour = colour
end

function COLOUR_PANEL:Paint()
	for k, v in pairs (self.colour) do
		self.colour[k] = v + (self.setcolour[k] - v) / 10
	end

	draw.RoundedBox(6, 0, 0, self:GetWide(), self:GetTall(), self.colour)
	draw.RoundedBox(6, 5, 15, self:GetWide() - 10, self:GetTall() - 20, BGColor)
end

vgui.Register("PA_Colour_Panel", COLOUR_PANEL, "DPanel")