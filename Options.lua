local IR, F, E, L, V, P, G = unpack(select(2, ...))
local ACH = E.Libs.ACH

function IR:OptionsCallback()
	-- 1. 메인 루트 그룹 생성
	E.Options.args.IringUI = ACH:Group(IR.Title or "IringUI", nil, 100)
	IR.Options = E.Options.args.IringUI

	-- 2. [일반 설정] 트리 (기존 스타일, 레이아웃 등)
	IR.Options.args.general = ACH:Group("일반 설정", nil, 1, "tab")
	
	-- 기존 옵션들 (스타일/레이아웃/자동바)
	IR.Options.args.general.args.style = ACH:Group("스타일", nil, 1)
	-- ... (내용 생략) ...

	-- 3. [기타 설정] 트리 (여기에 게임 메뉴 모듈이 들어갈 자리)
	-- 중요: args = {} 를 통해 하위 메뉴가 주입될 공간을 미리 확보합니다.
	IR.Options.args.misc = ACH:Group("기타 설정", nil, 10, "tab")
	IR.Options.args.misc.args = {} 
end
