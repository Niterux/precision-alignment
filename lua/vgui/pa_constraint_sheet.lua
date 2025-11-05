local CONSTRAINTS_SHEET = {}

function CONSTRAINTS_SHEET:Paint( w, h )
	draw.RoundedBox( 6, 0, 0, w, h, Color( 140, 140, 140, 255 ) )
end

-- Taken from gamemodes/sandbox/gamemode/spawnmenu/controls/control_presets.lua
function CONSTRAINTS_SHEET:AddComboBox( data )
	data = table.LowerKeyNames( data )
	local ctrl = vgui.Create( "ControlPresets", self )
	ctrl:SetPreset( data.folder )
	if ( data.options ) then
		for k, v in pairs( data.options ) do
			if ( k ~= "id" ) then -- Some txt file configs still have an `ID'. But these are redundant now.
				ctrl:AddOption( k, v )
			end
		end
	end

	if ( data.cvars ) then
		for _, v in pairs( data.cvars ) do
			ctrl:AddConVar( v )
		end
	end

	ctrl:SetWide(300)

	return ctrl
end

vgui.Register("PA_Constraints_Sheet", CONSTRAINTS_SHEET, "DPanel")