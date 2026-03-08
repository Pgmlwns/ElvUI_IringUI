local IR, F, E, L, V, P, G = unpack(select(2, ...))
local ACH = E.Libs.ACH

local function UpdateRL()
	E:StaticPopup_Show("PRIVATE_RL")
end

function IR:OptionsCallback()
	-- 1. 메인 루트 그룹 생성 (기본 트리 방식)
	E.Options.args.IringUI = ACH:Group(IR.Title or "IringUI", nil, 100)
	IR.Options = E.Options.args.IringUI

	-- 2. [일반 설정] 트리 메뉴 (내부에 기존 탭들을 묶음)
	IR.Options.args.general = ACH:Group("일반 설정", nil, 1, "tab")
	
	-- 기존 [스타일]
	IR.Options.args.general.args.style = ACH:Group("스타일", nil, 1)
	IR.Options.args.general.args.style.args.enable = ACH:Toggle("스킨 활성화", nil, 1, nil, nil, nil, function() return E.db.IringUI.skin.enable end, function(_, v) E.db.IringUI.skin.enable = v; UpdateRL() end)
	IR.Options.args.general.args.style.args.stripes = ACH:Toggle("빗살무늬", nil, 2, nil, nil, nil, function() return E.db.IringUI.skin.stripes end, function(_, v) E.db.IringUI.skin.stripes = v; UpdateRL() end)
	IR.Options.args.general.args.style.args.shadow = ACH:Toggle("그림자 효과", nil, 3, nil, nil, nil, function() return E.db.IringUI.skin.shadow end, function(_, v) E.db.IringUI.skin.shadow = v; UpdateRL() end)

	-- 기존 [레이아웃]
	IR.Options.args.general.args.layout = ACH:Group("레이아웃", nil, 2)
	IR.Options.args.general.args.layout.args.topBar = ACH:Toggle("상단 바", nil, 1, nil, nil, nil, function() return E.db.IringUI.layout.topBar end, function(_, v) E.db.IringUI.layout.topBar = v; IR:UpdateLayout() end)
	IR.Options.args.general.args.layout.args.bottomBar = ACH:Toggle("하단 바", nil, 2, nil, nil, nil, function() return E.db.IringUI.layout.bottomBar end, function(_, v) E.db.IringUI.layout.bottomBar = v; IR:UpdateLayout() end)

	-- 기존 [자동바]
	IR.Options.args.general.args.autobar = ACH:Group("자동바", nil, 3)
	IR.Options.args.general.args.autobar.args.enable = ACH:Toggle("스킨 활성화", nil, 1, nil, nil, nil, function() return E.db.IringUI.autobar and E.db.IringUI.autobar.enable end, function(_, v) if not E.db.IringUI.autobar then E.db.IringUI.autobar = {} end E.db.IringUI.autobar.enable = v; UpdateRL() end)

	-- 3. [기타 설정] 트리 메뉴 (여기에 GameMenu 설정이 주입됨)
	IR.Options.args.misc = ACH:Group("기타 설정", nil, 10, "tab")
end
