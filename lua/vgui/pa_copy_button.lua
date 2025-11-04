local COPY_BUTTON = {}
function COPY_BUTTON:Init()
	self:SetSize(26, 25)
	self:SetText( "=" )
	self:SetTooltip( "Set primary value equal to secondary" )
end

vgui.Register("PA_Copy_Button", COPY_BUTTON, "PA_Function_Button")

local COPY_RIGHT_BUTTON = {}
function COPY_RIGHT_BUTTON:Init()
	self:SetSize(26, 25)
	self:SetText( ">" )
	self:SetTooltip( "Copy value across to secondary slider" )
end

vgui.Register("PA_Copy_Right_Button", COPY_RIGHT_BUTTON, "PA_Function_Button")


local COPY_LEFT_BUTTON = {}
function COPY_LEFT_BUTTON:Init()
	self:SetSize(26, 25)
	self:SetText( "<" )
	self:SetTooltip( "Copy value across to primary slider" )
end

vgui.Register("PA_Copy_Left_Button", COPY_LEFT_BUTTON, "PA_Function_Button")