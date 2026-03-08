local IR, F, E, L, V, P, G = unpack(select(2, ...))
local ACH = E.Libs.ACH

local function UpdateRL()
	E:StaticPopup_Show("PRIVATE_RL")
end

function IR:OptionsCallback()
	-- 메인 루트 (상단 탭 방식 유지)
	E.Options.args.IringUI = ACH:Group(IR.Title or "IringUI", nil, 100, "tab")
	IR.Options = E.Options.args.IringUI

	-- 1. 스타일 탭 (기존 그대로)
	IR.Options.args.style = ACH:Group("스타일", nil, 1)
	IR.Options.args.style.args.enable = ACH:Toggle("스킨 활성화", nil, 1, nil, nil, nil, function() return E.db.IringUI.skin.enable end, function(_, v) E.db.IringUI.skin.enable = v; UpdateRL() end)
	IR.Options.args.style.args.stripes = ACH:Toggle("빗살무늬", nil, 2, nil, nil, nil, function() return E.db.IringUI.skin.stripes end, function(_, v) E.db.IringUI.skin.stripes = v; UpdateRL() end)
	IR.Options.args.style.args.shadow = ACH:Toggle("그림자 효과", nil, 3, nil, nil, nil, function() return E.db.IringUI.skin.shadow end, function(_, v) E.db.IringUI.skin.shadow = v; UpdateRL() end)

	-- 2. 레이아웃 탭 (기존 그대로)
	IR.Options.args.layout = ACH:Group("레이아웃", nil, 2)
	IR.Options.args.layout.args.topBar = ACH:Toggle("상단 바 표시", nil, 1, nil, nil, nil, function() return E.db.IringUI.layout.topBar end, function(_, v) E.db.IringUI.layout.topBar = v; IR:UpdateLayout() end)
	IR.Options.args.layout.args.bottomBar = ACH:Toggle("하단 바 표시", nil, 2, nil, nil, nil, function() return E.db.IringUI.layout.bottomBar end, function(_, v) E.db.IringUI.layout.bottomBar = v; IR:UpdateLayout() end)

	-- 3. 자동바 탭 (기존 그대로)
	IR.Options.args.autobar = ACH:Group("자동바", nil, 3)
	IR.Options.args.autobar.args.enable = ACH:Toggle("자동바 스킨", nil, 1, nil, nil, nil, 
		function() return E.db.IringUI.autobar and E.db.IringUI.autobar.enable end, 
		function(_, v) 
			if not E.db.IringUI.autobar then E.db.IringUI.autobar = {} end
			E.db.IringUI.autobar.enable = v; UpdateRL() 
		end)

	-- 4. 기타 탭 (여기에 GameMenu 설정이 주입됨)
	IR.Options.args.misc = ACH:Group("기타", nil, 4, "tab")
end
