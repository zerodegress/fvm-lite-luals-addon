-- system/strengthen_manager.lua
-- 强化系统管理器，支持Mod注册自定义处理器

local StrengthenManager = {
    handlers = {}   -- 处理器列表：{ priority, execute, preview }
}

-- 四叶草乘数映射
local cloverMultipliers = {
    None    = 1.0,
    Level1  = 1.2,
    Level2  = 1.4,
    Level3  = 1.7,
    Level4  = 2.0,
    Level5  = 2.4,
    Level6  = 2.7,
    LevelS   = 3.0,
    LevelSS  = 3.2,
    LevelSSS = 3.6,
    LevelSSR = 4.0
}

-- 火种类型判断
local function getCardFireEnergy(cardInfo)
    if not cardInfo then return 'Low' end
    if cardInfo.isPlus then return 'High' end
    if cardInfo.cost < 100 then return 'Low'
    elseif cardInfo.cost < 200 then return 'Medium'
    else return 'High' end
end

-- 火种乘数表（索引1对应主卡0星，2对应1星……）
local fireMultiplierTable = {
    Low    = {1, 1, 1, 0.7, 0.7, 0.7, 0.7, 0.7, 0.7, 0.7, 0.7, 0.7, 0.7, 0.7, 0.7, 0.7},
    Medium = {1, 1, 1, 0.85,0.85,0.85,0.85,0.85,0.85,0.85,0.85,0.85,0.85,0.85,0.85,0.85},
    High   = {1, 1, 1, 1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1}
}

-- 基础成功率表
local baseRateTable = {
    {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},                 -- 主卡0星
    {0.88,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},              -- 主卡1星
    {0.608,0.792,0.968,1,1,1,1,1,1,1,1,1,1,1,1,1,1},      -- 主卡2星
    {0,0.429,0.55,0.686,0.88,1,1,1,1,1,1,1,1,1,1,1,1},    -- 主卡3星
    {0,0,0.242,0.403,0.495,0.88,1,1,1,1,1,1,1,1,1,1,1},   -- 主卡4星
    {0,0,0,0.201,0.33,0.396,0.88,1,1,1,1,1,1,1,1,1,1},    -- 主卡5星
    {0,0,0,0,0.132,0.264,0.319,0.88,1,1,1,1,1,1,1,1,1},   -- 主卡6星
    {0,0,0,0,0,0.106,0.212,0.264,0.88,1,1,1,1,1,1,1,1},   -- 主卡7星
    {0,0,0,0,0,0,0.06,0.132,0.22,0.88,1,1,1,1,1,1,1},     -- 主卡8星
    {0,0,0,0,0,0,0,0.022,0.045,0.135,0.88,1,1,1,1,1,1},   -- 主卡9星
    {0,0,0,0,0,0,0,0,0.018,0.046,0.125,0.88,1,1,1,1,1},   -- 主卡10星
    {0,0,0,0,0,0,0,0,0,0.017,0.043,0.116,0.88,1,1,1,1},   -- 主卡11星
    {0,0,0,0,0,0,0,0,0,0,0.0157,0.0398,0.107,0.88,1,1,1}, -- 主卡12星
    {0,0,0,0,0,0,0,0,0,0,0.014,0.035,0.095,0.88,1,1,1},   -- 主卡13星
    {0,0,0,0,0,0,0,0,0,0,0,0.012,0.031,0.085,0.88,1,1},   -- 主卡14星
    {0,0,0,0,0,0,0,0,0,0,0,0,0.010,0.026,0.015,0.028,0.036} -- 主卡15星
}

function StrengthenManager.getBaseRate(mainStar, subStar)
    local row = baseRateTable[mainStar + 1]
    if not row then return 0 end
    return row[subStar + 1] or 0
end

-- 保底配置
local pityConfigs = {
    {min=0, max=3, base=4, range=2},
    {min=4, max=6, base=6, range=3},
    {min=7, max=9, base=8, range=4},
    {min=10, max=15, base=10, range=5}
}

