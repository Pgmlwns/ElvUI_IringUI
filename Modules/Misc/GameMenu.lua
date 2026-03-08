local IR, F, E, L, V, P, G = unpack(select(2, ...))
local GM = E:NewModule('IringUI_GameMenu', 'AceHook-3.0')
local ACH = E.Libs.ACH

-- [표준 주입] OptionsCallback이 실행된 직후 실행됨
function GM:InsertOptions()
	if not IR.Options or not IR.Options.args then return end

	IR.Options.args.gamemenu = ACH:Group("게임 메뉴", nil, 4)
	IR.Options.args.gamemenu.args.enable = ACH:Toggle(
		"스타일 활성화", 
		"ESC 메뉴에 IringUI 스킨을 적용합니다.", 
		1, nil, nil, nil,
		function() return E.db.IringUI.general and E.db.IringUI.general.gameMenu end,
		function(_, value) 
			if not E.db.IringUI.general then E.db.IringUI.general = {} end
			E.db.IringUI.general.gameMenu = value; E:StaticPopup_Show("PRIVATE_RL") 
		end
	)
end

function GM:StyleGameMenu()
	-- [에러 방지] 꼼꼼한 체크 후 실행
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

function GM:Initialize()
	-- 메인 옵션이 생성된 직후 내 설정을 주입 (표준 훅 방식)
	self:SecureHook(IR, "OptionsCallback", "InsertOptions")

	if GameMenuFrame then
		self:SecureHookScript(GameMenuFrame, "OnShow", "StyleGameMenu")
	end
end

E:RegisterModule(GM:GetName())
