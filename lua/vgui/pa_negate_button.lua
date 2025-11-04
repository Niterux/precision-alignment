local NEGATE_BUTTON = {}
function NEGATE_BUTTON:Init()
	self:SetSize(20, 20)
	self:SetText( "-" )
	self:SetTooltip( "Negate slider values" )
end

function NEGATE_BUTTON:SetSliders( panel )
	self:SetFunction( function()
		local v = panel:GetValues()
		panel:SetValues( Vector(-v.x, -v.y, -v.z) )
		return true
	end )
end

vgui.Register("PA_Negate_Button", NEGATE_BUTTON, "PA_Function_Button")