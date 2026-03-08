local IR, F, E, L, V, P, G = unpack(select(2, ...))

IR.Styling = {}

-- [1] 공통 스타일링 함수 (빗살무늬 및 그림자)
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
		stripes:SetAlpha(0.5)
		
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

-- [2] 버튼 전용 마우스 오버 효과 함수
F.StyleButton = function(f)
	if not f or f.IringStyled then return end
	
	local color = RAID_CLASS_COLORS[E.myclass]

	-- 마우스 진입: 테두리를 직업 색상으로
	f:HookScript("OnEnter", function(self)
		local target = self.backdrop or self
		if target.SetBackdropBorderColor then
			target:SetBackdropBorderColor(color.r, color.g, color.b)
		end
	end)

	-- 마우스 퇴장: 테두리를 기본 색상으로 복구
	f:HookScript("OnLeave", function(self)
		local target = self.backdrop or self
		if target.SetBackdropBorderColor then
			target:SetBackdropBorderColor(unpack(E.media.bordercolor))
		end
	end)

	f.IringStyled = true
end

-- [3] ElvUI 스킨 모듈 후킹 (가장 확실한 방법)
local function HookSkins()
	local S = E:GetModule('Skins')
	
	-- ElvUI가 버튼을 스킨할 때마다 우리 스타일을 끼워넣음
	hooksecurefunc(S, "HandleButton", function(_, button)
		if button and button.Styling then
			button:Styling() -- 빗살무늬 적용
			F.StyleButton(button) -- 마우스 오버 효과 적용
		end
	end)
end

-- 시스템 API 주입
local function AddIringAPI()
	local mt = getmetatable(CreateFrame("Frame")).__index
	if not mt.Styling then mt.Styling = F.Styling end

	-- 배경 생성 시 자동 스타일링
	if mt.SetTemplate then
		hooksecurefunc(mt, "SetTemplate", function(f)
			if f and f.Styling then f:Styling() end
		end)
	end
    
	HookSkins()
end

AddIringAPI()
