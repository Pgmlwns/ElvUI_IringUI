local IR, F, E, L, V, P, G = unpack(select(2, ...))
local ACH = E.Libs.ACH -- ElvUI 설정 헬퍼 라이브러리

-- 설정창 내 공용 함수 (재시작 팝업)
local function UpdateRL()
	E:StaticPopup_Show("PRIVATE_RL")
end

-- ElvUI 설정창 내에 IringUI 메뉴를 생성하는 콜백 함수
function IR:OptionsCallback()
	-- 1. 메인 루트 그룹 생성 (탭 형식)
	-- 이 테이블이 생성된 후, 각 모듈(GameMenu.lua 등)이 자기 설정을 여기에 주입합니다.
	E.Options.args.IringUI = ACH:Group(IR.Title or "IringUI", nil, 100, "tab")
	
	-- 2. 스타일 탭 (기본 포함)
	E.Options.args.IringUI.args.style = ACH:Group("스타일", nil, 1)
	E.Options.args.IringUI.args.style.args.header = ACH:Header("스타일 및 스킨 설정", 1)
	
	E.Options.args.IringUI.args.style.args.enable = ACH:Toggle("IringUI 스킨 활성화", "모든 프레임에 전용 스타일을 입힙니다.", 2, nil, nil, nil, 
		function() return E.db.IringUI.skin.enable end,
		function(_, value) E.db.IringUI.skin.enable = value; UpdateRL() end)
		
	E.Options.args.IringUI.args.style.args.stripes = ACH:Toggle("사선(빗살) 패턴 사용", "배경에 은은한 빗살무늬를 추가합니다.", 3, nil, nil, nil, 
		function() return E.db.IringUI.skin.stripes end,
		function(_, value) E.db.IringUI.skin.stripes = value; UpdateRL() end)
		
	E.Options.args.IringUI.args.style.args.shadow = ACH:Toggle("그림자 효과 사용", "프레임 가장자리에 입체적인 그림자를 추가합니다.", 4, nil, nil, nil, 
		function() return E.db.IringUI.skin.shadow end,
		function(_, value) E.db.IringUI.skin.shadow = value; UpdateRL() end)

	-- 3. 레이아웃 탭 (기본 포함)
	E.Options.args.IringUI.args.layout = ACH:Group("레이아웃", nil, 2)
	E.Options.args.IringUI.args.layout.args.header = ACH:Header("프레임 및 바 레이아웃", 1)
	
	E.Options.args.IringUI.args.layout.args.topBar = ACH:Toggle("상단 바 표시", nil, 2, nil, nil, nil, 
		function() return E.db.IringUI.layout.topBar end,
		function(_, value) E.db.IringUI.layout.topBar = value; IR:UpdateLayout() end)
		
	E.Options.args.IringUI.args.layout.args.bottomBar = ACH:Toggle("하단 바 표시", nil, 3, nil, nil, nil, 
		function() return E.db.IringUI.layout.bottomBar end,
		function(_, value) E.db.IringUI.layout.bottomBar = value; IR:UpdateLayout() end)

	-- 4. 자동바 탭 (에러 방지용 nil 체크 포함)
	E.Options.args.IringUI.args.autobar = ACH:Group("자동바", nil, 3)
	E.Options.args.IringUI.args.autobar.args.header = ACH:Header("AutoBar 애드온 연동", 1)
	
	E.Options.args.IringUI.args.autobar.args.enable = ACH:Toggle("자동바 스킨 활성화", "AutoBar 애드온에 IringUI 스타일을 적용합니다.", 2, nil, nil, nil, 
		function() 
			-- 테이블 존재 여부 확인 후 값 반환 (43라인 nil 에러 방지)
			return E.db.IringUI.autobar and E.db.IringUI.autobar.enable 
		end,
		function(_, value) 
			if not E.db.IringUI.autobar then E.db.IringUI.autobar = {} end
			E.db.IringUI.autobar.enable = value; UpdateRL() 
		end)

	-- [중요] 모듈 주입 신호 발송
	-- GameMenu.lua 같은 독립 모듈들이 hooksecurefunc를 통해 
	-- 이 시점에 E.Options.args.IringUI.args 하위에 자기 메뉴를 추가합니다.
end
