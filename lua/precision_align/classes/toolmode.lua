PrecisionAlign.ToolMode = PrecisionAlign.Class()
PrecisionAlign.ToolModes = {}

-- TODO: Modularize constructs?
local ConstructNames = {
    "Point",
    "Line",
    "Plane"
}
local ConstructColors = {
    function() return PrecisionAlign.TOOLMODE_BACKGROUND_COLOR_POINT end,
    function() return PrecisionAlign.TOOLMODE_BACKGROUND_COLOR_LINE end,
    function() return PrecisionAlign.TOOLMODE_BACKGROUND_COLOR_PLANE end
}

function PrecisionAlign.GetConstructName(Construct)
    return ConstructNames[Construct + 1]
end

function PrecisionAlign.GetConstructColor(Construct)
    return ConstructColors[Construct + 1]()
end

function PrecisionAlign.ToolMode:__new(Construct, Name, SortIndex)
    self.ID = string.format("%s - %s", PrecisionAlign.GetConstructName(Construct), Name)
    self.Construct = Construct
    self.Name     = Name
    self.SortIndex = SortIndex
    PrecisionAlign.ToolModes[self.ID] = self
end

function PrecisionAlign.ToolMode:GetName()
    return self.Name
end

-- Not required, but this is the signature for those who wish to override the click position
-- function PrecisionAlign.ToolMode:GetClickPosition(Trace, Pos, Ent, Phys)

function PrecisionAlign.ToolMode:GetBackgroundColor()
    return ConstructColors[self.Construct + 1]()
end

function PrecisionAlign.GetToolModes()
    return SortedPairsByMemberValue(PrecisionAlign.ToolModes, "SortIndex")
end
