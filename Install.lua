local IR, F, E, L, V, P, G = unpack(select(2, ...))
local PI = E:GetModule('PluginInstaller')

-- 설치 완료 함수
local function InstallComplete()
	E.db.IringUI.install_complete = E.version
	_G.ReloadUI()
end

-- [최후의 수단] ElvUI 배경과 별개로 IringUI 전용 배경층을 새로 생성
local function CreatePersistentBackground()
	local f = _G.PluginInstallFrame
	if not f then return end

	-- 1. 메인 배경 뒤에 고정될 IringUI 전용 배경 생성
	if not f.IringBG then
		local bg = CreateFrame("Frame", nil, f, "BackdropTemplate")
		bg:SetAllPoints(f)
		bg:SetFrameLevel(f:GetFrameLevel() - 1) -- 설치창보다 한 단계 아래 배치
		
		-- 빗살무늬 텍스처 직접 생성
		local stripes = bg:CreateTexture(nil, "BACKGROUND")
		stripes:SetAllPoints(bg)
		stripes:SetTexture(IR.Media.Stripes, true, true)
		stripes:SetHorizTile(true)
		stripes:SetVertTile(true)
		stripes:SetBlendMode("ADD")
		stripes:SetAlpha(0.5) -- 은은하게 조절
		
		f.IringBG = bg
	end

	-- 2. ElvUI가 기본 배경색으로 우리 무늬를 가리지 못하게 투명도 조절
	if f.backdrop then
		f.backdrop:SetAlpha(0.3) -- ElvUI 배경을 반투명하게 해서 우리 무늬가 보이게 함
	end
    
	-- 3. 타이틀 바 배경 처리
	local title = _G.PluginInstallTitleFrame
	if title and not title.IringBG then
		local bg = CreateFrame("Frame", nil, title, "BackdropTemplate")
		bg:SetAllPoints(title)
		bg:SetFrameLevel(title:GetFrameLevel() - 1)
		
		local stripes = bg:CreateTexture(nil, "BACKGROUND")
		stripes:SetAllPoints(bg)
		stripes:SetTexture(IR.Media.Stripes, true, true)
		stripes:SetHorizTile(true)
		stripes:SetVertTile(true)
		stripes:SetBlendMode("ADD")
		
		title.IringBG = bg
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

-- 설치 가이드 테이블
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
			CreatePersistentBackground() -- 배경 생성 및 유지
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
			CreatePersistentBackground()
		end,
		[3] = function()
			if not _G.PluginInstallFrame then return end
			_G.PluginInstallFrame.SubTitle:SetText("설치 완료")
			_G.PluginInstallFrame.Desc1:SetText("모든 준비가 끝났습니다. 이제 판다리아 클래식을 즐기실 시간입니다.")
			_G.PluginInstallFrame.Option1:Show()
			_G.PluginInstallFrame.Option1:SetScript("OnClick", function() InstallComplete() end)
			_G.PluginInstallFrame.Option1:SetText("완료")
			CreatePersistentBackground()
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

-- 페이지가 바뀔 때마다 배경 상태를 다시 체크
hooksecurefunc(PI, "SetPage", function()
	E:Delay(0.01, CreatePersistentBackground)
end)