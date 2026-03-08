local IR, F, E, L, V, P, G = unpack(select(2, ...))
local GM = E:NewModule('IringUI_GameMenu', 'AceHook-3.0', 'AceEvent-3.0')

-- 1. 데이터베이스 기본값 등록 (먼저 실행됨)
function GM:RegisterDefaultDB()
	if not P["IringUI"] then P["IringUI"] = {} end
	if not P["IringUI"]["general"] then P["IringUI"]["general"] = {} end
	
	-- 기본값: 게임 메뉴 스타일 활성화
	P["IringUI"]["general"]["gameMenu"] = true
end

-- 2. 게임 메뉴 스타일 적용 로직
function GM:StyleGameMenu()
	if not E.db.IringUI.general.gameMenu then return end

	-- 메인 프레임 스타일링 (빗살무늬/그림자)
	if GameMenuFrame and not GameMenuFrame.IRstyle then
		if IR.Styling then IR.Styling(GameMenuFrame) end
	end

	-- 버튼들 자동 검색 및 스타일 적용
	for i = 1, GameMenuFrame:GetNumChildren() do
		local child = select(i, GameMenuFrame:GetChildren())
		if child and child:IsObjectType("Button") and not child.IringBtnStyled then
			if IR.Styling then IR.Styling(child) end
			if IR.StyleButton then IR.StyleButton(child) end
		end
	end
end

-- 3. 설정 옵션 주입 (설정창 로드 시 호출)
function GM:InsertOptions()
	if not E.Options.args.IringUI then return end
	
	E.Options.args.IringUI.args.general.args.gameMenu = {
		order = 20,
		type = "toggle",
		name = "게임 메뉴 스타일링",
		desc = "ESC 메뉴 프레임과 버튼에 IringUI 스타일을 적용합니다.",
		get = function(info) return E.db.IringUI.general.gameMenu end,
		set = function(info, value) E.db.IringUI.general.gameMenu = value; E:StaticPopup_Show("PRIVATE_RL") end,
	}
end

-- 4. 모듈 초기화 (엘브 코어가 호출함)
function GM:Initialize()
	-- 게임 메뉴가 열릴 때 스타일 적용하도록 후킹
	self:SecureHookScript(GameMenuFrame, "OnShow", "StyleGameMenu")
	
	-- 설정 옵션 추가
	self:InsertOptions()
end

-- 엘브 코어에 모듈 등록
GM:RegisterDefaultDB()
E:RegisterModule(GM:GetName())