function StrengthenManager.calcPityThreshold(star)
    for _, cfg in ipairs(pityConfigs) do
        if star >= cfg.min and star <= cfg.max then
            return cfg.base + math.random(0, cfg.range)
        end
    end
    return 10
end

-- 默认强化处理器（实现原StrengthenSystem逻辑）
function StrengthenManager:defaultExecute(request)
    local player = request.player
    local mainIdx = request.mainCardIdx
    local materialIndices = request.materialIndices
    local cloverLevel = request.cloverLevel
    local useInsurance = request.useInsurance
    local vipBonus = request.vipBonus or 0
    local guildBonus = request.guildBonus or 0

    -- 验证主卡
    local mainCard = game.getCardInfo(player, mainIdx)
    if not mainCard then
        return {success=false, message="主卡不存在"}
    end
    local mainStar = mainCard.level
    if mainStar > 15 then
        return {success=false, message="主卡已达到最大等级"}
    end

    -- 验证材料卡
    local materials = {}
    for i, idx in ipairs(materialIndices) do
        if idx == mainIdx then
            return {success=false, message="不能使用主卡作为材料卡"}
        end
        local card = game.getCardInfo(player, idx)
        if not card then
            return {success=false, message=string.format("材料卡 %d 不存在", idx)}
        end
        table.insert(materials, {idx=idx, info=card})
    end

    -- 计算基础成功率
    local rates = {}
    for _, mat in ipairs(materials) do
        local baseRate = StrengthenManager.getBaseRate(mainStar, mat.info.level)
        local fireType = getCardFireEnergy(mat.info)
        local fireMult = fireMultiplierTable[fireType][mainStar + 1]
        local adjusted = baseRate * fireMult
        table.insert(rates, adjusted)
    end
    table.sort(rates, function(a,b) return a > b end)
    local baseRate = 0
    for i, r in ipairs(rates) do
        if i == 1 then
            baseRate = baseRate + r
        else
            baseRate = baseRate + r / 3.0
        end
    end
    baseRate = math.min(baseRate, 1.0)

    -- 保底状态
    if not StrengthenManager.state then
        StrengthenManager.state = {
            currentFailStreak = 0,
            currentPityThreshold = 0,
            lastPityResetStar = 0
        }
    end
    local state = StrengthenManager.state

    if state.currentPityThreshold == 0 then
        state.currentPityThreshold = StrengthenManager.calcPityThreshold(mainStar)
        state.lastPityResetStar = mainStar
    end

    -- 硬保底触发
    if state.currentFailStreak >= state.currentPityThreshold then
        local newStar = mainStar + 1
        game.setCardLevel(player, mainIdx, newStar)
        for _, idx in ipairs(materialIndices) do
            game.removeCard(player, idx)
        end
        state.currentFailStreak = 0
        state.currentPityThreshold = StrengthenManager.calcPityThreshold(newStar)
        state.lastPityResetStar = newStar
        return {
            success = true,
            usedPity = true,
            probability = 1.0,
            newStarLevel = newStar,
            message = "物品强化成功,您可以到物\\品栏查看该卡的属性",
            isDowngraded = false,
            consumedMaterials = materialIndices
        }
    end

    -- 软保底
    if baseRate > 0.0000000001 then
        baseRate = baseRate + math.min(state.currentFailStreak * 0.01, 0.8)
    else
        state.currentFailStreak = 0
    end

    -- 最终成功率
    local cloverMult = cloverMultipliers[cloverLevel] or 1.0
    local finalRate = baseRate * cloverMult
    finalRate = finalRate + baseRate * (vipBonus + guildBonus)
    finalRate = math.min(finalRate, 1.0)

    local success = math.random() <= finalRate
    local result = {
        success = success,
        usedPity = false,
        probability = finalRate,
        newStarLevel = mainStar,
        isDowngraded = false,
        message = success and "物品强化成功,您可以到物\\品栏查看该卡的属性" or "不够好运,升级失败"
    }

    if success then
        result.newStarLevel = mainStar + 1
        result.consumedMaterials = materialIndices
        game.setCardLevel(player, mainIdx, result.newStarLevel)
        for _, idx in ipairs(materialIndices) do
            game.removeCard(player, idx)
        end
        state.currentFailStreak = 0
        state.currentPityThreshold = StrengthenManager.calcPityThreshold(result.newStarLevel)
        state.lastPityResetStar = result.newStarLevel
    else
        -- 保险金处理，之后四叶草也要在这里设置消耗
        if useInsurance then
            result.consumedMaterials = {}
        else
            result.consumedMaterials = materialIndices
            for _, idx in ipairs(materialIndices) do
                game.removeCard(player, idx)
            end
            if mainStar > 5 then
                result.newStarLevel = mainStar - 1
                result.isDowngraded = true
                game.setCardLevel(player, mainIdx, result.newStarLevel)
            end
        end
        state.currentFailStreak = state.currentFailStreak + 1
    end

    return result
