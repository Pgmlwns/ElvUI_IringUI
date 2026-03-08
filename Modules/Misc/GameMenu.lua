local IR, F, E, L, V, P, G = unpack(select(2, ...))

-- 게임 메뉴 스타일 적용 메인 함수
local function StyleGameMenu()
    -- 설정에서 게임 메뉴 스타일링이 꺼져있으면 중단
    if not E.db.IringUI.general.gameMenu then return end

    -- 1. 메인 프레임 스타일링 (빗살무늬 및 그림자)
    if GameMenuFrame and not GameMenuFrame.IRstyle then
        -- Styling.lua에서 등록한 IR.Styling 호출
        if IR.Styling then IR.Styling(GameMenuFrame) end
    end

    -- 2. 게임 메뉴 내의 모든 버튼 자동 검색 및 스타일 적용
    for i = 1, GameMenuFrame:GetNumChildren() do
        local child = select(i, GameMenuFrame:GetChildren())
        
        -- 버튼 객체이고 아직 스타일이 입혀지지 않은 경우에만 실행
        if child and child:IsObjectType("Button") and not child.IringBtnStyled then
            
            -- 빗살무늬/그림자 적용 (IR.Styling 활용)
            if IR.Styling then IR.Styling(child) end
            
            -- 선명한 직업 색상 테두리 하이라이트 적용 (IR.StyleButton 활용)
            if IR.StyleButton then 
                IR.StyleButton(child) 
            end
        end
    end
end

-- 게임 메뉴가 보여질 때마다(ESC 키 누를 때) 실행되도록 후킹
local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", function(self)
    if GameMenuFrame then
        -- 게임 메뉴가 열릴 때 StyleGameMenu 함수가 실행되도록 연결
        GameMenuFrame:HookScript("OnShow", StyleGameMenu)
        self:UnregisterEvent("PLAYER_ENTERING_WORLD")
    end
end)
