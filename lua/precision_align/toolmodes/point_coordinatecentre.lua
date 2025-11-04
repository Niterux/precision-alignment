local MODE = PrecisionAlign.PointToolMode("Coordinate Centre", 1010)

function MODE:GetClickPosition(_, _, Ent, _)
    return Ent:GetPos()
end