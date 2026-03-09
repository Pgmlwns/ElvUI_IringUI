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

    -- 현재 캐릭터의 직업 색상 가져오기
    local color = RAID_CLASS_COLORS[E.myclass]

    -- [1] 상단 패널 생성
    local tp = CreateFrame("Frame", "IR_TopPanel", GameMenuFrame, "BackdropTemplate")
    tp:SetFrameStrata("TOOLTIP") tp:SetFrameLevel(10)
    tp:SetSize(E.screenWidth + 20, E.screenHeight / 4)
    tp:SetPoint("TOP", E.UIParent, "TOP", 0, 1)
    tp:SetTemplate("Transparent")
    if IR.ApplyStyle then IR:ApplyStyle(tp) end
    
    -- 상단 패널 하단 직업 색상 선 (두께 2px)
    local tpLine = tp:CreateTexture(nil, "OVERLAY")
    tpLine:SetHeight(2)
    tpLine:SetPoint("BOTTOMLEFT", tp, "BOTTOMLEFT", 0, 0)
    tpLine:SetPoint("BOTTOMRIGHT", tp, "BOTTOMRIGHT", 0, 0)
    tpLine:SetTexture(E.media.blankTex)
    tpLine:SetVertexColor(color.r, color.g, color.b)
    
    -- [중앙 상단] 직업 아이콘 (나중에 경로 수정 가능)
    local classIcon = tp:CreateTexture(nil, "OVERLAY")
    classIcon:SetSize(80, 80)
    classIcon:SetPoint("CENTER", tp, "BOTTOM", 0, 0) -- 하단 선 중앙에 배치
    -- 현재 직업 아이콘 자동 설정 (경로: "Interface\\Icons\\ClassIcon_"..E.myclass)
    classIcon:SetTexture("Interface\\Icons\\ClassIcon_"..E.myclass) 
    tp.classIcon = classIcon

    -- [2] 하단 패널 생성
    local bp = CreateFrame("Frame", "IR_BottomPanel", GameMenuFrame, "BackdropTemplate")
    bp:SetFrameStrata("TOOLTIP") bp:SetFrameLevel(10)
    bp:SetSize(E.screenWidth + 20, E.screenHeight / 4)
    bp:SetPoint("BOTTOM", E.UIParent, "BOTTOM", 0, -1)
    bp:SetTemplate("Transparent")
    if IR.ApplyStyle then IR:ApplyStyle(bp) end

    -- 하단 패널 상단 직업 색상 선 (두께 2px)
    local bpLine = bp:CreateTexture(nil, "OVERLAY")
    bpLine:SetHeight(2)
    bpLine:SetPoint("TOPLEFT", bp, "TOPLEFT", 0, 0)
    bpLine:SetPoint("TOPRIGHT", bp, "TOPRIGHT", 0, 0)
    bpLine:SetTexture(E.media.blankTex)
    bpLine:SetVertexColor(color.r, color.g, color.b)

    -- [중앙 하단] 커스텀 로고 (나중에 경로 수정 가능)
    local logo = bp:CreateTexture(nil, "OVERLAY")
    logo:SetSize(120, 60)
    logo:SetPoint("CENTER", bp, "TOP", 0, -10) -- 상단 선 중앙에서 살짝 아래로
    -- 임시 경로 (나중에 로고 파일 경로로 바꾸세요)
    logo:SetTexture("Interface\\Glues\\MainScreen\\Glues-WoW-Logo") 
    bp.logo = logo

    -- [3] 왼쪽 캐릭터 모델 (중앙 메뉴 쪽으로 가깝게 배치)
    local model = CreateFrame("PlayerModel", "IR_GameMenuModel", GameMenuFrame)
    model:SetFrameStrata("TOOLTIP")
    model:SetFrameLevel(9) -- 메뉴 버튼보다 살짝 아래 레이어
    model:SetSize(E.screenWidth / 2, E.screenHeight * 1.2) -- 전신이 잘 나오도록 크게 설정
    
    -- 위치 수정: 왼쪽 끝에서 450픽셀 지점으로 이동 (중앙 메뉴에 가깝게)
    model:SetPoint("LEFT", E.UIParent, "LEFT", 450, -50) 
    
    model:SetUnit("player")
    model:SetFacing(0.4) -- 메뉴를 살짝 바라보는 각도
    model:SetCamDistanceScale(1.1) -- 캐릭터 크기 비율
    model:SetPortraitZoom(0) -- 전신 샷
    
    -- 매번 ESC를 누를 때마다 모델 정보 갱신
    model:SetScript("OnShow", function(self) 
        self:SetUnit("player") 
        self:SetAnimation(0) -- 대기 모션
        self:SetRotation(0.4)
    end)
    
    GameMenuFrame.IRplayerModel = model
    GameMenuFrame.IRtopPanel = tp
    GameMenuFrame.IRbottomPanel = bp
end

-- 시스템 초기화 및 후킹 로직
function module:Initialize()
    local frame = _G["GameMenuFrame"]
    if frame then
        -- 게임 메뉴가 열릴 때 실행
        frame:HookScript("OnShow", function()
            if E.db.IringUI and E.db.IringUI and E.db.IringUI.misc and E.db.IringUI.misc.gameMenu then
                module:SetupGameMenu()
                -- 각 요소들을 강제로 출력
                if frame.IRtopPanel then frame.IRtopPanel:Show() end
                if frame.IRbottomPanel then frame.IRbottomPanel:Show() end
                if frame.IRplayerModel then frame.IRplayerModel:Show() end
            end
        end)
        -- 게임 메뉴가 닫힐 때 실행
        frame:HookScript("OnHide", function()
            if frame.IRtopPanel then frame.IRtopPanel:Hide() end
            if frame.IRbottomPanel then frame.IRbottomPanel:Hide() end
            if frame.IRplayerModel then frame.IRplayerModel:Hide() end
        end)
    end
end

-- PLAYER_ENTERING_WORLD 이벤트를 통해 초기화 보장
local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", function()
    module:Initialize()
end)
