local addon, Engine = ...
local IR, F, E, L, V, P, G = unpack(Engine)
local PI = E:GetModule('PluginInstaller')

-- [에러 방지] Title과 Media 경로 안전하게 확보
local IR_Title = IR.Title or "IringUI"
local Stripes = (IR.Media and IR.Media.Stripes) or [[Interface\AddOns\ElvUI_IringUI\Media\Textures\mUI1.tga]]
local Overlay = (IR.Media and IR.Media.Overlay) or [[Interface\AddOns\ElvUI_IringUI\Media\Textures\mUI1.tga]]

local function InstallComplete()
    if E.db.IringUI then
        E.db.IringUI.install_complete = E.version
    end
    _G.ReloadUI()
end

local function ForceIringStyle()
    local f = _G.PluginInstallFrame
    if not f then return end
    local target = f.backdrop or f
    
    -- 방어 로직: 이미 IringShadow가 있다면 두 번 그리지 않음 (아주 잘 짠 부분!)
    if target and not target.IringShadow then
        -- 빗살무늬 텍스처 생성
        local tex = target:CreateTexture(nil, "OVERLAY", nil, 6)
        tex:SetInside(target, 1, -1)
        tex:SetTexture(Stripes, true, true)
        tex:SetHorizTile(true) 
        tex:SetVertTile(true)
        tex:SetBlendMode("ADD") 
        tex:SetAlpha(0.5)
        target.IringStripes = tex

        -- 직업 색상 그림자 생성
        local sha = target:CreateTexture(nil, "OVERLAY", nil, 7)
        sha:SetInside(target, 0, 0)
        sha:SetTexture(Overlay)
        
        -- [수정됨] ElvUI 내장 클래스 색상 시스템 사용
        local classColor = E:ClassColor(E.myclass, true) or RAID_CLASS_COLORS[E.myclass]
        sha:SetVertexColor(classColor.r, classColor.g, classColor.b)
        sha:SetAlpha(0.4)
        target.IringShadow = sha
    end
end

function IR:InterceptInstaller()
    if _G.ElvUIInstallFrame then _G.ElvUIInstallFrame:Hide() end
    
    -- ElvUI 기본 설치창 대신 Iring 설치창을 대기열에 추가
    E.Install = function() 
        PI:Queue(IR.installTable)
        -- 옵션창에서 인스톨 버튼을 눌렀을 때 열려있던 옵션창 닫기
        if E.ToggleOptions then E:ToggleOptions() end 
    end

    -- 설치 기록이 없으면 자동으로 띄움
    if E.db.IringUI and not E.db.IringUI.install_complete then
        E.private.install_complete = E.version
        PI:Queue(IR.installTable)
    end
end

-- 설치창 구성 테이블
IR.installTable = {
    ["Name"] = IR_Title,
    ["Title"] = IR_Title .. " 설치 가이드",
    ["Pages"] = {
        [1] = function()
            _G.PluginInstallFrame.SubTitle:SetText("환영합니다")
            _G.PluginInstallFrame.Desc1:SetText(IR_Title .. "를 이용해 주셔서 감사합니다.")
            _G.PluginInstallFrame.Option1:Show()
            _G.PluginInstallFrame.Option1:SetText("설치 건너뛰기")
            _G.PluginInstallFrame.Option1:SetScript("OnClick", InstallComplete)
            ForceIringStyle()
        end,
        [2] = function()
            _G.PluginInstallFrame.SubTitle:SetText("레이아웃 및 미디어")
            _G.PluginInstallFrame.Desc1:SetText("IringUI의 전용 스타일과 미디어를 적용합니다.")
            _G.PluginInstallFrame.Option1:Show()
            _G.PluginInstallFrame.Option1:SetText("스타일 적용")
            _G.PluginInstallFrame.Option1:SetScript("OnClick", function() 
                if IR.ForceMediaUpdate then IR:ForceMediaUpdate() end 
                -- [수정됨] 버튼 클릭 시 다음 페이지로 부드럽게 넘어가도록 추가
                PI:SetPage(3) 
            end)
            ForceIringStyle()
        end,
        [3] = function()
            _G.PluginInstallFrame.SubTitle:SetText("설치 완료")
            _G.PluginInstallFrame.Desc1:SetText("모든 설정이 완료되었습니다. 리로드 후 사용하세요.")
            _G.PluginInstallFrame.Option1:Show()
            _G.PluginInstallFrame.Option1:SetText("완료")
            _G.PluginInstallFrame.Option1:SetScript("OnClick", InstallComplete)
            ForceIringStyle()
        end,
    },
    ["StepTitles"] = { 
        [1] = "시작", 
        [2] = "레이아웃", 
        [3] = "완료" 
    },
}

-- 페이지 이동 시마다 스타일 강제 적용
hooksecurefunc(PI, "SetPage", function() 
    E:Delay(0.01, ForceIringStyle) 
end)