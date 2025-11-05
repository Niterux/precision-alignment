PrecisionAlign.ToolMode = PrecisionAlign.Class()
PrecisionAlign.ToolModes = {}

-- TODO: Modularize constructs?
local ConstructNames = {
    "Point",
    "Line",
    "Plane"
}
function PrecisionAlign.GetConstructName(Construct)
    return ConstructNames[Construct + 1]
end

function PrecisionAlign.ToolMode:__new(Construct, Name, SortIndex)
    self.ID = string.format("%s - %s", PrecisionAlign.GetConstructName(Construct), Name)
    self.Construct = Construct
    self.Name     = Name
    self.SortIndex = SortIndex
    PrecisionAlign.ToolModes[self.ID] = self
end

-- Not required, but this is the signature for those who wish to override the click position
-- function PrecisionAlign.ToolMode:GetClickPosition(Trace, Pos, Ent, Phys)

function PrecisionAlign.ToolMode:GetBackgroundColor()
    if self.Construct == PrecisionAlign.CONSTRUCT_POINT then
        return PrecisionAlign.TOOLMODE_BACKGROUND_COLOR_POINT
    elseif self.Construct == PrecisionAlign.CONSTRUCT_LINE then
        return PrecisionAlign.TOOLMODE_BACKGROUND_COLOR_LINE
    elseif self.Construct == PrecisionAlign.CONSTRUCT_PLANE then
        return PrecisionAlign.TOOLMODE_BACKGROUND_COLOR_PLANE
    else
        return PrecisionAlign.TOOLMODE_BACKGROUND_COLOR_DISPLAY
    end
end

function PrecisionAlign.GetToolModes()
    return SortedPairsByMemberValue(PrecisionAlign.ToolModes, "SortIndex")
end
