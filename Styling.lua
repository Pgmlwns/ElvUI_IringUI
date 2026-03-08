local IR, F, E, L, V, P, G = unpack(select(2, ...))

-- [1] 프레임/버튼 공통 스타일링 함수
F.Styling = function(f, useStripes, useShadow)
	if not E.db or not E.db.IringUI or not E.db.IringUI.skin.enable then return end
	if not f or f.IRstyle or f.__style then return end

	local frameName = f.GetName and f:GetName()
	local style = CreateFrame("Frame", frameName and frameName.."_IRStyle" or nil, f, "BackdropTemplate")

	-- 빗살무늬 (Stripes)
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

-- [2] 버튼 전용 하이라이트 및 직업 색상 테두리 함수
F.StyleButton = function(f)
	if not f or f.IringBtnStyled then return end
	
	local color = RAID_CLASS_COLORS[E.myclass]

	-- 은은한 직업 색상 하이라이트 (0.15)
	local hover = f:CreateTexture(nil, "HIGHLIGHT")
	hover:SetInside(f, 1, -1)
	hover:SetTexture(E.media.blankTex)
	hover:SetVertexColor(color.r, color.g, color.b, 0.15)
	f.IringHover = hover

	-- 마우스 오버 시 테두리 색상 변경
	f:HookScript("OnEnter", function(self)
		local c = RAID_CLASS_COLORS[E.myclass]
		local target = self.backdrop or self
		if target.SetBackdropBorderColor then
			target:SetBackdropBorderColor(c.r, c.g, c.b)
		end
	end)

	f:HookScript("OnLeave", function(self)
		local target = self.backdrop or self
		if target.SetBackdropBorderColor then
			target:SetBackdropBorderColor(unpack(E.media.bordercolor))
		end
	end)

	f.IringBtnStyled = true
end

-- [3] 모든 설계도(Metatable) 장악
local function AddIringAPI()
	local mt = getmetatable(CreateFrame("Frame")).__index
	
	if not mt.Styling then mt.Styling = F.Styling end

	-- ElvUI의 모든 배경 생성/템플릿 함수를 후킹
	local function HookFunction(funcName)
		if mt[funcName] then
			hooksecurefunc(mt, funcName, function(f)
				if not f then return end
				-- 1. 빗살무늬 적용
				if f.Styling then f:Styling() end
				-- 2. 버튼인 경우 하이라이트 적용
				if f:IsObjectType("Button") then F.StyleButton(f) end
			end)
		end
	end

	HookFunction("SetTemplate")
	HookFunction("CreateBackdrop")
end

AddIringAPI()
