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

-- [핵심] 설치창 전용 빗살무늬 강제 생성 함수 (Styling.lua 독립형)
local function ForceIringStyle()
	local f = _G.PluginInstallFrame
	if not f then return end

	-- 1. 메인 본체 배경(backdrop)에 직접 텍스처 생성
	local target = f.backdrop or f
	if target and not target.IringStripes then
		local tex = target:CreateTexture(nil, "OVERLAY", nil, 7) -- 최상단 레이어
		tex:SetInside(target, 1, -1)
		tex:SetTexture(IR.Media.Stripes, true, true)
		tex:SetHorizTile(true)
		tex:SetVertTile(true)
		tex:SetBlendMode("ADD")
		tex:SetAlpha(0.5) -- 빗살무늬 농도
		target.IringStripes = tex
	end

	-- 2. 제목 줄(Title) 배경 처리
	local title = _G.PluginInstallTitleFrame
	if title and title.backdrop and not title.backdrop.IringStripes then
		local tex = title.backdrop:CreateTexture(nil, "OVERLAY", nil, 7)
		tex:SetInside(title.backdrop, 1, -1)
		tex:SetTexture(IR.Media.Stripes, true, true)
		tex:SetHorizTile(true)
		tex:SetVertTile(true)
		tex:SetBlendMode("ADD")
		title.backdrop.IringStripes = tex
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
	["Pages"] = {
		[1] = function()
			if not _G.PluginInstallFrame then return end
			_G.PluginInstallFrame.SubTitle:SetFormattedText("환영합니다! |cffff69b4Iring|r|cffb2b2b2UI|r 버전 %s", "1.0.0")
			_G.PluginInstallFrame.Desc1:SetText("이 가이드는 IringUI의 핵심 스타일과 레이아웃을 캐릭터에 적용합니다.")
			_G.PluginInstallFrame.Option1:Show()
			_G.PluginInstallFrame.Option1:SetText("설치 건너뛰기")
			_G.PluginInstallFrame.Option1:SetScript("OnClick", function() InstallComplete() end)
			ForceIringStyle() -- 페이지 진입 시 강제 적용
		end,
		[2] = function()
			if not _G.PluginInstallFrame then return end
			_G.PluginInstallFrame.SubTitle:SetText("레이아웃 및 스킨")
			_G.PluginInstallFrame.Desc1:SetText("IringUI 전용 빗살무늬 배경과 프레임 스타일을 적용합니다.")
			_G.PluginInstallFrame.Option1:Show()
			_G.PluginInstallFrame.Option1:SetText("스타일 적용")
			_G.PluginInstallFrame.Option1:SetScript("OnClick", function() 
				if IR.ForceMediaUpdate then IR:ForceMediaUpdate() end
				if IR.UpdateLayout then IR:UpdateLayout() end
				E:Print("IringUI 스타일 및 레이아웃 적용 완료!")
			end)
			ForceIringStyle()
		end,
		[3] = function()
			if not _G.PluginInstallFrame then return end
			_G.PluginInstallFrame.SubTitle:SetText("설치 완료")
			_G.PluginInstallFrame.Desc1:SetText("모든 준비가 끝났습니다. 이제 판다리아 클래식을 즐기실 시간입니다.")
			_G.PluginInstallFrame.Option1:Show()
			_G.PluginInstallFrame.Option1:SetText("완료")
			_G.PluginInstallFrame.Option1:SetScript("OnClick", function() InstallComplete() end)
			ForceIringStyle()
		end,
	},
	["StepTitles"] = {
		[1] = "시작",
		[2] = "레이아웃",
		[3] = "완료",
	},
	["StepTitlesColorSelected"] = RAID_CLASS_COLORS[E.myclass],
}

-- 페이지 바뀔 때마다 0.01초 뒤에 스타일 재확인 (결정타)
hooksecurefunc(PI, "SetPage", function()
	E:Delay(0.01, ForceIringStyle)
end)
