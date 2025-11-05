local XYZ_SLIDERS = {}
function XYZ_SLIDERS:Init()
	self.slider_x = vgui.Create( "PA_XYZ_Slider", self )
	self.slider_y = vgui.Create( "PA_XYZ_Slider", self )
	self.slider_z = vgui.Create( "PA_XYZ_Slider", self )

	self.slider_x.Label:SetWide( 5 )
	self.slider_y.Label:SetWide( 5 )
	self.slider_z.Label:SetWide( 5 )

	self.slider_x:SetText("X")
	self.slider_y:SetText("Y")
	self.slider_z:SetText("Z")
end

function XYZ_SLIDERS:PerformLayout()
	local w, h = self:GetWide(), self:GetTall() - 10
	local x = 0
	local y1 = 0
	local y2 = h / 2 - 20
	local y3 = h - 40
	local width = w
	-- local height = 100

	self.slider_x:SetWide( width ) --:SetSize(width, height)
	self.slider_y:SetWide( width ) --:SetSize(width, height)
	self.slider_z:SetWide( width ) --:SetSize(width, height)

	self.slider_x:SetPos(x, y1)
	self.slider_y:SetPos(x, y2)
	self.slider_z:SetPos(x, y3)
end

function XYZ_SLIDERS:GetValues()
	local x, y, z
	x = self.slider_x:GetValue()
	y = self.slider_y:GetValue()
	z = self.slider_z:GetValue()

	return Vector( x, y, z )
end

function XYZ_SLIDERS:SetValues( vec )
	self.slider_x:SetValue(vec.x)
	self.slider_y:SetValue(vec.y)
	self.slider_z:SetValue(vec.z)
end

function XYZ_SLIDERS:SetRange( x )
	self.slider_x:SetMinMax( -x, x )
	self.slider_y:SetMinMax( -x, x )
	self.slider_z:SetMinMax( -x, x )
end

function XYZ_SLIDERS:Paint()
end

vgui.Register("PA_XYZ_Sliders", XYZ_SLIDERS, "DPanel")