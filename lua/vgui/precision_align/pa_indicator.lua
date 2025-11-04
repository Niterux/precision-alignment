local PA_Indicator = {}

function PA_Indicator:Init()
    self.offset = 0
end

function PA_Indicator:PerformLayout()
    local offset = self:GetParent():GetListView().VBar:IsVisible() and self:GetParent():GetTall() - 4 or 0
    local width, height = self:GetParent():GetWide() - 5 - offset, self:GetParent():GetTall() - 4
    self:SetSize(height, height)
    self:SetPos(width - height, 2)
end

function PA_Indicator:Paint(w, h)
    local textbox = self:GetParent()
    if PrecisionAlign.Functions.construct_exists(textbox:GetListView().construct_type, textbox:GetID()) then
        local Pulse = Color(126, 255, 126)
        Pulse:SetBrightness(math.Remap(math.cos(RealTime() * 6), -1, 1, 0.89, 1))
        draw.RoundedBox(6, 0, 0, w, h, Pulse)
    end
end

vgui.Register("PA_Indicator", PA_Indicator, "DPanel")