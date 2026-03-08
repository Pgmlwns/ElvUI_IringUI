local IR, F, E, L, V, P, G = unpack(select(2, ...))

-- 1. 전역 보따리 F에 함수 담기 (에러 방지용)
F.StripFrame = function(f, kill, alpha)
	if not f then return end
	if f.GetNumRegions then
		for i = 1, f:GetNumRegions() do
			local region = select(i, f:GetRegions())
			if region and region:IsObjectType("Texture") then
				if kill then
					region:Hide()
					region.Show = function() end
				elseif alpha then
					region:SetAlpha(0)
				else
					region:SetTexture(nil)
				end
			end
		end
	end
end

-- 2. 스타일링 함수
F.Styling = function(f, useStripes, useShadow)
	if not E.db or not E.db.IringUI or not E.db.IringUI.skin.enable then return end
	if not f or f.IRstyle or f.__style then return end

	local style = CreateFrame("Frame", nil, f, "BackdropTemplate")
	if E.db.IringUI.skin.stripes and not useStripes then
		local stripes = f:CreateTexture(nil, "BORDER")
		stripes:SetInside(f, 1, -1)
		stripes:SetTexture(IR.Media.Stripes, true, true)
		stripes:SetHorizTile(true)
		stripes:SetVertTile(true)
		stripes:SetBlendMode("ADD")
		style.stripes = stripes
	end
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
	f.__style = 1
end

-- 3. 메타테이블 주입 (기존 방식 유지)
local function AddIringAPI()
	local frame = CreateFrame("Frame")
	local mt = getmetatable(frame).__index
	if not mt.Styling then mt.Styling = F.Styling end
	if not mt.StripFrame then mt.StripFrame = F.StripFrame end

	if mt.SetTemplate then
		hooksecurefunc(mt, "SetTemplate", function(f)
			if f and f.Styling then f:Styling() end
		end)
	end
end
AddIringAPI()