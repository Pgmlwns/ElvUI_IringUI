local IR, F, E, L, V, P, G = unpack(select(2, ...))

-- 1. 데이터베이스 초기화
P["IringUI"] = P["IringUI"] or {}
P["IringUI"]["general"] = P["IringUI"]["general"] or {}
if P["IringUI"]["general"]["gameMenu"] == nil then
    P["IringUI"]["general"]["gameMenu"] = true
end

-- 2. 설정창 옵션 강제 주입
local function UpdateOptions()
    -- IringUI 메인 메뉴가 없으면 생성
    E.Options.args.IringUI = E.Options.args.IringUI or {
        type = "group",
        name = "IringUI",
        args = {
            general = {
                type = "group",
                name = "일반",
                args = {},
            },
        },
    }

    -- 게임 메뉴 옵션 주입
    E.Options.args.IringUI.args.general.args.gameMenu = {
        order = 10,
        type = "toggle",
        name = "게임 메뉴 스타일링",
        desc = "ESC 메뉴(게임 메뉴) 프레임과 버튼에 IringUI 스타일을 적용합니다.",
        get = function(info) return E.db.IringUI.general.gameMenu end,
        set = function(info, value) 
            E.db.IringUI.general.gameMenu = value
            E:StaticPopup_Show("PRIVATE_RL") 
        end,
    }
end

-- 엘브 설정창이 호출될 때 실행되도록 등록
E:RegisterModule("IringUI_GameMenuConfig", UpdateOptions)
