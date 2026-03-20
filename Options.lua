local addon, Engine = ...
local IR, F, E, L, V, P, G = unpack(Engine)
local ACH = E.Libs.ACH

local function UpdateRL()
    E:StaticPopup_Show("PRIVATE_RL")
end

function IR:OptionsCallback()
    -- 1. 메인 루트 생성
    E.Options.args.IringUI = ACH:Group(IR.Title or "IringUI", nil, 100)
    local main = E.Options.args.IringUI.args

    -- 2. [일반 설정] 탭 (기존 스타일 및 레이아웃 설정)
    main.general = ACH:Group("일반 설정", nil, 1, "tab")
    local general = main.general.args

    -- [스타일 설정]
    general.style = ACH:Group("스타일", nil, 1)
    general.style.args.enable = ACH:Toggle("스킨 활성화", nil, 1, nil, nil, nil, function() return E.db.IringUI.skin.enable end, function(_, v) E.db.IringUI.skin.enable = v; UpdateRL() end)
    general.style.args.stripes = ACH:Toggle("빗살무늬", nil, 2, nil, nil, nil, function() return E.db.IringUI.skin.stripes end, function(_, v) E.db.IringUI.skin.stripes = v; UpdateRL() end)
    general.style.args.shadow = ACH:Toggle("그림자 효과", nil, 3, nil, nil, nil, function() return E.db.IringUI.skin.shadow end, function(_, v) E.db.IringUI.skin.shadow = v; UpdateRL() end)

    -- [레이아웃 설정]
    general.layout = ACH:Group("레이아웃", nil, 2)
    general.layout.args.topBar = ACH:Toggle("상단 바 표시", nil, 1, nil, nil, nil, function() return E.db.IringUI.layout.topBar end, function(_, v) E.db.IringUI.layout.topBar = v; UpdateRL() end)

    -- [자동바 설정] (방어 코드 제거)
    general.autobar = ACH:Group("자동바", nil, 3)
    general.autobar.args.enable = ACH:Toggle("자동바 스킨", nil, 1, nil, nil, nil, function() return E.db.IringUI.autobar.enable end, function(_, v) E.db.IringUI.autobar.enable = v; UpdateRL() end)

    -- 3. [기타 설정] 탭 (게임 메뉴 및 유틸리티 버튼)
    main.misc = ACH:Group("기타 설정", nil, 2, "tab")
    local misc = main.misc.args

    -- [게임 메뉴] 설정
    misc.gamemenu = ACH:Group("게임 메뉴", nil, 1)
    misc.gamemenu.args.enable = ACH:Toggle("게임 메뉴 스타일 활성화", "ESC 메뉴에 IringUI 스타일을 적용합니다.", 1, nil, nil, nil,
        function() return E.db.IringUI.misc.gameMenu end,
        function(_, v) E.db.IringUI.misc.gameMenu = v; UpdateRL() end)

    -- [유틸리티] 버튼들
    misc.util = ACH:Group("유틸리티", nil, 10, "inline")
    misc.util.args.install = ACH:Execute("설치 가이드 열기", "IringUI 설치 창을 다시 엽니다.", 1, function() if IR.InterceptInstaller then IR:InterceptInstaller() end; E:ToggleOptionsUI() end)
    misc.util.args.media = ACH:Execute("미디어 업데이트", "IringUI 전용 미디어 설정을 강제로 다시 적용합니다.", 2, function() if IR.ForceMediaUpdate then IR:ForceMediaUpdate() end; UpdateRL() end)
    
    -- [수정됨] Layout 모듈을 정상적으로 불러와서 업데이트 실행
    misc.util.args.layout = ACH:Execute("레이아웃 업데이트", "IringUI 전용 레이아웃을 다시 적용합니다.", 3, function() 
        local LayoutModule = IR:GetModule("Layout")
        if LayoutModule and LayoutModule.UpdateLayout then 
            LayoutModule:UpdateLayout() 
        end
        UpdateRL() 
    end)
end