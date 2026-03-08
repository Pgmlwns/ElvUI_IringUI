local IR, F, E, L, V, P, G = unpack(select(2, ...))
local PI = E:GetModule('PluginInstaller')

-- ElvUI 기본 설치창 가로채기 함수
function IR:InterceptInstaller()
	-- 이미 설치창이 떠 있다면 숨김
	if _G.ElvUIInstallFrame then _G.ElvUIInstallFrame:Hide() end
	
	-- ElvUI 설정창의 '설치' 버튼을 내 설치창으로 교체
	E.Install = function() 
		PI:Queue(self.installTable)
		E:ToggleOptionsUI() 
	end

	-- 아직 설치되지 않았다면 내 설치창을 큐에 넣음
	if not E.db.IringUI.install_complete then
		E.private.install_complete = E.version
		PI:Queue(self.installTable)
	end
end

-- 설치창의 텍스트를 안전하게 변경하는 유틸리티 함수
local function SetInstallText(subtitle, desc)
	local f = _G.ElvUIInstallFrame
	if f then
		if subtitle then f.SubTitle:SetText(subtitle) end
		if desc then f.Desc1:SetText(desc) end
	end
end

-- 설치 가이드 테이블
IR.installTable = {
	Title = IR.Title .. " 설치",
	Name = "IringUI",
	Pages = {
		[1] = function()
			-- f가 nil인지 체크하여 에러 방지
			if not _G.ElvUIInstallFrame then return end
			
			SetInstallText("환영합니다", "IringUI 레이아웃 설치를 시작합니다.")
			
			_G.ElvUIInstallFrame.Option1:Show()
			_G.ElvUIInstallFrame.Option1:SetText("다음")
			_G.ElvUIInstallFrame.Option1:SetScript("OnClick", function() _G.ElvUIInstallFrame:NextPage() end)
		end,
		[2] = function()
			if not _G.ElvUIInstallFrame then return end
			
			SetInstallText("완료", "설치가 완료되었습니다. UI를 재시작합니다.")
			
			_G.ElvUIInstallFrame.Option1:Show()
			_G.ElvUIInstallFrame.Option1:SetText("마치기")
			_G.ElvUIInstallFrame.Option1:SetScript("OnClick", function()
				E.db.IringUI.install_complete = E.version
				_G.ReloadUI()
			end)
		end,
	},
}