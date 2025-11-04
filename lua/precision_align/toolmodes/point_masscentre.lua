local MODE = PrecisionAlign.PointToolMode("Mass Centre", 1020)

function MODE:GetClickPosition(_, _, Ent, Phys)
    return Ent:LocalToWorld(Phys:GetMassCenter())
end