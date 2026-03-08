local addon, Engine = ...
local IR, F, E, L, V, P, G = unpack(Engine)

-- [에러 방지] P["IringUI"]가 생성 전일 때 대비
if not P["IringUI"] then P["IringUI"] = {} end
if not P["IringUI"]["misc"] then P["IringUI"]["misc"] = {} end
if P["IringUI"]["misc"]["gameMenu"] == nil then P["IringUI"]["misc"]["gameMenu"] = true end

local module = IR:NewModule('IR_GameMenu', 'AceEvent-3.0')
local _G = _G

-- [수동 디버깅용 전역 등록]
_G["IR_GM"] = module 

function module:SetupGameMenu()
    local GameMenuFrame = _G["GameMenuFrame"]
    if not GameMenuFrame or GameMenuFrame.IRtopPanel then return end

    -- 상단 패널
    local tp = CreateFrame("Frame", "IR_TopPanel", GameMenuFrame, "BackdropTemplate")
    tp:SetFrameStrata("TOOLTIP")
    tp:SetSize(GetScreenWidth() + 20, GetScreenHeight() / 4)
    tp:SetPoint("TOP", E.UIParent, "TOP", 0, 1)
    tp:SetTemplate("Transparent")
    if IR.ApplyStyle then IR:ApplyStyle(tp) end -- 빗살무늬 적용 확인용
    GameMenuFrame.IRtopPanel = tp

    -- 하단 패널
    local bp = CreateFrame("Frame", "IR_BottomPanel", GameMenuFrame, "BackdropTemplate")
    bp:SetFrameStrata("TOOLTIP")
    bp:SetSize(GetScreenWidth() + 20, GetScreenHeight() / 4)
    bp:SetPoint("BOTTOM", E.UIParent, "BOTTOM", 0, -1)
    bp:SetTemplate("Transparent")
    if IR.ApplyStyle then IR:ApplyStyle(bp) end
    GameMenuFrame.IRbottomPanel = bp
    
    print("|cffff69b4IringUI|r: 게임 메뉴 패널 생성 완료")
end

function module:Initialize()
    _G.GameMenuFrame:HookScript("OnShow", function()
        -- DB 경로 확인을 위한 디버깅 출력 (필요시 주석 해제)
        -- print("GameMenu OnShow: ", E.db.IringUI.misc.gameMenu)
        if E.db.IringUI and E.db.IringUI.misc and E.db.IringUI.misc.gameMenu then
            module:SetupGameMenu()
        end
    end)
end
