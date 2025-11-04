if SERVER then return end

local PA = "precision_align"
local PA_ = PA .. "_"

PrecisionAlign.SelectedPoint = 1
PrecisionAlign.SelectedLine = 1
PrecisionAlign.SelectedPlane = 1

PrecisionAlign.ActiveEnt = nil

include("weapons/gmod_tool/stools/" .. PA .. "/manipulation_panel.lua")

local pointcolour = PrecisionAlign.GetConstructColor(PrecisionAlign.CONSTRUCT_POINT):Copy()
local linecolour  = PrecisionAlign.GetConstructColor(PrecisionAlign.CONSTRUCT_LINE):Copy()
local planecolour = PrecisionAlign.GetConstructColor(PrecisionAlign.CONSTRUCT_PLANE):Copy()

pointcolour:SetBrightness(0.98)
pointcolour:SetSaturation(0.8)
linecolour:SetBrightness(0.98)
linecolour:SetSaturation(0.8)
planecolour:SetBrightness(0.98)
planecolour:SetSaturation(0.8)

local attachHCvar = GetConVar( PA_ .. "attachcolour_h" )
local attachSCvar = GetConVar( PA_ .. "attachcolour_s" )
local attachVCvar = GetConVar( PA_ .. "attachcolour_v" )
local attachACvar = GetConVar( PA_ .. "attachcolour_a" )
local tooltypeCvar = GetConVar( PA_ .. "toolname" )
local sizePointCvar = GetConVar( PA_ .. "size_point" )
local sizeLineStartCvar = GetConVar( PA_ .. "size_line_start" )
local sizeLineEndCvar = GetConVar( PA_ .. "size_line_end" )
local sizePlaneCvar = GetConVar( PA_ .. "size_plane" )
local sizePlaneNormCvar = GetConVar( PA_ .. "size_plane_normal" )

local CPanel = controlpanel.Get(PA)
local Warning = PrecisionAlign.Warning

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

local PA_manipulation_panel = false
local function precision_align_open_panel_func()
    if not PA_manipulation_panel then
        PA_manipulation_panel = vgui.Create( "PA_Manipulation_Frame" )
    else
        if PA_manipulation_panel:IsVisible() then
            RememberCursorPosition()
            PA_manipulation_panel:SetVisible(false)
        else
            PA_manipulation_panel:SetVisible(true)
            RestoreCursorPosition()
        end
    end
end
concommand.Add( PA_ .. "open_panel", precision_align_open_panel_func )

do
    local PA_ToolModeSelector = {}

    function PA_ToolModeSelector:SetMode(ToolMode)
        self.ToolMode = ToolMode
        local ToolModeObj = PrecisionAlign.ToolModes[ToolMode]
        if not ToolModeObj then return ErrorNoHalt("Couldn't set the mode!") end

        self.DrawColor                    = ToolModeObj:GetBackgroundColor():Copy()
        self.DrawColor:AddBrightness(0.08) -- To adjust for the default skin

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
            DrawColor = DrawColor:Copy()
            if not self.SelectTime then
                self.SelectTime = RealTime()
            end
            DrawColor:AddBrightness(math.Remap(math.cos((RealTime() - self.SelectTime) * 6), -1, 1, 0, -0.2))
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

do
    local PA_Indicator = {}

    function PA_Indicator:Init()
        self.offset = 0
    end

    function PA_Indicator:PerformLayout()
        local width, height = self:GetParent():GetWide() - 5 - self.offset, self:GetParent():GetTall() - 4
        self:SetSize(height, height)
        self:SetPos(width - height, 2)
    end

    function PA_Indicator:Paint()
        local textbox = self:GetParent()

        if PrecisionAlign.Functions.construct_exists(textbox:GetListView().construct_type, textbox:GetID()) then
            draw.RoundedBox(6, 0, 0, self:GetWide(), self:GetTall(), Color(121, 247, 121))
        end
    end

    vgui.Register("PA_Indicator", PA_Indicator, "DPanel")
