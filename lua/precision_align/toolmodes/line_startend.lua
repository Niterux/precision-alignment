local MODE = PrecisionAlign.LineToolMode("Start / End (Alt)", 2000)

function MODE:OnClick(Entity, Point, _, Shift, Alt)
    if Shift then
        PrecisionAlign.SelectNextLine()
    end

    -- Alt-click will place end point
    if Alt then
        PrecisionAlign.Functions.set_line( PrecisionAlign.SelectedLine, nil, Point, nil, nil )
    else
        PrecisionAlign.Functions.set_line( PrecisionAlign.SelectedLine, Point, nil, nil, nil )

        -- Only auto-attach by start point, not end point
        if PrecisionAlign.Functions.construct_exists( PrecisionAlign.CONSTRUCT_LINE, PrecisionAlign.SelectedLine ) and PrecisionAlign.Lines[PrecisionAlign.SelectedLine].entity ~= Entity then
            PrecisionAlign.Functions.attach_line( PrecisionAlign.SelectedLine, Entity )
        end
    end
end