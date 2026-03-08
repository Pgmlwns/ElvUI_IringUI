local E, L, V, P, G = unpack(ElvUI)
local addon, Engine = ...

local IR = E:NewModule("IringUI", 'AceConsole-3.0', 'AceEvent-3.0', 'AceHook-3.0', 'AceTimer-3.0')
local F = {}

-- DB 초기화
P["IringUI"] = {
	["install_complete"] = nil,
	["skin"] = { ["enable"] = true, ["stripes"] = true, ["shadow"] = true },
	["layout"] = { ["topBar"] = true, ["topBarHeight"] = 22 },
}

-- [에러 해결의 핵심] 번호 순서대로 보따리 채우기
Engine[1] = IR
Engine[2] = F
Engine[3] = E
Engine[4] = L
Engine[5] = V.IringUI
Engine[6] = P.IringUI
Engine[7] = G.IringUI

_G[addon] = Engine
IR.Title = "|cffff69b4Iring|r|cffb2b2b2UI|r"

function IR:Initialize()
	if self.InterceptInstaller then self:InterceptInstaller() end
	if self.ForceMediaUpdate then self:ForceMediaUpdate() end
	E.Libs.EP:RegisterPlugin(addon, self.OptionsCallback)
	print(self.Title .. " 로드 완료!")
end

E:RegisterModule(IR:GetName())
