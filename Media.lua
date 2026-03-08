local IR, F, E, L, V, P, G = unpack(select(2, ...))
local LSM = E.LSM

IR.Media = {
    ["Stripes"] = [[Interface\AddOns\ElvUI_IringUI\Media\Textures\stripes]],
    ["Overlay"] = [[Interface\AddOns\ElvUI_IringUI\Media\Textures\Overlay]],
}

LSM:Register("statusbar", "Iring_Stripes", IR.Media.Stripes)
LSM:Register("background", "Iring_Overlay", IR.Media.Overlay)

function IR:ForceMediaUpdate()
    E.private.general.normTex = "Iring_Stripes"
    E.private.general.glossTex = "Iring_Stripes"
    E:UpdateMedia()
end
