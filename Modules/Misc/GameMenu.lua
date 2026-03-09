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

    -- 직업 색상 가져오기
    local color = RAID_CLASS_COLORS[E.myclass]

    -- 상단 패널
    local tp = CreateFrame("Frame", "IR_TopPanel", GameMenuFrame, "BackdropTemplate")
    tp:SetFrameStrata("TOOLTIP") tp:SetFrameLevel(10)
    tp:SetSize(GetScreenWidth() + 20, GetScreenHeight() / 4)
    tp:SetPoint("TOP", E.UIParent, "TOP", 0, 1)
    tp:SetTemplate("Transparent")
    if IR.ApplyStyle then IR:ApplyStyle(tp) end
    
    -- [추가] 상단 패널 하단 직업 색상 선
    local tpLine = tp:CreateTexture(nil, "OVERLAY")
    tpLine:SetHeight(2) -- 선 두께
    tpLine:SetPoint("BOTTOMLEFT", tp, "BOTTOMLEFT", 0, 0)
    tpLine:SetPoint("BOTTOMRIGHT", tp, "BOTTOMRIGHT", 0, 0)
    tpLine:SetTexture(E.media.blankTex)
    tpLine:SetVertexColor(color.r, color.g, color.b)
    
    GameMenuFrame.IRtopPanel = tp

    -- 하단 패널
    local bp = CreateFrame("Frame", "IR_BottomPanel", GameMenuFrame, "BackdropTemplate")
    bp:SetFrameStrata("TOOLTIP") bp:SetFrameLevel(10)
    bp:SetSize(GetScreenWidth() + 20, GetScreenHeight() / 4)
    bp:SetPoint("BOTTOM", E.UIParent, "BOTTOM", 0, -1)
    bp:SetTemplate("Transparent")
    if IR.ApplyStyle then IR:ApplyStyle(bp) end

    -- [추가] 하단 패널 상단 직업 색상 선
    local bpLine = bp:CreateTexture(nil, "OVERLAY")
    bpLine:SetHeight(2) -- 선 두께
    bpLine:SetPoint("TOPLEFT", bp, "TOPLEFT", 0, 0)
    bpLine:SetPoint("TOPRIGHT", bp, "TOPRIGHT", 0, 0)
    bpLine:SetTexture(E.media.blankTex)
    bpLine:SetVertexColor(color.r, color.g, color.b)
    
    GameMenuFrame.IRbottomPanel = bp
end

-- [수정] ElvUI 시스템 외부에서도 작동하도록 OnShow 직접 후킹
function module:Initialize()
    local frame = _G["GameMenuFrame"]
    if frame then
        frame:HookScript("OnShow", function()
            if E.db.IringUI and E.db.IringUI.misc and E.db.IringUI.misc.gameMenu then
                module:SetupGameMenu()
                -- 강제 출력
                if frame.IRtopPanel then frame.IRtopPanel:Show() end
                if frame.IRbottomPanel then frame.IRbottomPanel:Show() end
            end
        end)
    end
end

-- [강제 실행] 혹시라도 Initialize가 씹힐 경우를 대비해 이벤트 등록
local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", function()
    module:Initialize()
end)
