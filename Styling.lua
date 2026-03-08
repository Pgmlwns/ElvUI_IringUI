local function StyleButton(f)
	if not f or f.IringBtnStyled then return end

	-- 마우스 진입 시 (발광 및 테두리)
	f:HookScript("OnEnter", function(self)
		local color = RAID_CLASS_COLORS[E.myclass]
		-- ElvUI 버튼은 보통 .backdrop에 테두리가 있습니다.
		local target = self.backdrop or (self.GetBackdrop and self)
		
		if target and target.SetBackdropBorderColor then
			target:SetBackdropBorderColor(color.r, color.g, color.b, 1) -- 직업색상 테두리
		end
		
		-- [선택] 아주 약한 발광 효과 추가 (필요 없으면 이 블록 삭제)
		if self.SetAlpha then self:SetAlpha(0.8) end 
	end)

	-- 마우스 나갈 때 (원래대로)
	f:HookScript("OnLeave", function(self)
		local target = self.backdrop or (self.GetBackdrop and self)
		if target and target.SetBackdropBorderColor then
			target:SetBackdropBorderColor(unpack(E.media.bordercolor))
		end
		
		if self.SetAlpha then self:SetAlpha(1) end
	end)

	f.IringBtnStyled = true
end

-- 캐릭터 창 하단 탭(평판, 숙련 등)을 강제로 스타일링하는 함수
local function StyleCharacterTabs()
	-- 캐릭터 창의 탭 개수만큼 반복 (보통 1~5번)
	for i = 1, 5 do
		local tab = _G["CharacterFrameTab"..i]
		if tab then
			StyleButton(tab)
			-- 탭의 배경 프레임이 별도로 있다면 그것도 스타일링
			if tab.backdrop then StyleButton(tab.backdrop) end
		end
	end
end

-- [3] API 주입 및 엘브 후킹 부분 수정
local function AddIringAPI()
	local frame = CreateFrame("Frame")
	local mt = getmetatable(frame).__index
	
	if not mt.Styling then mt.Styling = Styling end

	if mt.SetTemplate then
		hooksecurefunc(mt, "SetTemplate", function(f)
			if not f then return end
			if f.Styling then f:Styling() end
			
			-- 버튼이거나 이름에 'Tab'이 들어가는 경우 하이라이트 적용
			local name = f.GetName and f:GetName()
			if f:IsObjectType("Button") or (name and name:find("Tab")) then
				StyleButton(f)
			end
		end)
	end
    
	-- 캐릭터 창이 열릴 때 탭 스타일링 강제 실행
	local eventFrame = CreateFrame("Frame")
	eventFrame:RegisterEvent("ADDON_LOADED")
	eventFrame:SetScript("OnEvent", function(self, event, addon)
		if addon == "Blizzard_CharacterFrame" or addon == "ElvUI" then
			StyleCharacterTabs()
		end
	end)
end

AddIringAPI()
