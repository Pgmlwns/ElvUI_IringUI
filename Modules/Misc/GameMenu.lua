-- ElvUI 전역 객체 가져오기
local E = unpack(_G.ElvUI) 
local IR = E:GetModule('IringUI', true) -- IringUI 메인 모듈 이름 확인 필요

-- 모듈 생성
local module = IR:NewModule('IR_GameMenu', 'AceEvent-3.0')
local _G = _G

-- 설정 및 경로
local logoTexture = [[Interface\AddOns\ElvUI_IringUI\Media\Textures\mUI1.tga]]
local classBannerPath = [[Interface\AddOns\ElvUI_IringUI\Media\Textures\ClassBanner\CLASS-]]

-- 패널 생성 로직
local function CreateMenuPanel(name, point)
    local frame = CreateFrame("Frame", name, _G.GameMenuFrame, "BackdropTemplate")
    frame:SetFrameStrata("HIGH")
    frame:SetFrameLevel(1)
    
    if point == "TOP" then
        frame:SetPoint("TOP", E.UIParent, "TOP", 0, 1)
    else
        frame:SetPoint("BOTTOM", E.UIParent, "BOTTOM", 0, -1)
    end
    
    -- 초기 상태: 높이 1, 너비는 화면 전체
    frame:SetSize(GetScreenWidth() + 10, 1)
    frame:SetTemplate("Transparent")
    
    -- 애니메이션 그룹
    frame.anim = frame:CreateAnimationGroup()
    local grow = frame.anim:CreateAnimation("Height")
    grow:SetToHeight(GetScreenHeight() / 4)
    grow:SetDuration(0.5)
    grow:SetSmoothing("Out")
    
    -- 메뉴가 열릴 때마다 애니메이션 재생
    frame:SetScript("OnShow", function(self)
        self:SetHeight(1)
        self.anim:Play()
    end)
    
    return frame
end

function module:SetupGameMenu()
    local GameMenuFrame = _G.GameMenuFrame
    if not GameMenuFrame or GameMenuFrame.IRtopPanel then return end

    -- 상단 패널 생성
    GameMenuFrame.IRtopPanel = CreateMenuPanel("IR_TopPanel", "TOP")
    local t1 = GameMenuFrame.IRtopPanel:CreateTexture(nil, "OVERLAY")
    t1:SetPoint("CENTER")
    t1:SetSize(180, 180)
    t1:SetTexture(classBannerPath .. E.myclass)

    -- 하단 패널 생성
    GameMenuFrame.IRbottomPanel = CreateMenuPanel("IR_BottomPanel", "BOTTOM")
    local t2 = GameMenuFrame.IRbottomPanel:CreateTexture(nil, "OVERLAY")
    t2:SetPoint("CENTER")
    t2:SetSize(140, 140)
    t2:SetTexture(logoTexture)

    -- ESC 메뉴가 이미 열려 있을 수도 있으므로 Show 강제 호출
    GameMenuFrame.IRtopPanel:Show()
    GameMenuFrame.IRbottomPanel:Show()
end

function module:Initialize()
    -- 옵션 DB 확인 (경로: E.db.IringUI.misc.gameMenu)
    if E.db.IringUI and E.db.IringUI.misc and E.db.IringUI.misc.gameMenu then
        self:SetupGameMenu()
    end
end
