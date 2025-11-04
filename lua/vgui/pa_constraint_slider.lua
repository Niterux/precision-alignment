local CONSTRAINT_SLIDER = {}

function CONSTRAINT_SLIDER:Init()
	-- self:SetSize(130, 100) -- Keep the second number at 100
	self.Label:SetSize( 100 )
	self:SetMinMax( 0, 50000 )
end

-- Base this off PA_XYZ_Slider so the keyboard hook functions apply
vgui.Register("PA_Constraint_Slider", CONSTRAINT_SLIDER, "PA_XYZ_Slider")