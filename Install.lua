local IR, F, E, L, V, P, G = unpack(select(2, ...))
local PI = E:GetModule('PluginInstaller')

local function InstallComplete()
	E.db.IringUI.install_complete = E.version
	_G.ReloadUI()
end

-- [완전 고정] ElvUI가 건드리지 못하도록 본체 프레임에 직접 무늬 삽입
local function ForceIringTexture()
	local f = _G.PluginInstallFrame
	if not f then return end

	-- 1. 메인 본체(f)에 직접 무늬 텍스처 생성 (backdrop이 아님!)
	if not f.IringStripes then
		local tex = f:CreateTexture(nil, "BACKGROUND", nil, 1) -- 가장 낮은 레이어
		tex:SetInside(f, 1, -1)
		tex:SetTexture(IR.Media.Stripes, true, true)
		tex:SetHorizTile(true)
		tex:SetVertTile(true)
		tex:SetBlendMode("ADD")
		tex:SetAlpha(0.4) -- 빗살무늬 농도 조절
		f.IringStripes = tex
	end

	-- 2. ElvUI 배경(backdrop)을 아주 어둡게 고정하여 무늬가 잘 보이게 함
	if f.backdrop then
		f.backdrop:SetBackdropColor(0.06, 0.06, 0.06, 0.8) -- 진한 배경색 강제 지정
		f.backdrop:SetAlpha(1) -- 흐려진 화면 복구
	end
    
	-- 3. 제목 표시줄(Title) 처리
	local title = _G.PluginInstallTitleFrame
	if title and not title.IringStripes then
		local tex = title:CreateTexture(nil, "BACKGROUND", nil, 1)
		tex:SetInside(title, 1, -1)
		tex:SetTexture(IR.Media.Stripes, true, true)
		tex:SetHorizTile(true)
		tex:SetVertTile(true)
		tex:SetBlendMode("ADD")
		title.IringStripes = tex
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
			ForceIringTexture() -- 강제 적용
		end,
		[2] = function()
			_G.PluginInstallFrame.SubTitle:SetText("레이아웃")
			_G.PluginInstallFrame.Desc1:SetText("스타일을 적용합니다.")
			_G.PluginInstallFrame.Option1:Show()
			_G.PluginInstallFrame.Option1:SetText("스타일 적용")
			_G.PluginInstallFrame.Option1:SetScript("OnClick", function() IR:ForceMediaUpdate(); IR:UpdateLayout() end)
			ForceIringTexture()
		end,
		[3] = function()
			_G.PluginInstallFrame.SubTitle:SetText("완료")
			_G.PluginInstallFrame.Option1:Show()
			_G.PluginInstallFrame.Option1:SetText("완료")
			_G.PluginInstallFrame.Option1:SetScript("OnClick", function() InstallComplete() end)
			ForceIringTexture()
		end,
	},
	["StepTitles"] = { [1] = "시작", [2] = "레이아웃", [3] = "완료" },
	StepTitlesColorSelected = RAID_CLASS_COLORS[E.myclass],
}

-- 페이지 바뀔 때마다 다시 강제 적용 (연해지는 현상 방어)
hooksecurefunc(PI, "SetPage", function()
	E:Delay(0.01, ForceIringTexture)
end)
