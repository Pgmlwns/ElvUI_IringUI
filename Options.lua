local IR, F, E, L, V, P, G = unpack(select(2, ...))
local ACH = E.Libs.ACH

function IR:OptionsCallback()
	-- 메인 그룹 (탭 형식)
	E.Options.args.IringUI = ACH:Group(IR.Title or "IringUI", nil, 100, "tab")

	-- 1. 스타일 탭
	E.Options.args.IringUI.args.style = ACH:Group("스타일", nil, 1)
	E.Options.args.IringUI.args.style.args.enable = ACH:Toggle("스킨 활성화", nil, 1, nil, nil, nil, 
		function() return E.db.IringUI.skin.enable end,
		function(_, value) E.db.IringUI.skin.enable = value; E:StaticPopup_Show("PRIVATE_RL") end)
	E.Options.args.IringUI.args.style.args.stripes = ACH:Toggle("빗살무늬", nil, 2, nil, nil, nil, 
		function() return E.db.IringUI.skin.stripes end,
		function(_, value) E.db.IringUI.skin.stripes = value; E:StaticPopup_Show("PRIVATE_RL") end)

	-- 2. 레이아웃 탭 (탑바/바닥바 복구)
	E.Options.args.IringUI.args.layout = ACH:Group("레이아웃", nil, 2)
	E.Options.args.IringUI.args.layout.args.topBar = ACH:Toggle("상단 바 표시", nil, 1, nil, nil, nil, 
		function() return E.db.IringUI.layout.topBar end,
		function(_, value) E.db.IringUI.layout.topBar = value; IR:UpdateLayout() end)
	E.Options.args.IringUI.args.layout.args.bottomBar = ACH:Toggle("하단 바 표시", nil, 2, nil, nil, nil, 
		function() return E.db.IringUI.layout.bottomBar end,
		function(_, value) E.db.IringUI.layout.bottomBar = value; IR:UpdateLayout() end)

	-- 3. 자동바 탭
	E.Options.args.IringUI.args.autobar = ACH:Group("자동바", nil, 3)
	E.Options.args.IringUI.args.autobar.args.enable = ACH:Toggle("자동바 스킨", nil, 1, nil, nil, nil,
		function() return E.db.IringUI.autobar and E.db.IringUI.autobar.enable end,
		function(_, value) 
			if not E.db.IringUI.autobar then E.db.IringUI.autobar = {} end
			E.db.IringUI.autobar.enable = value; E:StaticPopup_Show("PRIVATE_RL") 
		end)
end
