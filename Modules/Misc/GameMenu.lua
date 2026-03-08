local IR, F, E, L, V, P, G = unpack(select(2, ...))
local GM = E:NewModule('IringUI_GameMenu', 'AceHook-3.0')
local ACH = E.Libs.ACH

-- [설정 주입] Options.lua의 실행이 끝난 직후 호출됨
function GM:InjectOptions()
	if not E.Options.args.IringUI then return end

	E.Options.args.IringUI.args.gamemenu = ACH:Group("게임 메뉴", nil, 4)
	E.Options.args.IringUI.args.gamemenu.args.header = ACH:Header("게임 메뉴(ESC) 스타일", 1)
	E.Options.args.IringUI.args.gamemenu.args.enable = ACH:Toggle(
		"스타일 활성화", 
		"ESC 메뉴에 IringUI 스킨을 적용합니다.", 
		2, nil, nil, nil,
		function() return E.db.IringUI.general.gameMenu end,
		function(_, value) 
			E.db.IringUI.general.gameMenu = value
			E:StaticPopup_Show("PRIVATE_RL") 
		end
	)
end

-- [기능] 스타일 적용 로직
function GM:StyleGameMenu()
	if not E.db.IringUI.general.gameMenu then return end
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
	-- 1. 핵심: OptionsCallback이 실행된 후 자동으로 설정을 주입하도록 후킹
	self:SecureHook(IR, "OptionsCallback", "InjectOptions")

	-- 2. 게임 메뉴 후킹
	if GameMenuFrame then
		self:SecureHookScript(GameMenuFrame, "OnShow", "StyleGameMenu")
	end
end

E:RegisterModule(GM:GetName())
