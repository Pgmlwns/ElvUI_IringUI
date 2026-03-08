local IR, F, E, L, V, P, G = unpack(select(2, ...))

-- IringUI 전용 데이터 저장소 생성
P["IringUI"] = {
	["general"] = {
		["gameMenu"] = true,
	},
	["autobar"] = { -- Options.lua의 nil 에러 방지용
		["enable"] = true,
	},
}
