TradeGuildManagerExporter = {}

function TradeGuildManagerExporter.init()
    TradeGuildManager = {
        join = {},
        bank_gold_deposit = {},
        bank_gold_withdrawal = {}
    }
end


function TradeGuildManagerExporter.storeJoin(guildId, accountName, eventTime)
    event = 'join'
    TradeGuildManager[event][#TradeGuildManager[event] + 1] = guildId .. "$" .. accountName .. "$" .. eventTime 
end

function TradeGuildManagerExporter.storeBankGold(guildId, accountName, gold, event, eventTime)
    event = 'bank_gold_' .. event    
    TradeGuildManager[event][#TradeGuildManager[event] + 1] = guildId .. "$" .. accountName .. "$" .. gold .. "$" .. eventTime    
end
