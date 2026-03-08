local IR, F, E, L, V, P, G = unpack(select(2, ...))

-- [표준 방식] P["IringUI"] 저장소를 안전하게 생성
P["IringUI"] = P["IringUI"] or {}
P["IringUI"]["skin"] = P["IringUI"]["skin"] or { ["enable"] = true, ["stripes"] = true, ["shadow"] = true }
P["IringUI"]["layout"] = P["IringUI"]["layout"] or { ["topBar"] = true, ["bottomBar"] = true }
P["IringUI"]["autobar"] = P["IringUI"]["autobar"] or { ["enable"] = true }
P["IringUI"]["general"] = P["IringUI"]["general"] or { ["gameMenu"] = true }
