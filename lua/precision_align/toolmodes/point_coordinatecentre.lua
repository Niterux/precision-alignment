local MODE = PrecisionAlign.ToolMode("Point - Coordinate Centre", 1100)

function MODE:GetClickPosition(_, _, Ent, _)
    return Ent:GetPos()
end