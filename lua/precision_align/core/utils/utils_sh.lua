local PA_Queue_Methods = {}
local PA_Queue_MT      = {__index = PA_Queue_Methods}

function PA_Queue_Methods:Enqueue(v)
    self.Items[self.WritePointer] = v
    self.WritePointer = self.WritePointer + 1
end

function PA_Queue_Methods:Peek()
    if self.ReadPointer >= self.WritePointer then return end

    local peeked = self.Items[self.ReadPointer]
    return peeked
end

function PA_Queue_Methods:Dequeue()
    if self.ReadPointer >= self.WritePointer then return end

    local popped = self.Items[self.ReadPointer]

    self.Items[self.ReadPointer] = nil
    self.ReadPointer = self.ReadPointer + 1
    return popped
end

function PA_Queue_Methods:Length()
    return self.WritePointer - self.ReadPointer
end

function PA_Queue_Methods:CanDequeue()
    return (self.WritePointer - self.ReadPointer) > 0
end

local function iter(a, i)
    i = i + 1
    local v = a[i]
    if v then
        return i, v
    end
end

function PA_Queue_Methods:Iterator()
    return iter, self.Items, self.ReadPointer - 1
end

function PrecisionAlign.Queue()
    return setmetatable({
        ReadPointer = 1,
        WritePointer = 1,
        Items = {}
    }, PA_Queue_MT)
end