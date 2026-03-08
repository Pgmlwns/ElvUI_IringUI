local addon, Engine = ...
local IR, F, E, L, V, P, G = unpack(Engine)

-- [에러 해결] 코어 파일에 설정이 없어도 에러가 나지 않도록 단계별 생성
if not P["IringUI"] then P["IringUI"] = {} end
if not P["IringUI"]["misc"] then P["IringUI"]["misc"] = {} end

-- 게임 메뉴 기본값 설정
if P["IringUI"]["misc"]["gameMenu"] == nil then
	P["IringUI"]["misc"]["gameMenu"] = true
end

local module = IR:NewModule('IR_GameMenu', 'AceEvent-3.0')
local _G = _G

-- 리소스 경로
local logoTexture = [[Interface\AddOns\ElvUI_IringUI\Media\Textures\mUI1.tga]]
local classBannerPath = [[Interface\AddOns\ElvUI_IringUI\Media\Textures\ClassBanner\CLASS-]]

local function CreateMenuPanel(name, point)
	local GameMenuFrame = _G["GameMenuFrame"]
	local frame = CreateFrame("Frame", name, GameMenuFrame, "BackdropTemplate")
	frame:SetFrameStrata("TOOLTIP") 
	frame:SetFrameLevel(10)
	
	local panelHeight = GetScreenHeight() / 4
	frame:SetSize(GetScreenWidth() + 20, panelHeight)
	frame:SetTemplate("Transparent")
	
	if point == "TOP" then
		frame:SetPoint("TOP", E.UIParent, "TOP", 0, 1)
	else
		frame:SetPoint("BOTTOM", E.UIParent, "BOTTOM", 0, -1)
	end

	-- [빗살무늬 복구] 코어 파일의 공통 함수를 안전하게 호출
	if IR.ApplyStyle then 
		IR:ApplyStyle(frame) 
	end
	
	return frame
end

function module:SetupGameMenu()
	local GameMenuFrame = _G["GameMenuFrame"]
	if not GameMenuFrame or GameMenuFrame.IRtopPanel then return end

	GameMenuFrame.IRtopPanel = CreateMenuPanel("IR_TopPanel", "TOP")
	local t1 = GameMenuFrame.IRtopPanel:CreateTexture(nil, "OVERLAY")
	t1:SetPoint("CENTER")
	t1:SetSize(180, 180)
	t1:SetTexture(classBannerPath .. E.myclass)

	GameMenuFrame.IRbottomPanel = CreateMenuPanel("IR_BottomPanel", "BOTTOM")
	local t2 = GameMenuFrame.IRbottomPanel:CreateTexture(nil, "OVERLAY")
	t2:SetPoint("CENTER")
	t2:SetSize(140, 140)
	t2:SetTexture(logoTexture)
end

function module:Initialize()
	_G.GameMenuFrame:HookScript("OnShow", function()
		-- DB 경로 안전 체크
		if E.db.IringUI and E.db.IringUI.misc and E.db.IringUI.misc.gameMenu then
			module:SetupGameMenu()
			if _G.GameMenuFrame.IRtopPanel then _G.GameMenuFrame.IRtopPanel:Show() end
			if _G.GameMenuFrame.IRbottomPanel then _G.GameMenuFrame.IRbottomPanel:Show() end
		end
	end)
end
