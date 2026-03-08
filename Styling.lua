local IR, F, E, L, V, P, G = unpack(select(2, ...))

-- 모든 프레임 및 버튼에 빗살무늬와 그림자를 입히는 함수
local function Styling(f, useStripes, useShadow)
	-- [에러 해결] DB가 아직 준비되지 않았을 경우를 대비해 단계별로 nil 체크
	if not E.db or not E.db.IringUI or not E.db.IringUI.skin or not E.db.IringUI.skin.enable then return end
	if not f or f.IRstyle or f.__style then return end

	if f:GetObjectType() == "Texture" then f = f:GetParent() end

	local frameName = f.GetName and f:GetName()
	local style = CreateFrame("Frame", frameName and frameName.."_IRStyle" or nil, f, "BackdropTemplate")

	-- 빗살무늬 (Stripes)
	if E.db.IringUI.skin.stripes and not useStripes then
		local stripes = f:CreateTexture(nil, "BACKGROUND", nil, 1)
		stripes:SetInside(f, 1, -1)
		stripes:SetTexture(IR.Media.Stripes, true, true)
		stripes:SetHorizTile(true) stripes:SetVertTile(true)
		stripes:SetBlendMode("ADD")
		style.stripes = stripes
	end

	-- 그림자 (Shadow)
	if E.db.IringUI.skin.shadow and not useShadow then
		local mshadow = f:CreateTexture(nil, "BACKGROUND", nil, 0)
		mshadow:SetInside(f, 0, 0)
		mshadow:SetTexture(IR.Media.Overlay)
		local color = RAID_CLASS_COLORS[E.myclass]
		mshadow:SetVertexColor(color.r, color.g, color.b)
		mshadow:SetAlpha(0.3)
		style.mshadow = mshadow
	end

	style:SetFrameStrata(f:GetFrameStrata())
	style:SetFrameLevel(math.max(0, f:GetFrameLevel() - 1))
	style:SetAllPoints(f)
	
	f.IRstyle = style
	f.__style = 1
end

-- 버튼 전용 하이라이트 함수 (선명도 강화)
local function StyleButton(f)
	if not f or f.IringBtnStyled then return end
	f:HookScript("OnEnter", function(self)
		local color = RAID_CLASS_COLORS[E.myclass]
		local target = self.backdrop or self
		if target.SetBackdropBorderColor then
			target:SetBackdropBorderColor(color.r, color.g, color.b, 1)
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

-- 외부 공유 등록
IR.Styling = Styling
IR.StyleButton = StyleButton

-- API 주입 및 후킹
local function AddIringAPI()
	local mt = getmetatable(CreateFrame("Frame")).__index
	local bt = getmetatable(CreateFrame("Button")).__index
	if not mt.Styling then mt.Styling = Styling end

	if mt.SetTemplate then
		hooksecurefunc(mt, "SetTemplate", function(f)
			if not f then return end
			Styling(f)
			local name = f.GetName and f:GetName() or ""
			if name:find("ChatTab") or name:find("ChatFrame") or name:find("Install") then return end
			if f:IsObjectType("Button") or name:find("Tab") then
				StyleButton(f)
			end
		end)
	end
end
AddIringAPI()
