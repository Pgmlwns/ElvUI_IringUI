local addon, Engine = ...
local IR, F, E, L, V, P, G = unpack(Engine)

-- 모듈 생성
local module = IR:NewModule('IR_GameMenu', 'AceEvent-3.0')
local _G = _G

-- 리소스 경로 (본인의 파일 유무 확인 필수)
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
    
    -- 판다리아 클래식 호환 애니메이션 (Translation)
    frame.anim = frame:CreateAnimationGroup()
    local slide = frame.anim:CreateAnimation("Translation")
    slide:SetDuration(0.5)
    slide:SetSmoothing("Out")
    
    if point == "TOP" then
        frame:SetPoint("TOP", E.UIParent, "TOP", 0, panelHeight)
        slide:SetOffset(0, -panelHeight)
    else
        frame:SetPoint("BOTTOM", E.UIParent, "BOTTOM", 0, -panelHeight)
        slide:SetOffset(0, panelHeight)
    end

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
    -- Defaults.lua에서 설정한 값을 참조합니다.
    if E.db.IringUI and E.db.IringUI.misc and E.db.IringUI.misc.gameMenu then
        self:SetupGameMenu()
    end
end
