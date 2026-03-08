local IR, F, E, L, V, P, G = unpack(select(2, ...))
local PI = E:GetModule('PluginInstaller')

-- ElvUI 기본 설치창 가로채기 함수
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
	Title = IR.Title .. " 설치",
	Name = "IringUI",
	Pages = {
		= function()
			_G.ElvUIInstallFrame.SubTitle:SetText("환영합니다")
			_G.ElvUIInstallFrame.Desc1:SetText("IringUI 레이아웃 설치를 시작합니다.")
			_G.ElvUIInstallFrame.Option1:SetText("다음")
			_G.ElvUIInstallFrame.Option1:SetScript("OnClick", function() _G.ElvUIInstallFrame:NextPage() end)
		end,
		= function()
			_G.ElvUIInstallFrame.SubTitle:SetText("완료")
			_G.ElvUIInstallFrame.Desc1:SetText("설치가 완료되었습니다.")
			_G.ElvUIInstallFrame.Option1:SetText("마치기")
			_G.ElvUIInstallFrame.Option1:SetScript("OnClick", function()
				E.db.IringUI.install_complete = E.version
				_G.ReloadUI()
			end)
		end,
	},
}
