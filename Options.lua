local IR, F, E, L, V, P, G = unpack(select(2, ...))
local ACH = E.Libs.ACH

function IR:OptionsCallback()
	-- 메인 그룹 생성
	E.Options.args.IringUI = ACH:Group(IR.Title or "IringUI", nil, 100, "tab")
	
	-- 기본 스타일 탭
	E.Options.args.IringUI.args.style = ACH:Group("스타일", nil, 1)
	E.Options.args.IringUI.args.style.args.enable = ACH:Toggle("스킨 활성화", nil, 1, nil, nil, nil, 
		function() return E.db.IringUI.skin.enable end,
		function(_, value) E.db.IringUI.skin.enable = value; E:StaticPopup_Show("PRIVATE_RL") end)

	-- 레이아웃 탭
	E.Options.args.IringUI.args.layout = ACH:Group("레이아웃", nil, 2)
	-- (필요한 레이아웃 설정 추가...)

	-- 자동바 탭 (안전장치 추가)
	E.Options.args.IringUI.args.autobar = ACH:Group("자동바", nil, 3)
	E.Options.args.IringUI.args.autobar.args.enable = ACH:Toggle("자동바 스킨", nil, 1, nil, nil, nil,
		function() return E.db.IringUI.autobar and E.db.IringUI.autobar.enable end,
		function(_, value) 
			if not E.db.IringUI.autobar then E.db.IringUI.autobar = {} end
			E.db.IringUI.autobar.enable = value; E:StaticPopup_Show("PRIVATE_RL") 
		end)
end
