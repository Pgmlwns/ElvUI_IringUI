local E, L, V, P, G = unpack(ElvUI)
local addon, Engine = ... -- addon은 "ElvUI_IringUI"가 됩니다.

local IR = E:NewModule("IringUI", 'AceConsole-3.0', 'AceEvent-3.0', 'AceHook-3.0', 'AceTimer-3.0')
local F = {}

IR.Title = "|cffff69b4Iring|r|cffb2b2b2UI|r"
P["IringUI"] = {} -- 그릇 준비

Engine[1], Engine[2], Engine[3], Engine[4], Engine[5], Engine[6], Engine[7] = IR, F, E, L, V, P, G
_G[addon] = Engine

function IR:Initialize()
    self.db = E.db.IringUI or P.IringUI
    
    -- [중요] 엘브 설정창(Options)에 플러그인 등록
    -- 이 코드가 있어야 왼쪽 사이드바에 메뉴가 나타납니다.
    if E.Libs and E.Libs.EP then
        E.Libs.EP:RegisterPlugin(addon, function() IR:OptionsCallback() end)
    end

    if self.InterceptInstaller then self:InterceptInstaller() end
    
    -- 하위 모듈 초기화
    for _, moduleName in ipairs(self.modules) do
        local module = self:GetModule(moduleName)
        if module and module.Initialize then module:Initialize() end
    end
end

E:RegisterModule(IR:GetName())
