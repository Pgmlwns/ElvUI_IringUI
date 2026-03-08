local IR, F, E, L, V, P, G = unpack(select(2, ...))
local GM = E:NewModule('IringUI_GameMenu', 'AceHook-3.0')
local ACH = E.Libs.ACH

function GM:InjectOptions()
	if not E.Options.args.IringUI then return end
	E.Options.args.IringUI.args.gamemenu = ACH:Group("게임 메뉴", nil, 4)
	E.Options.args.IringUI.args.gamemenu.args.enable = ACH:Toggle("스타일 활성화", nil, 1, nil, nil, nil,
		function() return E.db.IringUI.general and E.db.IringUI.general.gameMenu end,
		function(_, value) 
			if not E.db.IringUI.general then E.db.IringUI.general = {} end
			E.db.IringUI.general.gameMenu = value; E:StaticPopup_Show("PRIVATE_RL") 
		end)
end

function GM:StyleGameMenu()
	-- [에러 방지] 꼼꼼한 체크
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
	self:SecureHook(IR, "OptionsCallback", "InjectOptions")
	if GameMenuFrame then
		self:SecureHookScript(GameMenuFrame, "OnShow", "StyleGameMenu")
	end
end

E:RegisterModule(GM:GetName())
