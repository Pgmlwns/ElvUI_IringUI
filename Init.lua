local E, L, V, P, G = unpack(ElvUI)
local addon, Engine = ...

-- 1. IR 메인 객체 생성
local IR = E:NewModule("IringUI", 'AceConsole-3.0', 'AceEvent-3.0', 'AceHook-3.0', 'AceTimer-3.0')
local F = {}

-- 2. 다른 파일에서 참조할 기본 정보 선언
IR.Title = "|cffff69b4Iring|r|cffb2b2b2UI|r"
IR.Media = {
	["Stripes"] = [[Interface\AddOns\ElvUI_IringUI\Media\Textures\mUI1.tga]],
}

-- 3. 보따리 채우기 (순서 고정: IR, F, E, L, V, P, G)
Engine[1], Engine[2], Engine[3], Engine[4], Engine[5], Engine[6], Engine[7] = IR, F, E, L, V, P, G
_G[addon] = Engine

-- 4. 공통 스타일 함수 (빗살무늬 용)
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
	
	-- 모든 하위 모듈(GameMenu 등) 자동 실행
	for _, moduleName in ipairs(self.modules) do
		local m = self:GetModule(moduleName)
		if m and m.Initialize then m:Initialize() end
	end
end

E:RegisterModule(IR:GetName())
