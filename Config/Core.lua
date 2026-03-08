local IR, F, E, L, V, P, G = unpack(select(2, ...))

-- [핵심] 기존 설정을 보존하며 누락된 테이블만 생성 (P가 nil이면 Init.lua 로드 순서 문제)
P["IringUI"] = P["IringUI"] or {}
P["IringUI"]["skin"] = P["IringUI"]["skin"] or { ["enable"] = true, ["stripes"] = true, ["shadow"] = true }
P["IringUI"]["layout"] = P["IringUI"]["layout"] or { ["topBar"] = true, ["bottomBar"] = true }
P["IringUI"]["autobar"] = P["IringUI"]["autobar"] or { ["enable"] = true }
P["IringUI"]["general"] = P["IringUI"]["general"] or { ["gameMenu"] = true }
