local E, L, V, P, G = unpack(ElvUI)
local addon, Engine = ...

-- IR: 메인모듈, F: 공통함수 저장소
local IR = E:NewModule(addon, 'AceConsole-3.0', 'AceEvent-3.0', 'AceHook-3.0', 'AceTimer-3.0')
local F = {}

-- 프로필 기본값 설정 (P.IringUI)
P["IringUI"] = {
	["install_complete"] = nil,
	["skin"] = {
		["enable"] = true,
		["stripes"] = true,
		["shadow"] = true,
	},
	["layout"] = {
		["topBar"] = true, -- 상단 바 기본 활성화
		["topBarHeight"] = 22,
	},
}

-- 보따리 구성 및 전역 등록
Engine = IR
Engine = F
Engine = E
Engine = L
Engine = V.IringUI
Engine = P.IringUI
Engine = G.IringUI

_G[addon] = Engine
IR.Title = "|cffff69b4Iring|r|cffb2b2b2UI|r"

-- 메인 초기화
function IR:Initialize()
	-- 1. ElvUI 기본 설치창 가로채기
	if self.InterceptInstaller then self:InterceptInstaller() end

	-- 2. 미디어 설정 강제 적용
	if self.ForceMediaUpdate then self:ForceMediaUpdate() end

	-- 3. ElvUI 설정창에 플러그인 등록
	local EP = E.Libs.EP
	EP:RegisterPlugin(addon, self.OptionsCallback)

	print(self.Title .. " 로드 완료! 판다리아 클래식을 환영합니다.")
end

E:RegisterModule(IR:GetName())
