local IR, F, E, L, V, P, G = unpack(select(2, ...))

-- ElvUI 설정창 내에 IringUI 메뉴를 생성하는 콜백 함수
function IR:OptionsCallback()
	E.Options.args.IringUI = {
		type = "group",
		name = IR.Title,
		order = 100,
		childGroups = "tab", -- 하위 메뉴를 탭 형식으로 표시
		args = {
			-- 1. 스타일 탭
			style = {
				order = 1,
				type = "group",
				name = "스타일",
				get = function(info) return E.db.IringUI.skin[info[#info]] end,
				set = function(info, value) E.db.IringUI.skin[info[#info]] = value; E:StaticPopup_Show("CONFIG_RL") end,
				args = {
					header = { order = 1, type = "header", name = "스타일 및 스킨 설정" },
					enable = { order = 2, type = "toggle", name = "IringUI 스킨 활성화", desc = "모든 프레임에 IringUI 전용 스타일을 입힙니다." },
					stripes = { order = 3, type = "toggle", name = "사선(빗살) 패턴 사용", desc = "배경에 은은한 빗살무늬를 추가합니다." },
					shadow = { order = 4, type = "toggle", name = "그림자 효과 사용", desc = "프레임 가장자리에 입체적인 그림자를 추가합니다." },
				},
			},
			-- 2. 레이아웃 탭
			layout = {
				order = 2,
				type = "group",
				name = "레이아웃",
				get = function(info) return E.db.IringUI.layout[info[#info]] end,
				set = function(info, value) E.db.IringUI.layout[info[#info]] = value; IR:UpdateLayout() end,
				args = {
					header = { order = 1, type = "header", name = "프레임 및 바 레이아웃" },
					topBar = { order = 2, type = "toggle", name = "상단 바 표시", desc = "화면 상단에 얇은 정보 바를 생성합니다." },
					bottomBar = { order = 3, type = "toggle", name = "하단 바 표시", desc = "화면 하단에 얇은 정보 바를 생성합니다." },
				},
			},
			-- 3. 자동바 탭
			autobar = {
				order = 3,
				type = "group",
				name = "자동바",
				get = function(info) return E.db.IringUI.autobar[info[#info]] end,
				set = function(info, value) E.db.IringUI.autobar[info[#info]] = value end,
				args = {
					header = { order = 1, type = "header", name = "AutoBar 애드온 연동" },
					enable = { order = 2, type = "toggle", name = "자동바 스킨 활성화", desc = "AutoBar 애드온 설치 시 IringUI 스타일을 적용합니다." },
				},
			},
		},
	}
end