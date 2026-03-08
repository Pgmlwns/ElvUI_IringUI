local IR, F, E, L, V, P, G = unpack(select(2, ...))
local module = IR:NewModule('IR_GameMenu', 'AceEvent-3.0')
local _G = _G

-- 테스트용 강제 활성화 (설정값 무시하고 일단 화면에 띄우기 위함)
local FORCE_ENABLE = true 

local logoTexture = [[Interface\AddOns\ElvUI_IringUI\Media\Textures\mUI1.tga]]
local classBannerPath = [[Interface\AddOns\ElvUI_IringUI\Media\Textures\ClassBanner\CLASS-]]

-- 패널 생성 함수 (레이어 및 부모 설정 강화)
local function CreateMenuPanel(name, point)
    -- GameMenuFrame이 아닌 UIParent를 부모로 하여 레이어 간섭 최소화
    local frame = CreateFrame("Frame", name, _G["GameMenuFrame"], "BackdropTemplate")
    frame:SetFrameStrata("HIGH") -- 게임 메뉴보다 위 혹은 같은 층위
    frame:SetFrameLevel(1)
    
    -- 위치 설정
    if point == "TOP" then
        frame:SetPoint("TOP", E.UIParent, "TOP", 0, 2)
    else
        frame:SetPoint("BOTTOM", E.UIParent, "BOTTOM", 0, -2)
    end
    
    frame:SetSize(GetScreenWidth() + 10, 1) -- 아주 작은 높이로 시작
    frame:SetTemplate("Transparent")
    
    -- 애니메이션 설정
    frame.anim = frame:CreateAnimationGroup()
    local grow = frame.anim:CreateAnimation("Height")
    grow:SetToHeight(GetScreenHeight() / 4)
    grow:SetDuration(0.5)
    grow:SetSmoothing("Out")
    
    -- 스크립트: 보일 때마다 재생
    frame:SetScript("OnShow", function(self)
        self:SetHeight(1)
        self.anim:Play()
    end)
    
    return frame
end

function module:SetupGameMenu()
    local GameMenuFrame = _G["GameMenuFrame"]
    if not GameMenuFrame then return end

    -- 상단 패널 강제 생성
    if not GameMenuFrame.IRtopPanel then
        GameMenuFrame.IRtopPanel = CreateMenuPanel("IR_TopPanel", "TOP")
        local tex = GameMenuFrame.IRtopPanel:CreateTexture(nil, "OVERLAY")
        tex:SetPoint("CENTER")
        tex:SetSize(180, 180)
        tex:SetTexture(classBannerPath .. E.myclass)
    end

    -- 하단 패널 강제 생성
    if not GameMenuFrame.IRbottomPanel then
        GameMenuFrame.IRbottomPanel = CreateMenuPanel("IR_BottomPanel", "BOTTOM")
        local tex = GameMenuFrame.IRbottomPanel:CreateTexture(nil, "OVERLAY")
        tex:SetPoint("CENTER")
        tex:SetSize(140, 140)
        tex:SetTexture(logoTexture)
    end

    -- ESC 메뉴가 열릴 때 우리 패널도 강제로 Show 시킴 (Hooking)
    GameMenuFrame:HookScript("OnShow", function()
        if GameMenuFrame.IRtopPanel then GameMenuFrame.IRtopPanel:Show() end
        if GameMenuFrame.IRbottomPanel then GameMenuFrame.IRbottomPanel:Show() end
    end)
end

function module:Initialize()
    -- 초기화 시점에 즉시 실행 (조건문 잠시 제거하여 테스트)
    self:SetupGameMenu()
end

-- IringUI 시스템에 모듈 등록 (RegisterModule 에러 방지 위해 수동 호출 확인)
-- 만약 IR:NewModule이 Initialize를 호출하지 않는 구조라면 아래 줄이 필요할 수 있습니다.
-- E:Delay(1, function() module:Initialize() end) 
