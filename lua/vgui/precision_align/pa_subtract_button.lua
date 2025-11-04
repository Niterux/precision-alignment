local SUBTRACT_BUTTON = {}
function SUBTRACT_BUTTON:Init()
	self:SetSize(26, 25)
	self:SetText( "-" )
	self:SetTooltip( "Subtract this value from primary value" )
end

vgui.Register("PA_Subtract_Button", SUBTRACT_BUTTON, "PA_Function_Button")