-- 순서: IR, F, E, L, V, P, G
local IR, F, E, L, V, P, G = unpack(select(2, ...))

-- [원본 유지] 빗살무늬 및 그림자 로직
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

-- [강화] 테두리 하이라이트 함수 (강제 색상 고정 및 선명도 강화)
local function StyleButton(f)
    if not f or f.IringBtnStyled then return end
    
    -- 마우스 진입 시
    f:HookScript("OnEnter", function(self)
        local color = RAID_CLASS_COLORS[E.myclass]
        local target = self.backdrop or self
        
        if target and target.SetBackdropBorderColor then
            -- 1. 테두리 색상 강제 적용 (투명도 1)
            target:SetBackdropBorderColor(color.r, color.g, color.b, 1)
            
            -- 2. 엘브가 색상을 다시 바꾸지 못하게 강제 고정 (선택 사항)
            if not target.IringForced then
                hooksecurefunc(target, "SetBackdropBorderColor", function(s, r, g, b, a)
                    if s.isHovered and (r ~= color.r or g ~= color.g or b ~= color.b) then
                        s:SetBackdropBorderColor(color.r, color.g, color.b, 1)
                    end
                end)
                target.IringForced = true
            end
        end
        self.isHovered = true
    end)
    
    -- 마우스 나갈 때
    f:HookScript("OnLeave", function(self)
        self.isHovered = false
        local target = self.backdrop or self
        if target and target.SetBackdropBorderColor then
            target:SetBackdropBorderColor(unpack(E.media.bordercolor))
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
