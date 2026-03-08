local E, L, V, P, G = unpack(ElvUI)
local addon, Engine = ...

-- 1. IR 메인 객체 생성
local IR = E:NewModule("IringUI", 'AceConsole-3.0', 'AceEvent-3.0', 'AceHook-3.0', 'AceTimer-3.0')
local F = {}

-- 2. 기본 정보 선언 (다른 파일 nil 에러 방지용)
IR.Title = "|cffff69b4Iring|r|cffb2b2b2UI|r"
IR.Media = {
	["Stripes"] = [[Interface\AddOns\ElvUI_IringUI\Media\Textures\mUI1.tga]],
}

-- 3. [보따리 순서 복구] 기존 파일들이 unpack(Engine) 할 때 기대하는 1~7번 순서입니다.
-- IR(1), F(2), E(3), L(4), V(5), P(6), G(7)
Engine[1], Engine[2], Engine[3], Engine[4], Engine[5], Engine[6], Engine[7] = IR, F, E, L, V, P, G
_G[addon] = Engine

-- 공통 스타일 함수
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

-- 4. 초기화 함수 (자동 실행 로직)
function IR:Initialize()
	-- 사용자 설정값 참조
	self.db = E.db.IringUI or P.IringUI
	
	-- [핵심] 등록된 모든 하위 모듈(GameMenu 등)을 자동으로 순회하며 초기화
	-- 이 루프가 있어야 GameMenu.lua의 Initialize가 자동으로 호출됩니다.
	if self.modules then
		for _, module in self:IterateModules() do
			if module.Initialize then
				module:Initialize()
			end
		end
	end

	-- 설치창 호출 로직
	if self.InterceptInstaller then self:InterceptInstaller() end
	
	-- 옵션 등록
	if E.Libs and E.Libs.EP then
		E.Libs.EP:RegisterPlugin(addon, function() IR:OptionsCallback() end)
	end
end

-- ElvUI 모듈 시스템에 최종 등록
E:RegisterModule(IR:GetName())
