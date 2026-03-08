local IR, F, E, L, V, P, G = unpack(select(2, ...))

IR.Styling = {}

-- 스타일링 적용 핵심 함수
local function Styling(f, useStripes, useShadow)
	if not E.db or not E.db.IringUI or not E.db.IringUI.skin.enable then return end
	if not f or f.IRstyle or f.__style then return end

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

-- 모든 프레임 엔진에 Styling 주입 및 SetTemplate 후킹
local function AddStylingAPI()
	local frame = CreateFrame("Frame")
	local mt = getmetatable(frame).__index
	
	-- 1. 모든 프레임에서 :Styling() 호출 가능하게 함
	if not mt.Styling then mt.Styling = Styling end

	-- 2. ElvUI의 가장 핵심 함수인 SetTemplate을 낚아챔 (블리자드 스킨용)
	if mt.SetTemplate then
		hooksecurefunc(mt, "SetTemplate", function(f)
			if f and f.Styling then f:Styling() end
		end)
	end

	-- 3. CreateBackdrop도 안전하게 한 번 더 후킹
	if mt.CreateBackdrop then
		hooksecurefunc(mt, "CreateBackdrop", function(f)
			if f and f.Styling then f:Styling() end
		end)
	end
end

-- API 주입 실행
AddStylingAPI()

-- 기존 프레임 및 이미 스킨된 블리자드 프레임 소급 적용
local function ApplyToExisting()
	-- 주요 ElvUI 패널
	local panels = {
		_G["LeftChatPanel"], _G["RightChatPanel"], _G["MinimapPanel"], 
		_G["ElvUI_Bar1"], _G["ElvUI_Bar2"], _G["ElvUI_Bar3"], 
		_G["ElvUI_Bar4"], _G["ElvUI_Bar5"], _G["ElvUI_Bar6"]
	}
	for _, frame in pairs(panels) do
		if frame and frame.Styling then frame:Styling() end
	end
    
    -- 이미 열려있거나 생성된 블리자드 프레임들 처리
    if _G["CharacterFrame"] and _G["CharacterFrame"].backdrop then _G["CharacterFrame"].backdrop:Styling() end
    if _G["SpellBookFrame"] and _G["SpellBookFrame"].backdrop then _G["SpellBookFrame"].SpellBookFrame:Styling() end
end

local loader = CreateFrame("Frame")
loader:RegisterEvent("PLAYER_ENTERING_WORLD")
loader:SetScript("OnEvent", function(self)
	ApplyToExisting()
	self:UnregisterAllEvents()
end)