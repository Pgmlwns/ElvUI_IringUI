local E, L, V, P, G = unpack(ElvUI)
local addon, Engine = ...

local IR = E:NewModule("IringUI", 'AceConsole-3.0', 'AceEvent-3.0', 'AceHook-3.0', 'AceTimer-3.0')
local F = {}

IR.Title = "|cffff69b4Iring|r|cffb2b2b2UI|r"

-- P["IringUI"]를 빈 테이블로 선언하여 모듈들이 값을 채울 수 있게 준비만 합니다.
P["IringUI"] = {}

Engine[1], Engine[2], Engine[3], Engine[4], Engine[5], Engine[6], Engine[7] = IR, F, E, L, V, P, G
_G[addon] = Engine

function IR:Initialize()
    self.db = E.db.IringUI or P.IringUI
    
    if self.InterceptInstaller then self:InterceptInstaller() end
    
    for _, moduleName in ipairs(self.modules) do
        local module = self:GetModule(moduleName)
        if module and module.Initialize then module:Initialize() end
    end
end

E:RegisterModule(IR:GetName())
