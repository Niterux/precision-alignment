local MODE = PrecisionAlign.PointToolMode("Bone", 1050)

function MODE:GetClickPosition(_, Pos, Ent, _)
    local ClosestBone
    local ClosestBonePos
    local ClosestBoneDistance = 100000000000
    for I = 1, Ent:GetBoneCount() do
        local BonePos = Ent:GetBonePosition(I - 1)
        if BonePos == Ent:GetPos() then
            BonePos = Ent:GetBoneMatrix(I - 1):GetTranslation()
        end

        local Dist = Pos:Distance(BonePos)
        if Dist < ClosestBoneDistance then
            ClosestBone = I - 1
            ClosestBonePos = BonePos
            ClosestBoneDistance = Dist
        end
    end
    if ClosestBone then
        PrecisionAlign.Message("Selected bone '" .. Ent:GetBoneName(ClosestBone) .. "'")
        return ClosestBonePos
    else
        PrecisionAlign.Warning("Could not find any bones on this entity.")
        return Pos
    end
end