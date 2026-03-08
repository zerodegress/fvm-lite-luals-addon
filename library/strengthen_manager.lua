--! @meta
--
-- FVM-Lite - Strengthen System Manager
--
-- This file provides LuaLS type annotations for the card strengthening system.
-- The StrengthenManager handles card upgrade mechanics including success rates,
-- pity systems, and custom mod handlers.
--
-- API Version: 1.0.0
-- Game Engine: FVM-Lite
--
-- Usage:
-- 1. Place this file in your project's workspace
-- 2. Configure LuaLS to include this file in your workspace settings
-- 3. Use StrengthenManager to handle card strengthening operations
--
-- Important Notes:
-- - This is a type definition file only, not a runtime module
-- - All functions are declared as empty stubs for documentation purposes
-- - Actual implementation is provided by the game engine at runtime

--- @class StrengthenRequest
--- Request object containing all parameters for a card strengthening operation.
--- @field player userdata The player object performing the strengthening.
--- @field mainCardIdx number Index of the main card to be strengthened (0-based).
--- @field materialIndices number[] Array of material card indices to consume (0-based).
--- @field cloverLevel string Clover level affecting success rate multiplier. Valid values: "None", "Level1"-"Level6", "LevelS", "LevelSS", "LevelSSS", "LevelSSR".
--- @field useInsurance boolean Whether to use insurance (prevents material loss on failure).
--- @field vipBonus number|nil Optional VIP bonus rate (e.g., 0.1 for +10%).
--- @field guildBonus number|nil Optional guild bonus rate (e.g., 0.05 for +5%).

--- @class StrengthenResult
--- Result object returned after a strengthening operation.
--- @field success boolean Whether the strengthening succeeded.
--- @field usedPity boolean Whether hard pity was triggered to guarantee success.
--- @field probability number The final calculated success probability (0.0-1.0).
--- @field newStarLevel number The card's star level after the operation.
--- @field isDowngraded boolean Whether the card was downgraded due to failure (stars > 5).
--- @field message string User-facing message describing the result.
--- @field consumedMaterials number[] Array of material card indices that were consumed.

--- @class StrengthenHandler
--- Handler object that can be registered to customize strengthening behavior.
--- @field execute fun(self: StrengthenHandler, request: StrengthenRequest): StrengthenResult|nil Execute strengthening logic. Return nil to pass to next handler.
--- @field preview fun(self: StrengthenHandler, request: StrengthenRequest): number|nil Calculate success rate preview. Return nil to pass to next handler.

--- @class StrengthenState
--- Internal state tracking pity system progress.
--- @field currentFailStreak number Number of consecutive failures since last success.
--- @field currentPityThreshold number Number of failures needed to trigger hard pity.
--- @field lastPityResetStar number Star level when pity was last reset.

--- @class StrengthenManager
--- Main manager class for the card strengthening system.
--- Supports custom mod handlers with priority-based execution order.
--- Implements success rate calculations, pity systems, and material consumption logic.
--- @field handlers {priority: number, execute: function, preview: function}[] Registered handler list sorted by priority (descending).
--- @field state StrengthenState|nil Current pity system state.
--- @usage
--- ```lua
--- -- Execute a strengthening operation
--- local request = {
---     player = game.getPlayer(),
---     mainCardIdx = 0,
---     materialIndices = {1, 2, 3},
---     cloverLevel = "Level3",
---     useInsurance = false,
---     vipBonus = 0.1,
---     guildBonus = 0.05
--- }
--- local result = StrengthenManager:execute(request)
--- if result.success then
---     print("Success! New star level: " .. result.newStarLevel)
--- else
---     print("Failed: " .. result.message)
--- end
---
--- -- Preview success rate before attempting
--- local rate = StrengthenManager:preview(request)
--- print(string.format("Success rate: %.2f%%", rate * 100))
--- ```
StrengthenManager = {}

