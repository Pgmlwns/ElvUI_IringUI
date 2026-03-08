-- Styling.lua 내 F.Styling 함수 부분 수정
F.Styling = function(f, useStripes, useShadow)
	local db = E.db and E.db.IringUI
	if not db or not db.skin.enable then return end
	if not f or f.IRstyle then return end

	-- 배경색을 더 진한 검은색으로 고정 (선택 사항)
	if f.SetBackdropColor then
		f:SetBackdropColor(0.06, 0.06, 0.06, 0.85) -- 0.7에서 0.85로 상향 (더 어두워짐)
	end

	local style = CreateFrame("Frame", nil, f, "BackdropTemplate")
	style:SetAllPoints(f)
	style:SetFrameLevel(f:GetFrameLevel() + 1)

	-- 빗살무늬 (Stripes) 선명도 강화
	if db.skin.stripes and not useStripes then
		local stripes = style:CreateTexture(nil, "OVERLAY")
		stripes:SetInside(style, 1, -1)
		stripes:SetTexture(IR.Media.Stripes, true, true)
		stripes:SetHorizTile(true)
		stripes:SetVertTile(true)
		stripes:SetBlendMode("ADD")
		stripes:SetAlpha(0.75) -- 기존 0.5에서 0.75로 상향 (더 진해짐)
		style.stripes = stripes
	end

	-- 그림자 (Shadow)
	if db.skin.shadow and not useShadow then
		local mshadow = style:CreateTexture(nil, "OVERLAY")
		mshadow:SetInside(style, 0, 0)
		mshadow:SetTexture(IR.Media.Overlay)
		mshadow:SetVertexColor(1, 1, 1, 0.6)
		style.mshadow = mshadow
	end
	
	f.IRstyle = style
end
