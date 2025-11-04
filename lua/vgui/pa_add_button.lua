local ADD_BUTTON = {}
function ADD_BUTTON:Init()
	self:SetSize(26, 25)
	self:SetText( "+" )
	self:SetTooltip( "Add this value to primary value" )
end

vgui.Register("PA_Add_Button", ADD_BUTTON, "PA_Function_Button")