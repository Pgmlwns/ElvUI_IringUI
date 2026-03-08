local IR, F, E, L, V, P, G = unpack(select(2, ...))

-- IringUI 기본 프로필 설정
P["IringUI"] = P["IringUI"] or {}

-- [스킨 설정]
P["IringUI"]["skin"] = {
	["enable"] = true,
	["stripes"] = true,
	["shadow"] = true,
}

-- [레이아웃 설정]
P["IringUI"]["layout"] = {
	["topBar"] = true,
	["bottomBar"] = true,
}

-- [자동바 설정]
P["IringUI"]["autobar"] = {
	["enable"] = true,
}

-- [기타 설정] 게임 메뉴 기본값 활성화(true)
P["IringUI"]["misc"] = {
	["gameMenu"] = true,
}
