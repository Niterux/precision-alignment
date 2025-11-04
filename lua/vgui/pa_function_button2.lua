local BGColor_Disabled   = PrecisionAlign.TOOLMODE_BACKGROUND_COLOR_DISABLED
local BGColor_Point      = PrecisionAlign.TOOLMODE_BACKGROUND_COLOR_POINT
local BGColor_Line       = PrecisionAlign.TOOLMODE_BACKGROUND_COLOR_LINE
local BGColor_Plane      = PrecisionAlign.TOOLMODE_BACKGROUND_COLOR_PLANE

local function_buttons_2_list = {}
local FUNCTION_BUTTON_2 = {}

function FUNCTION_BUTTON_2:Init()
	self:SetSize(130, 25)
	table.insert(function_buttons_2_list, self)

	self.DoClick = function()
		local T = self.selections
		local tab = self:GetParent()

		tab.activebutton = self
		tab:UpdateDescription()

		tab.list_point_primary:SetVisible(false)
		tab.list_line_primary:SetVisible(false)
		tab.list_plane_primary:SetVisible(false)

		if T[1] == PrecisionAlign.CONSTRUCT_POINT then
			tab.colour_panel_1:SetColour(BGColor_Point)
			tab.list_point_primary:SetVisible(true)
		elseif T[1] == PrecisionAlign.CONSTRUCT_LINE then
			tab.colour_panel_1:SetColour(BGColor_Line)
			tab.list_line_primary:SetVisible(true)
		elseif T[1] == PrecisionAlign.CONSTRUCT_PLANE then
			tab.colour_panel_1:SetColour(BGColor_Plane)
			tab.list_plane_primary:SetVisible(true)
		else
			tab.colour_panel_1:SetColour(BGColor_Disabled)
		end

		if T[2] ~= 0 then
			--tab.point_text:SetText( "Select " .. tostring(T[2]) )
			tab.colour_panel_2:SetColour(BGColor_Point)
			tab.list_point_secondary:SetVisible(true)
		else
			--tab.point_text:SetText( "" )
			tab.colour_panel_2:SetColour(BGColor_Disabled)
			tab.list_point_secondary:SetVisible(false)
		end

		if T[3] ~= 0 then
			--tab.line_text:SetText( "Select " .. tostring(T[3]) )
			tab.colour_panel_3:SetColour(BGColor_Line)
			tab.list_line_secondary:SetVisible(true)
		else
			--tab.line_text:SetText( "" )
			tab.colour_panel_3:SetColour(BGColor_Disabled)
			tab.list_line_secondary:SetVisible(false)
		end

		if T[4] ~= 0 then
			--tab.plane_text:SetText( "Select " .. tostring(T[4]) )
			tab.colour_panel_4:SetColour(BGColor_Plane)
			tab.list_plane_secondary:SetVisible(true)
		else
			--tab.plane_text:SetText( "" )
			tab.colour_panel_4:SetColour(BGColor_Disabled)
			tab.list_plane_secondary:SetVisible(false)
		end
	end
end

-- Override mouse functions (make it into a toggle button)
function FUNCTION_BUTTON_2:OnMousePressed()
	if not self.Depressed then
		-- pop up any previously depressed buttons
		for _, v in pairs(function_buttons_2_list) do
			if v.Depressed then
				v.Depressed = false
			end
		end
		self.Depressed = true
		return self.DoClick()
	end
end

function FUNCTION_BUTTON_2:OnMouseReleased()
end

vgui.Register("PA_Function_Button_2", FUNCTION_BUTTON_2, "DButton")