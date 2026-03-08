-- 순서: IR, F, E, L, V, P, G
local IR, F, E, L, V, P, G = unpack(select(2, ...))

-- [1] 모든 프레임 및 버튼에 빗살무늬와 그림자를 입히는 함수
local function Styling(f, useStripes, useShadow)
    if not E.db or not E.db.IringUI or not E.db.IringUI.skin.enable then return end
    if not f or f.IRstyle or f.__style then return end

    local frameName = f.GetName and f:GetName()
    local style = CreateFrame("Frame", frameName and frameName.."_IRStyle" or nil, f, "BackdropTemplate")

    -- 빗살무늬 (BACKGROUND 레이어로 내려서 테두리 방해 금지)
    if E.db.IringUI.skin.stripes and not useStripes then
        local stripes = f:CreateTexture(nil, "BACKGROUND", nil, 1)
        stripes:SetInside(f, 1, -1)
        stripes:SetTexture(IR.Media.Stripes, true, true)
        stripes:SetHorizTile(true) stripes:SetVertTile(true)
        stripes:SetBlendMode("ADD")
        style.stripes = stripes
    end

    -- 그림자 (은은한 직업 색상)
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

-- [2] 버튼 및 탭 전용 테두리 하이라이트 함수 (선명도 강화)
local function StyleButton(f)
    if not f or f.IringBtnStyled then return end
    
    f:HookScript("OnEnter", function(self)
        local color = RAID_CLASS_COLORS[E.myclass]
        local target = self.backdrop or self
        if target.SetBackdropBorderColor then
            -- 알파값 1로 고정하여 선명하게 표시
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

-- [3] 다른 파일에서 사용할 수 있도록 IR 테이블에 함수 등록 (중요)
IR.Styling = Styling
IR.StyleButton = StyleButton

-- [4] API 주입 및 판다리아 클래식 대응 자동 후킹
local function AddIringAPI()
    local mt = getmetatable(CreateFrame("Frame")).__index
    local bt = getmetatable(CreateFrame("Button")).__index
    
    -- 객체 메소드로 등록 (:Styling() 사용 가능하게)
    if not mt.Styling then mt.Styling = Styling end
    if not bt.Styling then bt.Styling = Styling end

    local function OnSetTemplate(f)
        if not f then return end
        
        -- 빗살무늬/그림자 적용
        if f.Styling then f:Styling() end
        
        -- 하이라이트 적용 여부 필터 (채팅 탭 및 설치창 제외)
        local name = f.GetName and f:GetName() or ""
        if name:find("ChatTab") or name:find("ChatFrame") or name:find("Install") then
            return
        end
        
        if f:IsObjectType("Button") or name:find("Tab") then
            StyleButton(f)
        end
    end

    if mt.SetTemplate then hooksecurefunc(mt, "SetTemplate", OnSetTemplate) end
    if bt.SetTemplate then hooksecurefunc(bt, "SetTemplate", OnSetTemplate) end

    -- 판다리아 클래식 전용 탭 스킨 후킹 (모든 창의 하단 탭 대응)
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
