-- 순서: IR, F, E, L, V, P, G
local IR, F, E, L, V, P, G = unpack(select(2, ...))

-- [수정] 빗살무늬 및 그림자 로직 (레이어 순서 최적화)
local function Styling(f, useStripes, useShadow)
    if not E.db or not E.db.IringUI or not E.db.IringUI.skin.enable then return end
    if not f or f.IRstyle or f.__style then return end

    local frameName = f.GetName and f:GetName()
    local style = CreateFrame("Frame", frameName and frameName.."_IRStyle" or nil, f, "BackdropTemplate")

    -- 빗살무늬 (배경 바로 위)
    if E.db.IringUI.skin.stripes and not useStripes then
        local stripes = f:CreateTexture(nil, "BACKGROUND", nil, 1) -- 레이어를 낮춤
        stripes:SetInside(f, 1, -1)
        stripes:SetTexture(IR.Media.Stripes, true, true)
        stripes:SetHorizTile(true) stripes:SetVertTile(true)
        stripes:SetBlendMode("ADD")
        style.stripes = stripes
    end

    -- 그림자 (가장 아래 레이어로 배치하여 테두리를 가리지 않게 함)
    if E.db.IringUI.skin.shadow and not useShadow then
        local mshadow = f:CreateTexture(nil, "BACKGROUND", nil, 0) -- 가장 아래
        mshadow:SetInside(f, 0, 0)
        mshadow:SetTexture(IR.Media.Overlay)
        local color = RAID_CLASS_COLORS[E.myclass]
        mshadow:SetVertexColor(color.r, color.g, color.b)
        mshadow:SetAlpha(0.3) -- 투명도를 조금 더 낮춰 번짐 방지
        style.mshadow = mshadow
    end

    -- 스타일 프레임 레벨 조정 (본체보다 낮게 설정하여 테두리 방해 금지)
    style:SetFrameStrata(f:GetFrameStrata())
    style:SetFrameLevel(math.max(0, f:GetFrameLevel() - 1))
    style:SetAllPoints(f)
    f.IRstyle = style
    f.__style = 1
end

-- [수정] 테두리 하이라이트 (선명도 및 계층 우선순위 강화)
local function StyleButton(f)
    if not f or f.IringBtnStyled then return end
    
    f:HookScript("OnEnter", function(self)
        local color = RAID_CLASS_COLORS[E.myclass]
        local target = self.backdrop or self
        if target.SetBackdropBorderColor then
            -- 선명하게 적용 (알파값 1)
            target:SetBackdropBorderColor(color.r, color.g, color.b, 1)
            -- 테두리가 다른 레이어에 가려지지 않도록 프레임 레벨 일시적 상승
            if self.SetFrameLevel then self:SetFrameLevel(self:GetFrameLevel() + 2) end
        end
    end)
    
    f:HookScript("OnLeave", function(self)
        local target = self.backdrop or self
        if target.SetBackdropBorderColor then
            target:SetBackdropBorderColor(unpack(E.media.bordercolor))
            if self.SetFrameLevel then self:SetFrameLevel(math.max(0, self:GetFrameLevel() - 2)) end
        end
    end)
    
    f.IringBtnStyled = true
end

-- [유지] 판다리아 클래식 대응 API 주입
local function AddIringAPI()
    local mt = getmetatable(CreateFrame("Frame")).__index
    local bt = getmetatable(CreateFrame("Button")).__index
    
    if not mt.Styling then mt.Styling = Styling end
    if not bt.Styling then bt.Styling = Styling end

    local function OnSetTemplate(f)
        if not f then return end
        if f.Styling then f:Styling() end
        
        local name = f.GetName and f:GetName()
        if f:IsObjectType("Button") or (name and name:find("Tab")) then
            StyleButton(f)
        end
    end

    if mt.SetTemplate then hooksecurefunc(mt, "SetTemplate", OnSetTemplate) end
    if bt.SetTemplate then hooksecurefunc(bt, "SetTemplate", OnSetTemplate) end

    local S = E:GetModule('Skins')
    if S and S.HandleTab then
        hooksecurefunc(S, "HandleTab", function(_, tab)
            if tab then StyleButton(tab) end
        end)
    end
end

AddIringAPI()
