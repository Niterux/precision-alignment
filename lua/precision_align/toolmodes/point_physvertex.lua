local MODE = PrecisionAlign.PointToolMode("Phys. Vertex", 1060)

function MODE:GetClickPosition(_, Pos, _, Phys)
    local ClosestVertex
    local ClosestVertexDistance = 100000000000

    local Vertices = Phys:GetMesh()
    if not Vertices then
        -- Spherical? So we should just return the trace hitpos I guess.
        return Pos
    end

    for _, Vertex in ipairs(Vertices) do
        local VertexPos = Phys:LocalToWorld(Vertex.pos)

        local Dist = Pos:Distance(VertexPos)
        if Dist < ClosestVertexDistance then
            ClosestVertex = VertexPos
            ClosestVertexDistance = Dist
        end
    end

    if ClosestVertex then
        return ClosestVertex
    else
        PrecisionAlign.Warning("Could not find any vertices on this entity???")
        return Pos
    end
end