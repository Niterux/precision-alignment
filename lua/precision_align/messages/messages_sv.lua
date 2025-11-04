local MessageTarget

function PrecisionAlign.SetNextMessageTarget(Target)
    MessageTarget = Target
end


util.AddNetworkString("PrecisionAlign_Message")
local function EnqueueMessage(Text, Type, Time)
    if not IsValid(MessageTarget) then return ErrorNoHalt("Cannot send a message without a valid message target!") end
    net.Start("PrecisionAlign_Message")
    net.WriteString(Text)
    net.WriteUInt(Type, 5)
    net.WriteFloat(Time)
    net.Send(MessageTarget)
end

function PrecisionAlign.Message(Text)
    EnqueueMessage(Text, 0, 5)
end

function PrecisionAlign.Warning(Text)
    EnqueueMessage(Text, 1, 5)
end