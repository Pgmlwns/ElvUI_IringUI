-- 순서: IR, F, E, L, V, P, G
local IR, F, E, L, V, P, G = unpack(select(2, ...))

-- [원본 유지] 빗살무늬 및 그림자 로직 (이 부분은 무조건 실행됨)
local function Styling(f, useStripes, useShadow)
    if not E.db or not E.db.IringUI or not E.db.IringUI.skin.enable then return end
    if not f or f.IRstyle or f.__style then return end

    local frameName = f.GetName and f:GetName()
    local style = CreateFrame("Frame", frameName and frameName.."_IRStyle" or nil, f, "BackdropTemplate")

    -- 빗살무늬
    if E.db.IringUI.skin.stripes and not useStripes then
        local stripes = f:CreateTexture(nil, "BACKGROUND", nil, 1)
        stripes:SetInside(f, 1, -1)
        stripes:SetTexture(IR.Media.Stripes, true, true)
        stripes:SetHorizTile(true) stripes:SetVertTile(true)
        stripes:SetBlendMode("ADD")
        style.stripes = stripes
    end

    -- 그림자
    if E.db.IringUI.skin.shadow and not useShadow then
        local mshadow = f:CreateTexture(nil, "BACKGROUND", nil, 0)
        mshadow:SetInside(f, 0, 0)
        mshadow:SetTexture(IR.Media.Overlay)
        local color = RAID_CLASS_COLORS[E.myclass]
        mshadow:SetVertexColor(color.r, color.g, color.b)
        mshadow:SetAlpha(0.3)
        style.mshadow = mshadow
    end

    style:SetFrameStrata(f:GetFrameStrata())
    style:SetFrameLevel(math.max(0, f:GetFrameLevel() - 1))
    style:SetAllPoints(f)
    f.IRstyle = style
    f.__style = 1
end

-- [유지] 테두리 하이라이트 함수
local function StyleButton(f)
    if not f or f.IringBtnStyled then return end
    
    f:HookScript("OnEnter", function(self)
        local color = RAID_CLASS_COLORS[E.myclass]
        local target = self.backdrop or self
        if target.SetBackdropBorderColor then
            target:SetBackdropBorderColor(color.r, color.g, color.b, 1)
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

-- [완전 수정] 안전한 API 주입 로직
local function AddIringAPI()
    local mt = getmetatable(CreateFrame("Frame")).__index
    local bt = getmetatable(CreateFrame("Button")).__index
    
    if not mt.Styling then mt.Styling = Styling end
    if not bt.Styling then bt.Styling = Styling end

    local function OnSetTemplate(f)
        if not f then return end
        
        -- 1. 빗살무늬는 모든 프레임에 예외 없이 시도 (Styling 함수 내부에서 중복체크함)
        if f.Styling then f:Styling() end
        
        -- 2. 테두리 하이라이트 적용 여부 판단
        local name = f.GetName and f:GetName() or ""
        
        -- 채팅 탭 및 설치창 키워드가 있으면 테두리 로직 건너뜀
        if name:find("ChatTab") or name:find("ChatFrame") or name:find("Install") then
            return
        end
        
        -- 버튼이거나 이름에 Tab이 포함된 경우에만 테두리 하이라이트 적용
        if f:IsObjectType("Button") or name:find("Tab") then
            StyleButton(f)
        end
    end

    if mt.SetTemplate then hooksecurefunc(mt, "SetTemplate", OnSetTemplate) end
    if bt.SetTemplate then hooksecurefunc(bt, "SetTemplate", OnSetTemplate) end

    -- 판다리아 클래식 대응 탭 후킹
    local S = E:GetModule('Skins')
    if S and S.HandleTab then
        hooksecurefunc(S, "HandleTab", function(_, tab)
            if not tab then return end
            local name = tab.GetName and tab:GetName() or ""
            if name:find("ChatTab") or name:find("ChatFrame") then return end
            
            StyleButton(tab)
        end)
    end
end

AddIringAPI()
