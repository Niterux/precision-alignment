local ZERO_BUTTON = {}
function ZERO_BUTTON:Init()
	self:SetSize(20, 20)
	self:SetText( "0" )
	self:SetTooltip( "Set slider values to 0" )
end

function ZERO_BUTTON:SetSliders( panel )
	self:SetFunction( function()
		panel:SetValues( Vector(0, 0, 0) )
		return true
	end )
end

vgui.Register("PA_Zero_Button", ZERO_BUTTON, "PA_Function_Button")