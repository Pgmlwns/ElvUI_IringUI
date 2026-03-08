local addon, Engine = ...
local IR, F, E, L, V, P, G = unpack(Engine)

-- [모듈 독립 설정] 코어 파일을 수정하지 않고 여기서 직접 주입합니다.
P["IringUI"]["misc"] = P["IringUI"]["misc"] or {}
if P["IringUI"]["misc"]["gameMenu"] == nil then
    P["IringUI"]["misc"]["gameMenu"] = true
end

local module = IR:NewModule('IR_GameMenu', 'AceEvent-3.0')
local _G = _G

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
        -- DB에 설정이 있을 때만 실행
        if E.db.IringUI.misc and E.db.IringUI.misc.gameMenu then
            module:SetupGameMenu()
            _G.GameMenuFrame.IRtopPanel:Show()
            _G.GameMenuFrame.IRbottomPanel:Show()
        end
    end)
end
