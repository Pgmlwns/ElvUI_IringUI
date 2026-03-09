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

    -- [상단 패널]
    local tp = CreateFrame("Frame", "IR_TopPanel", GameMenuFrame, "BackdropTemplate")
    tp:SetFrameStrata("TOOLTIP") tp:SetFrameLevel(10)
    tp:SetSize(E.screenWidth + 20, E.screenHeight / 4)
    tp:SetPoint("TOP", E.UIParent, "TOP", 0, 1)
    
    tp:SetTemplate("Transparent")
    if IR.Styling then 
        IR.Styling(tp) 
        if tp.IRstripes then tp.IRstripes:SetAlpha(1) end
        if tp.IRshadow then tp.IRshadow:SetAlpha(0.4) end
    end
    
    -- 상단 패널 하단 직업 색상 선
    local tpLine = tp:CreateTexture(nil, "OVERLAY")
    tpLine:SetHeight(2)
    tpLine:SetPoint("BOTTOMLEFT", tp, "BOTTOMLEFT", 0, 0)
    tpLine:SetPoint("BOTTOMRIGHT", tp, "BOTTOMRIGHT", 0, 0)
    tpLine:SetTexture(E.media.blankTex)
    tpLine:SetVertexColor(color.r, color.g, color.b)
    
    -- [중앙 상단 직업 아이콘]
    local classIcon = tp:CreateTexture(nil, "OVERLAY")
    classIcon:SetSize(80, 80)
    classIcon:SetPoint("CENTER", tp, "BOTTOM", 0, 0)
    classIcon:SetTexture("Interface\\Icons\\ClassIcon_"..E.myclass) 
    tp.classIcon = classIcon

    -- [하단 패널]
    local bp = CreateFrame("Frame", "IR_BottomPanel", GameMenuFrame, "BackdropTemplate")
    bp:SetFrameStrata("TOOLTIP") bp:SetFrameLevel(10)
    bp:SetSize(E.screenWidth + 20, E.screenHeight / 4)
    bp:SetPoint("BOTTOM", E.UIParent, "BOTTOM", 0, -1)
    
    bp:SetTemplate("Transparent")
    if IR.Styling then 
        IR.Styling(bp) 
        if bp.IRstripes then bp.IRstripes:SetAlpha(1) end
        if bp.IRshadow then bp.IRshadow:SetAlpha(0.4) end
    end

    -- 하단 패널 상단 직업 색상 선
    local bpLine = bp:CreateTexture(nil, "OVERLAY")
    bpLine:SetHeight(2)
    bpLine:SetPoint("TOPLEFT", bp, "TOPLEFT", 0, 0)
    bpLine:SetPoint("TOPRIGHT", bp, "TOPRIGHT", 0, 0)
    bpLine:SetTexture(E.media.blankTex)
    bpLine:SetVertexColor(color.r, color.g, color.b)

    -- [중앙 하단 로고]
    local logo = bp:CreateTexture(nil, "OVERLAY")
    logo:SetSize(120, 60)
    logo:SetPoint("CENTER", bp, "TOP", 0, -10)
    logo:SetTexture("Interface\\Glues\\MainScreen\\Glues-WoW-Logo") 
    bp.logo = logo

    -- [왼쪽 캐릭터 모델] 크기 및 위치 수정
    local model = CreateFrame("PlayerModel", "IR_GameMenuModel", GameMenuFrame)
    model:SetFrameStrata("TOOLTIP")
    model:SetFrameLevel(9)
    
    -- 모델 크기 축소 (기존 해상도 절반 수준에서 적정 크기로 조정)
    model:SetSize(E.screenWidth / 3, E.screenHeight) 
    
    -- [위치 수정] 왼쪽 끝에서 120픽셀 지점으로 이동
    model:SetPoint("LEFT", E.UIParent, "LEFT", 120, -20) 
    
    model:SetUnit("player")
    model:SetFacing(0.5) -- 모델 회전 각도
    model:SetCamDistanceScale(1.3) -- 숫자를 키울수록 캐릭터가 작게 보입니다 (멀어짐)
    model:SetPortraitZoom(0) -- 전신 모드
    
    model:SetScript("OnShow", function(self) 
        self:SetUnit("player") 
        self:SetAnimation(0) 
        self:SetRotation(0.5)
    end)
    
    GameMenuFrame.IRplayerModel = model
    GameMenuFrame.IRtopPanel = tp
    GameMenuFrame.IRbottomPanel = bp
end

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
