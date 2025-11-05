local MODE = PrecisionAlign.PlaneToolMode("Hitnormal", 3010)

function MODE:OnClick(_, _, Normal)
    PrecisionAlign.Functions.set_plane( PrecisionAlign.SelectedPlane, nil, Normal )
end