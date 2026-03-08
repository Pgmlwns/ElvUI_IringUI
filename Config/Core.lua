local E, L, V, P, G = unpack(select(2, ...))
local IR = E:GetModule('IringUI') -- IR 객체는 여기서 가져옵니다.

-- [핵심] 기존 설정을 보존하며 모든 테이블 구조를 강제 생성
P["IringUI"] = P["IringUI"] or {}
P["IringUI"]["skin"] = P["IringUI"]["skin"] or { ["enable"] = true, ["stripes"] = true, ["shadow"] = true }
P["IringUI"]["layout"] = P["IringUI"]["layout"] or { ["topBar"] = true, ["bottomBar"] = true }
P["IringUI"]["autobar"] = P["IringUI"]["autobar"] or { ["enable"] = true }
P["IringUI"]["general"] = P["IringUI"]["general"] or { ["gameMenu"] = true }
