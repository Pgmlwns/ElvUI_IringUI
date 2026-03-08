local IR, F, E, L, V, P, G = unpack(select(2, ...))

function IR:OptionsCallback()
    E.Options.args.IringUI = {
        type = "group",
        name = IR.Title,
        childGroups = "tab",
        args = {
            general = { order = 1, type = "group", name = "일반", args = { header = { order = 1, type = "header", name = "일반 설정" }}},
            style = {
                order = 2,
                type = "group",
                name = "스타일",
                get = function(info) return E.db.IringUI.skin[info[#info]] end,
                set = function(info, value) E.db.IringUI.skin[info[#info]] = value; E:StaticPopup_Show("CONFIG_RL") end,
                args = {
                    header = { order = 1, type = "header", name = "스타일 설정" },
                    enable = { order = 2, type = "toggle", name = "스킨 활성화" },
                    stripes = { order = 3, type = "toggle", name = "사선 패턴" },
                    shadow = { order = 4, type = "toggle", name = "그림자 효과" },
                },
            },
            layout = { 
                order = 3, 
                type = "group", 
                name = "레이아웃", 
                get = function(info) return E.db.IringUI.layout[info[#info]] end,
                set = function(info, value) E.db.IringUI.layout[info[#info]] = value; IR:UpdateLayout() end,
                args = { 
                    header = { order = 1, type = "header", name = "레이아웃 설정" },
                    topBar = { order = 2, type = "toggle", name = "상단 바 표시" },
                    bottomBar = { order = 3, type = "toggle", name = "하단 바 표시" },
                }
            },
            autobar = { order = 4, type = "group", name = "자동바", args = { header = { order = 1, type = "header", name = "AutoBar 설정" }}},
        },
    }
end
