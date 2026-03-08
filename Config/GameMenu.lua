local IR, F, E, L, V, P, G = unpack(select(2, ...))

-- [1] 기본값 등록 (Database.lua 등에 합치셔도 됩니다)
P["IringUI"]["general"]["gameMenu"] = true

-- [2] 설정창 옵션 (Config.lua의 general 섹션 하위에 추가)
E.Options.args.IringUI.args.general.args.gameMenu = {
    order = 10,
    type = "toggle",
    name = "게임 메뉴 스타일링",
    desc = "ESC 메뉴 프레임과 버튼에 IringUI 스타일을 적용합니다.",
    get = function(info) return E.db.IringUI.general.gameMenu end,
    set = function(info, value) E.db.IringUI.general.gameMenu = value; E:StaticPopup_Show("PRIVATE_RL") end,
}
