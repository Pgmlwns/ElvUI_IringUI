local addon, Engine = ...
local IR, F, E, L, V, P, G = unpack(Engine)
local ACH = E.Libs.ACH

function IR:OptionsCallback()
    E.Options.args.IringUI = ACH:Group(IR.Title or "IringUI", nil, 100)
    local main = E.Options.args.IringUI.args

    -- 기타 설정 탭 자동 생성
    if not main.misc then
        main.misc = ACH:Group("기타 설정", nil, 5, "tab")
    end
    local misc = main.misc.args

    -- 게임 메뉴 옵션 추가
    misc.gamemenu = ACH:Group("게임 메뉴", nil, 1)
    misc.gamemenu.args.enable = ACH:Toggle("게임 메뉴 스타일 활성화", nil, 1, nil, nil, nil,
        function() return E.db.IringUI.misc and E.db.IringUI.misc.gameMenu end,
        function(_, v) 
            if not E.db.IringUI.misc then E.db.IringUI.misc = {} end
            E.db.IringUI.misc.gameMenu = v
            E:StaticPopup_Show("PRIVATE_RL") 
        end
    )
end
