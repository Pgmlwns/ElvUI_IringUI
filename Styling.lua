local IR, F, E, L, V, P, G = unpack(select(2, ...))

IR.Styling = {}

-- [핵심] 스타일링 적용 함수
local function Styling(f, useStripes, useShadow)
	if not E.db or not E.db.IringUI or not E.db.IringUI.skin.enable then return end
	if not f or f.IRstyle or f.__style then return end

	if f:GetObjectType() == "Texture" then f = f:GetParent() end

	local frameName = f.GetName and f:GetName()
	local style = CreateFrame("Frame", frameName and frameName.."_IRStyle" or nil, f, "BackdropTemplate")

	-- 1. 빗살무늬 (Stripes)
	if E.db.IringUI.skin.stripes and not useStripes then
		local stripes = f:CreateTexture(nil, "BORDER")
		stripes:SetInside(f, 1, -1)
		stripes:SetTexture(IR.Media.Stripes, true, true)
		stripes:SetHorizTile(true)
		stripes:SetVertTile(true)
		stripes:SetBlendMode("ADD")
		
		-- 설치창 레이어 격상
		if frameName and (frameName:find("PluginInstall") or frameName:find("ElvUIInstall")) then
			stripes:SetDrawLayer("OVERLAY", 7)
		end
		style.stripes = stripes
	end

	-- 2. 그림자 (Shadow) - 은은한 직업 색상
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

-- [API 주입] 모든 프레임 및 버튼 설계도 장악
local function AddIringAPI()
	-- 일반 프레임 메타테이블
	local mt = getmetatable(CreateFrame("Frame")).__index
	if not mt.Styling then mt.Styling = Styling end

	-- 버튼 메타테이블
	local bt = getmetatable(CreateFrame("Button")).__index
	if not bt.Styling then bt.Styling = Styling end

	-- ElvUI가 배경(Template)을 입히는 모든 순간을 가로챔 (버튼 포함)
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
end

AddIringAPI()
