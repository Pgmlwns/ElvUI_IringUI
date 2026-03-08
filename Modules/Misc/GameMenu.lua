local addon, Engine = ...
local IR, F, E, L, V, P, G = unpack(Engine)

-- [안전 장치] P["IringUI"] 그릇이 없으면 생성 (5번 줄 에러 방지)
if not P["IringUI"] then P["IringUI"] = {} end
if not P["IringUI"]["misc"] then P["IringUI"]["misc"] = {} end
if P["IringUI"]["misc"]["gameMenu"] == nil then 
    P["IringUI"]["misc"]["gameMenu"] = true 
end

-- 모듈 생성 (이 시점에 init.lua의 IR.modules 리스트에 등록됨)
local module = IR:NewModule('IR_GameMenu', 'AceEvent-3.0')
local _G = _G

-- 디버깅 및 수동 호출용 전역 변수 유지
_G["IR_GM"] = module 

local logoTexture = [[Interface\AddOns\ElvUI_IringUI\Media\Textures\mUI1.tga]]
local classBannerPath = [[Interface\AddOns\ElvUI_IringUI\Media\Textures\ClassBanner\CLASS-]]

-- 패널 생성 함수
local function CreateMenuPanel(name, point)
    local GameMenuFrame = _G["GameMenuFrame"]
    if _G[name] then return _G[name] end -- 이미 존재하면 중복 생성 방지

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

    -- init.lua에 정의된 공통 스타일 함수 호출 (빗살무늬 적용)
    if IR.ApplyStyle then IR:ApplyStyle(frame) end
    
    return frame
end

-- 패널 구성 및 출력 함수
function module:SetupGameMenu()
    local GameMenuFrame = _G["GameMenuFrame"]
    if not GameMenuFrame or GameMenuFrame.IRtopPanel then return end

    -- 상단 패널 생성
    GameMenuFrame.IRtopPanel = CreateMenuPanel("IR_TopPanel", "TOP")
    local t1 = GameMenuFrame.IRtopPanel:CreateTexture(nil, "OVERLAY")
    t1:SetPoint("CENTER") t1:SetSize(180, 180)
    t1:SetTexture(classBannerPath .. E.myclass)

    -- 하단 패널 생성
    GameMenuFrame.IRbottomPanel = CreateMenuPanel("IR_BottomPanel", "BOTTOM")
    local t2 = GameMenuFrame.IRbottomPanel:CreateTexture(nil, "OVERLAY")
    t2:SetPoint("CENTER") t2:SetSize(140, 140)
    t2:SetTexture(logoTexture)
end

-- [자동 실행 핵심] init.lua의 루프에 의해 호출됨
function module:Initialize()
    -- 게임 메뉴(ESC)가 나타날 때 실행되도록 후킹
    if _G.GameMenuFrame then
        _G.GameMenuFrame:HookScript("OnShow", function()
            -- DB 설정값 체크 (켜져 있을 때만 실행)
            if E.db.IringUI and E.db.IringUI.misc and E.db.IringUI.misc.gameMenu then
                module:SetupGameMenu()
                -- 생성 후 명시적으로 Show (안전 장치)
                if _G.GameMenuFrame.IRtopPanel then _G.GameMenuFrame.IRtopPanel:Show() end
                if _G.GameMenuFrame.IRbottomPanel then _G.GameMenuFrame.IRbottomPanel:Show() end
            end
        end)
    end
end
