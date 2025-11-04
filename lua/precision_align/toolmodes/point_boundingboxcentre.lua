local MODE = PrecisionAlign.ToolMode(PrecisionAlign.CONSTRUCT_POINT, "Bounding Box Centre", 1030)

function MODE:GetClickPosition(_, _, Ent, _)
    return Ent:LocalToWorld(Ent:OBBCenter())
end