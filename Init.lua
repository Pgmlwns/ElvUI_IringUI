local E, L, V, P, G = unpack(ElvUI)
local addon, Engine = ...

local IR = E:NewModule(addon, 'AceConsole-3.0', 'AceEvent-3.0', 'AceHook-3.0', 'AceTimer-3.0')
local F = {}

-- 프로필 기본값
P["IringUI"] = {
	["install_complete"] = nil,
	["skin"] = { ["enable"] = true, ["stripes"] = true, ["shadow"] = true },
	["layout"] = { ["topBar"] = true, ["topBarHeight"] = 22 },
}

-- [순서 절대 고정] IR, F, E, L, V, P, G
Engine = IR
Engine = F
Engine = E
Engine = L
Engine = V.IringUI
Engine = P.IringUI
Engine = G.IringUI

_G[addon] = Engine
IR.Title = "|cffff69b4Iring|r|cffb2b2b2UI|r"

function IR:Initialize()
	if self.InterceptInstaller then self:InterceptInstaller() end
	if self.ForceMediaUpdate then self:ForceMediaUpdate() end
	E.Libs.EP:RegisterPlugin(addon, self.OptionsCallback)
	print(self.Title .. " 로드 완료!")
end

E:RegisterModule(IR:GetName())
