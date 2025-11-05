local MODE = PrecisionAlign.LineToolMode("Hitpos + Hitnormal", 2010)

function MODE:OnClick(Entity, Point, Normal, Shift, Alt)
    if Shift then
        PrecisionAlign.SelectNextLine()
    end

    PrecisionAlign.Functions.set_line( PrecisionAlign.SelectedLine, Point, nil, Normal, nil )
    if Alt then
        if PrecisionAlign.ActiveEnt then
            PrecisionAlign.Functions.attach_line( PrecisionAlign.SelectedLine, PrecisionAlign.ActiveEnt )
        elseif PrecisionAlign.Lines[PrecisionAlign.SelectedLine].entity then
            PrecisionAlign.Functions.attach_line( PrecisionAlign.SelectedLine, nil )
        end
    elseif PrecisionAlign.Lines[PrecisionAlign.SelectedLine].entity ~= Entity then
        PrecisionAlign.Functions.attach_line( PrecisionAlign.SelectedLine, Entity )
    end
end