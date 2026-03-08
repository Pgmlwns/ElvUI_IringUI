local E, L, V, P, G = unpack(ElvUI)
local addon, Engine = ...

-- 1. 객체 생성 및 기본 정보
local IR = E:NewModule("IringUI", 'AceConsole-3.0', 'AceEvent-3.0', 'AceHook-3.0', 'AceTimer-3.0')
local F = {}
IR.Title = "|cffff69b4Iring|r|cffb2b2b2UI|r"

-- [미디어 선언] 전역에서 참조 가능하도록 보따리 채우기 전에 확정
IR.Media = {
	["Stripes"] = [[Interface\AddOns\ElvUI_IringUI\Media\Textures\mUI1.tga]],
	["Overlay"] = [[Interface\AddOns\ElvUI_IringUI\Media\Textures\mUI1.tga]],
}

-- 2. 보따리 채우기 및 전역 변수 등록
Engine[1], Engine[2], Engine[3], Engine[4], Engine[5], Engine[6], Engine[7] = IR, F, E, L, V, P, G
_G[addon] = Engine

-- 3. 공통 스타일 함수 (각 모듈에서 호출하여 빗살무늬 적용)
function IR:ApplyStyle(frame)
	if not frame or frame.IringStripes then return end
	-- DB가 준비되지 않았을 경우를 대비해 안전하게 참조
	local db = E.db.IringUI
	if not db or not db.skin or not db.skin.stripes then return end

	local stripes = frame:CreateTexture(nil, "OVERLAY", nil, 6)
	stripes:SetInside(frame, 1, -1)
	stripes:SetTexture(IR.Media.Stripes, true, true)
	stripes:SetHorizTile(true)
	stripes:SetVertTile(true)
	stripes:SetBlendMode("ADD")
	stripes:SetAlpha(0.35)
	frame.IringStripes = stripes
end

function IR:Initialize()
	self.db = E.db.IringUI or P.IringUI
	if self.InterceptInstaller then self:InterceptInstaller() end
	
	-- 모든 하위 모듈 깨우기
	for _, moduleName in ipairs(self.modules) do
		local m = self:GetModule(moduleName)
		if m and m.Initialize then m:Initialize() end
	end
end

E:RegisterModule(IR:GetName())
