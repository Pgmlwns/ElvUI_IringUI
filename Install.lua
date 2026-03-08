local IR, F, E, L, V, P, G = unpack(select(2, ...))
local PI = E:GetModule('PluginInstaller')

local function InstallComplete()
	E.db.IringUI.install_complete = E.version
	_G.ReloadUI()
end

-- 스타일 적용 함수 (F 보따리 함수 사용으로 에러 방지)
local function StyleInstallFrame()
	local f = _G.PluginInstallFrame
	if not f then return end

	-- 엘브 기본 배경 제거 및 스타일 적용
	if f.backdrop then
		F.StripFrame(f.backdrop, true)
		F.Styling(f.backdrop)
	end

	F.StripFrame(f, true)
	F.Styling(f)

	local title = _G.PluginInstallTitleFrame
	if title then
		F.StripFrame(title, true)
		F.Styling(title)
	end
end

-- [이후 인스톨 테이블 및 가로채기 로직은 동일하게 유지하되 함수 호출만 변경]
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

IR.installTable = {
	["Name"] = "|cffff69b4Iring|r|cffb2b2b2UI|r",
	["Title"] = "|cffff69b4Iring|r|cffb2b2b2UI|r 설치 가이드",
	["Pages"] = {
		[1] = function()
			if not _G.PluginInstallFrame then return end
			_G.PluginInstallFrame.SubTitle:SetText("환영합니다")
			_G.PluginInstallFrame.Desc1:SetText("IringUI 레이아웃 설치를 시작합니다.")
			_G.PluginInstallFrame.Option1:Show()
			_G.PluginInstallFrame.Option1:SetText("설치 건너뛰기")
			_G.PluginInstallFrame.Option1:SetScript("OnClick", function() InstallComplete() end)
			StyleInstallFrame()
		end,
		[2] = function()
			if not _G.PluginInstallFrame then return end
			_G.PluginInstallFrame.SubTitle:SetText("레이아웃")
			_G.PluginInstallFrame.Desc1:SetText("스타일을 적용합니다.")
			_G.PluginInstallFrame.Option1:Show()
			_G.PluginInstallFrame.Option1:SetText("스타일 적용")
			_G.PluginInstallFrame.Option1:SetScript("OnClick", function() 
				IR:ForceMediaUpdate()
				IR:UpdateLayout()
			end)
			StyleInstallFrame()
		end,
		[3] = function()
			if not _G.PluginInstallFrame then return end
			_G.PluginInstallFrame.SubTitle:SetText("완료")
			_G.PluginInstallFrame.Option1:Show()
			_G.PluginInstallFrame.Option1:SetText("완료")
			_G.PluginInstallFrame.Option1:SetScript("OnClick", function() InstallComplete() end)
			StyleInstallFrame()
		end,
	},
	["StepTitles"] = { [1] = "시작", [2] = "레이아웃", [3] = "완료" },
	StepTitlesColorSelected = RAID_CLASS_COLORS[E.myclass],
}

hooksecurefunc(PI, "SetPage", function()
	E:Delay(0.01, StyleInstallFrame)
end)