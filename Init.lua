local E, L, V, P, G = unpack(ElvUI)
local addon, Engine = ...

local IR = E:NewModule("IringUI", 'AceConsole-3.0', 'AceEvent-3.0', 'AceHook-3.0', 'AceTimer-3.0')
local F = {}

-- 다른 파일에서 에러 안 나게 미리 선언
IR.Title = "|cffff69b4Iring|r|cffb2b2b2UI|r"
IR.Media = {
    ["Stripes"] = [[Interface\AddOns\ElvUI_IringUI\Media\Textures\mUI1.tga]], -- 경로 확인 필수
    ["Overlay"] = [[Interface\AddOns\ElvUI_IringUI\Media\Textures\mUI1.tga]],
}

Engine[1], Engine[2], Engine[3], Engine[4], Engine[5], Engine[6], Engine[7] = IR, F, E, L, V, P, G
_G[addon] = Engine

function IR:Initialize()
    self.db = E.db.IringUI or P.IringUI
    
    -- 설치창 호출
    if self.InterceptInstaller then self:InterceptInstaller() end
    
    -- 하위 모듈들 강제 초기화
    for _, moduleName in ipairs(self.modules) do
        local module = self:GetModule(moduleName)
        if module and module.Initialize then module:Initialize() end
    end
end

E:RegisterModule(IR:GetName())
