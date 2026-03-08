local IR, F, E, L, V, P, G = unpack(select(2, ...))

-- 1. 데이터베이스 초기화 (상위 테이블부터 차례대로 생성하여 nil 에러 방지)
P["IringUI"] = P["IringUI"] or {}
P["IringUI"]["general"] = P["IringUI"]["general"] or {}

-- 2. 게임 메뉴 스타일 활성화 기본값 설정
if P["IringUI"]["general"]["gameMenu"] == nil then
    P["IringUI"]["general"]["gameMenu"] = true
end

-- 3. 설정창 옵션 주입 함수
local function UpdateOptions()
    -- IringUI -> general 섹션이 존재하는지 확인 후 옵션 추가
    if E.Options and E.Options.args.IringUI and E.Options.args.IringUI.args.general then
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
end

-- 설정창이 로드될 때 실행되도록 등록
E:RegisterModule("IringUI_GameMenuConfig", UpdateOptions)
