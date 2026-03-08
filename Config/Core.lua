local IR, F, E, L, V, P, G = unpack(select(2, ...))

-- [수정] 게임 메뉴 설정을 misc(기타) 키값으로 저장
P["IringUI"] = P["IringUI"] or {}
P["IringUI"]["skin"] = P["IringUI"]["skin"] or { ["enable"] = true, ["stripes"] = true, ["shadow"] = true }
P["IringUI"]["layout"] = P["IringUI"]["layout"] or { ["topBar"] = true, ["bottomBar"] = true }
P["IringUI"]["autobar"] = P["IringUI"]["autobar"] or { ["enable"] = true }
P["IringUI"]["misc"] = P["IringUI"]["misc"] or { ["gameMenu"] = true } -- general 대신 misc 사용