end

-- 处理器列表（按优先级降序）
StrengthenManager.handlers = {}

function StrengthenManager:registerHandler(handlerTable, priority)
    priority = priority or 0
    table.insert(self.handlers, {
        priority = priority,
        execute = handlerTable.execute,
        preview = handlerTable.preview
    })
    table.sort(self.handlers, function(a,b) return a.priority > b.priority end)
end

-- 预览成功率（只计算，不修改数据）
function StrengthenManager:defaultPreview(request)
    -- 类似defaultHandler的计算部分，省略数据修改
    local player = request.player
    local mainIdx = request.mainCardIdx
    local materialIndices = request.materialIndices
    local cloverLevel = request.cloverLevel
    local vipBonus = request.vipBonus or 0
    local guildBonus = request.guildBonus or 0

    local mainCard = game.getCardInfo(player, mainIdx)
    if not mainCard then return 0 end
    local mainStar = mainCard.level
    if mainStar > 15 then return 0 end

    local rates = {}
    for _, idx in ipairs(materialIndices) do
        local card = game.getCardInfo(player, idx)
        if card then
            local baseRate = StrengthenManager.getBaseRate(mainStar, card.level)
            local fireType = getCardFireEnergy(card)
            local fireMult = fireMultiplierTable[fireType][mainStar + 1]
            table.insert(rates, baseRate * fireMult)
        end
    end
    table.sort(rates, function(a,b) return a > b end)
    local baseRate = 0
    for i, r in ipairs(rates) do
        if i == 1 then
            baseRate = baseRate + r
        else
            baseRate = baseRate + r / 3.0
        end
    end
    baseRate = math.min(baseRate, 1.0)

    -- 软保底（使用当前失败次数，但不会改变）
    if baseRate > 0 and StrengthenManager.state then
        baseRate = baseRate + math.min(StrengthenManager.state.currentFailStreak * 0.01, 0.8)
    end

    local cloverMult = cloverMultipliers[cloverLevel] or 1.0
    local finalRate = baseRate * cloverMult + baseRate * (vipBonus + guildBonus)
    return math.min(finalRate, 1.0)
end

-- 执行强化（遍历处理器，返回第一个非nil结果）
function StrengthenManager:execute(request)
    for _, h in ipairs(self.handlers) do
        if h.execute then
            local result = h:execute(request)
            if result ~= nil then
                return result
            end
        end
    end
    return {success=false, message="没有可用的强化处理器"}
end

function StrengthenManager:preview(request)
    for _, h in ipairs(self.handlers) do
        if h.preview then
            local result = h:preview(request)
            if result ~= nil then
                return result
            end
        end
    end
    return StrengthenManager.defaultPreview(request)
end

-- 注册默认处理器（优先级 -1000，确保最后执行）
StrengthenManager:registerHandler({
    execute = StrengthenManager.defaultExecute,
    preview = StrengthenManager.defaultPreview
}, -1000)


-- 给Delphi侧用的，懒得传一次self，直接这么跑
function StrengthenManager.executeHandler(request)
    return StrengthenManager:execute(request)
end
function StrengthenManager.previewHandler(request)
    return StrengthenManager:preview(request)
end

return StrengthenManager
