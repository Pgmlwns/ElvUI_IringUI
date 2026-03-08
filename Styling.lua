-- [최종 수정] 채팅 탭 및 설치창 필터 보강
local function AddIringAPI()
    local mt = getmetatable(CreateFrame("Frame")).__index
    local bt = getmetatable(CreateFrame("Button")).__index
    
    if not mt.Styling then mt.Styling = Styling end
    if not bt.Styling then bt.Styling = Styling end

    local function OnSetTemplate(f)
        if not f then return end
        if f.Styling then f:Styling() end -- 빗살무늬는 적용
        
        local name = f.GetName and f:GetName()
        if not name then 
            -- 이름 없는 버튼은 일반 버튼일 확률이 높으므로 적용
            if f:IsObjectType("Button") then StyleButton(f) end
            return 
        end

        -- [강력한 제외 필터] 채팅 탭 및 설치창 제외
        if name:find("ChatTab") or name:find("ChatFrame") or name:find("PluginInstall") or name:find("ElvUIInstall") then
            return
        end
        
        -- 일반 버튼이나 탭 이름이 포함된 경우 하이라이트 적용
        if f:IsObjectType("Button") or name:find("Tab") then
            StyleButton(f)
        end
    end

    if mt.SetTemplate then hooksecurefunc(mt, "SetTemplate", OnSetTemplate) end
    if bt.SetTemplate then hooksecurefunc(bt, "SetTemplate", OnSetTemplate) end

    -- 판다리아 클래식 대응 탭 후킹
    local S = E:GetModule('Skins')
    if S and S.HandleTab then
        hooksecurefunc(S, "HandleTab", function(_, tab)
            if not tab then return end
            local name = tab.GetName and tab:GetName()
            -- 채팅 탭 필터링
            if name and (name:find("ChatTab") or name:find("ChatFrame")) then return end
            
            StyleButton(tab)
        end)
    end
end

AddIringAPI()
