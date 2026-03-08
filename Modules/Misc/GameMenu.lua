local addon, Engine = ...
local IR, F, E, L, V, P, G = unpack(Engine)

-- [안전 장치] 설정값 주입
P["IringUI"] = P["IringUI"] or {}
P["IringUI"]["misc"] = P["IringUI"]["misc"] or {}
if P["IringUI"]["misc"]["gameMenu"] == nil then P["IringUI"]["misc"]["gameMenu"] = true end

local module = IR:NewModule('IR_GameMenu', 'AceEvent-3.0')
local _G = _G

-- 디버깅 및 수동 호출용 전역 변수 유지
_G["IR_GM"] = module 

local logoTexture = [[Interface\AddOns\ElvUI_IringUI\Media\Textures\mUI1.tga]]
local classBannerPath = [[Interface\AddOns\ElvUI_IringUI\Media\Textures\ClassBanner\CLASS-]]

local function CreateMenuPanel(name, point)
    local GameMenuFrame = _G["GameMenuFrame"]
    if _G[name] then return _G[name] end

    local frame = CreateFrame("Frame", name, GameMenuFrame, "BackdropTemplate")
    frame:SetFrameStrata("TOOLTIP")
    frame:SetFrameLevel(10)
    frame:SetSize(GetScreenWidth() + 20, GetScreenHeight() / 4)
    frame:SetTemplate("Transparent")
    
    if point == "TOP" then
        frame:SetPoint("TOP", E.UIParent, "TOP", 0, 1)
    else
        frame:SetPoint("BOTTOM", E.UIParent, "BOTTOM", 0, -1)
    end

    if IR.ApplyStyle then IR:ApplyStyle(frame) end
    return frame
end

function module:SetupGameMenu()
    local GameMenuFrame = _G["GameMenuFrame"]
    if not GameMenuFrame or GameMenuFrame.IRtopPanel then return end

    GameMenuFrame.IRtopPanel = CreateMenuPanel("IR_TopPanel", "TOP")
    local t1 = GameMenuFrame.IRtopPanel:CreateTexture(nil, "OVERLAY")
    t1:SetPoint("CENTER") t1:SetSize(180, 180)
    t1:SetTexture(classBannerPath .. E.myclass)

    GameMenuFrame.IRbottomPanel = CreateMenuPanel("IR_BottomPanel", "BOTTOM")
    local t2 = GameMenuFrame.IRbottomPanel:CreateTexture(nil, "OVERLAY")
    t2:SetPoint("CENTER") t2:SetSize(140, 140)
    t2:SetTexture(logoTexture)
end

function module:Initialize()
    -- [보강] 게임 메뉴가 로드될 때 확실히 실행되도록 HookScript 사용
    if _G.GameMenuFrame then
        _G.GameMenuFrame:HookScript("OnShow", function()
            -- DB 설정이 true이거나, 설정값이 아직 없을 때(기본값) 실행
            local db = E.db.IringUI
            if not db or not db.misc or db.misc.gameMenu ~= false then
                module:SetupGameMenu()
                -- 생성 후 명시적으로 Show (수동 명령어 로직과 동일하게)
                if _G.GameMenuFrame.IRtopPanel then _G.GameMenuFrame.IRtopPanel:Show() end
                if _G.GameMenuFrame.IRbottomPanel then _G.GameMenuFrame.IRbottomPanel:Show() end
            end
        end)
    end
end
