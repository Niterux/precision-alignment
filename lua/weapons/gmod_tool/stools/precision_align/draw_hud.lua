local PA = "precision_align"
local PA_ = PA .. "_"

local attachHCvar = GetConVar( PA_ .. "attachcolour_h" )
local attachSCvar = GetConVar( PA_ .. "attachcolour_s" )
local attachVCvar = GetConVar( PA_ .. "attachcolour_v" )
local attachACvar = GetConVar( PA_ .. "attachcolour_a" )
local sizePointCvar = GetConVar( PA_ .. "size_point" )
local sizeLineStartCvar = GetConVar( PA_ .. "size_line_start" )
local sizeLineEndCvar = GetConVar( PA_ .. "size_line_end" )
local sizePlaneCvar = GetConVar( PA_ .. "size_plane" )
local sizePlaneNormCvar = GetConVar( PA_ .. "size_plane_normal" )

local pointcolour = PrecisionAlign.GetConstructColor(PrecisionAlign.CONSTRUCT_POINT):Copy()
local linecolour  = PrecisionAlign.GetConstructColor(PrecisionAlign.CONSTRUCT_LINE):Copy()
local planecolour = PrecisionAlign.GetConstructColor(PrecisionAlign.CONSTRUCT_PLANE):Copy()

pointcolour:SetBrightness(0.98)
pointcolour:SetSaturation(0.8)
linecolour:SetBrightness(0.98)
linecolour:SetSaturation(0.8)
planecolour:SetBrightness(0.98)
planecolour:SetSaturation(0.8)

-- HUD display
local point_size_min = math.max( sizePointCvar:GetInt(), 1 )
local point_size_max = sizePointCvar:GetInt() * 1000

local line_size_start = sizeLineStartCvar:GetInt()
local line_size_min = sizeLineEndCvar:GetInt() -- End (double bar)
local line_size_max = line_size_min * 1000

local plane_size = sizePlaneCvar:GetInt()
local plane_size_normal = sizePlaneNormCvar:GetInt()
local text_min, text_max = 1, 4500

local draw_attachments = LocalPlayer():GetInfo( PA_ .. "draw_attachments" )

cvars.AddChangeCallback( PA_ .. "size_point", function( _, _, New ) point_size_min = tonumber(math.max(New, 1)); point_size_max = tonumber(New) * 1000 end )
cvars.AddChangeCallback( PA_ .. "size_line_start",  function( _, _, New ) line_size_start = tonumber(New) end  )
cvars.AddChangeCallback( PA_ .. "size_line_end",  function( _, _, New ) line_size_min = tonumber(New); line_size_max  = line_size_min * 1000 end  )
cvars.AddChangeCallback( PA_ .. "size_plane", function( _, _, New ) plane_size = tonumber(New) end  )
cvars.AddChangeCallback( PA_ .. "size_plane_normal", function( _, _, New ) plane_size_normal = tonumber(New) end  )

-- Manage attachment line colour changes
local H = attachHCvar:GetInt()
local S = attachSCvar:GetInt()
local V = attachVCvar:GetInt()
local A = attachACvar:GetInt()
local attachcolourHSV = { h = H, s = S, v = V, a = A }
local attachcolourRGB = HSVToColor( H, S, V )
attachcolourRGB.a = A

local function SetAttachColour(CVar, _, New)
    if CVar == PA_ .. "attachcolour_h" then
        attachcolourHSV.h = New
    elseif CVar == PA_ .. "attachcolour_s" then
        attachcolourHSV.s = New
    elseif CVar == PA_ .. "attachcolour_v" then
        attachcolourHSV.v = New
    elseif CVar == PA_ .. "attachcolour_a" then
        attachcolourHSV.a = New
    end

    attachcolourRGB = HSVToColor( attachcolourHSV.h, attachcolourHSV.s, attachcolourHSV.v )
    attachcolourRGB.a = attachcolourHSV.a
end

cvars.AddChangeCallback( PA_ .. "attachcolour_h", SetAttachColour )
cvars.AddChangeCallback( PA_ .. "attachcolour_s", SetAttachColour )
cvars.AddChangeCallback( PA_ .. "attachcolour_v", SetAttachColour )
cvars.AddChangeCallback( PA_ .. "attachcolour_a", SetAttachColour )


