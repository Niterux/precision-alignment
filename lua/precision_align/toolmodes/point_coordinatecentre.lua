local MODE = PrecisionAlign.ToolMode(PrecisionAlign.CONSTRUCT_POINT, "Coordinate Centre", 1100)

function MODE:GetClickPosition(_, _, Ent, _)
    return Ent:GetPos()
end