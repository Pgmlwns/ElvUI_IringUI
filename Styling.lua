local addon, Engine = ...
local IR, F, E, L, V, P, G = unpack(Engine)

F.Styling = function(f, useStripes, useShadow)
	if not E.db or not E.db.IringUI or not E.db.IringUI.skin.enable then return end
	if not f or f.IRstyle or f.__style then return end
	local frameName = f.GetName and f:GetName()
	local style = CreateFrame("Frame", frameName and frameName.."_IRStyle" or nil, f, "BackdropTemplate")

	if E.db.IringUI.skin.stripes and not useStripes then
		local stripes = f:CreateTexture(nil, "BORDER")
		stripes:SetInside(f, 1, -1)
		stripes:SetTexture(IR.Media.Stripes, true, true)
		stripes:SetHorizTile(true) stripes:SetVertTile(true)
		stripes:SetBlendMode("ADD")
		if frameName and (frameName:find("PluginInstall") or frameName:find("ElvUIInstall")) then
			stripes:SetDrawLayer("OVERLAY", 7)
		end
		style.stripes = stripes
	end

	if E.db.IringUI.skin.shadow and not useShadow then
		local mshadow = f:CreateTexture(nil, "BORDER")
		mshadow:SetInside(f, 0, 0)
		mshadow:SetTexture(IR.Media.Overlay)
		local color = RAID_CLASS_COLORS[E.myclass]
		mshadow:SetVertexColor(color.r, color.g, color.b)
		mshadow:SetAlpha(0.4)
		style.mshadow = mshadow
	end
	style:SetFrameStrata(f:GetFrameStrata())
	style:SetFrameLevel(f:GetFrameLevel() + 1)
	style:SetAllPoints(f)
	f.IRstyle = style
	f.__style = 1
end

-- 버튼 전용: 테두리만 직업 색상으로
F.StyleButton = function(f)
	if not f or f.IringStyled then return end
	f:HookScript("OnEnter", function(self)
		local color = RAID_CLASS_COLORS[E.myclass]
		local target = self.backdrop or self
		if target.SetBackdropBorderColor then target:SetBackdropBorderColor(color.r, color.g, color.b) end
	end)
	f:HookScript("OnLeave", function(self)
		local target = self.backdrop or self
		if target.SetBackdropBorderColor then target:SetBackdropBorderColor(unpack(E.media.bordercolor)) end
	end)
	f.IringStyled = true
end

local function AddIringAPI()
	local mt = getmetatable(CreateFrame("Frame")).__index
	if not mt.Styling then mt.Styling = F.Styling end
	if mt.SetTemplate then
		hooksecurefunc(mt, "SetTemplate", function(f)
			if f and f.Styling then f:Styling() end
			if f and f:IsObjectType("Button") then F.StyleButton(f) end
		end)
	end
end
AddIringAPI()
