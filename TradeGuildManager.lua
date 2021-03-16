-------------------------------------------------------------------------------
-- Guild Tools By Fen v0.1.0
-------------------------------------------------------------------------------
-- Author: Fenweldryn
-- This Add-on is not created by, affiliated with or sponsored by ZeniMax Media
-- Inc. or its affiliates. The Elder Scrolls® and related logos are registered
-- trademarks or trademarks of ZeniMax Media Inc. in the United States and/or
-- other countries.
--
-- You can read the full terms at:
-- https://account.elderscrollsonline.com/add-on-terms
--
---------------------------------------------------------------------------------

-- local langStrings = TradeGuildManagerInternals.langStrings
-- local lang = TradeGuildManagerInternals.lang
local exporter = TradeGuildManagerExporter

function secToTime(seconds)    
    local time = math.floor(seconds / 60)
    local str = langStrings[lang].minute
    
    if (time > 60) then
        time = math.floor(seconds / (60 * 60))
        
        if (time > 24) then
            time = math.floor(seconds / (60 * 60 * 24))
            
            str = langStrings[lang].day
        else
            str = langStrings[lang].hour
        end
    end
    
    if (time ~= 1) then
        if (lang == "en") then
            str = str .. 's'
        end
        
        if (lang == "de") then
            if (str == langStrings[lang].day) then
                str = str .. 'en'
            else
                str = str .. 'n'
            end
        end
    end
    
    return time, str
end

local function SetUpLibHistoireListener(guildId, category, startTime, endTime)
    local listener = LibHistoire:CreateGuildHistoryListener(guildId, category)   
    listener:SetTimeFrame(startTime, endTime)
    
    listener:SetEventCallback(function(eventType, eventId, eventTime, param1, param2, param3, param4, param5, param6)        
            
        if(eventType == GUILD_EVENT_GUILD_JOIN and category == GUILD_HISTORY_GENERAL) then              
            exporter.storeJoin(guildId, param1, eventTime)            
        end
        
        if(eventType == GUILD_EVENT_BANKGOLD_ADDED and category == GUILD_HISTORY_BANK) then                    
            exporter.storeBankGold(guildId, param1, param2, 'deposit', eventTime)  
        end
        
        if(eventType == GUILD_EVENT_BANKGOLD_REMOVED and category == GUILD_HISTORY_BANK) then
            exporter.storeBankGold(guildId, param1, param2, 'withdrawal', eventTime)                          
        end        
    end)
    listener:Start()
end

function onAddOnLoaded(eventCode, addonName)
    if (addonName ~= TradeGuildManagerInternals.name) then
        return
    end
    
    EVENT_MANAGER:UnregisterForEvent(TradeGuildManagerInternals.name, EVENT_ADD_ON_LOADED)
    exporter.init()    
    
    startTime = os.time() - 30*24*60*60
    endTime = os.time()
    
    for i = 1, GetNumGuilds() do
        SetUpLibHistoireListener(GetGuildId(i), GUILD_HISTORY_GENERAL, startTime, endTime)        
        SetUpLibHistoireListener(GetGuildId(i), GUILD_HISTORY_BANK, startTime, endTime)
        -- SetUpLibHistoireListener(GetGuildId(i), GUILD_HISTORY_STORE, startTime, endTime)
    end
end

EVENT_MANAGER:RegisterForEvent(TradeGuildManagerInternals.name, EVENT_ADD_ON_LOADED, onAddOnLoaded)
