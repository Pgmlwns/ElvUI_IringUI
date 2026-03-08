local IR, F, E, L, V, P, G = unpack(select(2, ...))
local LSM = E.LSM

-- 미디어 경로 정의
IR.Media = {
	["Stripes"] = [[Interface\AddOns\ElvUI_IringUI\Media\Textures\stripes]],
	["Overlay"] = [[Interface\AddOns\ElvUI_IringUI\Media\Textures\Overlay]],
}

-- SharedMedia 등록
LSM:Register("statusbar", "Iring_Stripes", IR.Media.Stripes)
LSM:Register("background", "Iring_Overlay", IR.Media.Overlay)

-- ElvUI 기본 텍스처 강제 지정
function IR:ForceMediaUpdate()
	E.private.general.normTex = "Iring_Stripes"
	E.private.general.glossTex = "Iring_Stripes"
	E:UpdateMedia()
end
