local MODE = PrecisionAlign.ToolMode("Point - Mass Centre", 1200)

function MODE:GetClickPosition(_, _, Ent, Phys)
    return Ent:LocalToWorld(Phys:GetMassCenter())
end