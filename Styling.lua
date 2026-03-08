local IR, F, E, L, V, P, G = unpack(select(2, ...))

IR.Styling = {}

-- 스타일링 적용 핵심 함수
local function Styling(f, useStripes, useShadow)
	-- 설정에서 스킨이 꺼져있으면 작동 안 함
	if E.db.IringUI and E.db.IringUI.skin and not E.db.IringUI.skin.enable then return end
	if not f or f.IRstyle or f.__style then return end

	-- 텍스처인 경우 부모 프레임을 대상으로 함
	if f:GetObjectType() == "Texture" then f = f:GetParent() end

	local frameName = f.GetName and f:GetName()
	local style = CreateFrame("Frame", frameName and frameName.."_IRStyle" or nil, f, "BackdropTemplate")

	-- 사선 패턴 (Stripes)
	if E.db.IringUI.skin.stripes and not useStripes then
		local stripes = f:CreateTexture(nil, "BORDER")
		stripes:SetInside(f, 1, -1)
		stripes:SetTexture(IR.Media.Stripes, true, true)
		stripes:SetHorizTile(true)
		stripes:SetVertTile(true)
		stripes:SetBlendMode("ADD")
		style.stripes = stripes
	end

	-- 그림자 효과 (Shadow)
	if E.db.IringUI.skin.shadow and not useShadow then
		local mshadow = f:CreateTexture(nil, "BORDER")
		mshadow:SetInside(f, 0, 0)
		mshadow:SetTexture(IR.Media.Overlay)
		mshadow:SetVertexColor(1, 1, 1, 0.6)
		style.mshadow = mshadow
	end

	style:SetFrameStrata(f:GetFrameStrata())
	style:SetFrameLevel(f:GetFrameLevel() + 1)
	style:SetAllPoints(f)
	
	f.IRstyle = style
	f.__style = 1
	IR.Styling[style] = true
end

-- 프레임 기본 도구(API) 주입
local function AddStylingAPI()
	local frame = CreateFrame("Frame")
	local mt = getmetatable(frame).__index
	
	-- 모든 프레임에서 :Styling() 함수를 사용할 수 있게 주입
	if not mt.Styling then
		mt.Styling = Styling
	end

	-- CreateBackdrop 함수를 낚아채서 자동으로 Styling 적용
	-- ElvUI 엔진(E)에 없을 경우 메타테이블(mt)에서 직접 후킹
	if E.CreateBackdrop then
		hooksecurefunc(E, "CreateBackdrop", function(_, frame)
			if frame and frame.Styling then frame:Styling() end
		end)
	elseif mt.CreateBackdrop then
		hooksecurefunc(mt, "CreateBackdrop", function(frame)
			if frame and frame.Styling then frame:Styling() end
		end)
	end
end

-- 시스템에 API 주입 실행
AddStylingAPI()

-- 기존에 이미 생성된 프레임들에 대한 소급 적용
local function ApplyToExisting()
	local frames = {
		_G["LeftChatPanel"], _G["RightChatPanel"], _G["MinimapPanel"], 
		_G["ElvUI_Bar1"], _G["ElvUI_Bar2"], _G["ElvUI_Bar3"], 
		_G["ElvUI_Bar4"], _G["ElvUI_Bar5"], _G["ElvUI_Bar6"]
	}
	for _, frame in pairs(frames) do
		if frame and frame.Styling then frame:Styling() end
	end
end

-- 게임 로드 시 1회 실행
local loader = CreateFrame("Frame")
loader:RegisterEvent("PLAYER_ENTERING_WORLD")
loader:SetScript("OnEvent", function(self)
	ApplyToExisting()
	self:UnregisterAllEvents()
end)