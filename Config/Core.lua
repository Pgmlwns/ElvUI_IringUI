local IR, F, E, L, V, P, G = unpack(select(2, ...))

-- 1. IringUI 데이터베이스 구조 강제 생성 (nil 방지)
P["IringUI"] = P["IringUI"] or {}

-- 2. 각 섹션별 테이블 생성
P["IringUI"]["skin"] = P["IringUI"]["skin"] or { ["enable"] = true, ["stripes"] = true, ["shadow"] = true }
P["IringUI"]["layout"] = P["IringUI"]["layout"] or { ["topBar"] = true, ["bottomBar"] = true }
P["IringUI"]["autobar"] = P["IringUI"]["autobar"] or { ["enable"] = true } -- [해결 포인트]
P["IringUI"]["general"] = P["IringUI"]["general"] or { ["gameMenu"] = true }
