-- IringUI 전용 선언 (Engine 보따리 풀기)
local addon, Engine = ...
local IR, F, E, L, V, P, G = unpack(Engine)

-- IringUI의 하위 모듈로 등록
local module = IR:NewModule('IR_GameMenu', 'AceEvent-3.0')
local _G = _G

-- 리소스 경로 (본인의 파일 유무 확인 필수)
local logoTexture = [[Interface\AddOns\ElvUI_IringUI\Media\Textures\mUI1.tga]]
local classBannerPath = [[Interface\AddOns\ElvUI_IringUI\Media\Textures\ClassBanner\CLASS-]]

-- 패널 생성 함수
local function CreateMenuPanel(name, point)
    local GameMenuFrame = _G["GameMenuFrame"]
    -- 부모를 GameMenuFrame으로 설정하여 ESC를 누를 때만 보이게 함
    local frame = CreateFrame("Frame", name, GameMenuFrame, "BackdropTemplate")
    frame:SetFrameStrata("HIGH")
    frame:SetFrameLevel(1)
    
    if point == "TOP" then
        frame:SetPoint("TOP", E.UIParent, "TOP", 0, 1)
    else
        frame:SetPoint("BOTTOM", E.UIParent, "BOTTOM", 0, -1)
    end
    
    -- 초기 높이 1에서 시작 (애니메이션 효과 극대화)
    frame:SetSize(GetScreenWidth() + 20, 1)
    frame:SetTemplate("Transparent")
    
    -- 애니메이션 설정 (판다리아 클래식 호환)
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

    -- 상단 패널 생성 및 클래스 로고
    GameMenuFrame.IRtopPanel = CreateMenuPanel("IR_TopPanel", "TOP")
    local t1 = GameMenuFrame.IRtopPanel:CreateTexture(nil, "OVERLAY")
    t1:SetPoint("CENTER")
    t1:SetSize(180, 180)
    t1:SetTexture(classBannerPath .. E.myclass)

    -- 하단 패널 생성 및 UI 로고
    GameMenuFrame.IRbottomPanel = CreateMenuPanel("IR_BottomPanel", "BOTTOM")
    local t2 = GameMenuFrame.IRbottomPanel:CreateTexture(nil, "OVERLAY")
    t2:SetPoint("CENTER")
    t2:SetSize(140, 140)
    t2:SetTexture(logoTexture)

    -- 모델 설정 (간소화 버전)
    if not GameMenuFrame.IRplayerModel then
        local ph = CreateFrame("Frame", nil, GameMenuFrame)
        ph:SetSize(150, 150)
        ph:SetPoint("RIGHT", GameMenuFrame, "LEFT", -300, 0)
        local pm = CreateFrame("PlayerModel", nil, ph)
        pm:SetPoint("CENTER")
        pm:SetSize(GetScreenWidth() * 1.5, GetScreenHeight() * 1.5)
        pm:SetScript("OnShow", function(self)
            self:ClearModel()
            self:SetUnit("player")
            self:SetAnimation(69) -- Dance
        end)
        GameMenuFrame.IRplayerModel = pm
    end
end

-- IringUI의 메인 IR:Initialize()가 실행될 때 호출됨
function module:Initialize()
    -- Profile.lua에서 설정한 기본값 혹은 Options.lua에서 변경한 값 확인
    -- P["IringUI"]["misc"] ["gameMenu"] 경로가 정확한지 확인하세요.
    if E.db.IringUI and E.db.IringUI.misc and E.db.IringUI.misc.gameMenu then
        self:SetupGameMenu()
    end
end
