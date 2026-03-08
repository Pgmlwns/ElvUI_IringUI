local IR, F, E, L, V, P, G = unpack(select(2, ...))
local LSM = E.LSM

-- 미디어 경로 정의
IR.Media = {
	["Stripes"] = [[Interface\AddOns\ElvUI_IringUI\Media\Textures\stripes]],
	["Overlay"] = [[Interface\AddOns\ElvUI_IringUI\Media\Textures\Overlay]],
}

-- 1. 상태바 목록에는 등록만 해둠 (사용자가 원하면 설정에서 선택 가능)
LSM:Register("statusbar", "Iring_Stripes", IR.Media.Stripes)

-- 2. 배경(프레임 바탕) 목록에 등록 (IringUI 스타일링 엔진이 이 텍스처를 사용함)
LSM:Register("background", "Iring_Overlay", IR.Media.Overlay)

-- 상태바 강제 지정을 제거하고, 필요한 미디어 업데이트만 수행
function IR:ForceMediaUpdate()
	-- E.private.general.normTex 관련 강제 코드 삭제됨
	E:UpdateMedia()
end
