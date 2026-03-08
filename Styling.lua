local IR, F, E, L, V, P, G = unpack(select(2, ...))

local function Styling(f, useStripes, useShadow)
    if not E.db.IringUI.skin.enable then return end
    if not f or f.IRstyle or f.__style then return end

    local style = CreateFrame("Frame", nil, f, "BackdropTemplate")
    
    -- 사선 패턴
    if E.db.IringUI.skin.stripes and not useStripes then
        local stripes = f:CreateTexture(nil, "BORDER")
        stripes:SetInside(f, 1, -1)
        stripes:SetTexture(IR.Media.Stripes, true, true)
        stripes:SetHorizTile(true)
        stripes:SetVertTile(true)
        stripes:SetBlendMode("ADD")
        style.stripes = stripes
    end

    -- 그림자
    if E.db.IringUI.skin.shadow and not useShadow then
        local mshadow = f:CreateTexture(nil, "BORDER")
        mshadow:SetInside(f, 0, 0)
        mshadow:SetTexture(IR.Media.Overlay)
        mshadow:SetVertexColor(1, 1, 1, 0.6)
        style.mshadow = mshadow
    end

    style:SetFrameStrata(f:GetFrameStrata())
    style:SetFrameLevel(f:GetFrameLevel() + 1)
    style:SetAllPoints(f)
    f.IRstyle = style
end

-- API 주입 및 자동 후킹
hooksecurefunc(E, "CreateBackdrop", function(_, frame)
    if frame and not frame.Styling then 
        local mt = getmetatable(frame).__index
        mt.Styling = Styling
    end
    if frame and frame.Styling then frame:Styling() end
end)
