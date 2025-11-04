local BGColor_Disabled   = PrecisionAlign.TOOLMODE_BACKGROUND_COLOR_DISABLED
local BGColor_Point      = PrecisionAlign.TOOLMODE_BACKGROUND_COLOR_POINT
local BGColor_Line       = PrecisionAlign.TOOLMODE_BACKGROUND_COLOR_LINE
local BGColor_Plane      = PrecisionAlign.TOOLMODE_BACKGROUND_COLOR_PLANE

local function_buttons_3_list = {}
local FUNCTION_BUTTON_3 = {}

function FUNCTION_BUTTON_3:Init()
	self:SetSize(110, 25)
	table.insert(function_buttons_3_list, self)

	self.DoClick = function()
		local T = self.selections
		local tab = self:GetParent()

		tab.activebutton = self

		tab.list_point_1:SetVisible(false)
		tab.list_point_2:SetVisible(false)
		tab.list_line_1:SetVisible(false)
		tab.list_plane_1:SetVisible(false)

		if T == PrecisionAlign.CONSTRUCT_POINT then
			tab.colour_panel_1:SetColour(BGColor_Point)
			tab.colour_panel_2:SetColour(BGColor_Point)
			tab.list_point_1:SetVisible(true)
			tab.list_point_2:SetVisible(true)
		elseif T == PrecisionAlign.CONSTRUCT_LINE then
			tab.colour_panel_1:SetColour(BGColor_Disabled)
			tab.colour_panel_2:SetColour(BGColor_Line)
			tab.list_line_1:SetVisible(true)
		elseif T == PrecisionAlign.CONSTRUCT_PLANE then
			tab.colour_panel_1:SetColour(BGColor_Disabled)
			tab.colour_panel_2:SetColour(BGColor_Plane)
			tab.list_plane_1:SetVisible(true)
		else
			tab.colour_panel_1:SetColour(BGColor_Disabled)
			tab.colour_panel_2:SetColour(BGColor_Disabled)
		end
	end
end

-- Override mouse functions (make it into a toggle button)
function FUNCTION_BUTTON_3:OnMousePressed()
	if not self.Depressed then
		-- pop up any previously depressed buttons
		for _, v in pairs (function_buttons_3_list) do
			if v.Depressed then
				v.Depressed = false
			end
		end
		self.Depressed = true
		return self.DoClick()
	end
end

function FUNCTION_BUTTON_3:OnMouseReleased()
end

vgui.Register("PA_Function_Button_3", FUNCTION_BUTTON_3, "DButton")