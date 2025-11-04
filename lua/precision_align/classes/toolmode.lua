PrecisionAlign.ToolMode = PrecisionAlign.Class()
PrecisionAlign.ToolModes = {}

function PrecisionAlign.ToolMode:__new(Name, SortIndex)
    self.Name = Name
    self.SortIndex = SortIndex
    PrecisionAlign.ToolModes[self.Name] = SortIndex
end

function PrecisionAlign.GetToolModes()
    return SortedPairsByValue(PrecisionAlign.ToolModes)
end
