local MODE = PrecisionAlign.PointToolMode("Mass Centre", 1020)

function MODE:GetClickPosition(_, _, Ent, Phys)
    if not IsValid(Ent) then return end

    return Ent:LocalToWorld(Phys:GetMassCenter())
end