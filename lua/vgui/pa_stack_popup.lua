local STACK_POPUP = {}
local BGColor_Background = PrecisionAlign.TOOLMODE_BACKGROUND_COLOR_BACKGROUND
local BGColor_Display    = PrecisionAlign.TOOLMODE_BACKGROUND_COLOR_DISPLAY

local PA_ = PrecisionAlign.PA_


function STACK_POPUP:Init()
	local stackNumCvar = GetConVar( PA_ .. "stack_num" )
	local stackNoCollideCvar = GetConVar( PA_ .. "stack_nocollide" )
	self:SetSize( 300, 150 )
	self:Center()
	self:SetTitle( "Precision Alignment Multi-Stack Settings" )
	self:ShowCloseButton( true )
	self:SetDraggable( false )
	self:SetBackgroundBlur( true )
	self:SetDrawOnTop( true )

	self.text_stackamount = vgui.Create( "DLabel", self )
		self.text_stackamount:SetText( "Stack Amount:" )
		self.text_stackamount:SizeToContents()
		self.text_stackamount:SetContentAlignment( 8 )
		self.text_stackamount:SetTextColor( color_white )
		self.text_stackamount:StretchToParent( 5, 40, 5, 5 )

	self.slider_stackamount = vgui.Create( "DNumSlider", self )
		self.slider_stackamount:StretchToParent( 10, nil, 10, nil )
		self.slider_stackamount:AlignTop( 45 )
		self.slider_stackamount:SetText( "" )
		self.slider_stackamount:SetMinMax( 1, 20 )
		self.slider_stackamount:SetDecimals( 0 )
		self.slider_stackamount:SetValue( stackNumCvar:GetInt() )
		self.slider_stackamount.Text = self.slider_stackamount:GetTextArea()
		self.slider_stackamount.Text.OnEnter = function()
			self.button_ok:DoClick()
		end
		self.slider_stackamount.Text:RequestFocus()

	self.checkbox_nocollide = vgui.Create( "DCheckBoxLabel", self )
		self.checkbox_nocollide:SetText( "Nocollide" )
		self.checkbox_nocollide:SetTooltip( "Nocollide each stacked entity with the next" )
		self.checkbox_nocollide:SizeToContents()
		self.checkbox_nocollide:AlignBottom( 45 )
		self.checkbox_nocollide:AlignLeft( 10 )
		self.checkbox_nocollide:SetValue( stackNoCollideCvar:GetInt() )

	self.button_ok = vgui.Create( "DButton", self )
		self.button_ok:SetText( "OK" )
		self.button_ok:SizeToContents()
		self.button_ok:SetSize( 80, 25 )
		self.button_ok:AlignLeft( 5 )
		self.button_ok:AlignBottom( 5 )
		self.button_ok.DoClick = function()
			RunConsoleCommand( PA_ .. "stack_num", tostring( math.Clamp(self.slider_stackamount:GetValue(), 1, 20) ) )

			local nocollide = 0
			if self.checkbox_nocollide:GetChecked() then nocollide = 1 end
			RunConsoleCommand( PA_ .. "stack_nocollide", tostring( nocollide ) )

			self:Close()
		end

	self.button_cancel = vgui.Create( "DButton", self )
		self.button_cancel:SetText( "Cancel" )
		self.button_cancel:SizeToContents()
		self.button_cancel:SetSize( 80, 25 )
		self.button_cancel:SetPos( 5, 5 )
		self.button_cancel.DoClick = function() self:Close() end
		self.button_cancel:AlignRight( 5 )
		self.button_cancel:AlignBottom( 5 )

	self:MakePopup()
	self:DoModal()
end


function STACK_POPUP:Paint()
	if ( self.m_bBackgroundBlur ) then
		Derma_DrawBackgroundBlur( self, self.m_fCreateTime )
	end

	local width, height = self:GetSize()
	draw.RoundedBox(6, 0, 0, width, 25, BGColor_Display)
	draw.RoundedBox(6, 2, 2, width - 4, 21, BGColor_Background)

	draw.RoundedBox(6, 0, 25, width, height - 25, color_black)
	draw.RoundedBox(6, 1, 26, width - 2, height - 27, BGColor_Background )
end

vgui.Register("PA_Stack_Popup", STACK_POPUP, "DFrame")