local IR, F, E, L, V, P, G = unpack(select(2, ...))

IR.ModuleFilters = {}

local function Styling(f, useStripes, useShadow)
	if not E.db or not E.db.IringUI or not E.db.IringUI.skin or not E.db.IringUI.skin.enable then return end
	if not f or f.IRstyle or f.__style then return end

	local name = f.GetName and f:GetName() or ""
	for keyword, checkFunc in pairs(IR.ModuleFilters) do
		if name:find(keyword) then
			if not checkFunc() then return end
		end
	end

	-- [핵심 수정] 새로운 프레임을 만들지 않고 ElvUI의 backdrop이나 프레임 자체를 타겟으로 함
	local target = f.backdrop or f
	if f:GetObjectType() == "Texture" then target = f:GetParent() end

	-- 빗살무늬 (Stripes)
	if E.db.IringUI.skin.stripes and not useStripes then
		local stripes = target:CreateTexture(nil, "BACKGROUND", nil, 1)
		stripes:SetInside(target, 1, -1)
		stripes:SetTexture(IR.Media.Stripes, true, true)
		stripes:SetHorizTile(true) stripes:SetVertTile(true)
		stripes:SetBlendMode("ADD")
		
		-- 배경이 숨겨지면 같이 숨겨지도록 설정
		stripes:SetShowWhenParentShown(true)
		f.IRstripes = stripes
	end

	-- 그림자 (Shadow) - 직업 색상
	if E.db.IringUI.skin.shadow and not useShadow then
		local mshadow = target:CreateTexture(nil, "BACKGROUND", nil, 0)
		mshadow:SetInside(target, 0, 0)
		mshadow:SetTexture(IR.Media.Overlay)
		local color = RAID_CLASS_COLORS[E.myclass]
		mshadow:SetVertexColor(color.r, color.g, color.b)
		mshadow:SetAlpha(0.4)
		
		mshadow:SetShowWhenParentShown(true)
		f.IRshadow = mshadow
	end
	
	-- [배경 가시성 강제 동기화]
	-- ElvUI가 배경을 숨기면 텍스처도 같이 숨깁니다.
	local function UpdateVisibility()
		local isHidden = (f.template == "NoBackdrop") or (f.GetBackdropColor and select(4, f:GetBackdropColor()) == 0)
		if isHidden then
			if f.IRstripes then f.IRstripes:SetAlpha(0) end
			if f.IRshadow then f.IRshadow:SetAlpha(0) end
		else
			if f.IRstripes then f.IRstripes:SetAlpha(1) end
			if f.IRshadow then f.IRshadow:SetAlpha(1) end
		end
	end

	if f.SetBackdropColor then hooksecurefunc(f, "SetBackdropColor", UpdateVisibility) end
	f:HookScript("OnShow", UpdateVisibility)
	UpdateVisibility()

	f.__style = 1
end

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

IR.Styling = Styling
IR.StyleButton = StyleButton

local function AddIringAPI()
	local mt = getmetatable(CreateFrame("Frame")).__index
	local bt = getmetatable(CreateFrame("Button")).__index
	mt.Styling = Styling
	bt.Styling = Styling

	local function OnSetTemplate(f)
		if not f then return end
		Styling(f)
		local name = f.GetName and f:GetName() or ""
		if name:find("ChatTab") or name:find("ChatFrame") or name:find("Install") then return end
		if f:IsObjectType("Button") or name:find("Tab") then
			StyleButton(f)
		end
	end

	if mt.SetTemplate then hooksecurefunc(mt, "SetTemplate", OnSetTemplate) end
	if bt.SetTemplate then hooksecurefunc(bt, "SetTemplate", OnSetTemplate) end

	local S = E:GetModule('Skins')
	if S and S.HandleTab then
		hooksecurefunc(S, "HandleTab", function(_, tab)
			if not tab then return end
			local name = tab.GetName and tab:GetName() or ""
			if name:find("ChatTab") or name:find("ChatFrame") then return end
			StyleButton(tab)
		end)
	end
end

AddIringAPI()
