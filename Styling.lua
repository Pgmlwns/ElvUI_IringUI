-- 순서: IR, F, E, L, V, P, G
local IR, F, E, L, V, P, G = unpack(select(2, ...))

local function Styling(f, useStripes, useShadow)
    -- 이제 E가 nil이 아니므로 정상 작동합니다.
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

-- 버튼 및 프레임 API 주입
local function AddIringAPI()
    local mt = getmetatable(CreateFrame("Frame")).__index
    local bt = getmetatable(CreateFrame("Button")).__index
    if not mt.Styling then mt.Styling = Styling end
    if not bt.Styling then bt.Styling = Styling end

    if mt.SetTemplate then
        hooksecurefunc(mt, "SetTemplate", function(f) if f and f.Styling then f:Styling() end end)
    end
    if bt.SetTemplate then
        hooksecurefunc(bt, "SetTemplate", function(f) if f and f.Styling then f:Styling() end end)
    end
end
AddIringAPI()
