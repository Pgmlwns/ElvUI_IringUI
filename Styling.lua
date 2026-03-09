local IR, F, E, L, V, P, G = unpack(select(2, ...))

-- [1] 모듈들이 스스로 스타일 적용 여부를 등록할 테이블
IR.ModuleFilters = {}

-- [2] 모든 프레임 및 버튼에 빗살무늬와 그림자를 입히는 함수
local function Styling(f, useStripes, useShadow)
	-- 설정 체크 (DB가 로드되지 않았으면 중단)
	if not E.db or not E.db.IringUI or not E.db.IringUI.skin or not E.db.IringUI.skin.enable then return end
	if not f or f.IRstyle or f.__style then return end

	-- [자동 필터 로직] 등록된 모듈 키워드가 프레임 이름에 포함되어 있는지 확인
	local name = f.GetName and f:GetName() or ""
	for keyword, checkFunc in pairs(IR.ModuleFilters) do
		if name:find(keyword) then
			-- 해당 모듈의 설정이 꺼져있으면(false) 스타일을 입히지 않고 종료
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
		
		-- 설치창 레이어 처리
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
		
		-- 빗살무늬/그림자 스타일 적용 (필터 체크 포함)
		Styling(f)
		
		-- 하이라이트 제외 대상 필터링
		local name = f.GetName and f:GetName() or ""
		if name:find("ChatTab") or name:find("ChatFrame") or name:find("Install") then 
			return 
		end
		
		-- 버튼이거나 탭이면 테두리 하이라이트 적용
		if f:IsObjectType("Button") or name:find("Tab") then
			StyleButton(f)
		end
	end

	if mt.SetTemplate then hooksecurefunc(mt, "SetTemplate", OnSetTemplate) end
	if bt.SetTemplate then hooksecurefunc(bt, "SetTemplate", OnSetTemplate) end

	-- 판다리아 클래식 탭 스킨 후킹
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
