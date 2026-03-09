local addon, Engine = ...
local IR, F, E, L, V, P, G = unpack(Engine)

-- [안전 장치]
P["IringUI"] = P["IringUI"] or {}
P["IringUI"]["misc"] = P["IringUI"]["misc"] or {}
if P["IringUI"]["misc"]["gameMenu"] == nil then P["IringUI"]["misc"]["gameMenu"] = true end

local module = IR:NewModule('IR_GameMenu')
local _G = _G

function module:SetupGameMenu()
    local GameMenuFrame = _G["GameMenuFrame"]
    if not GameMenuFrame or GameMenuFrame.IRtopPanel then return end

    local color = RAID_CLASS_COLORS[E.myclass]

    -- [1] 상단 패널
    local tp = CreateFrame("Frame", "IR_TopPanel", GameMenuFrame, "BackdropTemplate")
    tp:SetFrameStrata("TOOLTIP") tp:SetFrameLevel(10)
    tp:SetSize(E.screenWidth + 20, E.screenHeight / 4)
    tp:SetPoint("TOP", E.UIParent, "TOP", 0, 1)
    tp:SetTemplate("Transparent")
    if IR.ApplyStyle then IR:ApplyStyle(tp) end
    
    -- 상단 직업 선
    local tpLine = tp:CreateTexture(nil, "OVERLAY")
    tpLine:SetHeight(2)
    tpLine:SetPoint("BOTTOMLEFT", tp, "BOTTOMLEFT", 0, 0)
    tpLine:SetPoint("BOTTOMRIGHT", tp, "BOTTOMRIGHT", 0, 0)
    tpLine:SetTexture(E.media.blankTex)
    tpLine:SetVertexColor(color.r, color.g, color.b)
    
    -- [중앙 상단] 직업 아이콘 (경로 수정 가능)
    local classIcon = tp:CreateTexture(nil, "OVERLAY")
    classIcon:SetSize(80, 80)
    classIcon:SetPoint("CENTER", tp, "BOTTOM", 0, 0) -- 선에 걸치게 배치
    -- 임시 경로 (나중에 원하는 아이콘 경로로 바꾸세요)
    classIcon:SetTexture("Interface\\Icons\\ClassIcon_"..E.myclass) 
    tp.classIcon = classIcon

    -- [2] 하단 패널
    local bp = CreateFrame("Frame", "IR_BottomPanel", GameMenuFrame, "BackdropTemplate")
    bp:SetFrameStrata("TOOLTIP") bp:SetFrameLevel(10)
    bp:SetSize(E.screenWidth + 20, E.screenHeight / 4)
    bp:SetPoint("BOTTOM", E.UIParent, "BOTTOM", 0, -1)
    bp:SetTemplate("Transparent")
    if IR.ApplyStyle then IR:ApplyStyle(bp) end

    -- 하단 직업 선
    local bpLine = bp:CreateTexture(nil, "OVERLAY")
    bpLine:SetHeight(2)
    bpLine:SetPoint("TOPLEFT", bp, "TOPLEFT", 0, 0)
    bpLine:SetPoint("TOPRIGHT", bp, "TOPRIGHT", 0, 0)
    bpLine:SetTexture(E.media.blankTex)
    bpLine:SetVertexColor(color.r, color.g, color.b)

    -- [중앙 하단] 커스텀 로고 (경로 수정 가능)
    local logo = bp:CreateTexture(nil, "OVERLAY")
    logo:SetSize(120, 60)
    logo:SetPoint("CENTER", bp, "TOP", 0, -10)
    -- 임시 경로 (나중에 로고 파일 경로로 바꾸세요)
    logo:SetTexture("Interface\\Glues\\MainScreen\\Glues-WoW-Logo") 
    bp.logo = logo

    -- [3] 왼쪽 캐릭터 모델 (현제 접속 중인 캐릭터)
    local model = CreateFrame("PlayerModel", "IR_GameMenuModel", GameMenuFrame)
    model:SetFrameStrata("TOOLTIP")
    model:SetFrameLevel(11) -- 패널보다 위
    model:SetSize(E.screenWidth / 3, E.screenHeight * 0.6)
    model:SetPoint("LEFT", E.UIParent, "LEFT", 100, 0)
    model:SetUnit("player")
    model:SetFacing(0.5) -- 약간 비스듬하게
    model:SetAnimation(0) -- 기본 대기 동작
    model:SetScript("OnShow", function(self) self:SetUnit("player") end)
    GameMenuFrame.IRplayerModel = model

    GameMenuFrame.IRtopPanel = tp
    GameMenuFrame.IRbottomPanel = bp
end

-- 초기화 및 후킹 로직
function module:Initialize()
    local frame = _G["GameMenuFrame"]
    if frame then
        frame:HookScript("OnShow", function()
            if E.db.IringUI and E.db.IringUI.misc and E.db.IringUI.misc.gameMenu then
                module:SetupGameMenu()
                if frame.IRtopPanel then frame.IRtopPanel:Show() end
                if frame.IRbottomPanel then frame.IRbottomPanel:Show() end
                if frame.IRplayerModel then frame.IRplayerModel:Show() end
            end
        end)
        frame:HookScript("OnHide", function()
            if frame.IRtopPanel then frame.IRtopPanel:Hide() end
            if frame.IRbottomPanel then frame.IRbottomPanel:Hide() end
            if frame.IRplayerModel then frame.IRplayerModel:Hide() end
        end)
    end
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", function()
    module:Initialize()
end)
