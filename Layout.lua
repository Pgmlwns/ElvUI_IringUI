local IR, F, E, L, V, P, G = unpack(select(2, ...))

-- 상단 바 생성
function IR:CreateTopBar()
	if self.TopBar then return end
	local bar = CreateFrame("Frame", "IringUI_TopBar", E.UIParent, "BackdropTemplate")
	bar:SetSize(E.screenWidth, 22)
	bar:SetPoint("TOP", E.UIParent, "TOP", 0, 0)
	bar:CreateBackdrop("Transparent")
	if bar.Styling then bar:Styling() end
	self.TopBar = bar
end

-- 하단 바 생성
function IR:CreateBottomBar()
	if self.BottomBar then return end
	local bar = CreateFrame("Frame", "IringUI_BottomBar", E.UIParent, "BackdropTemplate")
	bar:SetSize(E.screenWidth, 22)
	bar:SetPoint("BOTTOM", E.UIParent, "BOTTOM", 0, 0)
	bar:CreateBackdrop("Transparent")
	if bar.Styling then bar:Styling() end
	self.BottomBar = bar
end

function IR:UpdateLayout()
	if E.db.IringUI.layout.topBar then 
		self:CreateTopBar(); self.TopBar:Show() 
	elseif self.TopBar then self.TopBar:Hide() end

	if E.db.IringUI.layout.bottomBar then 
		self:CreateBottomBar(); self.BottomBar:Show() 
	elseif self.BottomBar then self.BottomBar:Hide() end
end

-- 초기화 시 레이아웃 업데이트 연결
hooksecurefunc(IR, "Initialize", function() IR:UpdateLayout() end)