end
do
    local PA_ConstructList = {}

    function PA_ConstructList:Init()
        self:AddColumn("")
        self:SetHideHeaders(true)
        self:SetMultiSelect(false)
    end

    function PA_ConstructList:Setup(Construct, Click, DbClick)
        self.construct_type = Construct
        local Name = PrecisionAlign.GetConstructName(Construct)
        for I = 1, 9 do
            local Line = self:AddLine(Name .. " " .. I)
            Line.Indicator = Line:Add "PA_Indicator"
        end

        if Click then
            self.OnRowSelected = function(_, Line) Click(Line) end
        end

        if DbClick then
            self.DoDoubleClick = function(_, Line) DbClick(Line) end
        end

        self:SelectFirstItem()
    end

    vgui.Register("PA_ConstructList", PA_ConstructList, "DListView")
end

do
    local PA_ConstructSelectionPanel = {}

    function PA_ConstructSelectionPanel:PerformLayout(w, h)
        if not IsValid(self.Left) then return end

        local Padding = 4
        if IsValid(self.Right) then
            self.Left:SetPos(Padding, Padding)
            self.Left:SetSize((w / 2) - Padding, h - (Padding * 2))

            self.Right:SetPos(Padding + (w / 2), Padding)
            self.Right:SetSize((w / 2) - Padding, h - (Padding * 2))
        else
            self.Left:SetPos(Padding, Padding)
            self.Left:SetSize(w - (Padding * 2), h - (Padding * 2))
        end
    end

    function PA_ConstructSelectionPanel:Setup(Construct, LeftClick, LeftDbClick, RightClick, RightDbClick)
        self.Left = self:Add("PA_ConstructList")
        self.Left:Setup(Construct, LeftClick, LeftDbClick)
        if RightClick and RightDbClick then
            self.Right = self:Add("PA_ConstructList")
            self.Right:Setup(Construct, RightClick, RightDbClick)
        end

        return self.Left, self.Right
    end

    vgui.Register("PA_ConstructSelectionPanel", PA_ConstructSelectionPanel, "DPanel")
end

do
    local PA_ButtonFlex = {}

    function PA_ButtonFlex:Init()
        self:SetPaintBackground(false)
    end

    function PA_ButtonFlex:PerformLayout(w, h)
        local Children = self:GetChildren()
        local ChildrenCount = #Children
        local Padding = 2
        for I, Child in ipairs(Children) do
            local X = Padding + math.Remap(I, 1, ChildrenCount + 1, 0, w)
            Child:SetPos(X, Padding)
            Child:SetSize((w - (Padding * 2)) / ChildrenCount, h - Padding)
        end
    end

    vgui.Register("PA_ButtonFlex", PA_ButtonFlex, "DPanel")
end

