local CONSTRAINT_TITLE_TEXT = {}
function CONSTRAINT_TITLE_TEXT:Init()
	self:SetSize( self:GetParent():GetWide(), 15 )
	self:SetFont("Default")
	self:SetContentAlignment(2)
end

vgui.Register("PA_Constraint_Title_Text", CONSTRAINT_TITLE_TEXT, "DLabel")