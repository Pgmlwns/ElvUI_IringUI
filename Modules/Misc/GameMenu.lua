local IR, F, E, L, V, P, G = unpack(select(2, ...))
local GM = E:NewModule('IringUI_GameMenu', 'AceHook-3.0')
local ACH = E.Libs.ACH

-- 설정 주입 (기타 탭 하위로)
function GM:InsertOptions()
	-- Options.lua에서 만든 'misc' 탭이 있는지 확인
	if not IR.Options or not IR.Options.args.misc then return end

	-- 기타 탭 안에 'gamemenu' 그룹 생성
	IR.Options.args.misc.args.gamemenu = ACH:Group("게임 메뉴", nil, 1)
	IR.Options.args.misc.args.gamemenu.args.enable = ACH:Toggle(
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

-- 스타일 적용 기능 (기존과 동일)
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

function GM:Initialize()
	-- OptionsCallback이 끝난 직후 실행되도록 확실하게 후킹
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
