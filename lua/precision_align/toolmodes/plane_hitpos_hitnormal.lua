local MODE = PrecisionAlign.PlaneToolMode("Hitpos + Hitnormal", 3000)

function MODE:OnClick(Entity, Point, Normal, Shift, Alt)
    if Shift then
        PrecisionAlign.SelectNextPlane()
    end

    PrecisionAlign.Functions.set_plane( PrecisionAlign.SelectedPlane, Point, Normal )
    if Alt then
        if PrecisionAlign.ActiveEnt then
            PrecisionAlign.Functions.attach_plane( PrecisionAlign.SelectedPlane, PrecisionAlign.ActiveEnt )
        elseif PrecisionAlign.Planes[PrecisionAlign.SelectedPlane].entity then
            PrecisionAlign.Functions.attach_plane( PrecisionAlign.SelectedPlane, nil )
        end
    elseif PrecisionAlign.Planes[PrecisionAlign.SelectedPlane].entity ~= Entity then
        PrecisionAlign.Functions.attach_plane( PrecisionAlign.SelectedPlane, Entity )
    end
end