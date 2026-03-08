local addon, Engine = ...
local IR, F, E, L, V, P, G = unpack(Engine)
local module = IR:NewModule('IR_GameMenu', 'AceEvent-3.0')
local _G = _G

local logoTexture = [[Interface\AddOns\ElvUI_IringUI\Media\Textures\mUI1.tga]]
local classBannerPath = [[Interface\AddOns\ElvUI_IringUI\Media\Textures\ClassBanner\CLASS-]]

-- 패널 생성 함수
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

    -- 상단 패널
    GameMenuFrame.IRtopPanel = CreateMenuPanel("IR_TopPanel", "TOP")
    local t1 = GameMenuFrame.IRtopPanel:CreateTexture(nil, "OVERLAY")
    t1:SetPoint("CENTER")
    t1:SetSize(180, 180)
    t1:SetTexture(classBannerPath .. E.myclass)

    -- 하단 패널
    GameMenuFrame.IRbottomPanel = CreateMenuPanel("IR_BottomPanel", "BOTTOM")
    local t2 = GameMenuFrame.IRbottomPanel:CreateTexture(nil, "OVERLAY")
    t2:SetPoint("CENTER")
    t2:SetSize(140, 140)
    t2:SetTexture(logoTexture)
end

-- [핵심 수정] 초기화 및 이벤트 등록
function module:Initialize()
    -- 1. 게임 메뉴가 열릴 때 실행되도록 후킹 (가장 확실한 방법)
    _G.GameMenuFrame:HookScript("OnShow", function()
        -- DB 설정값이 nil일 경우를 대비해 기본값 true로 처리하거나 상세 경로 확인
        local db = E.db.IringUI
        local enabled = db and db.misc and db.misc.gameMenu
        
        -- 만약 옵션에서 체크했는데도 안 나온다면 아래 주석을 풀고 테스트하세요
        -- enabled = true 

        if enabled then
            module:SetupGameMenu()
            if _G.GameMenuFrame.IRtopPanel then _G.GameMenuFrame.IRtopPanel:Show() end
            if _G.GameMenuFrame.IRbottomPanel then _G.GameMenuFrame.IRbottomPanel:Show() end
        end
    end)
end
