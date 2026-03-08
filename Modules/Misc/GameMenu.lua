local IR, F, E, L, V, P, G = unpack(select(2, ...))
local GM = E:NewModule('IringUI_GameMenu', 'AceHook-3.0')
local ACH = E.Libs.ACH

-- [설정 주입]
function GM:InjectOptions()
	-- Options.lua에서 만든 메인 그룹이 있는지 확인 (단계별 체크)
	if not E.Options or not E.Options.args or not E.Options.args.IringUI then return end

	E.Options.args.IringUI.args.gamemenu = ACH:Group("게임 메뉴", nil, 4)
	E.Options.args.IringUI.args.gamemenu.args.enable = ACH:Toggle(
		"스타일 활성화", 
		"ESC 메뉴에 IringUI 스킨을 적용합니다.", 
		1, nil, nil, nil,
		function() 
			-- [에러 방지] 안전하게 값 읽기
			return E.db.IringUI.general and E.db.IringUI.general.gameMenu 
		end,
		function(_, value) 
			-- [에러 방지] 테이블이 없으면 생성 후 저장
			if not E.db.IringUI.general then E.db.IringUI.general = {} end
			E.db.IringUI.general.gameMenu = value
			E:StaticPopup_Show("PRIVATE_RL") 
		end
	)
end

-- [스타일 적용 로직]
function GM:StyleGameMenu()
	-- [에러 발생 지점 수정] general이 nil인지 꼼꼼하게 확인
	if not E.db.IringUI or not E.db.IringUI.general or not E.db.IringUI.general.gameMenu then 
		return 
	end

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

-- [초기화]
function GM:Initialize()
	-- OptionsCallback이 실행된 후 설정을 주입하도록 후킹
	self:SecureHook(IR, "OptionsCallback", "InjectOptions")

	-- 게임 메뉴가 열릴 때 스타일 적용
	if GameMenuFrame then
		self:SecureHookScript(GameMenuFrame, "OnShow", "StyleGameMenu")
	end
end

E:RegisterModule(GM:GetName())
