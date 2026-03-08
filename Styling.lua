local IR, F, E, L, V, P, G = unpack(select(2, ...))

IR.Styling = {}

-- [핵심] 스타일링 적용 함수 (그림자 농도 조절 버전)
F.Styling = function(f, useStripes, useShadow)
	-- 설정값 체크 (에러 방지)
	if not E.db or not E.db.IringUI or not E.db.IringUI.skin.enable then return end
	if not f or f.IRstyle or f.__style then return end

	-- 배경색을 묵직하게 고정 (너무 검지 않게 0.08 정도로 상향)
	if f.SetBackdropColor then
		f:SetBackdropColor(0.08, 0.08, 0.08, 0.85) 
	end

	local style = CreateFrame("Frame", nil, f, "BackdropTemplate")
	style:SetAllPoints(f)
	style:SetFrameLevel(f:GetFrameLevel() + 1)

	-- 1. 빗살무늬 (Stripes) 선명하게 입히기
	if E.db.IringUI.skin.stripes and not useStripes then
		local stripes = style:CreateTexture(nil, "OVERLAY", nil, 6) -- 그림자보다 아래 레이어
		stripes:SetInside(style, 1, -1)
		stripes:SetTexture(IR.Media.Stripes, true, true)
		stripes:SetHorizTile(true)
		stripes:SetVertTile(true)
		stripes:SetBlendMode("ADD")
		stripes:SetAlpha(0.65) -- 무늬 농도 조절
		style.stripes = stripes
	end

	-- 2. 그림자 효과 (Shadow) - 가장자리가 너무 어두운 문제 해결
	if E.db.IringUI.skin.shadow and not useShadow then
		local mshadow = style:CreateTexture(nil, "OVERLAY", nil, 7) -- 최상단 레이어
		
		-- [핵심 수정] 테두리에서 2픽셀 안쪽으로 배치하여 클래스 테두리 색상을 가리지 않게 함
		mshadow:SetInside(style, 2, -2) 
		mshadow:SetTexture(IR.Media.Overlay)
		
		-- [핵심 수정] 투명도를 0.3으로 낮추고 밝은 회색을 섞어 테두리 시인성 확보
		mshadow:SetVertexColor(0.8, 0.8, 0.8) 
		mshadow:SetAlpha(0.25) -- 기존보다 훨씬 연하게 설정하여 테두리를 살림

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

	-- 2. ElvUI가 배경을 깔 때마다 자동으로 우리 스타일 입히기
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
