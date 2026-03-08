local IR, F, E, L, V, P, G = unpack(select(2, ...))
local GM = E:NewModule('IringUI_GameMenu', 'AceHook-3.0')
local ACH = E.Libs.ACH

-- [설정 주입] 기타 설정(misc) 트리 메뉴 내부로 직접 배달
function GM:InsertOptions()
	-- 뼈대가 있는지 확인 (단계별 체크)
	if not E.Options or not E.Options.args.IringUI or not E.Options.args.IringUI.args.misc then 
		return 
	end

	-- [기타 설정] 내부의 args 테이블에 'gamemenu' 그룹 생성
	E.Options.args.IringUI.args.misc.args.gamemenu = ACH:Group("게임 메뉴", nil, 1)
	
	-- 체크박스 추가
	E.Options.args.IringUI.args.misc.args.gamemenu.args.enable = ACH:Toggle(
		"게임 메뉴 스타일 활성화", 
		"ESC 메뉴 프레임과 버튼에 IringUI 스타일을 적용합니다.", 
		1, nil, nil, nil,
		function() return E.db.IringUI.general and E.db.IringUI.general.gameMenu end,
		function(_, value) 
			if not E.db.IringUI.general then E.db.IringUI.general = {} end
			E.db.IringUI.general.gameMenu = value
			E:StaticPopup_Show("PRIVATE_RL") 
		end
	)
end

-- 스타일 적용 기능 (생략 없이 유지)
function GM:StyleGameMenu()
	if not E.db.IringUI or not E.db.IringUI.general or not E.db.IringUI.general.gameMenu then return end
	if GameMenuFrame and not GameMenuFrame.IRstyle then
		if IR.Styling then IR.Styling(GameMenuFrame) end
	end
	for i = 1, GameMenuFrame:GetNumChildren() do
		local child = select(i, GameMenuFrame:GetChildren())
		if child and child:IsObjectType("Button") and not child.IringBtnStyled then
			if IR.Styling then IR.Styling(child) end
			if IR.StyleButton then IR.StyleButton(child) end
		end
	end
end

-- 초기화
function GM:Initialize()
	-- OptionsCallback이 끝난 직후 주입 실행 (다른 플러그인 표준 방식)
	if IR.OptionsCallback then
		hooksecurefunc(IR, "OptionsCallback", function()
			self:InsertOptions()
		end)
	end
    
	if GameMenuFrame then
		self:SecureHookScript(GameMenuFrame, "OnShow", "StyleGameMenu")
	end
end

E:RegisterModule(GM:GetName())
