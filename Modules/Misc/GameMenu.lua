-- 파일 내부에서는 addon 이름과 Engine 보따리를 가져옵니다.
local addon, Engine = ...
local IR, F, E, L, V, P, G = unpack(Engine)

local module = IR:NewModule('IR_GameMenu', 'AceEvent-3.0')
local _G = _G

-- 리소스 경로 (AddOns 폴더 내 실제 파일 유무 확인 필수)
local logoTexture = [[Interface\AddOns\ElvUI_IringUI\Media\Textures\mUI1.tga]]
local classBannerPath = [[Interface\AddOns\ElvUI_IringUI\Media\Textures\ClassBanner\CLASS-]]

-- 패널 생성 및 슬라이드 애니메이션 함수
local function CreateMenuPanel(name, point)
    local GameMenuFrame = _G["GameMenuFrame"]
    local frame = CreateFrame("Frame", name, GameMenuFrame, "BackdropTemplate")
    frame:SetFrameStrata("HIGH")
    frame:SetFrameLevel(1)
    
    local panelHeight = GetScreenHeight() / 4
    frame:SetSize(GetScreenWidth() + 20, panelHeight)
    frame:SetTemplate("Transparent")
    
    -- 판다리아 클래식 호환 애니메이션 (Translation 사용)
    frame.anim = frame:CreateAnimationGroup()
    local slide = frame.anim:CreateAnimation("Translation")
    slide:SetDuration(0.5)
    slide:SetSmoothing("Out")
    
    -- 위치 초기화 및 애니메이션 방향 설정
    if point == "TOP" then
        frame:SetPoint("TOP", E.UIParent, "TOP", 0, panelHeight) -- 화면 위로 숨김
        slide:SetOffset(0, -panelHeight) -- 아래로 슬라이드
    else
        frame:SetPoint("BOTTOM", E.UIParent, "BOTTOM", 0, -panelHeight) -- 화면 아래로 숨김
        slide:SetOffset(0, panelHeight) -- 위로 슬라이드
    end

    -- 애니메이션 종료 후 위치 고정
    frame.anim:SetScript("OnFinished", function(self)
        local p = self:GetParent()
        p:ClearAllPoints()
        if point == "TOP" then
            p:SetPoint("TOP", E.UIParent, "TOP", 0, 1)
        else
            p:SetPoint("BOTTOM", E.UIParent, "BOTTOM", 0, -1)
        end
    end)

    frame:SetScript("OnShow", function(self)
        self:ClearAllPoints()
        if point == "TOP" then
            self:SetPoint("TOP", E.UIParent, "TOP", 0, panelHeight)
        else
            self:SetPoint("BOTTOM", E.UIParent, "BOTTOM", 0, -panelHeight)
        end
        self.anim:Play()
    end)
    
    return frame
end

function module:SetupGameMenu()
    local GameMenuFrame = _G["GameMenuFrame"]
    if not GameMenuFrame or GameMenuFrame.IRtopPanel then return end

    -- 상단 패널 (클래스 배너)
    GameMenuFrame.IRtopPanel = CreateMenuPanel("IR_TopPanel", "TOP")
    local t1 = GameMenuFrame.IRtopPanel:CreateTexture(nil, "OVERLAY")
    t1:SetPoint("CENTER")
    t1:SetSize(180, 180)
    t1:SetTexture(classBannerPath .. E.myclass)

    -- 하단 패널 (IringUI 로고)
    GameMenuFrame.IRbottomPanel = CreateMenuPanel("IR_BottomPanel", "BOTTOM")
    local t2 = GameMenuFrame.IRbottomPanel:CreateTexture(nil, "OVERLAY")
    t2:SetPoint("CENTER")
    t2:SetSize(140, 140)
    t2:SetTexture(logoTexture)
end

function module:Initialize()
    -- 옵션 DB 확인 (경로: E.db.IringUI.misc.gameMenu)
    -- 만약 프로필에 misc 키가 없다면 작동 안하니 주의하세요.
    if E.db.IringUI and E.db.IringUI.misc and E.db.IringUI.misc.gameMenu then
        self:SetupGameMenu()
    end
end
