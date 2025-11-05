local PA_Function_Button = {}

function PA_Function_Button:Init()
    self:SetSize(200, 25)
end

function PA_Function_Button:SetFunction( func )
    self.DoClick = function()
        local ret = func()
        if ret == true then
            PrecisionAlign.PlaySoundTrue()
        elseif ret == false then
            PrecisionAlign.PlaySoundFalse()
        end
    end
end

function PA_Function_Button:SetHoverFunction(Hover, HoverEnter, HoverExit, ...)
    local WasHovering = false
    local HoverStartTime = RealTime()
    hook.Add("Think", self, function()
        local Hovering = vgui.GetHoveredPanel() == self
        if Hovering and not WasHovering and HoverEnter then
            HoverStartTime = RealTime()
            HoverEnter(self, HoverStartTime)
        end

        if Hovering and Hover then Hover(self, RealTime() - HoverStartTime) end

        if not Hovering and WasHovering and HoverExit then
            HoverExit(self, RealTime() - HoverStartTime)
            HoverStartTime = 0
        end
        WasHovering = Hovering
    end)
end

vgui.Register("PA_Function_Button", PA_Function_Button, "DButton")