local IR, F, E, L, V, P, G = unpack(select(2, ...))
local GM = E:NewModule('IringUI_GameMenu', 'AceHook-3.0')

-- 게임 메뉴 스타일 적용 함수
function GM:StyleGameMenu()
    -- 설정 체크 (안전장치 강화)
    if not E.db or not E.db.IringUI or not E.db.IringUI.general or not E.db.IringUI.general.gameMenu then 
        return 
    end

    -- 1. 메인 프레임 스타일링 (Styling.lua의 IR.Styling 활용)
    if GameMenuFrame and not GameMenuFrame.IRstyle then
        if IR.Styling then IR.Styling(GameMenuFrame) end
    end

    -- 2. 게임 메뉴 내의 모든 버튼 자동 검색 및 스타일 적용
    for i = 1, GameMenuFrame:GetNumChildren() do
        local child = select(i, GameMenuFrame:GetChildren())
        if child and child:IsObjectType("Button") and not child.IringBtnStyled then
            -- 빗살무늬 및 그림자 적용
            if IR.Styling then IR.Styling(child) end
            -- 선명한 직업 색상 테두리 적용
            if IR.StyleButton then IR.StyleButton(child) end
        end
    end
end

-- 모듈 초기화 (엘브 코어 호출)
function GM:Initialize()
    if GameMenuFrame then
        -- 게임 메뉴가 열릴 때 스타일 적용하도록 안전하게 후킹
        self:SecureHookScript(GameMenuFrame, "OnShow", "StyleGameMenu")
    end
end

-- 모듈 등록
E:RegisterModule(GM:GetName())
