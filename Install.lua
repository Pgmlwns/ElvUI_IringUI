local IR, F, E, L, V, P, G = unpack(select(2, ...))
local PI = E:GetModule('PluginInstaller')

-- 설치 완료 및 재시작 함수
local function InstallComplete()
	E.db.IringUI.install_complete = E.version
	if _G.PluginInstallStepComplete then
		_G.PluginInstallStepComplete.message = IR.Title .. " 설치 완료!"
		_G.PluginInstallStepComplete:Show()
	end
	_G.ReloadUI()
end

-- [핵심] 설치창 전용 스타일 입히기 함수
local function StyleInstallFrame()
	local f = _G.PluginInstallFrame
	if not f then return end

	-- 1. 메인 프레임에 스타일 적용
	if f.Styling and not f.IRstyle then
		f:Styling()
	end

	-- 2. 메인 프레임의 배경(Backdrop)에 스타일 적용 (왼쪽 구역)
	if f.backdrop and f.backdrop.Styling and not f.backdrop.IRstyle then
		f.backdrop:Styling()
	end

	-- 3. 상단 장식 바 추가 (선택 사항 - 핑크색 포인트)
	if not f.IringTopLine then
		local line = f:CreateTexture(nil, "OVERLAY")
		line:SetPoint("TOPLEFT", f, "TOPLEFT", 2, -2)
		line:SetPoint("TOPRIGHT", f, "TOPRIGHT", -2, -2)
		line:SetHeight(2)
		line:SetColorTexture(1, 0.41, 0.7, 0.8) -- 핑크색
		f.IringTopLine = line
	end
end

-- ElvUI 기본 설치창 가로채기
function IR:InterceptInstaller()
	if _G.ElvUIInstallFrame then _G.ElvUIInstallFrame:Hide() end
	
	-- ElvUI의 설치 함수를 우리 것으로 교체
	E.Install = function() 
		PI:Queue(self.installTable)
		E:ToggleOptionsUI() 
		E:Delay(0.02, StyleInstallFrame) -- 열릴 때 스타일 적용
	end

	-- 미설치 시 자동 실행
	if not E.db.IringUI.install_complete then
		E.private.install_complete = E.version
		PI:Queue(self.installTable)
		E:Delay(0.05, StyleInstallFrame) -- 초기 로드 시 지연 적용
	end
end

-- 설치 가이드 테이블 (3페이지)
IR.installTable = {
	["Name"] = "|cffff69b4Iring|r|cffb2b2b2UI|r",
	["Title"] = "|cffff69b4Iring|r|cffb2b2b2UI|r 설치 가이드",
	["tutorialImage"] = [[Interface\AddOns\ElvUI_IringUI\Media\Textures\stripes]],
	["tutorialImageSize"] = {256, 128},
	["tutorialImagePoint"] = {0, 30},
	["Pages"] = {
		[1] = function()
			if not _G.PluginInstallFrame then return end
			_G.PluginInstallFrame.SubTitle:SetFormattedText("환영합니다! |cffff69b4Iring|r|cffb2b2b2UI|r 버전 %s", "1.0.0")
			_G.PluginInstallFrame.Desc1:SetText("이 가이드는 IringUI의 핵심 스타일과 레이아웃을 캐릭터에 적용합니다.")
			_G.PluginInstallFrame.Desc2:SetText("계속하시려면 [다음] 버튼을, 설정을 건너뛰려면 [설치 건너뛰기]를 눌러주세요.")
			_G.PluginInstallFrame.Option1:Show()
			_G.PluginInstallFrame.Option1:SetScript("OnClick", function() InstallComplete() end)
			_G.PluginInstallFrame.Option1:SetText("설치 건너뛰기")
			StyleInstallFrame() -- 페이지 전환 시마다 체크
		end,
		[2] = function()
			if not _G.PluginInstallFrame then return end
			_G.PluginInstallFrame.SubTitle:SetText("레이아웃 및 스킨")
			_G.PluginInstallFrame.Desc1:SetText("IringUI 전용 빗살무늬 배경과 프레임 스타일을 적용합니다.")
			_G.PluginInstallFrame.Desc2:SetText("아래 버튼을 누르면 ElvUI의 기본 외형이 IringUI 스타일로 변경됩니다.")
			_G.PluginInstallFrame.Option1:Show()
			_G.PluginInstallFrame.Option1:SetScript("OnClick", function() 
				if IR.ForceMediaUpdate then IR:ForceMediaUpdate() end
				if IR.UpdateLayout then IR:UpdateLayout() end
				E:Print("IringUI 스타일 및 레이아웃 적용 완료!")
			end)
			_G.PluginInstallFrame.Option1:SetText("스타일 적용")
			StyleInstallFrame()
		end,
		[3] = function()
			if not _G.PluginInstallFrame then return end
			_G.PluginInstallFrame.SubTitle:SetText("설치 완료")
			_G.PluginInstallFrame.Desc1:SetText("모든 준비가 끝났습니다. 이제 판다리아 클래식을 즐기실 시간입니다.")
			_G.PluginInstallFrame.Option1:Show()
			_G.PluginInstallFrame.Option1:SetScript("OnClick", function() InstallComplete() end)
			_G.PluginInstallFrame.Option1:SetText("완료")
			StyleInstallFrame()
		end,
	},
	["StepTitles"] = {
		[1] = "시작",
		[2] = "레이아웃",
		[3] = "완료",
	},
	StepTitlesColorSelected = RAID_CLASS_COLORS[E.myclass],
	StepTitleWidth = 200,
	StepTitleButtonWidth = 200,
	StepTitleTextJustification = "CENTER",
}

-- 설치창이 큐에 들어올 때 스타일 적용 후킹
hooksecurefunc(PI, "Queue", function()
	E:Delay(0.05, StyleInstallFrame)
end)