--! @meta
--
-- FVM-Lite - Global Variables and Utilities
--
-- This file provides LuaLS type annotations for global variables and utility classes
-- used in FVM-Lite game mods. It includes card drawing systems and game state management.
--
-- API Version: 1.0.0
-- Game Engine: FVM-Lite
--
-- Usage:
-- 1. Place this file in your project's workspace
-- 2. Configure LuaLS to include this file in your workspace settings
-- 3. Access global variables and utilities with full IntelliSense support
--
-- Important Notes:
-- - This is a type definition file only, not a runtime module
-- - All functions are declared as empty stubs for documentation purposes
-- - Actual implementation is provided by the game engine at runtime

--- @class fvm
--- The global 'fvm' object provides core game functionality and state management.
fvm = {}

--- Global card draw list containing all available cards with their respective weights.
--- This table is used by the CardRandomizer to perform weighted random card selection.
--- Each entry contains a card identifier and its draw weight (higher weight = higher probability).
--- @type {name: string, weight: number}[]
--- @usage
--- ```lua
--- -- Iterate through all available cards
--- for i, card in ipairs(box_cards) do
---     print(string.format("Card: %s, Weight: %d", card.name, card.weight))
--- end
---
--- -- Calculate total weight
--- local totalWeight = 0
--- for _, card in ipairs(box_cards) do
---     totalWeight = totalWeight + card.weight
--- end
--- ```
box_cards = {
    {name = 'fvm:small_fire', weight = 30},
    {name = 'fvm:small_wine_fire', weight = 30},
    {name = 'fvm:single_shooter', weight = 50},
    {name = 'fvm:bread_wall', weight = 50},
    {name = 'fvm:small_tripple_shooter', weight = 30},
    {name = 'fvm:small_fire_pot', weight = 40},
    {name = 'fvm:double_shooter', weight = 50},
    {name = 'fvm:small_four_shooter', weight = 10},
    {name = 'fvm:watermelon_shield', weight = 40},
    {name = 'fvm:singleice_shooter', weight = 50},
    {name = 'fvm:wood_plate', weight = 30},
    {name = 'fvm:salad_thrower', weight = 30},
    {name = 'fvm:egg_thrower', weight = 30},
    {name = 'fvm:oil_lamp', weight = 50},
    {name = 'fvm:small_caffee_cup', weight = 50},
    {name = 'fvm:water_cup', weight = 50},
    {name = 'fvm:wood_stopper', weight = 50}

}

--- Utility class for random card drawing operations.
--- Provides methods for both uniform and weighted random card selection,
--- as well as giving cards directly to players.
--- @class CardRandomizer
--- @usage
--- ```lua
--- -- Draw a random card uniformly
--- local cardName = CardRandomizer.getRandomCard()
--- print("Drew card: " .. cardName)
---
--- -- Draw a card using weighted probabilities
--- local weightedCard = CardRandomizer.getWeightedRandom()
--- print("Drew weighted card: " .. weightedCard)
---
--- -- Give 5 random cards of star level 3 to the player
--- CardRandomizer.giveRandomCard(3, 5)
--- ```
CardRandomizer = {}

--- Draws a random card from the box_cards list using uniform distribution.
--- Each card has an equal probability of being selected, regardless of weight.
--- @return string The name/identifier of the randomly selected card.
--- @usage
--- ```lua
--- local card = CardRandomizer.getRandomCard()
--- print("Randomly selected: " .. card)
--- ```
function CardRandomizer.getRandomCard() end

--- Draws a random card from the box_cards list using weighted distribution.
--- Cards with higher weight values have a proportionally higher probability of being selected.
--- The probability of selecting a card is: card.weight / sum(all weights).
--- @return string The name/identifier of the randomly selected card.
--- @usage
--- ```lua
--- -- Cards with higher weights are more likely to be selected
--- local card = CardRandomizer.getWeightedRandom()
--- print("Weighted random card: " .. card)
--- ```
function CardRandomizer.getWeightedRandom() end

--- Gives random cards to the player with specified star level and quantity.
--- This method automatically selects random cards and adds them to the player's inventory.
--- @param star number The star level/rarity of the cards to give (e.g., 1-5).
--- @param count number The number of random cards to give to the player.
--- @usage
--- ```lua
--- -- Give 3 random cards of star level 2
--- CardRandomizer.giveRandomCard(2, 3)
---
--- -- Give 10 random cards of star level 5
--- CardRandomizer.giveRandomCard(5, 10)
--- ```
function CardRandomizer.giveRandomCard(star, count) end
