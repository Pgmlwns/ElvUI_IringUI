function IR:Initialize()
	-- DB 로드
	self.db = E.db.IringUI or P.IringUI

	-- [추가] 등록된 모든 하위 모듈(GameMenu 등)의 Initialize 호출
	for _, moduleName in ipairs(self.modules) do
		local module = self:GetModule(moduleName)
		if module and module.Initialize then
			module:Initialize()
		end
	end

	if self.InterceptInstaller then self:InterceptInstaller() end
	if self.ForceMediaUpdate then self:ForceMediaUpdate() end
	
	-- 옵션 등록
	E.Libs.EP:RegisterPlugin(addon, self.OptionsCallback)
end
