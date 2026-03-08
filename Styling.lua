local IR, F, E, L, V, P, G = unpack(select(2, ...))

-- 1. 스타일링 핵심 함수 (덧붙이기 방식)
F.Styling = function(f, useStripes, useShadow)
	-- 설정값 체크 (에러 방지)
	local db = E.db and E.db.IringUI
	if not db or not db.skin.enable then return end
	if not f or f.IRstyle then return end

	-- 스타일을 담을 프레임 생성
	local style = CreateFrame("Frame", nil, f, "BackdropTemplate")
	style:SetAllPoints(f)
	style:SetFrameLevel(f:GetFrameLevel() + 1) -- 부모보다 살짝 위로

	-- 빗살무늬 (Stripes)
	if db.skin.stripes and not useStripes then
		local stripes = style:CreateTexture(nil, "OVERLAY")
		stripes:SetInside(style, 1, -1)
		stripes:SetTexture(IR.Media.Stripes, true, true)
		stripes:SetHorizTile(true)
		stripes:SetVertTile(true)
		stripes:SetBlendMode("ADD")
		stripes:SetAlpha(0.5) -- 너무 진하지 않게 조절
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

-- 2. 모든 프레임 설계도에 기능 주입
local function AddIringAPI()
	local frame = CreateFrame("Frame")
	local mt = getmetatable(frame).__index
	if not mt.Styling then mt.Styling = F.Styling end

	-- ElvUI가 배경을 만들 때마다 자동 호출
	if mt.SetTemplate then
		hooksecurefunc(mt, "SetTemplate", function(f)
			if f and f.Styling then f:Styling() end
		end)
	end
end
AddIringAPI()
