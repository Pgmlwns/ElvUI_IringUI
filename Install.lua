local IR, F, E, L, V, P, G = unpack(select(2, ...))
local PI = E:GetModule('PluginInstaller')

local function InstallComplete()
	E.db.IringUI.install_complete = E.version
	_G.ReloadUI()
end

function IR:InterceptInstaller()
	if _G.ElvUIInstallFrame then _G.ElvUIInstallFrame:Hide() end
	E.Install = function() PI:Queue(self.installTable); E:ToggleOptionsUI() end

	if not E.db.IringUI.install_complete then
		E.private.install_complete = E.version
		PI:Queue(self.installTable)
	end
end

IR.installTable = {
	["Name"] = "|cffff69b4Iring|r|cffb2b2b2UI|r",
	["Title"] = "|cffff69b4Iring|r|cffb2b2b2UI|r 설치 가이드",
	["tutorialImage"] = [[Interface\AddOns\ElvUI_IringUI\Media\Textures\stripes]],
	["Pages"] = {
	 = function()
			if not _G.PluginInstallFrame then return end
			_G.PluginInstallFrame.SubTitle:SetText("환영합니다")
			_G.PluginInstallFrame.Desc1:SetText("IringUI 레이아웃 설치를 시작합니다.")
			_G.PluginInstallFrame.Option1:Show()
			_G.PluginInstallFrame.Option1:SetText("설치 건너뛰기")
			_G.PluginInstallFrame.Option1:SetScript("OnClick", function() InstallComplete() end)
		end,
	 = function()
			if not _G.PluginInstallFrame then return end
			_G.PluginInstallFrame.SubTitle:SetText("레이아웃 및 스킨")
			_G.PluginInstallFrame.Desc1:SetText("IringUI 전용 스타일을 적용합니다.")
			_G.PluginInstallFrame.Option1:Show()
			_G.PluginInstallFrame.Option1:SetText("스타일 적용")
			_G.PluginInstallFrame.Option1:SetScript("OnClick", function() IR:ForceMediaUpdate(); IR:UpdateLayout() end)
		end,
	 = function()
			if not _G.PluginInstallFrame then return end
			_G.PluginInstallFrame.SubTitle:SetText("완료")
			_G.PluginInstallFrame.Option1:Show()
			_G.PluginInstallFrame.Option1:SetText("완료")
			_G.PluginInstallFrame.Option1:SetScript("OnClick", function() InstallComplete() end)
		end,
	},
	["StepTitles"] = { = "시작", = "레이아웃", = "완료" },
	StepTitlesColorSelected = RAID_CLASS_COLORS[E.myclass],
}
