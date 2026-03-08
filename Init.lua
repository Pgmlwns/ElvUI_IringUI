local E, L, V, P, G = unpack(ElvUI)
local addon, Engine = ...

-- IR: 메인모듈, F: 공통함수
local IR = E:NewModule(addon, 'AceConsole-3.0', 'AceEvent-3.0', 'AceHook-3.0', 'AceTimer-3.0')
local F = {}

-- 전역 DB 초기화 (P: 프로필 설정값)
P["IringUI"] = {
    ["install_complete"] = nil,
    ["skin"] = {
        ["enable"] = true,
        ["stripes"] = true,
        ["shadow"] = true,
    },
    ["layout"] = {
        ["chatEnable"] = true,
        ["topBar"] = false,
        ["bottomBar"] = false,
    },
    ["autobar"] = {
        ["enable"] = false,
    },
}

-- 보따리 구성 (IR, F, E, L, V, P, G 순서)
Engine[1] = IR
Engine[2] = F
Engine[3] = E
Engine[4] = L
Engine[5] = V.IringUI
Engine[6] = P.IringUI
Engine[7] = G.IringUI

_G[addon] = Engine
IR.Title = "|cffff69b4Iring|r|cffb2b2b2UI|r"

-- 메인 초기화 함수
function IR:Initialize()
    -- 1. ElvUI 기본 설치창 가로채기 (가장 먼저 실행)
    self:InterceptInstaller()

    -- 2. 미디어 설정 적용
    if IR.ForceMediaUpdate then IR:ForceMediaUpdate() end

    -- 3. 설정창 플러그인 등록
    local EP = E.Libs.EP
    EP:RegisterPlugin(addon, IR.OptionsCallback)

    print(IR.Title .. " 로드 완료!")
end


E:RegisterModule(IR:GetName())
