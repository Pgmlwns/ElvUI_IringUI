local IR, F, E, L, V, P, G = unpack(select(2, ...))
local PI = E:GetModule('PluginInstaller')

-- 설치창에 IringUI 전용 스타일 입히기 (꾸미기용)
local function DecorateInstallFrame()
    local f = _G.PluginInstallFrame
    if not f or f.IringDecorated then return end

    -- 1. 상단에 핑크색 얇은 바 추가
    local topBar = f:CreateTexture(nil, "OVERLAY")
    topBar:SetPoint("TOPLEFT", f, "TOPLEFT", 5, -5)
    topBar:SetPoint("TOPRIGHT", f, "TOPRIGHT", -5, -5)
    topBar:SetHeight(3)
    topBar:SetColorTexture(1, 0.41, 0.7, 0.8) -- 영롱한 핑크색

    -- 2. 설치창 전체에 IringUI 스타일(빗살무늬) 입히기
    if f.Styling then 
        f:Styling() 
    end

    f.IringDecorated = true
end

-- 설치창이 열릴 때마다 꾸미기 실행
hooksecurefunc(PI, "Queue", function()
    E:Delay(0.01, DecorateInstallFrame)
end)

-- 설치 완료 시 실행될 함수
local function InstallComplete()
	E.db.IringUI.install_complete = E.version
	if _G.PluginInstallStepComplete then
		_G.PluginInstallStepComplete.message = IR.Title .. " 설치 완료!"
		_G.PluginInstallStepComplete:Show()
	end
	_G.ReloadUI()
end

-- ElvUI 기본 설치창 가로채기
function IR:InterceptInstaller()
	if _G.ElvUIInstallFrame then _G.ElvUIInstallFrame:Hide() end
	E.Install = function() PI:Queue(self.installTable); E:ToggleOptionsUI() end

	if not E.db.IringUI.install_complete then
		E.private.install_complete = E.version
		PI:Queue(self.installTable)
	end
end

-- IringUI 설치 테이블 정의 (3페이지 구성)
IR.installTable = {
	["Name"] = "|cffff69b4Iring|r|cffb2b2b2UI|r",
	["Title"] = "|cffff69b4Iring|r|cffb2b2b2UI|r 설치 가이드",
	["tutorialImage"] = [[Interface\AddOns\ElvUI_IringUI\Media\Textures\stripes]], -- 로고 파일이 있다면 경로 수정
	["tutorialImageSize"] = {256, 128},
	["tutorialImagePoint"] = {0, 30},
	["Pages"] = {
		[1] = function()
			_G.PluginInstallFrame.SubTitle:SetFormattedText("환영합니다! |cffff69b4Iring|r|cffb2b2b2UI|r 버전 %s", "1.0.0")
			_G.PluginInstallFrame.Desc1:SetText("이 가이드는 IringUI의 핵심 스타일과 레이아웃을 캐릭터에 적용합니다.")
			_G.PluginInstallFrame.Desc2:SetText("계속하시려면 [다음] 버튼을, 설정을 건너뛰려면 [설치 건너뛰기]를 눌러주세요.")
			_G.PluginInstallFrame.Option1:Show()
			_G.PluginInstallFrame.Option1:SetScript("OnClick", function() InstallComplete() end)
			_G.PluginInstallFrame.Option1:SetText("설치 건너뛰기")
		end,
		[2] = function()
			_G.PluginInstallFrame.SubTitle:SetText("레이아웃 및 스킨")
			_G.PluginInstallFrame.Desc1:SetText("IringUI 전용 빗살무늬 배경과 프레임 스타일을 적용합니다.")
			_G.PluginInstallFrame.Desc2:SetText("아래 버튼을 누르면 ElvUI의 기본 외형이 IringUI 스타일로 변경됩니다.")
			_G.PluginInstallFrame.Desc3:SetText("중요도: |cff07D400높음|r")
			_G.PluginInstallFrame.Option1:Show()
			_G.PluginInstallFrame.Option1:SetScript("OnClick", function() 
				if IR.ForceMediaUpdate then IR:ForceMediaUpdate() end
				if IR.UpdateLayout then IR:UpdateLayout() end
				E:Print("IringUI 레이아웃 적용 중...")
			end)
			_G.PluginInstallFrame.Option1:SetText("스타일 적용")
		end,
		[3] = function()
			_G.PluginInstallFrame.SubTitle:SetText("설치 완료")
			_G.PluginInstallFrame.Desc1:SetText("모든 준비가 끝났습니다. 이제 판다리아 클래식을 즐기실 시간입니다.")
			_G.PluginInstallFrame.Desc2:SetText("아래 [완료] 버튼을 누르면 UI를 재시작하고 설정을 마무리합니다.")
			_G.PluginInstallFrame.Option1:Show()
			_G.PluginInstallFrame.Option1:SetScript("OnClick", function() InstallComplete() end)
			_G.PluginInstallFrame.Option1:SetText("완료")
		end,
	},

	["StepTitles"] = {
		[1] = "시작",
		[2] = "레이아웃",
		[3] = "완료",
	},
	-- 현재 캐릭터 직업 색상으로 강조
	StepTitlesColorSelected = RAID_CLASS_COLORS[E.myclass],
	StepTitleWidth = 200,
	StepTitleButtonWidth = 200,
	StepTitleTextJustification = "CENTER",
}