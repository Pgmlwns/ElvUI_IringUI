local IR, F, E, L, V, P, G = unpack(select(2, ...))
local PI = E:GetModule('PluginInstaller')

-- 설치 완료 함수
local function InstallComplete()
	E.db.IringUI.install_complete = E.version
	_G.ReloadUI()
end

-- [완전 해결] 설치창 배경에 IringUI 스타일 강제 주입
local function StyleInstallFrame()
	local f = _G.PluginInstallFrame
	if not f then return end

	-- 1. 메인 배경(Backdrop) 자체에 Styling 강제 적용
	if f.backdrop then
		-- 이미 적용되었다면 중복 실행 방지
		if not f.backdrop.IRstyle then
			f.backdrop:Styling()
		end
		
		-- ElvUI가 배경을 단색으로 덮어쓰지 못하도록 사선 패턴을 최상단으로 올림
		if f.backdrop.IRstyle and f.backdrop.IRstyle.stripes then
			f.backdrop.IRstyle.stripes:SetDrawLayer("OVERLAY", 7)
		end
	end

	-- 2. 버튼들이 있는 하단부 및 오른쪽 리스트 배경도 확인
	if _G.PluginInstallTitleFrame and not _G.PluginInstallTitleFrame.IRstyle then
		_G.PluginInstallTitleFrame:Styling()
	end
end

-- ElvUI 기본 설치창 가로채기
function IR:InterceptInstaller()
	if _G.ElvUIInstallFrame then _G.ElvUIInstallFrame:Hide() end
	E.Install = function() 
		PI:Queue(self.installTable)
		E:ToggleOptionsUI() 
	end

	if not E.db.IringUI.install_complete then
		E.private.install_complete = E.version
		PI:Queue(self.installTable)
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
			_G.PluginInstallFrame.Option1:Show()
			_G.PluginInstallFrame.Option1:SetScript("OnClick", function() InstallComplete() end)
			_G.PluginInstallFrame.Option1:SetText("설치 건너뛰기")
			StyleInstallFrame() -- 강제 스타일 적용
		end,
		[2] = function()
			if not _G.PluginInstallFrame then return end
			_G.PluginInstallFrame.SubTitle:SetText("레이아웃 및 스킨")
			_G.PluginInstallFrame.Desc1:SetText("IringUI 전용 빗살무늬 배경과 프레임 스타일을 적용합니다.")
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

-- 설치창이 생성되거나 페이지가 바뀔 때마다 스타일을 감시
hooksecurefunc(PI, "SetPage", function()
	E:Delay(0.01, StyleInstallFrame)
end)