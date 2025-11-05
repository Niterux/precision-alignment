local MOVE_BUTTON = {}
function MOVE_BUTTON:SetFunction( func )
	self.DoClick = function()
		-- Alt to bring up stack number query
		local alt = LocalPlayer():KeyDown( IN_WALK )
		if alt then
			vgui.Create( "PA_Stack_Popup" )
			return
		end

		local ret = func()
		if ret == true then
			PrecisionAlign.PlaySoundTrue()
		elseif ret == false then
			PrecisionAlign.PlaySoundFalse()
		end
	end
end

function MOVE_BUTTON:Think()
	if IsValid(PrecisionAlign.ActiveEnt) and self:GetDisabled() then
		self:SetDisabled(false)
	elseif not IsValid(PrecisionAlign.ActiveEnt) and not self:GetDisabled() then
		self:SetDisabled(true)
	end
end

vgui.Register("PA_Move_Button", MOVE_BUTTON, "DButton")