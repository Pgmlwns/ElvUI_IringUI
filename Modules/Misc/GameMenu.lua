local addon, Engine = ...
local IR, F, E, L, V, P, G = unpack(Engine)

-- [안전 장치] P["IringUI"] 그릇이 없으면 생성 후 값 주입 (5번 줄 에러 방지)
if not P["IringUI"] then P["IringUI"] = {} end
if not P["IringUI"]["misc"] then P["IringUI"]["misc"] = {} end
if P["IringUI"]["misc"]["gameMenu"] == nil then P["IringUI"]["misc"]["gameMenu"] = true end

local module = IR:NewModule('IR_GameMenu', 'AceEvent-3.0')
local _G = _G

local logoTexture = [[Interface\AddOns\ElvUI_IringUI\Media\Textures\mUI1.tga]]
local classBannerPath = [[Interface\AddOns\ElvUI_IringUI\Media\Textures\ClassBanner\CLASS-]]

local function CreateMenuPanel(name, point)
	local GameMenuFrame = _G["GameMenuFrame"]
	local frame = CreateFrame("Frame", name, GameMenuFrame, "BackdropTemplate")
	frame:SetFrameStrata("TOOLTIP") 
	frame:SetFrameLevel(10)
	frame:SetSize(GetScreenWidth() + 20, GetScreenHeight() / 4)
	frame:SetTemplate("Transparent")
	
	if point == "TOP" then
		frame:SetPoint("TOP", E.UIParent, "TOP", 0, 1)
	else
		frame:SetPoint("BOTTOM", E.UIParent, "BOTTOM", 0, -1)
	end

	-- Core의 스타일 함수 호출 (빗살무늬 복구)
	if IR.ApplyStyle then IR:ApplyStyle(frame) end
	
	return frame
end

function module:SetupGameMenu()
	local GameMenuFrame = _G["GameMenuFrame"]
	if not GameMenuFrame or GameMenuFrame.IRtopPanel then return end

	GameMenuFrame.IRtopPanel = CreateMenuPanel("IR_TopPanel", "TOP")
	local t1 = GameMenuFrame.IRtopPanel:CreateTexture(nil, "OVERLAY")
	t1:SetPoint("CENTER") t1:SetSize(180, 180)
	t1:SetTexture(classBannerPath .. E.myclass)

	GameMenuFrame.IRbottomPanel = CreateMenuPanel("IR_BottomPanel", "BOTTOM")
	local t2 = GameMenuFrame.IRbottomPanel:CreateTexture(nil, "OVERLAY")
	t2:SetPoint("CENTER") t2:SetSize(140, 140)
	t2:SetTexture(logoTexture)
end

function module:Initialize()
	_G.GameMenuFrame:HookScript("OnShow", function()
		if E.db.IringUI and E.db.IringUI.misc and E.db.IringUI.misc.gameMenu then
			module:SetupGameMenu()
			if _G.GameMenuFrame.IRtopPanel then _G.GameMenuFrame.IRtopPanel:Show() end
			if _G.GameMenuFrame.IRbottomPanel then _G.GameMenuFrame.IRbottomPanel:Show() end
		end
	end)
end
