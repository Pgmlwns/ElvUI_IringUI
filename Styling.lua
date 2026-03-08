local IR, F, E, L, V, P, G = unpack(select(2, ...))

-- 스타일링 핵심 함수
local function Styling(f)
	if not E.db or not E.db.IringUI or not E.db.IringUI.skin.enable then return end
	if not f or f.IRstyle then return end

	-- 스타일 프레임 생성
	local style = CreateFrame("Frame", nil, f, "BackdropTemplate")
	style:SetAllPoints(f)
	style:SetFrameLevel(f:GetFrameLevel() + 1)

	-- 빗살무늬 (Stripes) - 레이어를 높여서 배경색에 묻히지 않게 함
	if E.db.IringUI.skin.stripes then
		local stripes = style:CreateTexture(nil, "OVERLAY", nil, 7)
		stripes:SetInside(style, 1, -1)
		stripes:SetTexture(IR.Media.Stripes, true, true)
		stripes:SetHorizTile(true)
		stripes:SetVertTile(true)
		stripes:SetBlendMode("ADD")
		stripes:SetAlpha(0.5)
		style.stripes = stripes
	end

	f.IRstyle = style
end

-- [핵심] 모든 프레임 설계도에 API 주입
local function AddIringAPI()
	local mt = getmetatable(CreateFrame("Frame")).__index
	if not mt.Styling then mt.Styling = Styling end

	-- ElvUI가 배경을 칠하는 모든 순간을 감시
	if mt.SetTemplate then
		hooksecurefunc(mt, "SetTemplate", function(f)
			if f and f.Styling then f:Styling() end
		end)
	end
end
AddIringAPI()