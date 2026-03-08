local addon, Engine = ...
local IR, F, E, L, V, P, G = unpack(Engine)

-- IringUI 전체 기본값 정의
P["IringUI"] = {
    ["install_complete"] = nil,
    
    -- [일반/스킨 설정]
    ["skin"] = { 
        ["enable"] = true, 
        ["stripes"] = true, 
        ["shadow"] = true 
    },
    
    -- [레이아웃 설정]
    ["layout"] = { 
        ["topBar"] = true, 
        ["topBarHeight"] = 22 
    },
    
    -- [기타/모듈 설정] 모듈을 추가할 때 여기만 한 줄 추가하세요.
    ["misc"] = {
        ["gameMenu"] = true, -- ESC 게임 메뉴 스타일 활성화 기본값
    },
}
