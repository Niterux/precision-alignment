local PA_ = PrecisionAlign.PA_
local ShowMessages = CreateClientConVar(PA_ .. "display_messages", "0", true, false, _, 0, 1)
local ShowWarns    = CreateClientConVar(PA_ .. "display_warnings", "1", true, false, _, 0, 1)

if PrecisionAlign.MessageQueue then
    while PrecisionAlign.MessageQueue:CanDequeue() do
        local Panel = PrecisionAlign.MessageQueue:Dequeue()
        if IsValid(Panel) then
            Panel:Remove()
        end
    end
end
PrecisionAlign.MessageQueue = PrecisionAlign.Queue()

local ICON_WARNING = Material("icon16/error.png")
local ICON_MESSAGE = Material("icon16/lightbulb.png")

local function EnqueueMessage(Text, Type, Time)
    local Panel = vgui.Create("PA_NotifyPanel")
    Panel:SetText("Precision Alignment: " .. Text)
    Panel:SetType(Type)
    Panel:SetDeathTime(RealTime() + (Time or 0))
    if PrecisionAlign.MessageQueue:Length() > 6 then
        PrecisionAlign.MessageQueue:Peek():SetDeathTime(RealTime() + 0.5)
    end
    PrecisionAlign.MessageQueue:Enqueue(Panel)
end

function PrecisionAlign.Message(Text)
    if not ShowMessages:GetBool() then return end
    EnqueueMessage(Text, NOTIFY_GENERIC, 5)
end

function PrecisionAlign.Warning(Text)
    if not ShowWarns:GetBool() then return end
    EnqueueMessage(Text, NOTIFY_ERROR, 5)
end

local PA_NotifyPanel = {}
function PA_NotifyPanel:SetText(Text)
    self.Text = Text
    surface.SetFont("DermaDefault")
    local W, H = surface.GetTextSize(Text)
    self.W, self.H = W + 8 + H + 16, H + 8
end

function PA_NotifyPanel:SetType(Type)
    self.Type = Type
    if Type == NOTIFY_ERROR then
        self.Icon = ICON_WARNING
    else
        self.Icon = ICON_MESSAGE
    end
end

function PA_NotifyPanel:SetDeathTime(Time)
    self.DeathTime = Time
    self.Birth = RealTime()
    self.TTL = Time - self.Birth
end

function PA_NotifyPanel:GetTimeLeftToLive()
    return self.TTL - (RealTime() - self.Birth)
end

function PA_NotifyPanel:GetLifeTime()
    return RealTime() - self.Birth
end

function PA_NotifyPanel:Paint(W, H)
    local M = surface.GetAlphaMultiplier()
    surface.SetAlphaMultiplier(
        math.ease.OutQuad(math.Clamp(self:GetLifeTime() * 1.7, 0, 1))
        * math.ease.InQuart(math.Clamp(self:GetTimeLeftToLive() * 1.7, 0, 1))
    )

    DPanel.Paint(self, W, H)
    draw.SimpleText(self.Text, "DermaDefault", (W / 2) + (H / 2), H / 2, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    surface.SetMaterial(self.Icon)
    surface.DrawTexturedRect(2 + 4, 2, H - 4, H - 4)
    surface.SetAlphaMultiplier(M)
end

function PA_NotifyPanel:Think()
    if not self.DeathTime then
        ErrorNoHaltWithStack("No death time???")
        self:Remove()
        return
    end
    if RealTime() > self.DeathTime then
        self:Remove()
        return
    end

    local LifeMult = math.Clamp(self:GetLifeTime() * 2, 0, 1)
    self:SetSize(self.W * math.ease.OutBack(LifeMult), self.H)
end

hook.Add("Think", "PA_NotifyPanels", function()
    local ScrW, ScrH = ScrW(), ScrH()
    local Y = 0
    for _, Panel in PrecisionAlign.MessageQueue:Iterator() do
        if IsValid(Panel) then
            local PnlW, PnlH = Panel:GetWide(), Panel:GetTall()
            Panel:SetPos((ScrW / 2) - (PnlW / 2), (ScrH * 0.92) - (PnlH / 2) - (Y * 32))
            Y = Y + math.ease.InQuad(math.Clamp(Panel:GetTimeLeftToLive() * 2, 0, 1))
        else
            PrecisionAlign.MessageQueue:Dequeue()
        end
    end
end)

vgui.Register("PA_NotifyPanel", PA_NotifyPanel, "DPanel")