-- 순서: IR, F, E, L, V, P, G
local IR, F, E, L, V, P, G = unpack(select(2, ...))

-- [원본 유지] 빗살무늬 및 그림자 로직 (절대 수정 금지)
local function Styling(f, useStripes, useShadow)
    if not E.db or not E.db.IringUI or not E.db.IringUI.skin.enable then return end
    if not f or f.IRstyle or f.__style then return end

    local frameName = f.GetName and f:GetName()
    local style = CreateFrame("Frame", frameName and frameName.."_IRStyle" or nil, f, "BackdropTemplate")

    -- 빗살무늬
    if E.db.IringUI.skin.stripes and not useStripes then
        local stripes = f:CreateTexture(nil, "BORDER")
        stripes:SetInside(f, 1, -1)
        stripes:SetTexture(IR.Media.Stripes, true, true)
        stripes:SetHorizTile(true) stripes:SetVertTile(true)
        stripes:SetBlendMode("ADD")
        if frameName and (frameName:find("PluginInstall") or frameName:find("ElvUIInstall")) then
            stripes:SetDrawLayer("OVERLAY", 7)
        end
        style.stripes = stripes
    end

    -- 그림자 (은은한 직업 색상)
    if E.db.IringUI.skin.shadow and not useShadow then
        local mshadow = f:CreateTexture(nil, "BORDER")
        mshadow:SetInside(f, 0, 0)
        mshadow:SetTexture(IR.Media.Overlay)
        local color = RAID_CLASS_COLORS[E.myclass]
        mshadow:SetVertexColor(color.r, color.g, color.b)
        mshadow:SetAlpha(0.4)
        style.mshadow = mshadow
    end

    style:SetFrameStrata(f:GetFrameStrata())
    style:SetFrameLevel(f:GetFrameLevel() + 1)
    style:SetAllPoints(f)
    f.IRstyle = style
    f.__style = 1
end

-- [보강] 모든 버튼 및 탭 테두리 하이라이트 적용 함수
local function StyleButton(f)
    if not f or f.IringBtnStyled then return end
    
    -- 마우스 진입 시 직업 색상 테두리
    f:HookScript("OnEnter", function(self)
        local color = RAID_CLASS_COLORS[E.myclass]
        local target = self.backdrop or (self.GetBackdrop and self)
        if target and target.SetBackdropBorderColor then
            target:SetBackdropBorderColor(color.r, color.g, color.b, 1)
        end
    end)
    
    -- 마우스 탈출 시 원래 색상으로
    f:HookScript("OnLeave", function(self)
        local target = self.backdrop or (self.GetBackdrop and self)
        if target and target.SetBackdropBorderColor then
            target:SetBackdropBorderColor(unpack(E.media.bordercolor))
        end
    end)
    
    f.IringBtnStyled = true
end

-- [최종 수정] API 주입 및 모든 탭/버튼 감시 로직
local function AddIringAPI()
    local mt = getmetatable(CreateFrame("Frame")).__index
    local bt = getmetatable(CreateFrame("Button")).__index
    
    if not mt.Styling then mt.Styling = Styling end
    if not bt.Styling then bt.Styling = Styling end

    -- 엘브가 배경을 입힐 때(SetTemplate) 실행되는 공용 함수
    local function OnSetTemplate(f)
        if not f then return end
        
        -- 1. 기존 빗살무늬 적용 (Styling 호출)
        if f.Styling then f:Styling() end
        
        -- 2. 버튼이거나 이름에 'Tab'이 포함된 프레임이면 테두리 적용
        local name = f.GetName and f:GetName()
        if f:IsObjectType("Button") or (name and (name:find("Tab") or name:find("Button"))) then
            StyleButton(f)
        end
    end

    -- Hook 적용
    if mt.SetTemplate then hooksecurefunc(mt, "SetTemplate", OnSetTemplate) end
    if bt.SetTemplate then hooksecurefunc(bt, "SetTemplate", OnSetTemplate) end
    
    -- 추가 조치: 엘브가 기본적으로 스타일링하는 탭들에 강제로 입힘
    hooksecurefunc(E, "ReskinTab", function(_, tab)
        if tab then StyleButton(tab) end
    end)
end

AddIringAPI()
