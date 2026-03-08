local IR, F, E, L, V, P, G = unpack(select(2, ...))
local ACH = E.Libs.ACH

function IR:OptionsCallback()
	-- 메인 그룹 생성
	E.Options.args.IringUI = ACH:Group(IR.Title or "IringUI", nil, 100, "tab")
	IR.Options = E.Options.args.IringUI -- 모듈 공유용 참조

	-- 1. 스타일 탭 (기존 설정 복구)
	IR.Options.args.style = ACH:Group("스타일", nil, 1)
	IR.Options.args.style.args.enable = ACH:Toggle("스킨 활성화", nil, 1, nil, nil, nil, function() return E.db.IringUI.skin.enable end, function(_, v) E.db.IringUI.skin.enable = v; E:StaticPopup_Show("PRIVATE_RL") end)
	IR.Options.args.style.args.stripes = ACH:Toggle("빗살무늬", nil, 2, nil, nil, nil, function() return E.db.IringUI.skin.stripes end, function(_, v) E.db.IringUI.skin.stripes = v; E:StaticPopup_Show("PRIVATE_RL") end)

	-- 2. 레이아웃 탭 (탑바/바닥바 복구)
	IR.Options.args.layout = ACH:Group("레이아웃", nil, 2)
	IR.Options.args.layout.args.topBar = ACH:Toggle("상단 바", nil, 1, nil, nil, nil, function() return E.db.IringUI.layout.topBar end, function(_, v) E.db.IringUI.layout.topBar = v; IR:UpdateLayout() end)
	IR.Options.args.layout.args.bottomBar = ACH:Toggle("하단 바", nil, 2, nil, nil, nil, function() return E.db.IringUI.layout.bottomBar end, function(_, v) E.db.IringUI.layout.bottomBar = v; IR:UpdateLayout() end)

	-- 3. 자동바 탭
	IR.Options.args.autobar = ACH:Group("자동바", nil, 3)
	IR.Options.args.autobar.args.enable = ACH:Toggle("스킨 활성화", nil, 1, nil, nil, nil, function() return E.db.IringUI.autobar.enable end, function(_, v) E.db.IringUI.autobar.enable = v; E:StaticPopup_Show("PRIVATE_RL") end)
end
