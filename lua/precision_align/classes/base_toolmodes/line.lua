PrecisionAlign.LineToolMode = PrecisionAlign.Class(PrecisionAlign.ToolMode)
function PrecisionAlign.LineToolMode:__new(Name, SortIndex)
    PrecisionAlign.ToolMode.__new(self, PrecisionAlign.CONSTRUCT_LINE, Name, SortIndex)
end

local PA = PrecisionAlign.PA
function PrecisionAlign.SelectNextLine()
    if PrecisionAlign.SelectedLine < 9 and PrecisionAlign.Functions.construct_exists( "Line", PrecisionAlign.SelectedLine ) then
        PrecisionAlign.SelectedLine = PrecisionAlign.SelectedLine + 1
        local dlist_lines = controlpanel.Get( PA ).line_window.list_line
        dlist_lines:ClearSelection()
        dlist_lines:SelectItem( dlist_lines:GetLine(PrecisionAlign.SelectedLine) )
        return true
    end
    return false
end