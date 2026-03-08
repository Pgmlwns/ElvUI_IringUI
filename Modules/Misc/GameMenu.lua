local E, L, V, P, G = unpack(select(2, ...)) -- 첫 번째 인자인 IR 대신 E를 먼저 받음
local IR = E:GetModule('IringUI', true) or _G["IringUI"] -- IringUI 메인 객체 찾기
if not IR then return end -- IR을 못 찾으면 실행 중단

local module = IR:NewModule('IR_GameMenu', 'AceEvent-3.0')
local _G = _G

local logoTexture = [[Interface\AddOns\ElvUI_IringUI\Media\Textures\mUI1.tga]]
local classBannerPath = [[Interface\AddOns\ElvUI_IringUI\Media\Textures\ClassBanner\CLASS-]]

-- 패널 생성 함수
local function CreateMenuPanel(name, point)
    local frame = CreateFrame("Frame", name, _G["GameMenuFrame"], "BackdropTemplate")
    frame:SetFrameStrata("HIGH")
    frame:SetFrameLevel(1)
    
    if point == "TOP" then
        frame:SetPoint("TOP", E.UIParent, "TOP", 0, 1)
    else
        frame:SetPoint("BOTTOM", E.UIParent, "BOTTOM", 0, -1)
    end
    
    frame:SetSize(GetScreenWidth() + 10, 1)
    frame:SetTemplate("Transparent")
    
    -- 애니메이션
    frame.anim = frame:CreateAnimationGroup()
    local grow = frame.anim:CreateAnimation("Height")
    grow:SetToHeight(GetScreenHeight() / 4)
    grow:SetDuration(0.5)
    grow:SetSmoothing("Out")
    
    frame:SetScript("OnShow", function(self)
        self:SetHeight(1)
        self.anim:Play()
    end)
    
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

    -- ESC 누를 때 강제 출력 보정
    GameMenuFrame:HookScript("OnShow", function()
        GameMenuFrame.IRtopPanel:Show()
        GameMenuFrame.IRbottomPanel:Show()
    end)
end

function module:Initialize()
    -- 설정값 확인 (프로필 DB에 misc.gameMenu가 있는지 확인)
    local db = E.db.IringUI
    if db and db.misc and db.misc.gameMenu then
        -- 프레임 생성을 지연시켜 UI 로드 오류 방지
        self:SetupGameMenu()
    end
end

-- IringUI가 이 모듈을 인식하도록 등록
-- (보통 IR:NewModule 시점에 자동으로 관리 리스트에 들어갑니다)
