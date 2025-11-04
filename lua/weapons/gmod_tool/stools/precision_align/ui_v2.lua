if SERVER then return end

local PA = "precision_align"
local PA_ = PA .. "_"

PrecisionAlign.SelectedPoint = 1
PrecisionAlign.SelectedLine = 1
PrecisionAlign.SelectedPlane = 1

PrecisionAlign.ActiveEnt = nil

include("weapons/gmod_tool/stools/" .. PA .. "/manipulation_panel.lua")

local tooltypeCvar = GetConVar( PA_ .. "toolname" )

local CPanel = controlpanel.Get(PA)

do
    local PA_CPanel_tool_list = {}

    function PA_CPanel_tool_list:AddLine(ToolMode)
        local Line = self:Add("PA_ToolModeSelector")
        Line:SetMode(ToolMode)
        Line:Dock(TOP)
        Line:SetSize(0, 18)
        if tooltypeCvar:GetString() == ToolMode then
            Line:SelectNode()
        end
        return Line
    end

    function PA_CPanel_tool_list:Init()
        local H = 0
        for ToolMode in PrecisionAlign.GetToolModes() do
            local Line = self:AddLine(ToolMode)
            H = H + Line:GetTall()
        end

        self:SetSize(0, H)
    end

    function PA_CPanel_tool_list:GetSelectedNode()
        return self.SelectedNode
    end

    function PA_CPanel_tool_list:SetSelectedNode(Node)
        self.SelectedNode = Node
    end

    vgui.Register("PA_CPanel_tool_list", PA_CPanel_tool_list, "DPanel")
end

do
    local PA_ToolModeSelector = {}

    function PA_ToolModeSelector:SetMode(ToolMode)
        self.ToolMode = ToolMode
        local ToolModeObj = PrecisionAlign.ToolModes[ToolMode]
        if not ToolModeObj then return ErrorNoHalt("Couldn't set the mode!") end

        self.DrawColor                    = ToolModeObj:GetBackgroundColor():Copy()
        self.SelectedDrawColor            = self.DrawColor:Copy()
        self.SelectedHighlightedDrawColor = self.DrawColor:Copy()
        self.HighlightDrawColor           = self.DrawColor:Copy()
        self.DepressedDrawColor           = self.DrawColor:Copy()

        self.SelectedDrawColor:SetBrightness(0.95)
        self.SelectedHighlightedDrawColor:SetBrightness(1)
        self.HighlightDrawColor:SetBrightness(0.8)
        self.DepressedDrawColor:SetBrightness(0.5)

        self:SetText("")
    end

    function PA_ToolModeSelector:DoClick()
        self:SelectNode(self)
        self.SelectTime = RealTime()
        RunConsoleCommand( PA_ .. "toolname", self.ToolMode)
    end

    function PA_ToolModeSelector:IsSelectedNode()
        return self:GetParent():GetSelectedNode() == self
    end

    function PA_ToolModeSelector:SelectNode()
        self:GetParent():SetSelectedNode(self)
    end

    function PA_ToolModeSelector:Paint(width, height)
        local DrawColor
        local TextColor = color_black
        if self:IsSelectedNode() then
            if self.Hovered then
                if input.IsMouseDown(MOUSE_LEFT) then
                    DrawColor = self.DepressedDrawColor
                else
                    DrawColor = self.SelectedHighlightedDrawColor
                end
            else
                DrawColor = self.SelectedDrawColor
            end
            TextColor = color_white
        elseif input.IsMouseDown(MOUSE_LEFT) and self.Hovered then
            DrawColor = self.DepressedDrawColor
        elseif self.Hovered then
            DrawColor = self.HighlightDrawColor
        else
            DrawColor = self.DrawColor
        end

        surface.SetDrawColor(DrawColor)
        self:GetSkin().tex.Button(0, 0, width, height, DrawColor)

        draw.SimpleText(self.ToolMode or "UNKNOWN", "DermaDefault", 4, height / 2, TextColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    vgui.Register("PA_ToolModeSelector", PA_ToolModeSelector, "DButton")
end

-- Set up the full UI.
do
    CPanel:Clear()

    local tool_list = vgui.Create( "PA_CPanel_tool_list" )
    CPanel:AddItem( tool_list )
    CPanel.tool_list = tool_list
end