local function inview( pos2D )
    if	pos2D.x > -ScrW() and
        pos2D.y > -ScrH() and
        pos2D.x < ScrW() * 2 and
        pos2D.y < ScrH() * 2 then
            return true
    end
    return false
end

-- HUD draw function
local function precision_align_draw()
    local playerpos = LocalPlayer():GetShootPos()

    -- Points
    for k, v in ipairs (PrecisionAlign.Points) do
        if v.visible and v.origin then

            --Check if point exists
            local point_temp = PrecisionAlign.Functions.point_global(k)
            if point_temp then
                local origin = point_temp.origin
                local point = origin:ToScreen()
                if inview( point ) then
                    local distance = playerpos:Distance( origin )
                    local size = math.Clamp( point_size_max / distance, point_size_min, point_size_max )
                    local text_dist = math.Clamp(text_max / distance, text_min, text_max)

                    surface.SetDrawColor( pointcolour.r, pointcolour.g, pointcolour.b, pointcolour.a )

                    surface.DrawLine( point.x - size, point.y, point.x + size, point.y )
                    surface.DrawLine( point.x, point.y + size, point.x, point.y - size )

                    draw.DrawText( tostring(k), "Default", point.x + text_dist, point.y + text_dist / 1.5, Color(pointcolour.r, pointcolour.g, pointcolour.b, pointcolour.a), 0 )

                    -- Draw attachment line
                    if draw_attachments and IsValid(v.entity) then
                        local entpos = v.entity:GetPos():ToScreen()
                        surface.SetDrawColor( attachcolourRGB.r, attachcolourRGB.g, attachcolourRGB.b, attachcolourRGB.a )
                        surface.DrawLine( point.x, point.y, entpos.x, entpos.y )
                    end
                end
            end
        end
    end

    -- Lines
    for k, v in ipairs (PrecisionAlign.Lines) do
        if v.visible and v.startpoint and v.endpoint then

            --Check if line exists
            local line_temp = PrecisionAlign.Functions.line_global(k)
            if line_temp then
                local startpoint = line_temp.startpoint
                local endpoint = line_temp.endpoint

                local line_start = startpoint:ToScreen()
                local line_end = endpoint:ToScreen()

                local distance1 = playerpos:Distance( startpoint )
                local distance2 = playerpos:Distance( endpoint )

                local size2 = math.Clamp(line_size_max / distance2, line_size_min, line_size_max)
                local text_dist = math.Clamp(text_max / distance1, text_min, text_max)

                surface.SetDrawColor( linecolour.r, linecolour.g, linecolour.b, linecolour.a )

                -- Start X
                local normal = (endpoint - startpoint):GetNormal()
                local dir1, dir2

                if IsValid(v.entity) then
                    local up = v.entity:GetUp()
                    if normal:Dot(up) < 0.9 then
                        dir1 = (normal:Cross(up)):GetNormal()
                    else
                        dir1 = (normal:Cross(v.entity:GetForward())):GetNormal()
                    end
                else
                    if math.abs(normal.z) < 0.9 then
                        dir1 = (normal:Cross(Vector(0, 0, 1))):GetNormal()
                    else
                        dir1 = (normal:Cross(Vector(1, 0, 0))):GetNormal()
                    end
                end

                dir2 = (dir1:Cross(normal)):GetNormal() * line_size_start
                dir1 = dir1 * line_size_start

                local v1 = (startpoint + dir1 + dir2):ToScreen()
                local v2 = (startpoint - dir1 + dir2):ToScreen()
                local v3 = (startpoint - dir1 - dir2):ToScreen()
                local v4 = (startpoint + dir1 - dir2):ToScreen()

                -- Start X
                if inview( line_start ) then
                    surface.DrawLine(v1.x, v1.y, v3.x, v3.y)
                    surface.DrawLine(v2.x, v2.y, v4.x, v4.y)
                end

                -- Line
                surface.DrawLine( line_start.x, line_start.y, line_end.x, line_end.y )

                -- End =
                if inview( line_end ) then
                    local line_dir_2D = Vector(line_end.x - line_start.x, line_end.y - line_start.y, 0):GetNormalized()
                    local norm_dir_2D = {x = -line_dir_2D.y, y = line_dir_2D.x}
                    surface.DrawLine( line_end.x - norm_dir_2D.x * size2, line_end.y - norm_dir_2D.y * size2,
                                    line_end.x + norm_dir_2D.x * size2, line_end.y + norm_dir_2D.y * size2 )
                    surface.DrawLine( line_end.x + (line_dir_2D.x / 3 - norm_dir_2D.x) * size2, line_end.y + (line_dir_2D.y / 3 - norm_dir_2D.y) * size2,
                                    line_end.x + (line_dir_2D.x / 3 + norm_dir_2D.x) * size2, line_end.y + (line_dir_2D.y / 3 + norm_dir_2D.y) * size2 )
                end

                draw.DrawText( tostring(k), "Default", line_start.x + text_dist, line_start.y - text_dist / 1.5 - 15, Color(linecolour.r, linecolour.g, linecolour.b, linecolour.a), 3 )

                -- Draw attachment line
                if draw_attachments and IsValid(v.entity) then
                    local entpos = v.entity:GetPos():ToScreen()
                    surface.SetDrawColor( attachcolourRGB.r, attachcolourRGB.g, attachcolourRGB.b, attachcolourRGB.a )
                    surface.DrawLine( line_start.x, line_start.y, entpos.x, entpos.y )
                end
            end
        end
    end

    -- Planes
    for k, v in ipairs ( PrecisionAlign.Planes ) do
        if v.visible and v.origin and v.normal then

            -- Check if plane exists
            local plane_temp = PrecisionAlign.Functions.plane_global(k)
            if plane_temp then

                local origin = plane_temp.origin
                local normal = plane_temp.normal

                -- Draw normal line
                local line_start = origin:ToScreen()
                if inview( line_start ) then

                    local line_end = ( origin + normal * plane_size_normal ):ToScreen()

                    local distance = playerpos:Distance( origin )
                    local text_dist = math.Clamp(text_max / distance, text_min, text_max)

                    surface.SetDrawColor( planecolour.r, planecolour.g, planecolour.b, planecolour.a )
                    surface.DrawLine( line_start.x, line_start.y, line_end.x, line_end.y )

                    -- Draw plane surface
                    local dir1, dir2
                    if IsValid( v.entity ) then
                        local up = v.entity:GetUp()
                        dir1 = math.abs( normal:Dot( up ) ) < 0.9 and up or v.entity:GetForward()
                    else
                        dir1 = math.abs( normal.z ) < 0.9 and Vector( 0, 0, 1 ) or Vector( 1, 0, 0 )
                    end

                    dir1 = ( normal:Cross( dir1 ) ):GetNormal()
                    dir2 = ( dir1:Cross( normal ) ):GetNormal() * plane_size
                    dir1 = dir1 * plane_size

                    local v1 = ( origin + dir1 + dir2 ):ToScreen()
                    local v2 = ( origin - dir1 + dir2 ):ToScreen()
                    local v3 = ( origin - dir1 - dir2 ):ToScreen()
                    local v4 = ( origin + dir1 - dir2 ):ToScreen()

                    surface.DrawLine( v1.x, v1.y, v2.x, v2.y )
                    surface.DrawLine( v2.x, v2.y, v3.x, v3.y )
                    surface.DrawLine( v3.x, v3.y, v4.x, v4.y )
                    surface.DrawLine( v4.x, v4.y, v1.x, v1.y )

                    draw.DrawText( tostring( k ), "Default", line_start.x - text_dist, line_start.y + text_dist / 1.5, Color( planecolour.r, planecolour.g, planecolour.b, planecolour.a ), 1 )
                    -- Default
                    -- Draw attachment line
                    if draw_attachments and IsValid(v.entity) then
                        local entpos = v.entity:GetPos():ToScreen()
                        surface.SetDrawColor( attachcolourRGB.r, attachcolourRGB.g, attachcolourRGB.b, attachcolourRGB.a )
                        surface.DrawLine( line_start.x, line_start.y, entpos.x, entpos.y )
                    end
                end
            end
        end
    end
end
hook.Add("HUDPaint", "draw_precision_align", precision_align_draw)

local function precision_align_displayhud_func( _, _, args )
    local enabled = tobool( args[1] )
    if not enabled then
        hook.Remove( "HUDPaint", "draw_precision_align" )
    else
        hook.Add("HUDPaint", "draw_precision_align", precision_align_draw)
    end
    return true
end
concommand.Add( PA_ .. "displayhud", precision_align_displayhud_func )