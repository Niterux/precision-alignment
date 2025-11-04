local BGColor_Disabled   = PrecisionAlign.TOOLMODE_BACKGROUND_COLOR_DISABLED
local BGColor_Line       = PrecisionAlign.TOOLMODE_BACKGROUND_COLOR_LINE
local BGColor_Plane      = PrecisionAlign.TOOLMODE_BACKGROUND_COLOR_PLANE

local rotation_function_buttons_list = {}
local FUNCTION_BUTTON_ROTATION = {}

function FUNCTION_BUTTON_ROTATION:Init()
	self:SetSize(168, 25)
	table.insert(rotation_function_buttons_list, self)

	self.DoClick = function()
		local tab = self:GetParent()

		tab.activebutton = self
		tab:UpdateDescription()

		-- Optional pivot point / axis selections
		if self.options[1] ~= 0 then
			tab.list_pivotpoint:SetVisible(true)
		else
			tab.list_pivotpoint:SetVisible(false)
		end

		if self.options[2] ~= 0 then
			tab.list_line_axis:SetVisible(true)
		else
			tab.list_line_axis:SetVisible(false)
		end

		-- Main function selections
		if self.selections[1] ~= 0 then
			tab.colour_panel_1:SetColour(BGColor_Line)
			tab.list_line_1:SetVisible(true)
		else
			tab.colour_panel_1:SetColour(BGColor_Disabled)
			tab.list_line_1:SetVisible(false)
		end

		if self.selections[2] ~= 0 then
			tab.colour_panel_2:SetColour(BGColor_Line)
			tab.list_line_2:SetVisible(true)
		else
			tab.colour_panel_2:SetColour(BGColor_Disabled)
			tab.list_line_2:SetVisible(false)
		end

		if self.selections[3] ~= 0 then
			tab.colour_panel_3:SetColour(BGColor_Plane)
			tab.list_plane_1:SetVisible(true)
		else
			tab.colour_panel_3:SetColour(BGColor_Disabled)
			tab.list_plane_1:SetVisible(false)
		end

		if self.selections[4] ~= 0 then
			tab.colour_panel_4:SetColour(BGColor_Plane)
			tab.list_plane_2:SetVisible(true)
		else
			tab.colour_panel_4:SetColour(BGColor_Disabled)
			tab.list_plane_2:SetVisible(false)
		end
	end
end

-- Override mouse functions (make it into a toggle button)
function FUNCTION_BUTTON_ROTATION:OnMousePressed()
	if not self.Depressed then
		-- pop up any previously depressed buttons
		for _, v in pairs(rotation_function_buttons_list) do
			if v.Depressed then
				v.Depressed = false
			end
		end
		self.Depressed = true
		return self.DoClick()
	end
end

function FUNCTION_BUTTON_ROTATION:OnMouseReleased()
end

vgui.Register("PA_Function_Button_Rotation", FUNCTION_BUTTON_ROTATION, "DButton")