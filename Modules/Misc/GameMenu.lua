local addon, Engine = ...
local IR, F, E, L, V, P, G = unpack(Engine)

local module = IR:NewModule('IR_GameMenu', 'AceEvent-3.0')
local _G = _G

local logoTexture = [[Interface\AddOns\ElvUI_IringUI\Media\Textures\mUI1.tga]]
local classBannerPath = [[Interface\AddOns\ElvUI_IringUI\Media\Textures\ClassBanner\CLASS-]]

-- 패널 생성 및 애니메이션 로직
local function CreateMenuPanel(name, point)
    local GameMenuFrame = _G["GameMenuFrame"]
    local frame = CreateFrame("Frame", name, GameMenuFrame, "BackdropTemplate")
    frame:SetFrameStrata("HIGH")
    frame:SetFrameLevel(1)
    
    local panelHeight = GetScreenHeight() / 4
    frame:SetSize(GetScreenWidth() + 20, panelHeight)
    frame:SetTemplate("Transparent")
    
    -- 애니메이션 그룹 생성
    frame.anim = frame:CreateAnimationGroup()
    
    -- [수정] 클래식에서 가장 안정적인 Translation(이동) 애니메이션 사용
    local slide = frame.anim:CreateAnimation("Translation")
    slide:SetDuration(0.5)
    slide:SetSmoothing("Out")
    
    if point == "TOP" then
        frame:SetPoint("TOP", E.UIParent, "TOP", 0, panelHeight) -- 화면 밖(위쪽)에서 시작
        slide:SetOffset(0, -panelHeight) -- 아래로 내려옴
    else
        frame:SetPoint("BOTTOM", E.UIParent, "BOTTOM", 0, -panelHeight) -- 화면 밖(아래쪽)에서 시작
        slide:SetOffset(0, panelHeight) -- 위로 올라옴
    end

    -- 애니메이션이 끝나면 위치 고정
    frame.anim:SetScript("OnFinished", function(self)
        local parent = self:GetParent()
        parent:ClearAllPoints()
        if point == "TOP" then
            parent:SetPoint("TOP", E.UIParent, "TOP", 0, 1)
        else
            parent:SetPoint("BOTTOM", E.UIParent, "BOTTOM", 0, -1)
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

function module:Initialize()
    if E.db.IringUI and E.db.IringUI.misc and E.db.IringUI.misc.gameMenu then
        self:SetupGameMenu()
    end
end
