local IR, F, E, L, V, P, G = unpack(select(2, ...))
local GM = E:NewModule('IringUI_GameMenu', 'AceHook-3.0')


-- 스타일 적용 기능
function GM:StyleGameMenu()
	-- 설정 체크 (Core.lua의 misc.gameMenu 참조)
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
	-- 게임 메뉴가 열릴 때 스타일 적용하도록 후킹
	if GameMenuFrame then
		self:SecureHookScript(GameMenuFrame, "OnShow", "StyleGameMenu")
	end
end

E:RegisterModule(GM:GetName())
