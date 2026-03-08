local E, L, V, P, G = unpack(ElvUI)
local addon, Engine = ...

-- 1. IR 메인 객체 생성
local IR = E:NewModule("IringUI", 'AceConsole-3.0', 'AceEvent-3.0', 'AceHook-3.0', 'AceTimer-3.0')
local F = {}

-- 2. 보따리 채우기 (기존 모듈 호환성 100% 유지)
Engine[1] = IR
Engine[2] = F
Engine[3] = E
Engine[4] = L
Engine[5] = V
Engine[6] = P
Engine[7] = G

_G[addon] = Engine
IR.Title = "|cffff69b4Iring|r|cffb2b2b2UI|r"

-- 3. 초기화 로직
function IR:Initialize()
    -- 실제 사용자 데이터 참조
    self.db = E.db.IringUI or P.IringUI 

    if self.InterceptInstaller then self:InterceptInstaller() end
    if self.ForceMediaUpdate then self:ForceMediaUpdate() end
    
    -- 옵션 등록
    if self.OptionsCallback then
        E.Libs.EP:RegisterPlugin(addon, self.OptionsCallback)
    end
    
    print(self.Title .. " 로드 완료!")
end

E:RegisterModule(IR:GetName())
