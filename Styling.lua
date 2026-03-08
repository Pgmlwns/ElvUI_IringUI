local IR, F, E, L, V, P, G = unpack(select(2, ...))

-- 1. 기존 프레임의 찌꺼기(블리자드/엘브 기본 배경)를 지우는 함수
local function StripFrame(f, kill, alpha)
	if not f then return end
	if f.GetNumRegions then
		for i = 1, f:GetNumRegions() do
			local region = select(i, f:GetRegions())
			if region and region:IsObjectType("Texture") then
				if kill then
					region:Hide()
					region.Show = function() end -- 다시는 나타나지 못하게 함
				elseif alpha then
					region:SetAlpha(0)
				else
					region:SetTexture(nil)
				end
			end
		end
	end
end

-- 2. IringUI 전용 스타일(빗살무늬/그림자)을 입히는 함수
local function Styling(f, useStripes, useShadow)
	if not E.db or not E.db.IringUI or not E.db.IringUI.skin.enable then return end
	if not f or f.IRstyle or f.__style then return end

	local frameName = f.GetName and f:GetName()
	local style = CreateFrame("Frame", frameName and frameName.."_IRStyle" or nil, f, "BackdropTemplate")

	-- 사선 패턴 (Stripes)
	if E.db.IringUI.skin.stripes and not useStripes then
		local stripes = f:CreateTexture(nil, "BORDER")
		stripes:SetInside(f, 1, -1)
		stripes:SetTexture(IR.Media.Stripes, true, true)
		stripes:SetHorizTile(true)
		stripes:SetVertTile(true)
		stripes:SetBlendMode("ADD")
		style.stripes = stripes
	end

	-- 그림자 효과 (Shadow)
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

-- 3. 모든 프레임 설계도(Metatable)에 IringUI 기능을 직접 주입 (핵심!)
local function AddIringAPI()
	local frame = CreateFrame("Frame")
	local mt = getmetatable(frame).__index
	
	if not mt.Styling then mt.Styling = Styling end
	if not mt.StripFrame then mt.StripFrame = StripFrame end

	-- ElvUI 배경 생성 시 자동 호출
	if mt.SetTemplate then
		hooksecurefunc(mt, "SetTemplate", function(f)
			if f and f.Styling then f:Styling() end
		end)
	end
end

AddIringAPI()