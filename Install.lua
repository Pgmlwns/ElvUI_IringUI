local IR, F, E, L, V, P, G = unpack(select(2, ...))
local PI = E:GetModule('PluginInstaller')

-- 설치 완료 함수
local function InstallComplete()
	E.db.IringUI.install_complete = E.version
	_G.ReloadUI()
end

-- [수정] 빗살무늬와 그림자(Shadow)를 동시에 강제 생성하는 함수
local function ForceIringStyle()
	local f = _G.PluginInstallFrame
	if not f then return end

	local target = f.backdrop or f
	if target then
		-- 1. 빗살무늬 (Stripes) 생성 및 유지
		if not target.IringStripes then
			local tex = target:CreateTexture(nil, "OVERLAY", nil, 6) -- 그림자보다 아래 레이어
			tex:SetInside(target, 1, -1)
			tex:SetTexture(IR.Media.Stripes, true, true)
			tex:SetHorizTile(true)
			tex:SetVertTile(true)
			tex:SetBlendMode("ADD")
			tex:SetAlpha(0.5)
			target.IringStripes = tex
		end

		-- 2. [추가] 그림자 (Shadow) 생성 - 서브창과 느낌 맞추기
		if not target.IringShadow then
			local sha = target:CreateTexture(nil, "OVERLAY", nil, 7) -- 빗살무늬보다 위 레이어
			sha:SetInside(target, 0, 0)
			sha:SetTexture(IR.Media.Overlay) -- Styling.lua에서 사용하는 그림자 텍스처
			
			-- 직업 색상 적용 (Styling.lua 로직과 통일)
			local color = RAID_CLASS_COLORS[E.myclass]
			sha:SetVertexColor(color.r, color.g, color.b)
			sha:SetAlpha(0.6) -- 서브창과 동일한 농도
			
			target.IringShadow = sha
		end
	end

	-- 제목 줄(Title)에도 동일하게 그림자 적용
	local title = _G.PluginInstallTitleFrame
	if title and title.backdrop then
		if not title.backdrop.IringShadow then
			local sha = title.backdrop:CreateTexture(nil, "OVERLAY", nil, 7)
			sha:SetInside(title.backdrop, 0, 0)
			sha:SetTexture(IR.Media.Overlay)
			local color = RAID_CLASS_COLORS[E.myclass]
			sha:SetVertexColor(color.r, color.g, color.b)
			sha:SetAlpha(0.6)
			title.backdrop.IringShadow = sha
		end
	end
end

-- [이하 InterceptInstaller, installTable, SetPage 후킹 로직은 기존과 동일]
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
		[1] = function()
			if not _G.PluginInstallFrame then return end
			_G.PluginInstallFrame.SubTitle:SetFormattedText("환영합니다! |cffff69b4Iring|r|cffb2b2b2UI|r 버전 %s", "1.0.0")
			_G.PluginInstallFrame.Desc1:SetText("이 가이드는 IringUI의 핵심 스타일과 레이아웃을 캐릭터에 적용합니다.")
			_G.PluginInstallFrame.Option1:Show()
			_G.PluginInstallFrame.Option1:SetText("설치 건너뛰기")
			_G.PluginInstallFrame.Option1:SetScript("OnClick", function() InstallComplete() end)
			ForceIringStyle()
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

hooksecurefunc(PI, "SetPage", function()
	E:Delay(0.01, ForceIringStyle)
end)
