local IR, F, E, L, V, P, G = unpack(select(2, ...))
local GM = E:NewModule('IringUI_GameMenu', 'AceHook-3.0')
local ACH = E.Libs.ACH

-- [설정 주입] Options.lua가 만든 IR.Options 하위에 독자적인 사이드 메뉴 생성
function GM:InsertOptions()
	-- IR.Options(뼈대)가 준비되었는지 확인
	if not IR.Options or not IR.Options.args then return end

	-- 왼쪽 사이드바에 [게임 메뉴] 항목 추가
	IR.Options.args.gamemenu = ACH:Group("게임 메뉴", nil, 4, "tab")
	
	-- 상세 설정 항목
	IR.Options.args.gamemenu.args.header = ACH:Header("게임 메뉴(ESC) 스타일 설정", 1)
	IR.Options.args.gamemenu.args.enable = ACH:Toggle(
		"스타일 활성화", 
		"ESC 메뉴 프레임과 버튼에 IringUI 스타일을 적용합니다.", 
		2, nil, nil, nil,
		function() 
			return E.db.IringUI.general and E.db.IringUI.general.gameMenu 
		end,
		function(_, value) 
			if not E.db.IringUI.general then E.db.IringUI.general = {} end
			E.db.IringUI.general.gameMenu = value
			E:StaticPopup_Show("PRIVATE_RL") 
		end
	)
end

-- [기능] 게임 메뉴 스타일링 로직
function GM:StyleGameMenu()
	-- 설정 체크 (안전장치)
	if not E.db.IringUI or not E.db.IringUI.general or not E.db.IringUI.general.gameMenu then return end

	-- 메인 프레임 스타일링 (빗살무늬/그림자)
	if GameMenuFrame and not GameMenuFrame.IRstyle then
		if IR.Styling then IR.Styling(GameMenuFrame) end
	end

	-- 버튼 자동 검색 및 스타일 적용
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
	-- 1. 설정 주입: Options.lua의 메인 콜백 실행 직후 내 메뉴를 주입
	if IR.OptionsCallback then
		hooksecurefunc(IR, "OptionsCallback", function()
			self:InsertOptions()
		end)
	end

	-- 2. 게임 메뉴 후킹: ESC 메뉴가 열릴 때 스타일 적용
	if GameMenuFrame then
		self:SecureHookScript(GameMenuFrame, "OnShow", "StyleGameMenu")
	end
end

-- 엘브유아이 모듈 시스템에 등록
E:RegisterModule(GM:GetName())
