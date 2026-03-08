local addon, Engine = ...
local IR, F, E, L, V, P, G = unpack(Engine)

-- 모듈 생성
local module = IR:NewModule('IR_GameMenu', 'AceEvent-3.0')
local _G = _G

local logoTexture = [[Interface\AddOns\ElvUI_IringUI\Media\Textures\mUI1.tga]]
local classBannerPath = [[Interface\AddOns\ElvUI_IringUI\Media\Textures\ClassBanner\CLASS-]]

-- 패널 생성 함수 (애니메이션 제외, 즉시 출력)
local function CreateMenuPanel(name, point)
    local GameMenuFrame = _G["GameMenuFrame"]
    local frame = CreateFrame("Frame", name, GameMenuFrame, "BackdropTemplate")
    frame:SetFrameStrata("HIGH")
    frame:SetFrameLevel(1)
    
    local panelHeight = GetScreenHeight() / 4
    frame:SetSize(GetScreenWidth() + 20, panelHeight)
    frame:SetTemplate("Transparent")
    
    if point == "TOP" then
        frame:SetPoint("TOP", E.UIParent, "TOP", 0, 1)
    else
        frame:SetPoint("BOTTOM", E.UIParent, "BOTTOM", 0, -1)
    end
    
    return frame
end

function module:SetupGameMenu()
    local GameMenuFrame = _G["GameMenuFrame"]
    if not GameMenuFrame then return end

    -- 상단 패널
    if not GameMenuFrame.IRtopPanel then
        GameMenuFrame.IRtopPanel = CreateMenuPanel("IR_TopPanel", "TOP")
        local t1 = GameMenuFrame.IRtopPanel:CreateTexture(nil, "OVERLAY")
        t1:SetPoint("CENTER")
        t1:SetSize(180, 180)
        t1:SetTexture(classBannerPath .. E.myclass)
    end

    -- 하단 패널
    if not GameMenuFrame.IRbottomPanel then
        GameMenuFrame.IRbottomPanel = CreateMenuPanel("IR_BottomPanel", "BOTTOM")
        local t2 = GameMenuFrame.IRbottomPanel:CreateTexture(nil, "OVERLAY")
        t2:SetPoint("CENTER")
        t2:SetSize(140, 140)
        t2:SetTexture(logoTexture)
    end
end

-- [핵심] Initialize가 안 불릴 경우를 대비해 OnShow 직접 후킹
function module:Initialize()
    local GameMenuFrame = _G["GameMenuFrame"]
    if GameMenuFrame then
        GameMenuFrame:HookScript("OnShow", function()
            -- DB 체크 (테스트를 위해 잠시 무시하거나 확실히 체크)
            if E.db.IringUI and E.db.IringUI.misc and E.db.IringUI.misc.gameMenu then
                module:SetupGameMenu()
            end
        end)
    end
end
