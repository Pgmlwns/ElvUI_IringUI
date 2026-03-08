local addon, Engine = ...
local IR, F, E, L, V, P, G = unpack(Engine)
local module = IR:NewModule('IR_GameMenu')

function module:SetupGameMenu()
    local GameMenuFrame = _G.GameMenuFrame
    if not GameMenuFrame or GameMenuFrame.IRtopPanel then return end

    -- 상단 패널 생성 (높이 직접 지정)
    local tp = CreateFrame("Frame", "IR_TopPanel", GameMenuFrame, "BackdropTemplate")
    tp:SetSize(GetScreenWidth() + 20, GetScreenHeight() / 4)
    tp:SetPoint("TOP", E.UIParent, "TOP", 0, 1)
    tp:SetTemplate("Transparent")
    GameMenuFrame.IRtopPanel = tp

    -- 하단 패널 생성
    local bp = CreateFrame("Frame", "IR_BottomPanel", GameMenuFrame, "BackdropTemplate")
    bp:SetSize(GetScreenWidth() + 20, GetScreenHeight() / 4)
    bp:SetPoint("BOTTOM", E.UIParent, "BOTTOM", 0, -1)
    bp:SetTemplate("Transparent")
    GameMenuFrame.IRbottomPanel = bp
end

function module:Initialize()
    _G.GameMenuFrame:HookScript("OnShow", function()
        if E.db.IringUI.misc.gameMenu then
            self:SetupGameMenu()
        end
    end)
end
