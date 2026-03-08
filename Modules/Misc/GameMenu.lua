local addon, Engine = ...
local IR, F, E, L, V, P, G = unpack(Engine)
local module = IR:NewModule('IR_GameMenu', 'AceEvent-3.0')
local _G = _G

-- 리소스 경로 (AddOns 폴더 내 실제 파일 유무 확인 필수)
local logoTexture = [[Interface\AddOns\ElvUI_IringUI\Media\Textures\mUI1.tga]]
local classBannerPath = [[Interface\AddOns\ElvUI_IringUI\Media\Textures\ClassBanner\CLASS-]]

-- 패널 생성 함수 (레이어 및 부모 설정 강화)
local function CreateMenuPanel(name, point)
    local GameMenuFrame = _G["GameMenuFrame"]
    -- 부모를 GameMenuFrame으로 설정하여 ESC 누를 때만 보이게 함
    local frame = CreateFrame("Frame", name, GameMenuFrame, "BackdropTemplate")
    
    -- [중요] 레이어를 TOOLTIP 수준으로 올려서 다른 UI에 가려지지 않게 함
    frame:SetFrameStrata("TOOLTIP") 
    frame:SetFrameLevel(10)
    
    local panelHeight = GetScreenHeight() / 4
    frame:SetSize(GetScreenWidth() + 20, panelHeight)
    frame:SetTemplate("Transparent") -- ElvUI 투명 스킨 적용
    
    if point == "TOP" then
        frame:SetPoint("TOP", E.UIParent, "TOP", 0, 1)
    else
        frame:SetPoint("BOTTOM", E.UIParent, "BOTTOM", 0, -1)
    end
    
    return frame
end

function module:SetupGameMenu()
    local GameMenuFrame = _G["GameMenuFrame"]
    if not GameMenuFrame then return end

    -- 상단 패널 생성 및 클래스 로고
    if not GameMenuFrame.IRtopPanel then
        GameMenuFrame.IRtopPanel = CreateMenuPanel("IR_TopPanel", "TOP")
        local t = GameMenuFrame.IRtopPanel:CreateTexture(nil, "OVERLAY")
        t:SetPoint("CENTER")
        t:SetSize(180, 180)
        t:SetTexture(classBannerPath .. E.myclass)
    end

    -- 하단 패널 생성 및 IringUI 로고
    if not GameMenuFrame.IRbottomPanel then
        GameMenuFrame.IRbottomPanel = CreateMenuPanel("IR_BottomPanel", "BOTTOM")
        local t = GameMenuFrame.IRbottomPanel:CreateTexture(nil, "OVERLAY")
        t:SetPoint("CENTER")
        t:SetSize(140, 140)
        t:SetTexture(logoTexture)
    end
end

-- 모듈 초기화
function module:Initialize()
    -- [수정] OnShow 후킹 방식이 안 먹힐 경우를 대비해 이벤트 등록 시도
    local GameMenuFrame = _G["GameMenuFrame"]
    if GameMenuFrame then
        GameMenuFrame:HookScript("OnShow", function()
            -- DB 설정값 확인 (E.db.IringUI.misc.gameMenu)
            if E.db.IringUI and E.db.IringUI.misc and E.db.IringUI.misc.gameMenu then
                module:SetupGameMenu()
                -- 강제로 다시 보여줌 (레이어 꼬임 방지)
                GameMenuFrame.IRtopPanel:Show()
                GameMenuFrame.IRbottomPanel:Show()
            end
        end)
    end
end
