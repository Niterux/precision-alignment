PrecisionAlign.ToolMode = PrecisionAlign.Class()
PrecisionAlign.ToolModes = {}

function PrecisionAlign.ToolMode:__new(Name, SortIndex)
    self.Name = Name
    self.SortIndex = SortIndex
    PrecisionAlign.ToolModes[self.Name] = self
end

-- Not required, but this is the signature for those who wish to override the click position
-- function PrecisionAlign.ToolMode:GetClickPosition(Trace, Pos, Ent, Phys)

function PrecisionAlign.GetToolModes()
    return SortedPairsByMemberValue(PrecisionAlign.ToolModes, "SortIndex")
end
