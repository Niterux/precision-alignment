if SERVER then
    local function SnapTo(Value, SnapAngles)
        return math.Round(Value / SnapAngles) * SnapAngles
    end

    hook.Add("OnPhysgunFreeze", "PA_FixPhysgunRotationInaccuracy", function(_, PhysObj, _, Player)
        if not Player:KeyDown(IN_SPEED) or not PhysObj:IsValid() then return end
        local ShouldSnap = Player:GetInfo("precision_align_snap_physgun")
        if ShouldSnap == 0 then return end

        local SnapAngles = Player:GetInfo("gm_snapangles")
        local Angles = PhysObj:GetAngles()
        local P, Y, R = Angles:Unpack()
        P = SnapTo(P, SnapAngles)
        Y = SnapTo(Y, SnapAngles)
        R = SnapTo(R, SnapAngles)
        Angles:SetUnpacked(P, Y, R)
        PhysObj:SetAngles(Angles)
    end)
else
    CreateClientConVar("precision_align_snap_physgun", "1", true, true, "When enabled, this forces physgun snapping to always be 100% accurate to your desired gm_snapangles.", 0, 1)
end
