local addon, Engine = ...
local IR, F, E, L, V, P, G = unpack(Engine)
local ACH = E.Libs.ACH

local function UpdateRL()
	E:StaticPopup_Show("PRIVATE_RL")
end

function IR:OptionsCallback()
	-- 1. 메인 루트 생성
	E.Options.args.IringUI = ACH:Group(IR.Title or "IringUI", nil, 100)
	local main = E.Options.args.IringUI.args

	-- 2. 일반 설정 탭 (기본으로 생성)
	main.general = ACH:Group("일반 설정", nil, 1, "tab")
	local general = main.general.args

	-- [스타일] 그룹
	general.style = ACH:Group("스타일", nil, 1)
	general.style.args.enable = ACH:Toggle("스킨 활성화", nil, 1, nil, nil, nil, function() return E.db.IringUI.skin.enable end, function(_, v) E.db.IringUI.skin.enable = v; UpdateRL() end)
	general.style.args.stripes = ACH:Toggle("빗살무늬", nil, 2, nil, nil, nil, function() return E.db.IringUI.skin.stripes end, function(_, v) E.db.IringUI.skin.stripes = v; UpdateRL() end)
	general.style.args.shadow = ACH:Toggle("그림자 효과", nil, 3, nil, nil, nil, function() return E.db.IringUI.skin.shadow end, function(_, v) E.db.IringUI.skin.shadow = v; UpdateRL() end)

	-- [레이아웃] 그룹
	general.layout = ACH:Group("레이아웃", nil, 2)
	general.layout.args.topBar = ACH:Toggle("상단 바 표시", nil, 1, nil, nil, nil, function() return E.db.IringUI.layout.topBar end, function(_, v) E.db.IringUI.layout.topBar = v; UpdateRL() end)

	-- [자동바] 그룹
	general.autobar = ACH:Group("자동바", nil, 3)
	general.autobar.args.enable = ACH:Toggle("자동바 스킨", nil, 1, nil, nil, nil, function() return E.db.IringUI.autobar and E.db.IringUI.autobar.enable end, function(_, v) if not E.db.IringUI.autobar then E.db.IringUI.autobar = {} end E.db.IringUI.autobar.enable = v; UpdateRL() end)

	-- 3. 기타 설정 탭 (동적 생성)
	if not main.misc then
		main.misc = ACH:Group("기타 설정", nil, 5, "tab")
	end
	local misc = main.misc.args

	-- [게임 메뉴] 그룹
	misc.gamemenu = ACH:Group("게임 메뉴", nil, 1)
	misc.gamemenu.args.enable = ACH:Toggle("게임 메뉴 스타일 활성화", "ESC 메뉴에 IringUI 스타일을 적용합니다.", 1, nil, nil, nil,
		function() 
			if not E.db.IringUI.misc then E.db.IringUI.misc = { gameMenu = true } end
			return E.db.IringUI.misc.gameMenu 
		end,
		function(_, v) 
			if not E.db.IringUI.misc then E.db.IringUI.misc = {} end
			E.db.IringUI.misc.gameMenu = v
			UpdateRL() 
		end
	)
end
