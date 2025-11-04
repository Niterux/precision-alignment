local MODE = PrecisionAlign.ToolMode("Point - Bounding Box Centre", 1300)

function MODE:GetClickPosition(_, _, Ent, _)
    return Ent:LocalToWorld(Ent:OBBCenter())
end