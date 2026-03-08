-- 순서: IR, F, E, L, V, P, G
local IR, F, E, L, V, P, G = unpack(select(2, ...))

-- [원본 그대로] 빗살무늬 및 스타일링 함수
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

    -- 그림자
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

-- [추가] 테두리 하이라이트 전용 함수
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

-- [수정] API 주입 및 탭 강제 적용
local function AddIringAPI()
    local mt = getmetatable(CreateFrame("Frame")).__index
    local bt = getmetatable(CreateFrame("Button")).__index
    if not mt.Styling then mt.Styling = Styling end
    if not bt.Styling then bt.Styling = Styling end

    -- 기존 SetTemplate 후킹 (빗살무늬용)
    if mt.SetTemplate then
        hooksecurefunc(mt, "SetTemplate", function(f) 
            if f and f.Styling then f:Styling() end 
        end)
    end
    if bt.SetTemplate then
        hooksecurefunc(bt, "SetTemplate", function(f) 
            if f and f.Styling then f:Styling() end 
        end)
    end

    -- [핵심] 캐릭터 창 탭들에 강제로 테두리 로직 주입
    local function ForceTabStyle()
        for i = 1, 5 do
            local tab = _G["CharacterFrameTab"..i]
            if tab then StyleButton(tab) end
        end
    end

    -- 캐릭터 창이 열릴 때마다 실행되도록 이벤트 등록
    local f = CreateFrame("Frame")
    f:RegisterEvent("ADDON_LOADED")
    f:SetScript("OnEvent", function(_, _, addon)
        if addon == "Blizzard_CharacterFrame" or addon == "ElvUI" then
            ForceTabStyle()
        end
    end)
    -- 초기 접속 시 실행
    ForceTabStyle()
end

AddIringAPI()
