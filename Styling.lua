local IR, F, E, L, V, P, G = unpack(select(2, ...))

IR.Styling = {}

-- [핵심] 스타일링 적용 함수 (농도 강화 버전)
F.Styling = function(f, useStripes, useShadow)
	-- 설정값 체크 (에러 방지)
	if not E.db or not E.db.IringUI or not E.db.IringUI.skin.enable then return end
	if not f or f.IRstyle or f.__style then return end

	-- 배경색을 더 진하고 묵직하게 고정
	if f.SetBackdropColor then
		f:SetBackdropColor(0.05, 0.05, 0.05, 0.7) -- 아주 어두운 검정 (70% 불투명)
	end

	local style = CreateFrame("Frame", nil, f, "BackdropTemplate")
	style:SetAllPoints(f)
	style:SetFrameLevel(f:GetFrameLevel() + 1)

	-- 빗살무늬 (Stripes) 선명하게 입히기
	if E.db.IringUI.skin.stripes and not useStripes then
		local stripes = style:CreateTexture(nil, "OVERLAY", nil, 7) -- 최상단 레이어 고정
		stripes:SetInside(style, 1, -1)
		stripes:SetTexture(IR.Media.Stripes, true, true)
		stripes:SetHorizTile(true)
		stripes:SetVertTile(true)
		stripes:SetBlendMode("ADD")
		stripes:SetAlpha(0.7) -- 무늬 농도 70% (매우 선명함)
		style.stripes = stripes
	end

	-- 그림자 (Shadow)
	if E.db.IringUI.skin.shadow and not useShadow then
		local mshadow = style:CreateTexture(nil, "OVERLAY")
		mshadow:SetInside(style, 0, 0)
		mshadow:SetTexture(IR.Media.Overlay)
		mshadow:SetVertexColor(1, 1, 1, 0.6)
		style.mshadow = mshadow
	end
	
	f.IRstyle = style
	f.__style = 1
end

-- [낚시질] 모든 프레임 설계도에 Styling 기능 심기
local function AddIringAPI()
	local frame = CreateFrame("Frame")
	local mt = getmetatable(frame).__index
	
	-- 1. 모든 프레임에서 :Styling() 호출 가능하게 함
	if not mt.Styling then mt.Styling = F.Styling end

	-- 2. ElvUI가 배경을 깔 때마다 자동으로 우리 스타일 입히기 (핵심 코드)
	if mt.SetTemplate then
		hooksecurefunc(mt, "SetTemplate", function(f)
			if f and f.Styling then f:Styling() end
		end)
	end
    
	if mt.CreateBackdrop then
		hooksecurefunc(mt, "CreateBackdrop", function(f)
			if f and f.Styling then f:Styling() end
		end)
	end
end

-- API 주입 실행
AddIringAPI()

-- 기존 프레임(채팅창 등) 소급 적용
local function ApplyToExisting()
	local panels = {
		_G["LeftChatPanel"], _G["RightChatPanel"], _G["MinimapPanel"], 
		_G["ElvUI_Bar1"], _G["ElvUI_Bar2"], _G["ElvUI_Bar3"], 
		_G["ElvUI_Bar4"], _G["ElvUI_Bar5"], _G["ElvUI_Bar6"]
	}
	for _, frame in pairs(panels) do
		if frame and frame.Styling then frame:Styling() end
	end
end

local loader = CreateFrame("Frame")
loader:RegisterEvent("PLAYER_ENTERING_WORLD")
loader:SetScript("OnEvent", function(self)
	ApplyToExisting()
	self:UnregisterAllEvents()
end)
