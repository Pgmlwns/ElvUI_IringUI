local IR, F, E, L, V, P, G = unpack(select(2, ...))
local GM = E:NewModule('IringUI_GameMenu', 'AceHook-3.0')
local ACH = E.Libs.ACH -- ElvUI의 설정창 헬퍼 라이브러리

-- 설정창 주입 (Eltruism 스타일)
function GM:InsertOptions()
    -- IringUI 메인 옵션 테이블이 준비되었는지 확인
    if not IR.Options or not IR.Options.args then return end

    -- ACH 라이브러리를 사용하여 'gamemenu' 그룹 생성
    IR.Options.args.gamemenu = ACH:Group("게임 메뉴", "게임 메뉴(ESC) 커스터마이징", 4, 'tab')
    
    -- 활성화 토글 추가
    IR.Options.args.gamemenu.args.enable = ACH:Toggle(
        "게임 메뉴 스타일 활성화", 
        "ESC 메뉴 프레임과 버튼에 IringUI 스타일을 적용합니다.", 
        1, 
        nil, 
        nil, 
        nil, 
        function() return E.db.IringUI.general.gameMenu end, 
        function(_, value) 
            E.db.IringUI.general.gameMenu = value 
            E:StaticPopup_Show('PRIVATE_RL') 
        end
    )
end

-- 스타일 적용 로직 (기존과 동일)
function GM:StyleGameMenu()
    if not E.db or not E.db.IringUI or not E.db.IringUI.general or not E.db.IringUI.general.gameMenu then return end

    if GameMenuFrame and not GameMenuFrame.IRstyle then
        if IR.Styling then IR.Styling(GameMenuFrame) end
    end

    for i = 1, GameMenuFrame:GetNumChildren() do
        local child = select(i, GameMenuFrame:GetChildren())
        if child and child:IsObjectType("Button") and not child.IringBtnStyled then
            if IR.Styling then IR.Styling(child) end
            if IR.StyleButton then IR.StyleButton(child) end
        end
    end
end

-- 초기화
function GM:Initialize()
    -- Options.lua에서 IR:OptionsCallback이 실행될 때 주입되도록 후킹
    if IR.OptionsCallback then
        hooksecurefunc(IR, "OptionsCallback", function()
            self:InsertOptions()
        end)
    end

    if GameMenuFrame then
        self:SecureHookScript(GameMenuFrame, "OnShow", "StyleGameMenu")
    end
end

E:RegisterModule(GM:GetName())
