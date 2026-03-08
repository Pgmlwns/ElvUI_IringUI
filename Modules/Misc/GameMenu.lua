local IR, F, E, L, V, P, G = unpack(select(2, ...))
local GM = E:NewModule('IringUI_GameMenu', 'AceHook-3.0')
local ACH = E.Libs.ACH

-- [설정 주입]
function GM:InsertOptions()
	-- IR.Options(뼈대)와 misc(바구니)가 있는지 확인
	if not IR.Options or not IR.Options.args.misc then return end
	
	-- 바구니 안에 'args' 테이블이 없으면 생성 (방지책)
	if not IR.Options.args.misc.args then IR.Options.args.misc.args = {} end

	-- [기타 설정] 하위 메뉴로 '게임 메뉴' 추가
	IR.Options.args.misc.args.gamemenu = ACH:Group("게임 메뉴", nil, 1)
	IR.Options.args.misc.args.gamemenu.args.enable = ACH:Toggle(
		"게임 메뉴 스타일 활성화", 
		"ESC 메뉴 프레임과 버튼에 IringUI 스타일을 적용합니다.", 
		1, nil, nil, nil,
		function() return E.db.IringUI.general.gameMenu end,
		function(_, value) 
			E.db.IringUI.general.gameMenu = value
			E:StaticPopup_Show("PRIVATE_RL") 
		end
	)
end

-- [기능] 게임 메뉴 스타일링 (기존 로직 유지)
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
	-- 설정 주입: OptionsCallback 실행 직후 강제 실행
	if IR.OptionsCallback then
		hooksecurefunc(IR, "OptionsCallback", function()
			self:InsertOptions()
		end)
	end

	-- 기능 후킹
	if GameMenuFrame then
		self:SecureHookScript(GameMenuFrame, "OnShow", "StyleGameMenu")
	end
end

E:RegisterModule(GM:GetName())
