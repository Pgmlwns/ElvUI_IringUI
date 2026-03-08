-- IringUI 전용 선언
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
    frame:SetFrameStrata("HIGH")
    frame:SetFrameLevel(1)
    
    if point == "TOP" then
        frame:SetPoint("TOP", E.UIParent, "TOP", 0, 1)
    else
        frame:SetPoint("BOTTOM", E.UIParent, "BOTTOM", 0, -1)
    end
    
    -- 초기 너비는 화면 전체, 높이는 1
    frame:SetSize(GetScreenWidth() + 20, 1)
    frame:SetTemplate("Transparent")
    
    -- [수정] 클래식 호환 애니메이션 설정
    frame.anim = frame:CreateAnimationGroup()
    local grow = frame.anim:CreateAnimation("Height")
    -- SetToHeight 대신 SetChange 사용 (판다리아 클래식 API)
    grow:SetChange(GetScreenHeight() / 4) 
    grow:SetDuration(0.5)
    grow:SetSmoothing("Out")
    
    frame:SetScript("OnShow", function(self)
        self:SetHeight(1) -- 시작 시 높이 초기화
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

    -- 모델 홀더 (간소화)
    if not GameMenuFrame.IRplayerHolder then
        local ph = CreateFrame("Frame", nil, GameMenuFrame)
        ph:SetSize(150, 150)
        ph:SetPoint("RIGHT", GameMenuFrame, "LEFT", -300, 0)
        local pm = CreateFrame("PlayerModel", nil, ph)
        pm:SetPoint("CENTER")
        pm:SetSize(GetScreenWidth() * 1.5, GetScreenHeight() * 1.5)
        pm:SetScript("OnShow", function(self)
            self:SetUnit("player")
            self:SetAnimation(69)
        end)
        GameMenuFrame.IRplayerHolder = ph
    end
end

function module:Initialize()
    -- 옵션 경로 확인
    if E.db.IringUI and E.db.IringUI.misc and E.db.IringUI.misc.gameMenu then
        self:SetupGameMenu()
    end
end
