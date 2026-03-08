local addon, Engine = ...
local IR, F, E, L, V, P, G = unpack(Engine)
local PI = E:GetModule('PluginInstaller')

-- [에러 방지] IR.Title이 nil일 경우를 대비해 기본값 설정
local IR_Title = IR.Title or "IringUI"

local function InstallComplete()
	E.db.IringUI.install_complete = E.version
	_G.ReloadUI()
end

local function ForceIringStyle()
	local f = _G.PluginInstallFrame
	if not f then return end
	local target = f.backdrop or f
	if target and not target.IringShadow then
		local tex = target:CreateTexture(nil, "OVERLAY", nil, 6)
		tex:SetInside(target, 1, -1)
		-- IR.Media가 로드 전일 수 있으므로 체크 후 할당
		if IR.Media and IR.Media.Stripes then
			tex:SetTexture(IR.Media.Stripes, true, true)
			tex:SetHorizTile(true) tex:SetVertTile(true)
			tex:SetBlendMode("ADD") tex:SetAlpha(0.5)
			target.IringStripes = tex
		end

		local sha = target:CreateTexture(nil, "OVERLAY", nil, 7)
		sha:SetInside(target, 0, 0)
		if IR.Media and IR.Media.Overlay then
			sha:SetTexture(IR.Media.Overlay)
			local color = RAID_CLASS_COLORS[E.myclass]
			sha:SetVertexColor(color.r, color.g, color.b)
			sha:SetAlpha(0.4)
			target.IringShadow = sha
		end
	end
end

function IR:InterceptInstaller()
	if _G.ElvUIInstallFrame then _G.ElvUIInstallFrame:Hide() end
	E.Install = function() PI:Queue(self.installTable); E:ToggleOptionsUI() end
	if not E.db.IringUI.install_complete then
		E.private.install_complete = E.version
		PI:Queue(self.installTable)
	end
end

-- [수정 포인트] IR.Title 대신 안전하게 정의된 IR_Title 변수 사용
IR.installTable = {
	["Name"] = IR_Title,
	["Title"] = IR_Title .. " 설치 가이드",
	["Pages"] = {
		[1] = function()
			_G.PluginInstallFrame.SubTitle:SetText("환영합니다")
			_G.PluginInstallFrame.Option1:Show()
			_G.PluginInstallFrame.Option1:SetText("설치 건너뛰기")
			_G.PluginInstallFrame.Option1:SetScript("OnClick", InstallComplete)
			ForceIringStyle()
		end,
		[2] = function()
			_G.PluginInstallFrame.SubTitle:SetText("레이아웃")
			_G.PluginInstallFrame.Option1:Show()
			_G.PluginInstallFrame.Option1:SetText("스타일 적용")
			_G.PluginInstallFrame.Option1:SetScript("OnClick", function() IR:ForceMediaUpdate() end)
			ForceIringStyle()
		end,
		[3] = function()
			_G.PluginInstallFrame.SubTitle:SetText("완료")
			_G.PluginInstallFrame.Option1:Show()
			_G.PluginInstallFrame.Option1:SetText("완료")
			_G.PluginInstallFrame.Option1:SetScript("OnClick", InstallComplete)
			ForceIringStyle()
		end,
	},
	["StepTitles"] = { [1] = "시작", [2] = "레이아웃", [3] = "완료" },
}

hooksecurefunc(PI, "SetPage", function() E:Delay(0.01, ForceIringStyle) end)
