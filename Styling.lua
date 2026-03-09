local IR, F, E, L, V, P, G = unpack(select(2, ...))

-- 모듈들이 스스로 스타일 적용 여부를 등록할 테이블
IR.ModuleFilters = {}

-- 모든 프레임 및 버튼에 빗살무늬와 그림자를 입히는 함수
local function Styling(f, useStripes, useShadow)
	-- 설정 체크 (DB가 로드되지 않았으면 중단)
	if not E.db or not E.db.IringUI or not E.db.IringUI.skin or not E.db.IringUI.skin.enable then return end
	if not f or f.IRstyle or f.__style then return end

	-- [자동 필터 로직]
	local name = f.GetName and f:GetName() or ""
	for keyword, checkFunc in pairs(IR.ModuleFilters) do
		if name:find(keyword) then
			if not checkFunc() then return end
		end
	end

	if f:GetObjectType() == "Texture" then f = f:GetParent() end

	-- [핵심 변경] 새로운 프레임을 만들지 않고 f에 직접 텍스처를 생성합니다.
	-- 이렇게 하면 부모 프레임(f)이 숨겨지거나 투명해질 때 텍스처도 같이 사라집니다.

	-- 빗살무늬 (Stripes)
	if E.db.IringUI.skin.stripes and not useStripes then
		local stripes = f:CreateTexture(nil, "BACKGROUND", nil, 1)
		stripes:SetInside(f, 1, -1)
		stripes:SetTexture(IR.Media.Stripes, true, true)
		stripes:SetHorizTile(true) stripes:SetVertTile(true)
		stripes:SetBlendMode("ADD")
		
		if name:find("PluginInstall") or name:find("ElvUIInstall") then
			stripes:SetDrawLayer("OVERLAY", 7)
		end
		f.IRstripes = stripes
	end

	-- 그림자 (Shadow) - 직업 색상
	if E.db.IringUI.skin.shadow and not useShadow then
		local mshadow = f:CreateTexture(nil, "BACKGROUND", nil, 0)
		mshadow:SetInside(f, 0, 0)
		mshadow:SetTexture(IR.Media.Overlay)
		local color = RAID_CLASS_COLORS[E.myclass]
		mshadow:SetVertexColor(color.r, color.g, color.b)
		mshadow:SetAlpha(0.9)
		f.IRshadow = mshadow
	end

	-- [배경 동기화 함수]
	-- 배경 알파값이 0이거나 NoBackdrop인 경우 텍스처를 강제로 숨깁니다.
	local function UpdateVisibility()
		if not f then return end
		local isHidden = (f.template == "NoBackdrop")
		if f.GetBackdropColor then
			local _, _, _, a = f:GetBackdropColor()
			if a and a <= 0.01 then isHidden = true end
		end

		local alpha = isHidden and 0 or 1
		if f.IRstripes then f.IRstripes:SetAlpha(alpha == 1 and 1 or 0) end
		if f.IRshadow then f.IRshadow:SetAlpha(alpha == 1 and 0.4 or 0) end
	end

	-- ElvUI의 배경색 변경 및 프레임 표시 시점에 맞춰 실시간 업데이트
	if f.SetBackdropColor then
		hooksecurefunc(f, "SetBackdropColor", UpdateVisibility)
	end
	
	-- OnUpdate 대신 더 가벼운 OnShow/OnHide 활용
	f:HookScript("OnShow", UpdateVisibility)
	UpdateVisibility()

	f.__style = 1
end

-- 버튼 전용 테두리 하이라이트 함수 (선명도 강화)
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

-- 외부 공유용 등록
IR.Styling = Styling
IR.StyleButton = StyleButton

-- API 주입 및 엘브 후킹
local function AddIringAPI()
	local mt = getmetatable(CreateFrame("Frame")).__index
	local bt = getmetatable(CreateFrame("Button")).__index
	
	if not mt.Styling then mt.Styling = Styling end
	if not bt.Styling then bt.Styling = Styling end

	local function OnSetTemplate(f)
		if not f then return end
		Styling(f)
		
		local name = f.GetName and f:GetName() or ""
		if name:find("ChatTab") or name:find("ChatFrame") or name:find("Install") then 
			return 
		end
		
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
