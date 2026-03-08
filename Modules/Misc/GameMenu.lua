local IR, F, E, L, V, P, G = unpack(select(2, ...))
local GM = E:NewModule('IringUI_GameMenu', 'AceHook-3.0')
local ACH = E.Libs.ACH

-- [설정 주입]
function GM:InsertOptions()
	if not IR.Options or not IR.Options.args.misc then return end

	IR.Options.args.misc.args.gamemenu = ACH:Group("게임 메뉴", nil, 1)
	IR.Options.args.misc.args.gamemenu.args.enable = ACH:Toggle(
		"게임 메뉴 스타일 활성화", 
		"ESC 메뉴 프레임과 버튼에 IringUI 스타일을 적용합니다.", 
		1, nil, nil, nil,
		-- [수정] db.IringUI.misc 경로 참조
		function() return E.db.IringUI.misc and E.db.IringUI.misc.gameMenu end,
		function(_, value) 
			if not E.db.IringUI.misc then E.db.IringUI.misc = {} end
			E.db.IringUI.misc.gameMenu = value
			E:StaticPopup_Show("PRIVATE_RL") 
		end
	)
end

-- [기능 로직]
function GM:StyleGameMenu()
	-- [수정] db.IringUI.misc 경로 참조
	if not E.db.IringUI or not E.db.IringUI.misc or not E.db.IringUI.misc.gameMenu then return end

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
	hooksecurefunc(IR, "OptionsCallback", function() self:InsertOptions() end)
	if GameMenuFrame then
		self:SecureHookScript(GameMenuFrame, "OnShow", "StyleGameMenu")
	end
end

E:RegisterModule(GM:GetName())
