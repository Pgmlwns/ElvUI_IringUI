local E, L, V, P, G = unpack(ElvUI)
local addon, Engine = ...

local IR = E:NewModule("IringUI", 'AceConsole-3.0', 'AceEvent-3.0', 'AceHook-3.0', 'AceTimer-3.0')
local F = {}

Engine[1], Engine[2], Engine[3], Engine[4], Engine[5], Engine[6], Engine[7] = IR, F, E, L, V, P, G
_G[addon] = Engine

function IR:Initialize()
    -- 하위 모듈들의 Initialize를 강제로 호출하는 로직 (안전장치)
    for _, moduleName in ipairs(self.modules) do
        local module = self:GetModule(moduleName)
        if module and module.Initialize then
            module:Initialize()
        end
    end
    print("|cffff69b4IringUI|r 로드 완료!")
end

E:RegisterModule(IR:GetName())
