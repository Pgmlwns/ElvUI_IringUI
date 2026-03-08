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

-- [필독] 설치창 전용 스타일 강제 고정 함수
local function StyleInstallFrame()
	local f = _G.PluginInstallFrame
	if not f then return end

	-- 1. 메인 프레임 배경(backdrop)에 스타일 입히기
	if f.backdrop then
		if not f.backdrop.IRstyle then
			f.backdrop:Styling()
		end
		
		-- 배경색 때문에 무늬가 안 보일 수 있으므로 최상단 레이어로 강제 이동
		if f.backdrop.IRstyle and f.backdrop.IRstyle.stripes then
			f.backdrop.IRstyle.stripes:SetDrawLayer("OVERLAY", 7)
		end
	end

	-- 2. 제목 줄 배경도 스타일 적용
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
		E:Delay(0.02, StyleInstallFrame)
	end

	if not E.db.IringUI.install_complete then
		E.private.install_complete = E.version
		PI:Queue(self.installTable)
		E:Delay(0.05, StyleInstallFrame)
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
			StyleInstallFrame()
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

-- [가장 중요한 부분] 페이지가 바뀔 때마다 스타일을 다시 입힘
hooksecurefunc(PI, "SetPage", function()
	E:Delay(0.01, StyleInstallFrame)
end)