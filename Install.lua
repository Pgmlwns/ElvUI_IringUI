local IR, F, E, L, V, P, G = unpack(select(2, ...))
local PI = E:GetModule('PluginInstaller')

-- 설치 완료 함수
local function InstallComplete()
	E.db.IringUI.install_complete = E.version
	_G.ReloadUI()
end

-- [해결책] 설치창 배경을 깨끗이 지우고 IringUI 스타일 입히기
local function StyleInstallFrame()
	local f = _G.PluginInstallFrame
	if not f then return end

	-- 1. 엘브가 그려놓은 기존 배경 텍스처들을 싹 지움 (제공해주신 소스 활용)
	if f.backdrop then
		f.backdrop:StripFrame(true) -- 배경 지우기
		f.backdrop:Styling()        -- 우리 스타일 입히기
	end

	-- 2. 메인 프레임 본체도 지우고 다시 입힘
	f:StripFrame(true)
	f:Styling()

	-- 3. 제목 줄 처리
	local title = _G.PluginInstallTitleFrame
	if title then
		title:StripFrame(true)
		title:Styling()
	end
end

-- [이후 내용은 기존 Install.lua와 동일하게 유지]
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

-- 페이지 바뀔 때마다 스타일 감시
hooksecurefunc(PI, "SetPage", function()
	E:Delay(0.01, StyleInstallFrame)
end)