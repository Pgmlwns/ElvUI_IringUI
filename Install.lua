local addon, Engine = ...
local IR, F, E, L, V, P, G = unpack(Engine)
local PI = E:GetModule('PluginInstaller')

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
		tex:SetTexture(IR.Media.Stripes, true, true)
		tex:SetHorizTile(true) tex:SetVertTile(true)
		tex:SetBlendMode("ADD") tex:SetAlpha(0.5)
		target.IringStripes = tex

		local sha = target:CreateTexture(nil, "OVERLAY", nil, 7)
		sha:SetInside(target, 0, 0)
		sha:SetTexture(IR.Media.Overlay)
		local color = RAID_CLASS_COLORS[E.myclass]
		sha:SetVertexColor(color.r, color.g, color.b)
		sha:SetAlpha(0.4)
		target.IringShadow = sha
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

IR.installTable = {
	["Name"] = IR.Title,
	["Title"] = IR.Title .. " 설치 가이드",
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
