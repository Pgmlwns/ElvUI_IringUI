local IR, F, E, L, V, P, G = unpack(select(2, ...))

-- [1] 모듈들이 스스로 스타일 적용 여부를 등록할 테이블
IR.ModuleFilters = {}

-- [2] 모든 프레임 및 버튼에 빗살무늬와 그림자를 입히는 함수
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

	local frameName = f.GetName and f:GetName()
	local style = CreateFrame("Frame", frameName and frameName.."_IRStyle" or nil, f, "BackdropTemplate")

	-- 빗살무늬 (Stripes)
	if E.db.IringUI.skin.stripes and not useStripes then
		local stripes = f:CreateTexture(nil, "BACKGROUND", nil, 1)
		stripes:SetInside(f, 1, -1)
		stripes:SetTexture(IR.Media.Stripes, true, true)
		stripes:SetHorizTile(true) stripes:SetVertTile(true)
		stripes:SetBlendMode("ADD")
		
		if frameName and (frameName:find("PluginInstall") or frameName:find("ElvUIInstall")) then
			stripes:SetDrawLayer("OVERLAY", 7)
		end
		style.stripes = stripes
	end

	-- 그림자 (Shadow) - 직업 색상
	if E.db.IringUI.skin.shadow and not useShadow then
		local mshadow = f:CreateTexture(nil, "BACKGROUND", nil, 0)
		mshadow:SetInside(f, 0, 0)
		mshadow:SetTexture(IR.Media.Overlay)
		local color = RAID_CLASS_COLORS[E.myclass]
		mshadow:SetVertexColor(color.r, color.g, color.b)
		mshadow:SetAlpha(0.4)
		style.mshadow = mshadow
	end

	style:SetFrameStrata(f:GetFrameStrata())
	style:SetFrameLevel(math.max(0, f:GetFrameLevel() - 1))
	style:SetAllPoints(f)
	
	-- [핵심 수정: 강제 투명도 동기화]
	-- 부모 프레임의 실제 배경 투명도를 실시간으로 감시하여 스타일을 숨깁니다.
	local function UpdateVisibility()
		if not f or not style then return end
		local r, g, b, a = 0, 0, 0, 1
		if f.GetBackdropColor then
			r, g, b, a = f:GetBackdropColor()
		end
		
		-- 배경 알파가 0이거나, 엘브에서 배경을 제거한 경우 스타일 숨김
		if (a and a <= 0.01) or (f.template == "NoBackdrop") then
			style:SetAlpha(0)
		else
			style:SetAlpha(1)
		end
	end

	-- 이벤트 핸들러 등록
	if f.SetBackdropColor then
		hooksecurefunc(f, "SetBackdropColor", UpdateVisibility)
	end
	
	-- 프레임이 그려질 때마다 투명도 상태를 강제로 다시 체크 (가장 확실한 방법)
	f:HookScript("OnShow", UpdateVisibility)
	style:SetScript("OnUpdate", function(self, elapsed)
		self.timer = (self.timer or 0) + elapsed
		if self.timer > 0.2 then -- 0.2초마다 배경 상태 감시
			UpdateVisibility()
			self.timer = 0
		end
	end)
	
	UpdateVisibility()
	f.IRstyle = style
	f.__style = 1
end

-- [3] 버튼 전용 테두리 하이라이트 함수 (선명도 강화)
local function StyleButton(f)
	if not f or f.IringBtnStyled then return end
	
	f:HookScript("OnEnter", function(self)
		local color = RAID_CLASS_COLORS[E.myclass]
		local target = self.backdrop or self
		if target.SetBackdropBorderColor then
			target:SetBackdropBorderColor(color.r, color.g, color.b, 1)
			if self.SetFrameLevel then self:SetFrameLevel(self:GetFrameLevel() + 2) end
		end
	end)
	
	f:HookScript("OnLeave", function(self)
		local target = self.backdrop or self
		if target.SetBackdropBorderColor then
			target:SetBackdropBorderColor(unpack(E.media.bordercolor))
			if self.SetFrameLevel then self:SetFrameLevel(math.max(0, self:GetFrameLevel() - 2)) end
		end
	end)
	
	f.IringBtnStyled = true
end

-- [4] 외부 공유용 등록
IR.Styling = Styling
IR.StyleButton = StyleButton

-- [5] API 주입 및 엘브 후킹
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