--- Gets the base success rate for a given main card star level and material card star level.
--- Uses an internal lookup table that defines success rates based on star level combinations.
--- @param mainStar number Main card star level (0-15).
--- @param subStar number Material card star level (0-16).
--- @return number Base success rate (0.0-1.0), or 0 if invalid combination.
--- @usage
--- ```lua
--- local rate = StrengthenManager.getBaseRate(5, 3)
--- print(string.format("Base rate: %.2f%%", rate * 100))
--- ```
function StrengthenManager.getBaseRate(mainStar, subStar) end

--- Calculates the pity threshold (number of failures needed for guaranteed success) based on star level.
--- Higher star levels have higher pity thresholds with randomization.
--- @param star number Current star level of the card.
--- @return number Number of failures needed to trigger hard pity.
--- @usage
--- ```lua
--- local threshold = StrengthenManager.calcPityThreshold(10)
--- print("Pity triggers after " .. threshold .. " failures")
--- ```
function StrengthenManager.calcPityThreshold(star) end

--- Registers a custom strengthening handler with specified priority.
--- Handlers with higher priority execute first. Return nil from handler to pass to next handler.
--- @param handlerTable StrengthenHandler Handler object with execute and/or preview functions.
--- @param priority number|nil Priority value (default: 0). Higher values execute first. Default handler has priority -1000.
--- @usage
--- ```lua
--- local myHandler = {
---     execute = function(self, request)
---         -- Custom logic here
---         if request.mainCardIdx == 0 then
---             return {success = true, message = "Custom success"}
---         end
---         return nil -- Pass to next handler
---     end,
---     preview = function(self, request)
---         return 0.5 -- 50% success rate
---     end
--- }
--- StrengthenManager:registerHandler(myHandler, 100)
--- ```
function StrengthenManager:registerHandler(handlerTable, priority) end

--- Executes a strengthening operation using registered handlers.
--- Iterates through handlers by priority until one returns a non-nil result.
--- @param request StrengthenRequest The strengthening request parameters.
--- @return StrengthenResult Result of the strengthening operation.
--- @usage
--- ```lua
--- local result = StrengthenManager:execute({
---     player = game.getPlayer(),
---     mainCardIdx = 0,
---     materialIndices = {1, 2},
---     cloverLevel = "Level1",
---     useInsurance = false
--- })
--- ```
function StrengthenManager:execute(request) end

--- Previews the success rate for a strengthening operation without modifying any data.
--- Calculates the final success probability including all bonuses and pity effects.
--- @param request StrengthenRequest The strengthening request parameters.
--- @return number Calculated success rate (0.0-1.0).
--- @usage
--- ```lua
--- local rate = StrengthenManager:preview({
---     player = game.getPlayer(),
---     mainCardIdx = 0,
---     materialIndices = {1, 2},
---     cloverLevel = "Level3",
---     vipBonus = 0.1
--- })
--- print(string.format("Success chance: %.1f%%", rate * 100))
--- ```
function StrengthenManager:preview(request) end

--- Default strengthening execution handler (priority -1000).
--- Implements the core strengthening logic including:
--- - Base rate calculation from star levels
--- - Fire energy multipliers (Low/Medium/High)
--- - Clover level multipliers
--- - VIP and guild bonuses
--- - Hard pity system (guaranteed success after threshold)
--- - Soft pity system (+1% per failure, max +80%)
--- - Material consumption and card downgrade on failure (stars > 5)
--- @param request StrengthenRequest The strengthening request parameters.
--- @return StrengthenResult Result of the strengthening operation.
function StrengthenManager:defaultExecute(request) end

--- Default preview handler for calculating success rates.
--- Performs the same calculations as defaultExecute but without modifying game state.
--- @param request StrengthenRequest The strengthening request parameters.
--- @return number Calculated success rate (0.0-1.0).
function StrengthenManager:defaultPreview(request) end

--- Wrapper function for Delphi interop. Executes strengthening without explicit self parameter.
--- @param request StrengthenRequest The strengthening request parameters.
--- @return StrengthenResult Result of the strengthening operation.
function StrengthenManager.executeHandler(request) end

--- Wrapper function for Delphi interop. Previews success rate without explicit self parameter.
--- @param request StrengthenRequest The strengthening request parameters.
--- @return number Calculated success rate (0.0-1.0).
function StrengthenManager.previewHandler(request) end
