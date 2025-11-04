local MODE = PrecisionAlign.LineToolMode("Hitnormal", 2020)

function MODE:OnClick(_, _, Normal)
    PrecisionAlign.Functions.set_line( PrecisionAlign.SelectedLine, nil, nil, Normal, nil )
end