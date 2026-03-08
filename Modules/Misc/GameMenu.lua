local IR, F, E, L, V, P, G = unpack(select(2, ...))
-- IR:NewModule을 통해 모듈을 생성하면 자동으로 IR의 모듈 리스트에 등록됩니다.
local module = IR:NewModule('IR_GameMenu', 'AceEvent-3.0')
local _G = _G

-- 로컬 유틸리티 함수
local random = random
local CreateFrame = CreateFrame
local CreateAnimationGroup = CreateAnimationGroup
local GetScreenWidth, GetScreenHeight = GetScreenWidth, GetScreenHeight
local UIFrameFadeIn = UIFrameFadeIn

-- [중요] 텍스처 경로: 본인의 AddOns 폴더 구조에 맞게 파일이 있는지 꼭 확인하세요.
local logoTexture = [[Interface\AddOns\ElvUI_IringUI\Media\Textures\mUI1.tga]]
local classBannerPath = [[Interface\AddOns\ElvUI_IringUI\Media\Textures\ClassBanner\CLASS-]]

-- 모델 리스트 (판다리아 및 최신 버전 포함)
local NPCS = {
    285, 86470, 16445, 15552, 32398, 82464, 71163, 91226, 54128, 28883, 61324, 23754, 34694, 54438, 
    85009, 68267, 51601, 85283, 103159, 123650, 126579, 85463, 119408, 127956, 85682, 72285, 
    67332, 71693, 66499, 139073, 139770, 140125, 141941, 143160, 143507, 143563, 143794, 143796, 
    172854, 175783, 171716, 173586, 173992, 183638, 188844, 188861, 189152, 191627,
}

local Sequences = {26, 52, 69, 111, 225}

-- 플레이어 모델 설정 함수
local function SetPlayerModel(self)
    local key = random(1, #Sequences)
    self:ClearModel()
    self:SetUnit("player")
    self:SetFacing(6.5)
    self:SetPortraitZoom(0.05)
    self:SetCamDistanceScale(4.8)
    self:SetAlpha(1)
    self:SetAnimation(Sequences[key])
    UIFrameFadeIn(self, 1, 0, 1)
end

-- NPC 모델 설정 함수
local function SetNPCModel(self)
    local npcID = NPCS[random(1, #NPCS)]
    local key = random(1, #Sequences)
    self:ClearModel()
    self:SetCreature(npcID)
    self:SetCamDistanceScale(1)
    self:SetFacing(6)
    self:SetAlpha(1)
    self:SetAnimation(Sequences[key])
    UIFrameFadeIn(self, 1, 0, 1)
end

function module:SetupGameMenu()
    local GameMenuFrame = _G["GameMenuFrame"]
    if not GameMenuFrame then return end

    -- 1. 하단 패널 (Bottom Panel)
    if not GameMenuFrame.IRbottomPanel then
        GameMenuFrame.IRbottomPanel = CreateFrame("Frame", nil, GameMenuFrame, "BackdropTemplate")
        local bp = GameMenuFrame.IRbottomPanel
        bp:SetFrameLevel(0)
        bp:SetPoint("BOTTOM", E.UIParent, "BOTTOM", 0, -E.Border)
        bp:SetSize(GetScreenWidth() + (E.Border * 2), GetScreenHeight() / 4)
        bp:SetTemplate("Transparent")

        -- 판다리아 클래식 호환 애니메이션
        bp.anim = CreateAnimationGroup(bp)
        local h = bp.anim:CreateAnimation("Height")
        h:SetFromHeight(0)
        h:SetToHeight(GetScreenHeight() / 4)
        h:SetDuration(0.6)
        h:SetSmoothing("Out")

        bp:SetScript("OnShow", function(self) self.anim:Play() end)

        bp.Logo = bp:CreateTexture(nil, "ARTWORK")
        bp.Logo:SetSize(150, 150)
        bp.Logo:SetPoint("CENTER", bp, "CENTER", 0, 0)
        bp.Logo:SetTexture(logoTexture)
    end

    -- 2. 상단 패널 (Top Panel)
    if not GameMenuFrame.IRtopPanel then
        GameMenuFrame.IRtopPanel = CreateFrame("Frame", nil, GameMenuFrame, "BackdropTemplate")
        local tp = GameMenuFrame.IRtopPanel
        tp:SetFrameLevel(0)
        tp:SetPoint("TOP", E.UIParent, "TOP", 0, E.Border)
        tp:SetSize(GetScreenWidth() + (E.Border * 2), GetScreenHeight() / 4)
        tp:SetTemplate("Transparent")

        tp.anim = CreateAnimationGroup(tp)
        local h = tp.anim:CreateAnimation("Height")
        h:SetFromHeight(0)
        h:SetToHeight(GetScreenHeight() / 4)
        h:SetDuration(0.6)
        h:SetSmoothing("Out")

        tp:SetScript("OnShow", function(self) self.anim:Play() end)

        tp.classLogo = tp:CreateTexture(nil, "ARTWORK")
        tp.classLogo:SetPoint("CENTER", tp, "CENTER", 0, 0)
        tp.classLogo:SetSize(186, 186)
        -- ElvUI 내부 클래스 변수 E.myclass 사용
        tp.classLogo:SetTexture(classBannerPath .. E.myclass)
    end

    -- 3. 좌측 플레이어 모델 홀더
    if not GameMenuFrame.IRplayerHolder then
        GameMenuFrame.IRplayerHolder = CreateFrame("Frame", nil, GameMenuFrame)
        GameMenuFrame.IRplayerHolder:SetSize(150, 150)
        GameMenuFrame.IRplayerHolder:SetPoint("RIGHT", GameMenuFrame, "LEFT", -300, 0)

        local m = CreateFrame("PlayerModel", nil, GameMenuFrame.IRplayerHolder)
        m:SetPoint("CENTER")
        m:SetSize(GetScreenWidth() * 1.5, GetScreenHeight() * 1.5)
        m:SetScale(0.8)
        m:SetScript("OnShow", SetPlayerModel)
    end

    -- 4. 우측 NPC 모델 홀더
    if not GameMenuFrame.IRnpcHolder then
        GameMenuFrame.IRnpcHolder = CreateFrame("Frame", nil, GameMenuFrame)
        GameMenuFrame.IRnpcHolder:SetSize(150, 150)
        GameMenuFrame.IRnpcHolder:SetPoint("LEFT", GameMenuFrame, "RIGHT", 300, 0)

        local m = CreateFrame("PlayerModel", nil, GameMenuFrame.IRnpcHolder)
        m:SetPoint("CENTER")
        m:SetSize(400, 400)
        m:SetScale(0.8)
        m:SetScript("OnShow", SetNPCModel)
    end
end

-- 모듈 초기화 함수 (IringUI가 로드될 때 실행됨)
function module:Initialize()
    -- 옵션 파일(Options.lua) 및 프로필(Profile.lua)의 경로 확인
    if E.db.IringUI and E.db.IringUI.misc and E.db.IringUI.misc.gameMenu then
        self:SetupGameMenu()
    end
end

-- [수정된 부분] 
-- RegisterModule(nil value) 오류 해결: 
-- IR:NewModule을 썼다면 보통 IR 메인 객체에서 Initialize를 호출하므로 별도 등록 함수가 필요 없습니다.
-- 만약 수동 등록이 필요한 구조라면 E:RegisterModule(module) 등을 사용해야 합니다.
