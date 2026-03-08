local IR, F, E, L, V, P, G = unpack(select(2, ...))

IR.Styling = {}

-- [1] 모든 프레임 및 버튼에 빗살무늬와 그림자를 입히는 함수
local function Styling(f, useStripes, useShadow)
	-- 설정 체크
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
		
		-- 설치창 레이어 처리
		if frameName and (frameName:find("PluginInstall") or frameName:find("ElvUIInstall")) then
			stripes:SetDrawLayer("OVERLAY", 7)
		end
		style.stripes = stripes
	end

	-- 그림자 (Shadow) - 직업 색상 0.4 투명도
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

-- [2] 버튼 전용 테두리 하이라이트 함수
local function StyleButton(f)
	if not f or f.IringBtnStyled then return end

	f:HookScript("OnEnter", function(self)
		local color = RAID_CLASS_COLORS[E.myclass]
		local target = self.backdrop or self
		if target.SetBackdropBorderColor then
			target:SetBackdropBorderColor(color.r, color.g, color.b)
		end
	end)

	f:HookScript("OnLeave", function(self)
		local target = self.backdrop or self
		if target.SetBackdropBorderColor then
			target:SetBackdropBorderColor(unpack(E.media.bordercolor))
		end
	end)

	f.IringBtnStyled = true
end

-- [3] API 주입 및 엘브 후킹
local function AddIringAPI()
	local frame = CreateFrame("Frame")
	local mt = getmetatable(frame).__index
	
	-- :Styling() 함수 등록
	if not mt.Styling then mt.Styling = Styling end

	-- 엘브가 배경을 입힐 때(SetTemplate) 무조건 실행
	if mt.SetTemplate then
		hooksecurefunc(mt, "SetTemplate", function(f)
			if not f then return end
			
			-- 빗살무늬 적용
			if f.Styling then f:Styling() end
			
			-- 버튼이면 테두리 하이라이트 추가 적용
			if f:IsObjectType("Button") or (f:GetParent() and f:GetParent():IsObjectType("Button")) then
				StyleButton(f)
			end
		end)
	end
end

AddIringAPI()
