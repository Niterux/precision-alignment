local MODE = PrecisionAlign.ToolMode(PrecisionAlign.CONSTRUCT_POINT, "Attachment", 1040)

function MODE:GetClickPosition(_, Pos, Ent, _)
    local Attachments = Ent:GetAttachments()
    local ClosestAttachment
    local ClosestAttachmentName
    local ClosestAttachmentDistance = 100000000000
    for _, AttachmentIdx in ipairs(Attachments) do
        local Attachment = Ent:GetAttachment(AttachmentIdx.id)
        if Attachment then
            local Dist = Pos:Distance(Attachment.Pos)
            if Dist < ClosestAttachmentDistance then
                ClosestAttachment = AttachmentIdx.id
                ClosestAttachmentName = AttachmentIdx.name
                ClosestAttachmentDistance = Dist
            end
        end
    end

    if ClosestAttachment then
        PrecisionAlign.Message("Selected attachment '" .. ClosestAttachmentName .. "'")
        return Ent:GetAttachment(ClosestAttachment).Pos
    else
        PrecisionAlign.Warning("Could not find any attachments on this entity.")
        return Pos
    end
end