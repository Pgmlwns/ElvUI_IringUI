local IR, F, E, L, V, P, G = unpack(select(2, ...))

-- [핵심] 모든 테이블 구조를 명확히 선언
P["IringUI"] = {
	["general"] = {
		["gameMenu"] = true,
	},
	["skin"] = {
		["enable"] = true,
		["stripes"] = true,
		["shadow"] = true,
	},
	["layout"] = {
		["topBar"] = true,
		["bottomBar"] = true,
	},
	["autobar"] = {
		["enable"] = true,
	},
}
