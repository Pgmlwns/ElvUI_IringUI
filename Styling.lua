local IR, F, E, L, V, P, G = unpack(select(2, ...))

-- 스타일링 핵심 함수 (메라실리스 로직)
local function Styling(f, useStripes, useShadow)
	-- 설정 체크 (에러 방지)
	if not E.db or not E.db.IringUI or not E.db.IringUI.skin.enable then return end
	if not f or f.IRstyle or f.__style then return end

	-- 텍스처인 경우 부모 프레임으로 대상 변경
	if f:GetObjectType() == "Texture" then f = f:GetParent() end

	local frameName = f.GetName and f:GetName()
	local style = CreateFrame("Frame", frameName and frameName.."_IRStyle" or nil, f, "BackdropTemplate")

	-- 빗살무늬 (Stripes) 생성
	if E.db.IringUI.skin.stripes and not useStripes then
		local stripes = f:CreateTexture(nil, "BORDER")
		stripes:SetInside(f, 1, -1)
		stripes:SetTexture(IR.Media.Stripes, true, true)
		stripes:SetHorizTile(true)
		stripes:SetVertTile(true)
		stripes:SetBlendMode("ADD")
		
		-- 설치창 계열은 레이어를 높여서 배경색에 묻히지 않게 함
		if frameName and (frameName:find("PluginInstall") or frameName:find("ElvUIInstall")) then
			stripes:SetDrawLayer("OVERLAY", 7)
		end
		
		style.stripes = stripes
	end

	-- 그림자 (Shadow) 생성 - 클래스 색상 적용
	if E.db.IringUI.skin.shadow and not useShadow then
		local mshadow = f:CreateTexture(nil, "BORDER")
		mshadow:SetInside(f, 0, 0)
		mshadow:SetTexture(IR.Media.Overlay)
		
		-- 직업 색상 적용
		local color = RAID_CLASS_COLORS[E.myclass]
		mshadow:SetVertexColor(color.r, color.g, color.b)
		mshadow:SetAlpha(0.6) -- 영롱한 느낌을 위해 0.6 설정

		style.mshadow = mshadow
	end

	style:SetFrameStrata(f:GetFrameStrata())
	style:SetFrameLevel(f:GetFrameLevel() + 1)
	style:SetAllPoints(f)
	
	f.IRstyle = style
	f.__style = 1
end

-- [핵심] 모든 프레임 설계도에 주입 (메라실리스 방식)
local function AddIringAPI()
	local frame = CreateFrame("Frame")
	local mt = getmetatable(frame).__index
	
	-- 모든 프레임에서 .Styling() 사용 가능하게 함
	if not mt.Styling then mt.Styling = Styling end

	-- ElvUI의 배경 생성 함수를 메타테이블 수준에서 후킹 (가장 확실한 방법)
	if mt.SetTemplate then
		hooksecurefunc(mt, "SetTemplate", function(f)
			if f and f.Styling then
				f:Styling()
			end
		end)
	end
end

AddIringAPI()
