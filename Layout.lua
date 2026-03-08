local IR, F, E, L, V, P, G = unpack(select(2, ...))

-- 상단 바 생성 함수 예시
function IR:CreateTopBar()
    if self.TopBar then return end -- 이미 있으면 생성 안함

    local bar = CreateFrame("Frame", "IringUI_TopBar", E.UIParent, "BackdropTemplate")
    bar:SetSize(E.screenWidth, 20)
    bar:SetPoint("TOP", E.UIParent, "TOP", 0, 0)
    bar:SetFrameStrata("BACKGROUND")
    
    -- ElvUI 스타일 적용 (Styling.lua에 정의된 기능)
    bar:CreateBackdrop("Transparent")
    if bar.Styling then bar:Styling() end

    self.TopBar = bar
    E:Print("IringUI 상단 바가 생성되었습니다.")
end

-- 하단 바 생성 함수 예시
function IR:CreateBottomBar()
    if self.BottomBar then return end

    local bar = CreateFrame("Frame", "IringUI_BottomBar", E.UIParent, "BackdropTemplate")
    bar:SetSize(E.screenWidth, 20)
    bar:SetPoint("BOTTOM", E.UIParent, "BOTTOM", 0, 0)
    bar:SetFrameStrata("BACKGROUND")
    
    bar:CreateBackdrop("Transparent")
    if bar.Styling then bar:Styling() end

    self.BottomBar = bar
    E:Print("IringUI 하단 바가 생성되었습니다.")
end

-- 설정값에 따라 바를 켜고 끄는 로직
function IR:UpdateLayout()
    if E.db.IringUI.layout.topBar then
        self:CreateTopBar()
        self.TopBar:Show()
    elseif self.TopBar then
        self.TopBar:Hide()
    end

    if E.db.IringUI.layout.bottomBar then
        self:CreateBottomBar()
        self.BottomBar:Show()
    elseif self.BottomBar then
        self.BottomBar:Hide()
    end
end

-- 게임 로드 시 실행
hooksecurefunc(IR, "Initialize", function()
    IR:UpdateLayout()
end)
