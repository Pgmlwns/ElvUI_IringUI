local IR, F, E, L, V, P, G = unpack(select(2, ...))
local GM = E:NewModule('IringUI_GameMenu', 'AceHook-3.0', 'AceEvent-3.0')

-- 1. 데이터베이스 기본값 등록 (테이블 구조 강제 생성)
function GM:RegisterDefaultDB()
	P["IringUI"] = P["IringUI"] or {}
	P["IringUI"]["general"] = P["IringUI"]["general"] or {}
	
	if P["IringUI"]["general"]["gameMenu"] == nil then
		P["IringUI"]["general"]["gameMenu"] = true
	end
end

-- 2. 게임 메뉴 스타일 적용 로직
function GM:StyleGameMenu()
	-- 테이블 존재 여부를 단계별로 체크하여 nil 에러 방지
	if not E.db or not E.db.IringUI or not E.db.IringUI.general or not E.db.IringUI.general.gameMenu then 
		return 
	end

	-- 메인 프레임 스타일링
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

-- 3. 설정 옵션 주입
function GM:InsertOptions()
	if not E.Options or not E.Options.args.IringUI then return end
	
	E.Options.args.IringUI.args.general.args.gameMenu = {
		order = 20,
		type = "toggle",
		name = "게임 메뉴 스타일링",
		desc = "ESC 메뉴 프레임과 버튼에 IringUI 스타일을 적용합니다.",
		get = function(info) return E.db.IringUI.general.gameMenu end,
		set = function(info, value) E.db.IringUI.general.gameMenu = value; E:StaticPopup_Show("PRIVATE_RL") end,
	}
end

-- 4. 모듈 초기화
function GM:Initialize()
	-- 게임 메뉴 후킹
	if GameMenuFrame then
		self:SecureHookScript(GameMenuFrame, "OnShow", "StyleGameMenu")
	end
	
	-- 설정 옵션은 설정창 로드 시점에 맞춰 안전하게 주입
	self:InsertOptions()
end

-- 엘브 코어에 등록
GM:RegisterDefaultDB()
E:RegisterModule(GM:GetName())
