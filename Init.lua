local E, L, V, P, G = unpack(ElvUI)
local addon, Engine = ...

local IR = E:NewModule("IringUI", 'AceConsole-3.0', 'AceEvent-3.0', 'AceHook-3.0', 'AceTimer-3.0')
local F = {}

IR.Title = "|cffff69b4Iring|r|cffb2b2b2UI|r"
IR.Media = {
    ["Stripes"] = [[Interface\AddOns\ElvUI_IringUI\Media\Textures\mUI1.tga]],
}

Engine, Engine, Engine, Engine, Engine, Engine, Engine = IR, F, E, L, V, P, G
_G[addon] = Engine

-- 공통 스타일 함수
function IR:ApplyStyle(frame)
    if not frame or frame.IringStripes then return end
    local db = E.db.IringUI
    if not db or not db.skin or not db.skin.stripes then return end

    local stripes = frame:CreateTexture(nil, "OVERLAY", nil, 6)
    stripes:SetInside(frame, 1, -1)
    stripes:SetTexture(IR.Media.Stripes, true, true)
    stripes:SetHorizTile(true) stripes:SetVertTile(true)
    stripes:SetBlendMode("ADD") stripes:SetAlpha(0.35)
    frame.IringStripes = stripes
end

function IR:Initialize()
    self.db = E.db.IringUI or P.IringUI
    
    -- [수정] 등록된 모든 하위 모듈(IR_GameMenu 등)을 수동으로 순회하며 초기화
    if self.modules then
        for name, module in self:IterateModules() do
            if module.Initialize then
                module:Initialize()
            end
        end
    end

    if self.InterceptInstaller then self:InterceptInstaller() end
    if self.OptionsCallback then
        E.Libs.EP:RegisterPlugin(addon, function() IR:OptionsCallback() end)
    end
end

E:RegisterModule(IR:GetName())
