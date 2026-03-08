local E, L, V, P, G = unpack(ElvUI)
local addon, Engine = ...

local IR = E:NewModule("IringUI", 'AceConsole-3.0', 'AceEvent-3.0', 'AceHook-3.0', 'AceTimer-3.0')
local F = {}
IR.Title = "|cffff69b4Iring|r|cffb2b2b2UI|r"

-- 미디어 경로
IR.Media = {
	["Stripes"] = [[Interface\AddOns\ElvUI_IringUI\Media\Textures\mUI1.tga]],
}

-- 보따리 채우기 및 전역 변수
Engine, Engine, Engine, Engine, Engine, Engine, Engine = IR, F, E, L, V, P, G
_G[addon] = Engine

-- 공통 스타일 함수 (빗살무늬 용)
function IR:ApplyStyle(frame)
	if not frame or frame.IringStripes then return end
	local db = E.db.IringUI
	if not db or not db.skin or not db.skin.stripes then return end

	local stripes = frame:CreateTexture(nil, "OVERLAY", nil, 6)
	stripes:SetInside(frame, 1, -1)
	stripes:SetTexture(IR.Media.Stripes, true, true)
	stripes:SetHorizTile(true) stripes:SetVertTile(true)
	stripes:SetBlendMode("ADD") stripes:SetAlpha(0.35)
	frame.IringStripes = stripes
end

function IR:Initialize()
	self.db = E.db.IringUI or P.IringUI
	if self.InterceptInstaller then self:InterceptInstaller() end
	
	for _, moduleName in ipairs(self.modules) do
		local m = self:GetModule(moduleName)
		if m and m.Initialize then m:Initialize() end
	end
end

E:RegisterModule(IR:GetName())
