local IR, F, E, L, V, P, G = unpack(select(2, ...))

IR.Styling = {}

-- [핵심] 스타일링 적용 함수 (직업 색상 그림자 적용)
F.Styling = function(f, useStripes, useShadow)
	if not E.db or not E.db.IringUI or not E.db.IringUI.skin.enable then return end
	if not f or f.IRstyle or f.__style then return end

	-- 배경색 고정
	if f.SetBackdropColor then
		f:SetBackdropColor(0.06, 0.06, 0.06, 0.85) 
	end

	local style = CreateFrame("Frame", nil, f, "BackdropTemplate")
	style:SetAllPoints(f)
	style:SetFrameLevel(f:GetFrameLevel() + 1)

	-- 1. 빗살무늬 (Stripes)
	if E.db.IringUI.skin.stripes and not useStripes then
		local stripes = style:CreateTexture(nil, "OVERLAY", nil, 6)
		stripes:SetInside(style, 1, -1)
		stripes:SetTexture(IR.Media.Stripes, true, true)
		stripes:SetHorizTile(true)
		stripes:SetVertTile(true)
		stripes:SetBlendMode("ADD")
		stripes:SetAlpha(0.55) 
		style.stripes = stripes
	end

	-- 2. 그림자 효과 (Shadow) - 클래스 색상 적용 버전
	if E.db.IringUI.skin.shadow and not useShadow then
		local mshadow = style:CreateTexture(nil, "OVERLAY", nil, 7)
		mshadow:SetInside(style, 0, 0) -- 테두리 끝까지 색상이 차오르게 설정
		mshadow:SetTexture(IR.Media.Overlay)
		
		-- [핵심 수정] 현재 캐릭터의 직업 색상 가져오기
		local color = RAID_CLASS_COLORS[E.myclass]
		
		-- [핵심 수정] 그림자 텍스처에 직업 색상 입히기 (r, g, b)
		mshadow:SetVertexColor(color.r, color.g, color.b) 
		
		-- [핵심 수정] 색상이 잘 보이도록 투명도를 0.8 정도로 높임 (영롱한 발광 효과)
		mshadow:SetAlpha(0.8) 
		
		-- 발광 느낌을 위해 블렌드 모드 추가 (선택 사항)
		mshadow:SetBlendMode("ADD") 

		style.mshadow = mshadow
	end
	
	f.IRstyle = style
	f.__style = 1
end

-- [낚시질] 모든 프레임 설계도에 Styling 기능 심기
local function AddIringAPI()
	local frame = CreateFrame("Frame")
	local mt = getmetatable(frame).__index
	if not mt.Styling then mt.Styling = F.Styling end
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

AddIringAPI()

-- 소급 적용
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
