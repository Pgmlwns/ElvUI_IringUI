local IR, F, E, L, V, P, G = unpack(select(2, ...))
local ACH = E.Libs.ACH -- ElvUI 설정 헬퍼 라이브러리 사용

-- 설정창 내에서 사용할 공용 함수 (새로고침 팝업)
local function UpdateRL()
	E:StaticPopup_Show("PRIVATE_RL")
end

-- ElvUI 설정창 내에 IringUI 메뉴를 생성하는 메인 함수
function IR:OptionsCallback()
	-- [1] 메인 루트 그룹 생성
	E.Options.args.IringUI = ACH:Group(IR.Title or "IringUI", nil, 100, "tab")
	
	-- 다른 모듈(GameMenu 등)이 접근할 수 있도록 IR 테이블에 저장
	IR.Options = E.Options.args.IringUI

	-- [2] 스타일 탭
	IR.Options.args.style = ACH:Group("스타일", nil, 1)
	IR.Options.args.style.args.header = ACH:Header("스타일 및 스킨 설정", 1)
	
	IR.Options.args.style.args.enable = ACH:Toggle("IringUI 스킨 활성화", "모든 프레임에 전용 스타일을 입힙니다.", 2, nil, nil, nil, 
		function() return E.db.IringUI.skin.enable end,
		function(_, value) E.db.IringUI.skin.enable = value; UpdateRL() end)
		
	IR.Options.args.style.args.stripes = ACH:Toggle("사선(빗살) 패턴 사용", "배경에 은은한 빗살무늬를 추가합니다.", 3, nil, nil, nil, 
		function() return E.db.IringUI.skin.stripes end,
		function(_, value) E.db.IringUI.skin.stripes = value; UpdateRL() end)
		
	IR.Options.args.style.args.shadow = ACH:Toggle("그림자 효과 사용", "프레임 가장자리에 입체적인 그림자를 추가합니다.", 4, nil, nil, nil, 
		function() return E.db.IringUI.skin.shadow end,
		function(_, value) E.db.IringUI.skin.shadow = value; UpdateRL() end)

	-- [3] 레이아웃 탭
	IR.Options.args.layout = ACH:Group("레이아웃", nil, 2)
	IR.Options.args.layout.args.header = ACH:Header("프레임 및 바 레이아웃", 1)
	
	IR.Options.args.layout.args.topBar = ACH:Toggle("상단 바 표시", nil, 2, nil, nil, nil, 
		function() return E.db.IringUI.layout.topBar end,
		function(_, value) E.db.IringUI.layout.topBar = value; IR:UpdateLayout() end)
		
	IR.Options.args.layout.args.bottomBar = ACH:Toggle("하단 바 표시", nil, 3, nil, nil, nil, 
		function() return E.db.IringUI.layout.bottomBar end,
		function(_, value) E.db.IringUI.layout.bottomBar = value; IR:UpdateLayout() end)

	-- [4] 자동바 탭 (에러 방지용 체크 추가)
	IR.Options.args.autobar = ACH:Group("자동바", nil, 3)
	IR.Options.args.autobar.args.header = ACH:Header("AutoBar 애드온 연동", 1)
	
	IR.Options.args.autobar.args.enable = ACH:Toggle("자동바 스킨 활성화", "AutoBar 애드온에 IringUI 스타일을 적용합니다.", 2, nil, nil, nil, 
		function() 
			return E.db.IringUI.autobar and E.db.IringUI.autobar.enable 
		end,
		function(_, value) 
			if not E.db.IringUI.autobar then E.db.IringUI.autobar = {} end
			E.db.IringUI.autobar.enable = value; UpdateRL() 
		end)

	-- [5] 모듈 주입 신호 발송
	-- 이 시점에 GameMenu.lua 같은 모듈들이 hooksecurefunc를 통해 자기 메뉴를 IR.Options.args에 추가합니다.
end