do
    local PA_Tool_Construct_Panel = {}
    function PA_Tool_Construct_Panel:SetConstructType(Construct)
        self.Header.Text = string.upper(PrecisionAlign.GetConstructName(Construct)) .. ""
        self.Header.Color = (Construct and PrecisionAlign.GetConstructColor(Construct) or color_black)
        self.Construct = Construct
    end

    function PA_Tool_Construct_Panel:SetTextColor(Text, Color)
        self.Header.Text = Text
        self.Header.Color = Color
    end

    function PA_Tool_Construct_Panel:SetSelectionMode(LeftClick, LeftDbClick, RightClick, RightDbClick)
        if IsValid(self.Selection) then self.Selection:Remove() end
        self.Selection = self:Add("PA_ConstructSelectionPanel")
        self.Selection:Dock(FILL)
        return self.Selection:Setup(self.Construct, LeftClick, LeftDbClick, RightClick, RightDbClick)
    end

    function PA_Tool_Construct_Panel:AddButtons(CanMoveEntity)
        local text = string.lower(PrecisionAlign.GetConstructName(self.Construct))

        local MoveBtn
        if CanMoveEntity then
            local MoveBtnContainer = self:Add("PA_ButtonFlex")
            MoveBtnContainer:Dock(BOTTOM)
            MoveBtnContainer:SetSize(0, 20)

            MoveBtn = MoveBtnContainer:Add("PA_Function_Button")
            MoveBtn:SetText("Move Entity")
            MoveBtn:SetTooltip("Move entity from left selected " .. text .. " -> right selected " .. text)
        end

        local Attach_DeleteAll = self:Add("PA_ButtonFlex")
        Attach_DeleteAll:Dock(BOTTOM)
        Attach_DeleteAll:SetSize(0, 20)

        local AttachBtn    = Attach_DeleteAll:Add("PA_Function_Button")
        AttachBtn:SetText("Attach")
        AttachBtn:SetTooltip("Attach " .. text .. " to selected entity (detach if no ent selected)")

        local DeleteAllBtn = Attach_DeleteAll:Add("PA_Function_Button")
        DeleteAllBtn:SetText("Delete All")
        DeleteAllBtn:SetTooltip("Delete all " .. text .. "s")

        local View_Delete = self:Add("PA_ButtonFlex")
        View_Delete:Dock(BOTTOM)
        View_Delete:SetSize(0, 20)

        local ViewBtn   = View_Delete:Add("PA_Function_Button")
        ViewBtn:SetText("View")
        ViewBtn:SetTooltip("View the selected " .. text)

        local DeleteBtn = View_Delete:Add("PA_Function_Button")
        DeleteBtn:SetTooltip("Delete the selected " .. text)
        DeleteBtn:SetText("Delete")

        return ViewBtn, DeleteBtn, AttachBtn, DeleteAllBtn, MoveBtn
    end

    function PA_Tool_Construct_Panel:Init()
        self:Dock(TOP)
        self:SetSize(0, 170)
        self.Header = self:Add("DButton")
        self.Header:Dock(TOP)
        self.Header:SetSize(0, 14)
        self.Header:SetText("")
        self.Header.DefaultColor = color_black
        self.Header.Paint = self.PaintButton
    end

    function PA_Tool_Construct_Panel:Paint()

    end

    function PA_Tool_Construct_Panel:PaintButton(w, h)
        local BackColor =  (self.Color or color_black):Copy()
        if self.Hovered then
            if input.IsMouseDown(MOUSE_LEFT) then
                BackColor:AddBrightness(-0.2)
                BackColor:AddSaturation(0.14)
            else
                BackColor:AddBrightness(0.1)
                BackColor:AddSaturation(0.1)
            end
        end

        local drawBack = w - 140
        draw.RoundedBox(6, w / 2 - (drawBack / 2), 0, drawBack, h, BackColor)
        draw.SimpleText(self.Text or "INVALID", "Default", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    vgui.Register("PA_Tool_Construct_Panel", PA_Tool_Construct_Panel, "DPanel")
end

local function play_sound_true()
    LocalPlayer():EmitSound("buttons/button15.wav", 100, 100)
end

local function play_sound_false()
    LocalPlayer():EmitSound("buttons/lightswitch2.wav", 100, 100)
end

do
    local PA_Function_Button = {}

    function PA_Function_Button:Init()
        self:SetSize(200, 25)
    end

    function PA_Function_Button:SetFunction( func )
        self.DoClick = function()
            local ret = func()
            if ret == true then
                play_sound_true()
            elseif ret == false then
                play_sound_false()
            end
        end
    end

    vgui.Register("PA_Function_Button", PA_Function_Button, "DButton")
end

-- Set up the full UI.
do
    CPanel:Clear()

    local ToolList = vgui.Create "PA_CPanel_tool_list"
    CPanel:AddItem(ToolList)
    CPanel.ToolList = ToolList

    local CheckboxHelpContainer = vgui.Create "DPanel"
    CPanel:AddItem(CheckboxHelpContainer)
    CheckboxHelpContainer:SetPaintBackground(false)
    CheckboxHelpContainer:Dock(TOP)
    CheckboxHelpContainer:SetSize(0, 54)

    local HelpContainer = CheckboxHelpContainer:Add("DPanel")

    HelpContainer:SetPaintBackground(false)
    HelpContainer:Dock(RIGHT)
    HelpContainer:SetSize(64, 0)

    local Help = HelpContainer:Add("DButton")
    Help:SetText("Help")
    Help:Dock(TOP)

    local Checkboxes = CheckboxHelpContainer:Add("DPanel")

    Checkboxes:SetPaintBackground(false)
    Checkboxes:Dock(FILL)

    local EnableConstructDisplays = Checkboxes:Add("DCheckBoxLabel")
    EnableConstructDisplays:Dock(TOP)
    EnableConstructDisplays:SetDark(true)
    EnableConstructDisplays:SetText("Enable Construct Displays")
    EnableConstructDisplays:SetValue(1)
    EnableConstructDisplays:SetTooltip("Show/Hide all constructs")
    EnableConstructDisplays:DockMargin(0, 0, 0, 4)
    function EnableConstructDisplays:OnChange()
        LocalPlayer():ConCommand(PA_ .. "displayhud")
    end

    local SnapToEdges = Checkboxes:Add("DCheckBoxLabel")
    SnapToEdges:Dock(TOP)
    SnapToEdges:SetDark(true)
    SnapToEdges:SetText("Snap to Edges")
    SnapToEdges:SetTooltip("Snap to the edges of props when placing constructs")
    SnapToEdges:SetConVar(PA_ .. "edge_snap")
    SnapToEdges:DockMargin(0, 0, 0, 4)

    local SnapToCentreLines = Checkboxes:Add("DCheckBoxLabel")
    SnapToCentreLines:Dock(TOP)
    SnapToCentreLines:SetDark(true)
    SnapToCentreLines:SetText("Snap to Centre Lines")
    SnapToCentreLines:SetTooltip("Snap to the centre-lines of props when placing constructs")
    SnapToCentreLines:SetConVar(PA_ .. "centre_snap")
    SnapToCentreLines:DockMargin(0, 0, 0, 4)

    local SnapSensitivity = vgui.Create "DNumSlider"
    CPanel:AddItem(SnapSensitivity)
    SnapSensitivity:Dock(TOP)
    SnapSensitivity:SetDark(true)
    SnapSensitivity:SetText("Snap Sensitivity")
    SnapSensitivity:SetMinMax(0.1, 100)
    SnapSensitivity:SetDecimals(1)
    SnapSensitivity:SetSize(0, 24)
    SnapSensitivity.Slider:SetNotches(SnapSensitivity.Slider:GetWide() / 4)
    SnapSensitivity:SetTooltip("Sets the maximum distance for edge/centre snap detection (in units)")
    SnapSensitivity:SetConVar(PA_ .. "snap_distance")

    local Points = vgui.Create("PA_Tool_Construct_Panel")
    CPanel.point_window = Points
    CPanel:AddItem(Points)
    Points:SetConstructType(PrecisionAlign.CONSTRUCT_POINT)

    local function SelectPoint(ID) PrecisionAlign.SelectedPoint = ID end
    local function SelectPoint2() end
    local function PointDbClick(ID)
        local panel = PA_manipulation_panel.points_tab
        Open_Manipulation_Tab(panel.tab)
        Listview_DoDoubleClick(panel.list_primarypoint, ID)
    end
    Points.list_primarypoint, Points.list_secondarypoint = Points:SetSelectionMode(SelectPoint, PointDbClick, SelectPoint2, PointDbClick) -- Assignment for backwards compat
    do
        local View, Delete, Attach, DeleteAll, MoveEntity = Points:AddButtons(true)
        MoveEntity:SetFunction(function()
            PrecisionAlign.SelectedPoint2 = Points.list_secondarypoint:GetSelectedLine()
            if PrecisionAlign.SelectedPoint == PrecisionAlign.SelectedPoint2 then
                Warning("Cannot move between the same point!")
                return false
            end

            local point1 = PrecisionAlign.Functions.point_global( PrecisionAlign.SelectedPoint )
            local point2 = PrecisionAlign.Functions.point_global( PrecisionAlign.SelectedPoint2 )

            if not point1 or not point2 then
                Warning("Points not correctly defined")
                return false
            end

            if not PrecisionAlign.Functions.move_entity(point1.origin, point2.origin, PrecisionAlign.ActiveEnt) then return false end
        end)
    end
    local Lines  = vgui.Create("PA_Tool_Construct_Panel")
    CPanel.line_window = Lines
    CPanel:AddItem(Lines)
    Lines:SetConstructType(PrecisionAlign.CONSTRUCT_LINE)
    Lines.list_line = Lines:SetSelectionMode(false) -- Assignment for backwards compat
    do
        local View, Delete, Attach, DeleteAll = Lines:AddButtons()
    end

    local Planes = vgui.Create("PA_Tool_Construct_Panel")
    CPanel.plane_window = Planes
    CPanel:AddItem(Planes)
    Planes:SetConstructType(PrecisionAlign.CONSTRUCT_PLANE)
    Planes.list_plane = Planes:SetSelectionMode(false) -- Assignment for backwards compat
    do
        local View, Delete, Attach, DeleteAll = Planes:AddButtons()
    end
end

-- Networking
-- Called when the server sends click data - used to add a new point/line
local function umsg_click_hook()
    local point = Vector(net.ReadFloat(), net.ReadFloat(), net.ReadFloat())
    local normal = Vector(net.ReadFloat(), net.ReadFloat(), net.ReadFloat())
    local ent = net.ReadEntity()

    local shift = LocalPlayer():KeyDown(IN_SPEED)
    local alt = LocalPlayer():KeyDown(IN_WALK)

    local tooltype = tooltypeCvar:GetString()
    local ToolMode = PrecisionAlign.ToolModes[tooltype]

    ToolMode:OnClick(ent, point, normal, shift, alt)
end
net.Receive(PA_ .. "click", umsg_click_hook)

-- Called when the server sends entity data - so the client knows which entity is selected
local function umsg_entity_hook()
    PrecisionAlign.ActiveEnt = net.ReadEntity()
end
net.Receive(PA_ .. "ent", umsg_entity_hook)

-- HUD display
do
    local point_size_min = math.max( sizePointCvar:GetInt(), 1 )
    local point_size_max = sizePointCvar:GetInt() * 1000

    local line_size_start = sizeLineStartCvar:GetInt()
    local line_size_min = sizeLineEndCvar:GetInt() -- End (double bar)
    local line_size_max = line_size_min * 1000

    local plane_size = sizePlaneCvar:GetInt()
    local plane_size_normal = sizePlaneNormCvar:GetInt()
    local text_min, text_max = 1, 4500

    local draw_attachments = LocalPlayer():GetInfo( PA_ .. "draw_attachments" )

    cvars.AddChangeCallback( PA_ .. "size_point", function( _, _, New ) point_size_min = tonumber(math.max(New, 1)); point_size_max = tonumber(New) * 1000 end )
    cvars.AddChangeCallback( PA_ .. "size_line_start",  function( _, _, New ) line_size_start = tonumber(New) end  )
    cvars.AddChangeCallback( PA_ .. "size_line_end",  function( _, _, New ) line_size_min = tonumber(New); line_size_max  = line_size_min * 1000 end  )
    cvars.AddChangeCallback( PA_ .. "size_plane", function( _, _, New ) plane_size = tonumber(New) end  )
    cvars.AddChangeCallback( PA_ .. "size_plane_normal", function( _, _, New ) plane_size_normal = tonumber(New) end  )

    -- Manage attachment line colour changes
    local H = attachHCvar:GetInt()
    local S = attachSCvar:GetInt()
    local V = attachVCvar:GetInt()
    local A = attachACvar:GetInt()
    local attachcolourHSV = { h = H, s = S, v = V, a = A }
    local attachcolourRGB = HSVToColor( H, S, V )
    attachcolourRGB.a = A

    local function SetAttachColour(CVar, _, New)
        if CVar == PA_ .. "attachcolour_h" then
            attachcolourHSV.h = New
        elseif CVar == PA_ .. "attachcolour_s" then
            attachcolourHSV.s = New
        elseif CVar == PA_ .. "attachcolour_v" then
            attachcolourHSV.v = New
        elseif CVar == PA_ .. "attachcolour_a" then
            attachcolourHSV.a = New
        end

        attachcolourRGB = HSVToColor( attachcolourHSV.h, attachcolourHSV.s, attachcolourHSV.v )
        attachcolourRGB.a = attachcolourHSV.a
    end

    cvars.AddChangeCallback( PA_ .. "attachcolour_h", SetAttachColour )
    cvars.AddChangeCallback( PA_ .. "attachcolour_s", SetAttachColour )
    cvars.AddChangeCallback( PA_ .. "attachcolour_v", SetAttachColour )
    cvars.AddChangeCallback( PA_ .. "attachcolour_a", SetAttachColour )


    local function inview( pos2D )
        if	pos2D.x > -ScrW() and
            pos2D.y > -ScrH() and
            pos2D.x < ScrW() * 2 and
            pos2D.y < ScrH() * 2 then
                return true
        end
        return false
    end

    -- HUD draw function
    local function precision_align_draw()
        local playerpos = LocalPlayer():GetShootPos()

        -- Points
        for k, v in ipairs (PrecisionAlign.Points) do
            if v.visible and v.origin then

                --Check if point exists
                local point_temp = PrecisionAlign.Functions.point_global(k)
                if point_temp then
                    local origin = point_temp.origin
                    local point = origin:ToScreen()
                    if inview( point ) then
                        local distance = playerpos:Distance( origin )
                        local size = math.Clamp( point_size_max / distance, point_size_min, point_size_max )
                        local text_dist = math.Clamp(text_max / distance, text_min, text_max)

                        surface.SetDrawColor( pointcolour.r, pointcolour.g, pointcolour.b, pointcolour.a )

                        surface.DrawLine( point.x - size, point.y, point.x + size, point.y )
                        surface.DrawLine( point.x, point.y + size, point.x, point.y - size )

                        draw.DrawText( tostring(k), "Default", point.x + text_dist, point.y + text_dist / 1.5, Color(pointcolour.r, pointcolour.g, pointcolour.b, pointcolour.a), 0 )

                        -- Draw attachment line
                        if draw_attachments and IsValid(v.entity) then
                            local entpos = v.entity:GetPos():ToScreen()
                            surface.SetDrawColor( attachcolourRGB.r, attachcolourRGB.g, attachcolourRGB.b, attachcolourRGB.a )
                            surface.DrawLine( point.x, point.y, entpos.x, entpos.y )
                        end
                    end
                end
            end
        end

        -- Lines
        for k, v in ipairs (PrecisionAlign.Lines) do
            if v.visible and v.startpoint and v.endpoint then

                --Check if line exists
                local line_temp = PrecisionAlign.Functions.line_global(k)
                if line_temp then
                    local startpoint = line_temp.startpoint
                    local endpoint = line_temp.endpoint

                    local line_start = startpoint:ToScreen()
                    local line_end = endpoint:ToScreen()

                    local distance1 = playerpos:Distance( startpoint )
                    local distance2 = playerpos:Distance( endpoint )

                    local size2 = math.Clamp(line_size_max / distance2, line_size_min, line_size_max)
                    local text_dist = math.Clamp(text_max / distance1, text_min, text_max)

                    surface.SetDrawColor( linecolour.r, linecolour.g, linecolour.b, linecolour.a )

                    -- Start X
                    local normal = (endpoint - startpoint):GetNormal()
                    local dir1, dir2

                    if IsValid(v.entity) then
                        local up = v.entity:GetUp()
                        if normal:Dot(up) < 0.9 then
                            dir1 = (normal:Cross(up)):GetNormal()
                        else
                            dir1 = (normal:Cross(v.entity:GetForward())):GetNormal()
                        end
                    else
                        if math.abs(normal.z) < 0.9 then
                            dir1 = (normal:Cross(Vector(0, 0, 1))):GetNormal()
                        else
                            dir1 = (normal:Cross(Vector(1, 0, 0))):GetNormal()
                        end
                    end

                    dir2 = (dir1:Cross(normal)):GetNormal() * line_size_start
                    dir1 = dir1 * line_size_start

                    local v1 = (startpoint + dir1 + dir2):ToScreen()
                    local v2 = (startpoint - dir1 + dir2):ToScreen()
                    local v3 = (startpoint - dir1 - dir2):ToScreen()
                    local v4 = (startpoint + dir1 - dir2):ToScreen()

                    -- Start X
                    if inview( line_start ) then
                        surface.DrawLine(v1.x, v1.y, v3.x, v3.y)
                        surface.DrawLine(v2.x, v2.y, v4.x, v4.y)
                    end

                    -- Line
                    surface.DrawLine( line_start.x, line_start.y, line_end.x, line_end.y )

                    -- End =
                    if inview( line_end ) then
                        local line_dir_2D = Vector(line_end.x - line_start.x, line_end.y - line_start.y, 0):GetNormalized()
                        local norm_dir_2D = {x = -line_dir_2D.y, y = line_dir_2D.x}
                        surface.DrawLine( line_end.x - norm_dir_2D.x * size2, line_end.y - norm_dir_2D.y * size2,
                                        line_end.x + norm_dir_2D.x * size2, line_end.y + norm_dir_2D.y * size2 )
                        surface.DrawLine( line_end.x + (line_dir_2D.x / 3 - norm_dir_2D.x) * size2, line_end.y + (line_dir_2D.y / 3 - norm_dir_2D.y) * size2,
                                        line_end.x + (line_dir_2D.x / 3 + norm_dir_2D.x) * size2, line_end.y + (line_dir_2D.y / 3 + norm_dir_2D.y) * size2 )
                    end

                    draw.DrawText( tostring(k), "Default", line_start.x + text_dist, line_start.y - text_dist / 1.5 - 15, Color(linecolour.r, linecolour.g, linecolour.b, linecolour.a), 3 )

                    -- Draw attachment line
                    if draw_attachments and IsValid(v.entity) then
                        local entpos = v.entity:GetPos():ToScreen()
                        surface.SetDrawColor( attachcolourRGB.r, attachcolourRGB.g, attachcolourRGB.b, attachcolourRGB.a )
                        surface.DrawLine( line_start.x, line_start.y, entpos.x, entpos.y )
                    end
                end
            end
        end

        -- Planes
        for k, v in ipairs ( PrecisionAlign.Planes ) do
            if v.visible and v.origin and v.normal then

                -- Check if plane exists
                local plane_temp = PrecisionAlign.Functions.plane_global(k)
                if plane_temp then

                    local origin = plane_temp.origin
                    local normal = plane_temp.normal

                    -- Draw normal line
                    local line_start = origin:ToScreen()
                    if inview( line_start ) then

                        local line_end = ( origin + normal * plane_size_normal ):ToScreen()

                        local distance = playerpos:Distance( origin )
                        local text_dist = math.Clamp(text_max / distance, text_min, text_max)

                        surface.SetDrawColor( planecolour.r, planecolour.g, planecolour.b, planecolour.a )
                        surface.DrawLine( line_start.x, line_start.y, line_end.x, line_end.y )

                        -- Draw plane surface
                        local dir1, dir2
                        if IsValid( v.entity ) then
                            local up = v.entity:GetUp()
                            dir1 = math.abs( normal:Dot( up ) ) < 0.9 and up or v.entity:GetForward()
                        else
                            dir1 = math.abs( normal.z ) < 0.9 and Vector( 0, 0, 1 ) or Vector( 1, 0, 0 )
                        end

                        dir1 = ( normal:Cross( dir1 ) ):GetNormal()
                        dir2 = ( dir1:Cross( normal ) ):GetNormal() * plane_size
                        dir1 = dir1 * plane_size

                        local v1 = ( origin + dir1 + dir2 ):ToScreen()
                        local v2 = ( origin - dir1 + dir2 ):ToScreen()
                        local v3 = ( origin - dir1 - dir2 ):ToScreen()
                        local v4 = ( origin + dir1 - dir2 ):ToScreen()

                        surface.DrawLine( v1.x, v1.y, v2.x, v2.y )
                        surface.DrawLine( v2.x, v2.y, v3.x, v3.y )
                        surface.DrawLine( v3.x, v3.y, v4.x, v4.y )
                        surface.DrawLine( v4.x, v4.y, v1.x, v1.y )

                        draw.DrawText( tostring( k ), "Default", line_start.x - text_dist, line_start.y + text_dist / 1.5, Color( planecolour.r, planecolour.g, planecolour.b, planecolour.a ), 1 )
                        -- Default
                        -- Draw attachment line
                        if draw_attachments and IsValid(v.entity) then
                            local entpos = v.entity:GetPos():ToScreen()
                            surface.SetDrawColor( attachcolourRGB.r, attachcolourRGB.g, attachcolourRGB.b, attachcolourRGB.a )
                            surface.DrawLine( line_start.x, line_start.y, entpos.x, entpos.y )
                        end
                    end
                end
            end
        end
    end
    hook.Add("HUDPaint", "draw_precision_align", precision_align_draw)


    local function precision_align_displayhud_func( _, _, args )
        local enabled = tobool( args[1] )
        if not enabled then
            hook.Remove( "HUDPaint", "draw_precision_align" )
        else
            hook.Add("HUDPaint", "draw_precision_align", precision_align_draw)
        end
        return true
    end
    concommand.Add( PA_ .. "displayhud", precision_align_displayhud_func )
end