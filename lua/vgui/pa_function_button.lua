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

vgui.Register("PA_Function_Button", PA_Function_Button, "DButton")