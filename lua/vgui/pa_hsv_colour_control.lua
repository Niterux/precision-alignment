local HSV_COLOUR_CONTROL = {}
function HSV_COLOUR_CONTROL:Init()
	self:SetSize(300, 200)
	self.ColorMixer = vgui.Create( "DColorMixer", self )
		self.ColorMixer:SetPos( 0, 35 )
		self.ColorMixer:SetSize( 250, 150 )
		self.ColorMixer:SetPalette( false )
		self.ColorMixer.ValueChanged = function( _, color )
			local H, S, V = ColorToHSV( color )
			local A = color.a or 255
			-- PrintTable( color ) -- print( tostring( color ) )
			-- PrintTable( self.ColorMixer:GetColor() )
			-- print( "changed: " .. H .. ", " .. S .. ", " .. V .. ", " .. A )
			RunConsoleCommand( self.convar .. "_h", H )
			RunConsoleCommand( self.convar .. "_s", S )
			RunConsoleCommand( self.convar .. "_v", V )
			RunConsoleCommand( self.convar .. "_a", A )
		end

	--[[
	self.ColourCircle = vgui.Create("PA_ColourCircle", self)
		self.ColourCircle:SetPos(0, 35)
		self.ColourCircle:SetSize(150, 150)
		self.ColourCircle.OnChange = function( panel, H, S )
			local colour_brightness = HSVToColor( H, S, 1 )
			self.Bar_Brightness:SetFGColor( colour_brightness )

			local V = self.Bar_Brightness:GetColor()
			local colour_alpha = HSVToColor( H, S, V )
			self.Bar_Alpha:SetFGColor( colour_alpha )

			RunConsoleCommand( self.convar .. "_h", H )
			RunConsoleCommand( self.convar .. "_s", S )
		end

	self.Bar_Brightness = vgui.Create( "DAlphaBar", self )
		-- self.Bar_Brightness:SetBGColor( "vgui/hsv-brightness" )
		self.Bar_Brightness:SetPaintBackground( "vgui/hsv-brightness" )
		self.Bar_Brightness:SetPos(160, 45)
		self.Bar_Brightness:SetSize(25, 130)
		self.Bar_Brightness.GetColor = function()
			return 1 - self.Bar_Brightness:GetValue()
		end

		self.Bar_Brightness.SetColor = function( panel, V )
			self.Bar_Brightness:SetValue( 1 - V )
			self.Bar_Brightness:OnChange( V * 255 )
		end

		self.Bar_Brightness.OnChange = function( panel, brightness )
			local V = brightness / 255
			local H, S = self.ColourCircle:GetColor()
			local colour_alpha = HSVToColor( H, S, V )
			self.Bar_Alpha:SetFGColor( colour_alpha )

			RunConsoleCommand( self.convar .. "_v", V )
		end

		-- Remove default alpha bar background image
 	--	self.Bar_Brightness.PerformLayout = function()
	--		DSlider.PerformLayout( self.Bar_Brightness )
	--	end
	--	self.Bar_Brightness.imgBackground:Remove()

	AddMenuText( "HSV", 130, 182, self )

	self.Bar_Alpha = vgui.Create( "DAlphaBar", self )
		self.Bar_Alpha:SetPos(210, 45)
		self.Bar_Alpha:SetSize(25, 130)
		self.Bar_Alpha.GetColor = function()
			return ( 1 - self.Bar_Alpha:GetValue() ) * 255
		end

		self.Bar_Alpha.SetColor = function( panel, alpha )
			self.Bar_Alpha:SetValue( 1 - alpha / 255 )
			self.Bar_Alpha:OnChange( alpha )
		end

		self.Bar_Alpha.OnChange = function( panel, alpha )
			RunConsoleCommand( self.convar .. "_a", alpha )
		end

	AddMenuText( "Alpha", 207, 182, self )
	]]

	self.button_defaults = vgui.Create( "PA_Function_Button", self )
		self.button_defaults:SetPos(200, 5)
		self.button_defaults:SetSize(90, 25)
		self.button_defaults:SetText( "Reset Defaults" )
		self.button_defaults:SetFunction( function()
			self:SetColor( self.default_H, self.default_S, self.default_V, self.default_A )
			return true
		end )
end

function HSV_COLOUR_CONTROL:SetConVar( convar )
	self.convar = convar
end

function HSV_COLOUR_CONTROL:SetDefaults( H, S, V, A )
	self.default_H = H
	self.default_S = S
	self.default_V = V
	self.default_A = A
end

function HSV_COLOUR_CONTROL:SetColor( H, S, V, A )
	local col = HSVToColor( H, S, V )
	col.a = A
	self.ColorMixer:SetColor( col )
	-- self.ColourCircle:SetColor( H, S )
	-- self.Bar_Brightness:SetColor( V )
	-- self.Bar_Alpha:SetColor( A )
end

function HSV_COLOUR_CONTROL:GetColor()
	local col = self.ColorMixer:GetColor()
	local H, S, V = ColorToHSV( col )
	local A = col.a
	-- return self.ColorMixer:GetColor()
	-- local H, S = self.ColourCircle:GetColor()
	-- local V = self.Bar_Brightness:GetColor()
	-- local A = self.Bar_Alpha:GetColor()
	return H, S, V, A
end

function HSV_COLOUR_CONTROL:Paint()
end

vgui.Register("PA_ColourControl", HSV_COLOUR_CONTROL, "DPanel")