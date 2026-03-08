-- 순서: IR, F, E, L, V, P, G
local IR, F, E, L, V, P, G = unpack(select(2, ...))

-- [건드리지 않음] 기존 빗살무늬 및 그림자 로직
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

    -- 그림자 (인스톨 창과 동일한 은은한 직업 색상)
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

-- [신규] 캐릭터 탭 및 버튼 테두리 하이라이트 함수
local function StyleButton(f)
    if not f or f.IringBtnStyled then return end
    f:HookScript("OnEnter", function(self)
        local color = RAID_CLASS_COLORS[E.myclass]
        local target = self.backdrop or self
        if target.SetBackdropBorderColor then
            target:SetBackdropBorderColor(color.r, color.g, color.b)
        end
    end)
    f:HookScript("OnLeave", function(self)
        local target = self.backdrop or self
        if target.SetBackdropBorderColor then
            target:SetBackdropBorderColor(unpack(E.media.bordercolor))
        end
    end)
    f.IringBtnStyled = true
end

-- [수정] API 주입 및 하이라이트 로직 추가
local function AddIringAPI()
    local mt = getmetatable(CreateFrame("Frame")).__index
    local bt = getmetatable(CreateFrame("Button")).__index
    if not mt.Styling then mt.Styling = Styling end
    if not bt.Styling then bt.Styling = Styling end

    -- 공통 적용 함수
    local function ApplyStyle(f)
        if not f then return end
        if f.Styling then f:Styling() end -- 기존 빗살무늬 적용
        
        -- 버튼이거나 이름에 'Tab'이 들어간 프레임에 테두리 하이라이트 추가
        local name = f.GetName and f:GetName()
        if f:IsObjectType("Button") or (name and name:find("Tab")) then
            StyleButton(f)
        end
    end

    if mt.SetTemplate then
        hooksecurefunc(mt, "SetTemplate", ApplyStyle)
    end
    if bt.SetTemplate then
        hooksecurefunc(bt, "SetTemplate", ApplyStyle)
    end
end

AddIringAPI()
