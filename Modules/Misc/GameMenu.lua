local IR, F, E, L, V, P, G = unpack(select(2, ...))
local GM = E:NewModule('IringUI_GameMenu', 'AceHook-3.0')

-- ... (기존 기능 로직 생략) ...

function GM:InsertOptions()
	-- Options.lua에서 만든 E.Options.args.IringUI.args 안에 'gamemenu' 탭을 추가
	if E.Options and E.Options.args.IringUI then
		E.Options.args.IringUI.args.gamemenu = {
			order = 4, -- 자동바(3번) 다음 순서
			type = "group",
			name = "게임 메뉴",
			args = {
				header = { order = 1, type = "header", name = "게임 메뉴(ESC) 스타일 설정" },
				enable = {
					order = 2,
					type = "toggle",
					name = "스타일 활성화",
					desc = "ESC 메뉴 프레임과 버튼에 IringUI 스타일을 적용합니다.",
					get = function(info) return E.db.IringUI.general.gameMenu end,
					set = function(info, value) E.db.IringUI.general.gameMenu = value; E:StaticPopup_Show("PRIVATE_RL") end,
				},
			},
		}
	end
end

function GM:Initialize()
	-- 게임 메뉴 후킹
	if GameMenuFrame then
		self:SecureHookScript(GameMenuFrame, "OnShow", "StyleGameMenu")
	end
	
	-- 설정 주입 (Options.lua가 실행된 후 주입되도록 설계됨)
	self:InsertOptions()
end
