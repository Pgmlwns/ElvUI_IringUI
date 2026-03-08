local IR, F, E, L, V, P, G = unpack(select(2, ...))

IR.Styling = {}

-- [1] 프레임 스타일링 함수
F.Styling = function(f, useStripes, useShadow)
	if not E.db or not E.db.IringUI or not E.db.IringUI.skin.enable then return end
	if not f or f.IRstyle or f.__style then return end

	local frameName = f.GetName and f:GetName()
	local style = CreateFrame("Frame", frameName and frameName.."_IRStyle" or nil, f, "BackdropTemplate")

	-- 빗살무늬
	if E.db.IringUI.skin.stripes and not useStripes then
		local stripes = f:CreateTexture(nil, "BORDER")
		stripes:SetInside(f, 1, -1)
		stripes:SetTexture(IR.Media.Stripes, true, true)
		stripes:SetHorizTile(true) stripes:SetVertTile(true)
		stripes:SetBlendMode("ADD")
		if frameName and (frameName:find("PluginInstall") or frameName:find("ElvUIInstall")) then
			stripes:SetDrawLayer("OVERLAY", 7)
		end
		style.stripes = stripes
	end

	-- 그림자 (은은한 직업 색상)
	if E.db.IringUI.skin.shadow and not useShadow then
		local mshadow = f:CreateTexture(nil, "BORDER")
		mshadow:SetInside(f, 0, 0)
		mshadow:SetTexture(IR.Media.Overlay)
		local color = RAID_CLASS_COLORS[E.myclass]
		mshadow:SetVertexColor(color.r, color.g, color.b)
		mshadow:SetAlpha(0.4)
		style.mshadow = mshadow
	end

	style:SetFrameStrata(f:GetFrameStrata())
	style:SetFrameLevel(f:GetFrameLevel() + 1)
	style:SetAllPoints(f)
	f.IRstyle = style
	f.__style = 1
end

-- [2] 버튼 전용 하이라이트 & 테두리 함수
F.StyleButton = function(f)
	if not f or f.IringBtnStyled then return end
	
	local classColor = RAID_CLASS_COLORS[E.myclass]

	-- 은은한 하이라이트 텍스처 생성 (약하게)
	local hover = f:CreateTexture(nil, "HIGHLIGHT")
	hover:SetInside(f, 1, -1)
	hover:SetTexture(E.media.blankTex)
	hover:SetVertexColor(classColor.r, classColor.g, classColor.b, 0.15) -- 0.15로 아주 약하게 설정
	f.IringHover = hover

	-- 마우스 오버 시 테두리 색상 변경 후킹
	f:HookScript("OnEnter", function(self)
		local color = RAID_CLASS_COLORS[E.myclass]
		if self.backdrop then
			self.backdrop:SetBackdropBorderColor(color.r, color.g, color.b)
		else
			self:SetBackdropBorderColor(color.r, color.g, color.b)
		end
	end)

	f:HookScript("OnLeave", function(self)
		local dbColor = E.media.bordercolor
		if self.backdrop then
			self.backdrop:SetBackdropBorderColor(unpack(dbColor))
		else
			self:SetBackdropBorderColor(unpack(dbColor))
		end
	end)

	f.IringBtnStyled = true
end

-- [3] API 주입 및 자동 적용
local function AddIringAPI()
	local mt = getmetatable(CreateFrame("Frame")).__index
	local bt = getmetatable(CreateFrame("Button")).__index
	
	if not mt.Styling then mt.Styling = F.Styling end
	
	-- ElvUI SetTemplate 후킹 (프레임 및 버튼 공통)
	if mt.SetTemplate then
		hooksecurefunc(mt, "SetTemplate", function(f)
			if f and f.Styling then f:Styling() end
			-- 버튼일 경우 추가 스킨 적용
			if f:IsObjectType("Button") then F.StyleButton(f) end
		end)
	end
end

AddIringAPI()
