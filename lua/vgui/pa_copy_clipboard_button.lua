local COPY_CLIPBOARD_BUTTON = {}
function COPY_CLIPBOARD_BUTTON:Init()
	self:SetSize(40, 20)
	self:SetText( "Copy" )
	self:SetTooltip( "Copy values to clipboard" )
end

function COPY_CLIPBOARD_BUTTON:SetSliders( panel )
	self:SetFunction( function()
		local v = panel:GetValues()
		-- Format string for better use with E2
		local x = tostring( math.Round(v.x * 1000) / 1000 )
		local y = tostring( math.Round(v.y * 1000) / 1000 )
		local z = tostring( math.Round(v.z * 1000) / 1000 )

		local str = x .. ", " .. y .. ", " .. z
		SetClipboardText( str )
		return true
	end )
end

vgui.Register("PA_Copy_Clipboard_Button", COPY_CLIPBOARD_BUTTON, "PA_Function_Button")