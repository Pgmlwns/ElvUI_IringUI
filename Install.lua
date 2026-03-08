local IR, F, E, L, V, P, G = unpack(select(2, ...))
local PI = E:GetModule('PluginInstaller')

-- 설치 완료 함수
local function InstallComplete()
	E.db.IringUI.install_complete = E.version
	_G.ReloadUI()
end

-- [수정] 배경을 지우지 않고 스타일만 덧씌우는 함수
local function StyleInstallFrame()
	local f = _G.PluginInstallFrame
	if not f then return end

	-- 1. 메인 배경 처리 (StripFrame 제거)
	if f.backdrop then
		-- ElvUI 설정 색상을 살리기 위해 지우지 않고 Styling만 호출
		if not f.backdrop.IRstyle then
			F.Styling(f.backdrop)
		end
		
		-- 빗살무늬가 배경색 위로 잘 보이도록 레이어 조정
		if f.backdrop.IRstyle and f.backdrop.IRstyle.stripes then
			f.backdrop.IRstyle.stripes:SetDrawLayer("OVERLAY", 7)
		end
	end

	-- 2. 제목 줄 및 오른쪽 단계 리스트 처리
	if _G.PluginInstallTitleFrame and not _G.PluginInstallTitleFrame.IRstyle then
		F.Styling(_G.PluginInstallTitleFrame)
	end
    
	-- 3. 하단 진행 바(Status) 및 버튼들 스타일 입히기
	if f.Status and not f.Status.IRstyle then
		F.Styling(f.Status)
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
	["tutorialImage"] = [[Interface\AddOns\ElvUI_IringUI\Media\Textures\stripes]],
	["Pages"] = {
		[1] = function()
			if not _G.PluginInstallFrame then return end
			_G.PluginInstallFrame.SubTitle:SetText("환영합니다")
			_G.PluginInstallFrame.Desc1:SetText("IringUI 설치를 시작합니다.")
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

-- 페이지 전환 시 스타일 감시
hooksecurefunc(PI, "SetPage", function()
	E:Delay(0.01, StyleInstallFrame)
end)
