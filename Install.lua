local IR, F, E, L, V, P, G = unpack(select(2, ...))
local PI = E:GetModule('PluginInstaller')

-- 설치 완료 함수
local function InstallComplete()
	E.db.IringUI.install_complete = E.version
	_G.ReloadUI()
end

-- [완전 해결용] 설치창의 모든 배경 텍스처를 억지로 끄집어내는 함수
local function ForceStyleInstaller()
	local f = _G.PluginInstallFrame
	if not f then return end

	-- 1. 메인 배경(backdrop)에 스타일 입히기
	if f.backdrop then
		-- 이미 스타일이 입혀졌어도 텍스처 레이어를 다시 한번 강조
		if not f.backdrop.IRstyle then
			F.Styling(f.backdrop)
		end
		
		-- 핵심: ElvUI의 기본 배경색 위로 우리 빗살무늬를 강제로 올림
		if f.backdrop.IRstyle and f.backdrop.IRstyle.stripes then
			f.backdrop.IRstyle.stripes:SetParent(f) -- 부모를 본체로 변경하여 배경색을 뚫게 함
			f.backdrop.IRstyle.stripes:SetDrawLayer("OVERLAY", 7)
			f.backdrop.IRstyle.stripes:SetAllPoints(f.backdrop)
		end
	end

	-- 2. 제목창(TitleFrame)도 동일하게 처리
	local title = _G.PluginInstallTitleFrame
	if title and title.backdrop then
		if not title.backdrop.IRstyle then F.Styling(title.backdrop) end
		if title.backdrop.IRstyle and title.backdrop.IRstyle.stripes then
			title.backdrop.IRstyle.stripes:SetParent(title)
			title.backdrop.IRstyle.stripes:SetDrawLayer("OVERLAY", 7)
		end
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

-- 설치 테이블
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
			ForceStyleInstaller() -- 여기서 강제 적용
		end,
		[2] = function()
			if not _G.PluginInstallFrame then return end
			_G.PluginInstallFrame.SubTitle:SetText("레이아웃")
			_G.PluginInstallFrame.Desc1:SetText("스타일을 적용합니다.")
			_G.PluginInstallFrame.Option1:Show()
			_G.PluginInstallFrame.Option1:SetText("스타일 적용")
			_G.PluginInstallFrame.Option1:SetScript("OnClick", function() IR:ForceMediaUpdate(); IR:UpdateLayout() end)
			ForceStyleInstaller()
		end,
		[3] = function()
			if not _G.PluginInstallFrame then return end
			_G.PluginInstallFrame.SubTitle:SetText("완료")
			_G.PluginInstallFrame.Option1:Show()
			_G.PluginInstallFrame.Option1:SetText("완료")
			_G.PluginInstallFrame.Option1:SetScript("OnClick", function() InstallComplete() end)
			ForceStyleInstaller()
		end,
	},
	["StepTitles"] = { [1] = "시작", [2] = "레이아웃", [3] = "완료" },
	StepTitlesColorSelected = RAID_CLASS_COLORS[E.myclass],
}

-- 페이지 전환 시마다 강제 호출
hooksecurefunc(PI, "SetPage", function()
	E:Delay(0.01, ForceStyleInstaller)
end)
