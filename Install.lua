local IR, F, E, L, V, P, G = unpack(select(2, ...))
local PI = E:GetModule('PluginInstaller')

-- [1] ElvUI 기본 설치창 무조건 무력화 및 IringUI로 대체
function IR:InterceptInstaller()
    -- ElvUI 기본 설치 프레임이 있으면 즉시 숨김
    if _G.ElvUIInstallFrame then
        _G.ElvUIInstallFrame:Hide()
    end

    -- ElvUI 설정창의 '설치' 버튼을 눌렀을 때 실행되는 함수를 교체
    E.Install = function()
        PI:Queue(IR.installTable) -- 내 설치 테이블을 큐에 넣음
        E:ToggleOptionsUI()       -- 설정창 닫기
    end

    -- 아직 설치되지 않았다면 즉시 내 설치창을 큐에 추가
    if not E.db.IringUI.install_complete then
        -- ElvUI가 내부적으로 '설치 완료'라고 착각하게 만들어 기본창이 안 뜨게 함
        E.private.install_complete = E.version
        
        -- 내 설치창 실행
        PI:Queue(IR.installTable)
    end
end

-- [2] ElvUI의 포스트 설치 로직을 재정의 (필요한 경우만)
function E:PostInstall()
    -- ElvUI 기본 로직이 실행되지 않도록 비워두거나 
    -- IringUI에 필요한 최소한의 초기화만 진행
    E:Print(IR.Title .. ": ElvUI 기본 설정을 건너뛰고 IringUI 설정을 준비합니다.")
end


IR.installTable = {
    Title = IR.Title .. " 설치 가이드",
    Name = "IringUI",
    Pages = {
        [1] = function()
            _G.ElvUIInstallFrame.SubTitle:SetText("환영합니다")
            _G.ElvUIInstallFrame.Desc1:SetText("IringUI 레이아웃 설치를 시작합니다.")
            _G.ElvUIInstallFrame.Option1:SetText("다음")
            _G.ElvUIInstallFrame.Option1:SetScript("OnClick", function() _G.ElvUIInstallFrame:NextPage() end)
        end,
        [2] = function()
            _G.ElvUIInstallFrame.SubTitle:SetText("외부 애드온 설정")
            _G.ElvUIInstallFrame.Desc1:SetText("Details, WeakAuras 등의 프로필을 적용합니다.")
            _G.ElvUIInstallFrame.Option1:SetText("프로필 가져오기")
            _G.ElvUIInstallFrame.Option1:SetScript("OnClick", function() 
                -- 여기에 암호화 문자열 복사 로직 추가 가능
                E:Print("외부 설정을 적용했습니다.") 
            end)
        end,
        [3] = function()
            _G.ElvUIInstallFrame.SubTitle:SetText("완료")
            _G.ElvUIInstallFrame.Option1:SetText("마치기")
            _G.ElvUIInstallFrame.Option1:SetScript("OnClick", function()
                E.db.IringUI.install_complete = E.version
                _G.ReloadUI()
            end)
        end,
    },
}
