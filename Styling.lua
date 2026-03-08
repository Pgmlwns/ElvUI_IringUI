local IR, F, E, L, V, P, G = unpack(select(2, ...))

IR.Styling = {}

local function Styling(f, useStripes, useShadow)
	if not E.db or not E.db.IringUI or not E.db.IringUI.skin.enable then return end
	if not f or f.IRstyle or f.__style then return end

	if f:GetObjectType() == "Texture" then f = f:GetParent() end

	local frameName = f.GetName and f:GetName()
	local style = CreateFrame("Frame", frameName and frameName.."_IRStyle" or nil, f, "BackdropTemplate")

	-- 빗살무늬 (Stripes)
	if E.db.IringUI.skin.stripes and not useStripes then
		local stripes = f:CreateTexture(nil, "BORDER")
		stripes:SetInside(f, 1, -1)
		stripes:SetTexture(IR.Media.Stripes, true, true)
		stripes:SetHorizTile(true)
		stripes:SetVertTile(true)
		stripes:SetBlendMode("ADD")
		
		-- 설치창 레이어 격상 (메라실리스 방식)
		if frameName and (frameName:find("PluginInstall") or frameName:find("ElvUIInstall")) then
			stripes:SetDrawLayer("OVERLAY", 7)
		end
		style.stripes = stripes
	end

	-- 그림자 (Shadow) - 인스톨 파일과 동일한 설정값 적용
	if E.db.IringUI.skin.shadow and not useShadow then
		local mshadow = f:CreateTexture(nil, "BORDER")
		mshadow:SetInside(f, 0, 0)
		mshadow:SetTexture(IR.Media.Overlay)
		
		-- 인스톨 파일에서 성공한 직업 색상 및 투명도(0.4)
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

local function AddIringAPI()
	local frame = CreateFrame("Frame")
	local mt = getmetatable(frame).__index
	if not mt.Styling then mt.Styling = Styling end

	-- 메라실리스 핵심: SetTemplate 후킹
	if mt.SetTemplate then
		hooksecurefunc(mt, "SetTemplate", function(f)
			if f and f.Styling then f:Styling() end
		end)
	end
end

AddIringAPI()
