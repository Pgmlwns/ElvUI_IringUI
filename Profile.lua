local E, L, V, P, G = unpack(ElvUI)

-- P는 ElvUI의 '프로필' 기본값을 의미합니다.
-- 여기에 선언해 두어야 E.db.IringUI.layout 이 에러 없이 생성됩니다.
P["IringUI"] = {
    ["layout"] = {
        ["topBar"] = true,
        ["bottomBar"] = true,
    },
    ["skin"] = {  -- Core.lua의 ApplyStyle 함수에서 쓰시는 값도 추가해 줍니다.
        ["stripes"] = true,
    }
}