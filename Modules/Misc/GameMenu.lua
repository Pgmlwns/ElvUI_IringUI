local addon, Engine = ...
local IR, F, E, L, V, P, G = unpack(Engine)

-- [모듈 독립 설정] 코어 파일을 수정하지 않고 여기서 직접 기본값 주입
P["IringUI"] = P["IringUI"] or {}
P["IringUI"]["misc"] = P["IringUI"]["misc"] or {}
if P["IringUI"]["misc"]["gameMenu"] == nil then
	P["IringUI"]["misc"]["gameMenu"] = true
end

local module = IR:NewModule('IR_GameMenu', 'AceEvent-3.0')
local _G = _G

-- 리소스 경로 (AddOns 폴더 내 실제 파일 유무 확인 필수)
local logoTexture = [[Interface\AddOns\ElvUI_IringUI\Media\Textures\mUI1.tga]]
local classBannerPath = [[Interface\AddOns\ElvUI_IringUI\Media\Textures\ClassBanner\CLASS-]]

-- 패널 생성 함수
local function CreateMenuPanel(name, point)
	local GameMenuFrame = _G["GameMenuFrame"]
	-- 부모를 GameMenuFrame으로 설정하여 ESC 누를 때만 보이게 함
	local frame = CreateFrame("Frame", name, GameMenuFrame, "BackdropTemplate")
	
	-- 레이어를 최상단으로 올려 ElvUI 배경 뒤에 숨지 않게 함
	frame:SetFrameStrata("TOOLTIP") 
	frame:SetFrameLevel(10)
	
	local panelHeight = GetScreenHeight() / 4
	frame:SetSize(GetScreenWidth() + 20, panelHeight)
	frame:SetTemplate("Transparent") -- ElvUI 투명 스킨
	
	if point == "TOP" then
		frame:SetPoint("TOP", E.UIParent, "TOP", 0, 1)
	else
		frame:SetPoint("BOTTOM", E.UIParent, "BOTTOM", 0, -1)
	end

	-- [스타일 적용] 코어의 공통 함수를 사용하여 빗살무늬 입히기
	if IR.ApplyStyle then 
		IR:ApplyStyle(frame) 
	end
	
	return frame
end

function module:SetupGameMenu()
	local GameMenuFrame = _G["GameMenuFrame"]
	if not GameMenuFrame or GameMenuFrame.IRtopPanel then return end

	-- 상단 패널 및 클래스 로고
	GameMenuFrame.IRtopPanel = CreateMenuPanel("IR_TopPanel", "TOP")
	local t1 = GameMenuFrame.IRtopPanel:CreateTexture(nil, "OVERLAY")
	t1:SetPoint("CENTER")
	t1:SetSize(180, 180)
	t1:SetTexture(classBannerPath .. E.myclass)

	-- 하단 패널 및 IringUI 로고
	GameMenuFrame.IRbottomPanel = CreateMenuPanel("IR_BottomPanel", "BOTTOM")
	local t2 = GameMenuFrame.IRbottomPanel:CreateTexture(nil, "OVERLAY")
	t2:SetPoint("CENTER")
	t2:SetSize(140, 140)
	t2:SetTexture(logoTexture)
end

function module:Initialize()
	-- 게임 메뉴가 열릴 때마다 실행 여부 체크 및 생성
	_G.GameMenuFrame:HookScript("OnShow", function()
		if E.db.IringUI and E.db.IringUI.misc and E.db.IringUI.misc.gameMenu then
			module:SetupGameMenu()
			-- 이미 생성되었다면 강제로 보여줌
			if _G.GameMenuFrame.IRtopPanel then _G.GameMenuFrame.IRtopPanel:Show() end
			if _G.GameMenuFrame.IRbottomPanel then _G.GameMenuFrame.IRbottomPanel:Show() end
		end
	end)
end
