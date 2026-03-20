local IR, F, E, L, V, P, G = unpack(select(2, ...))

-- IR의 하위 모듈로 'Layout' 생성
local Layout = IR:NewModule("Layout", 'AceEvent-3.0')

-- 상단 바 생성
function Layout:CreateTopBar()
    if self.TopBar then return end
    
    local bar = CreateFrame("Frame", "IringUI_TopBar", E.UIParent, "BackdropTemplate")
    bar:SetSize(E.screenWidth, 22)
    bar:SetPoint("TOP", E.UIParent, "TOP", 0, 0)
    bar:CreateBackdrop("Transparent")
    
    -- Core.lua에 있는 공통 스타일(Stripes) 적용
    if IR.ApplyStyle then 
        IR:ApplyStyle(bar) 
    end
    
    self.TopBar = bar
end

-- 하단 바 생성
function Layout:CreateBottomBar()
    if self.BottomBar then return end
    
    local bar = CreateFrame("Frame", "IringUI_BottomBar", E.UIParent, "BackdropTemplate")
    bar:SetSize(E.screenWidth, 22)
    bar:SetPoint("BOTTOM", E.UIParent, "BOTTOM", 0, 0)
    bar:CreateBackdrop("Transparent")
    
    -- Core.lua에 있는 공통 스타일(Stripes) 적용
    if IR.ApplyStyle then 
        IR:ApplyStyle(bar) 
    end
    
    self.BottomBar = bar
end

-- 레이아웃 업데이트 (설정값에 따라 보여주기/숨기기)
function Layout:UpdateLayout()
    -- 방어적 코딩: 혹시라도 Profile.lua 설정이 누락되었을 때의 에러 방지
    if not E.db.IringUI or not E.db.IringUI.layout then return end

    -- 상단 바 제어
    if E.db.IringUI.layout.topBar then 
        self:CreateTopBar()
        self.TopBar:Show() 
    elseif self.TopBar then 
        self.TopBar:Hide() 
    end

    -- 하단 바 제어
    if E.db.IringUI.layout.bottomBar then 
        self:CreateBottomBar()
        self.BottomBar:Show() 
    elseif self.BottomBar then 
        self.BottomBar:Hide() 
    end
end

-- 모듈 초기화 (Core.lua의 IterateModules에서 자동으로 실행됨)
function Layout:Initialize()
    self:UpdateLayout()
end