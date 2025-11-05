local UPDATE_BUTTON = {}
function UPDATE_BUTTON:Init()
	self:SetSize(90, 25)
	self:SetText( "Update" )
	self:SetTooltip( "Update other sliders according to these values" )
end

vgui.Register("PA_Update_Button", UPDATE_BUTTON, "PA_Function_Button")