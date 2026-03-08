local IR, F, E, L, V, P, G = unpack(select(2, ...))
local PI = E:GetModule('PluginInstaller')

-- 설치 완료 함수
local function InstallComplete()
	E.db.IringUI.install_complete = E.version
	_G.ReloadUI()
end

-- [해결사] 설치창의 무늬가 가려지지 않게 레이어를 고정하는 함수
local function RefreshInstallStyle()
	local f = _G.PluginInstallFrame
	if not f then return end

	-- 메인 창과 그 배경에 스타일이 있는지 확인하고 강제 적용
	local target = f.backdrop or f
	if target.Styling then target:Styling() end

	-- 만약 무늬가 배경색 뒤로 숨었다면 강제로 앞으로 끄집어냄
	if target.IRstyle and target.IRstyle.stripes then
		target.IRstyle.stripes:SetDrawLayer("OVERLAY", 7)
	end
end

-- 가로채기 로직
function IR:InterceptInstaller()
	if _G.ElvUIInstallFrame then _G.ElvUIInstallFrame:Hide() end
	E.Install = function() PI:Queue(self.installTable); E:ToggleOptionsUI() end

	if not E.db.IringUI.install_complete then
		E.private.install_complete = E.version
		PI:Queue(self.installTable)
	end
end

-- 설치 가이드 테이블
IR.installTable = {
	["Name"] = "|cffff69b4Iring|r|cffb2b2b2UI|r",
	["Title"] = "|cffff69b4Iring|r|cffb2b2b2UI|r 설치 가이드",
	["Pages"] = {
		[1] = function()
			_G.PluginInstallFrame.SubTitle:SetText("환영합니다")
			_G.PluginInstallFrame.Desc1:SetText("IringUI 설치를 시작합니다.")
			_G.PluginInstallFrame.Option1:Show()
			_G.PluginInstallFrame.Option1:SetText("설치 건너뛰기")
			_G.PluginInstallFrame.Option1:SetScript("OnClick", function() InstallComplete() end)
			RefreshInstallStyle()
		end,
		[2] = function()
			_G.PluginInstallFrame.SubTitle:SetText("레이아웃")
			_G.PluginInstallFrame.Desc1:SetText("스타일을 적용합니다.")
			_G.PluginInstallFrame.Option1:Show()
			_G.PluginInstallFrame.Option1:SetText("스타일 적용")
			_G.PluginInstallFrame.Option1:SetScript("OnClick", function() IR:ForceMediaUpdate(); IR:UpdateLayout() end)
			RefreshInstallStyle()
		end,
		[3] = function()
			_G.PluginInstallFrame.SubTitle:SetText("완료")
			_G.PluginInstallFrame.Option1:Show()
			_G.PluginInstallFrame.Option1:SetText("완료")
			_G.PluginInstallFrame.Option1:SetScript("OnClick", function() InstallComplete() end)
			RefreshInstallStyle()
		end,
	},
	["StepTitles"] = { [1] = "시작", [2] = "레이아웃", [3] = "완료" },
	StepTitlesColorSelected = RAID_CLASS_COLORS[E.myclass],
}

-- [결정타] 페이지 바뀔 때마다 스타일 다시 부활시키기
hooksecurefunc(PI, "SetPage", function()
	E:Delay(0.01, RefreshInstallStyle)
end)
