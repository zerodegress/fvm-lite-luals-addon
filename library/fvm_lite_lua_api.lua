--! @meta
--
-- FVM-Lite - LuaLS Addon
--
-- This file provides LuaLS type annotations for the FVM-Lite game engine API.
-- It enables intelligent code completion, type checking, and documentation
-- in editors that support LuaLS (such as VS Code with sumneko.lua extension).
--
-- API Version: 1.0.0
-- Game Engine: FVM-Lite
-- Documentation: For detailed usage examples and tutorials, refer to the modding documentation.
--
-- Usage:
-- 1. Place this file in your project's workspace
-- 2. Configure LuaLS to include this file in your workspace settings
-- 3. Enjoy type-safe modding with full IntelliSense support
--
-- Important Notes:
-- - This is a type definition file only, not a runtime module
-- - All functions are declared as empty stubs for documentation purposes
-- - Actual implementation is provided by the game engine at runtime

--- @class GameAPI
--- The global 'game' object provides an interface to the underlying game engine.
--- @usage
--- ```lua
--- -- Logging a message
--- game.logMessage("Hello from my mod!")
---
--- -- Getting platform information
--- local platform = game.getPlatform()
--- print("Running on: " .. platform)
---
--- -- Checking file existence
--- if game.fileExists("config.json") then
---     print("Config file exists")
--- end
--- ```
game = {}

--- Displays a dialog box with a message.
--- @param msg string The message to display.
function game.dialog(msg) end

--- Logs a message to the game's console or log file. Supports multiple parameters which will be concatenated.
--- @param ... string Variable number of string parameters to log.
function game.logMessage(...) end

--- Outputs a message to the game chat board.
--- @param msg string The message content.
--- @param color number|nil Optional color value (e.g., 0xFFFFFFFF for white). Default is white.
function game.outMessage(msg, color) end

--- Outputs a mod-specific message to the game UI with custom color.
--- This is typically used for mod status messages, notifications, or announcements.
--- @param msg string The message to display.
--- @param color number|nil Optional color value (e.g., 0xFF00CCFF for cyan). Default is white.
--- @usage
--- ```lua
--- -- Display a mod loading message with custom color
--- game.outModMessage('[R键整理] 已加载，按"R"键或使用指令/resortcard整理卡牌', 0xFF00CCFF)
--- ```
function game.outModMessage(msg, color) end

--- Outputs a JSON formatted message to the chat board (may be parsed and displayed with specific styling).
--- @param jsonString string JSON formatted string.
function game.outJsonMsg(jsonString) end

--- Displays a move-related message in the game UI (e.g., when obtaining cards or items).
--- @param msg string The message to display.
function game.makeMoveMessage(msg) end

--- Checks if a file exists at the given path.
--- @param path string The file path.
--- @return boolean `true` if the file exists, `false` otherwise.
function game.fileExists(path) end

--- Checks if a directory exists at the given path.
--- @param path string The directory path.
--- @return boolean `true` if the directory exists, `false` otherwise.
function game.dirExists(path) end

--- Gets the encoding information of a file.
--- @param path string The file path.
--- @return userdata Light userdata (pointer to encoding object).
function game.getFileEncoding(path) end

--- Gets the integer pointer value of a Delphi object (for debugging or special passing).
--- @param obj userdata Any Delphi object pointer.
--- @return number Integer pointer value.
function game.getObjectIntPtr(obj) end

--- Returns the current running platform.
--- @return string "windows"|"android"|"linux"|"unknown" The platform name.
function game.getPlatform() end

--- Gets the external storage path (external storage directory on Android, program directory on other platforms).
--- @return string The external storage path.
function game.getExternalStoragePath() end

--- Lists all files and subdirectories in the specified directory (excluding "." and "..").
--- @param path string The directory path.
--- @return string[] Indexed array (starting from 1) of file and directory names.
function game.listDirectory(path) end

--- Gets the current scene object pointer.
--- @return userdata|nil Current scene object or `nil`.
function game.getCurrentScene() end

--- Registers a plant class with the game engine.
--- @param className string The class name.
--- @param classTable table Lua table containing methods or properties.
--- @return boolean Whether registration was successful.
function game.registerPlantClass(className, classTable) end

--- Creates a Lua plant object.
--- @param className string Registered plant class name.
--- @param ident string Plant instance identifier.
--- @return userdata|nil Plant object on success, `nil` + error message on failure.
function game.createLuaPlant(className, ident) end

--- Gets a property from a plant object (case-insensitive).
--- @param plant userdata Plant object.
--- @param propName string Property name.
--- @return any|nil Property value (type depends on property), or `nil` if property doesn't exist.
function game.getPlantProperty(plant, propName) end

--- Sets a property on a plant object (only writable properties).
--- @param plant userdata Plant object.
--- @param propName string Property name.
--- @param value any New value (must match type).
function game.setPlantProperty(plant, propName, value) end

--- Calls a method on a plant object via RTTI.
--- @param plant userdata Plant object.
--- @param methodName string Method name.
--- @param ... any Parameters to pass to the method (supports number, boolean, string, userdata).
--- @return any|nil Method return value (if any), otherwise no return value.
function game.callPlantMethod(plant, methodName, ...) end

--- Gets a registered plant class table.
--- @param className string Class name.
--- @return table|nil Registered plant class table or `nil`.
function game.getPlantClass(className) end

--- Creates a Lua enemy object.
--- @param className string Registered enemy class name.
--- @param ident string Enemy instance identifier.
--- @return userdata|nil Enemy object on success, `nil` + error message on failure.
function game.createEnemy(className, ident) end

--- Gets a property from an enemy object (case-insensitive).
--- @param enemy userdata Enemy object.
--- @param propName string Property name.
--- @return any|nil Property value (type depends on property), or `nil` if property doesn't exist.
function game.getEnemyProperty(enemy, propName) end

--- Sets a property on an enemy object (only writable properties).
--- @param enemy userdata Enemy object.
--- @param propName string Property name.
--- @param value any New value (must match type).
function game.setEnemyProperty(enemy, propName, value) end

--- Calls a method on an enemy object via RTTI.
--- @param enemy userdata Enemy object.
--- @param methodName string Method name.
--- @param ... any Parameters to pass to the method (supports number, boolean, string, userdata).
--- @return any|nil Method return value (if any), otherwise no return value.
function game.callEnemyMethod(enemy, methodName, ...) end

--- Registers an enemy class with the game engine.
--- @param className string The class name.
--- @param classTable table Lua table containing methods or properties.
--- @return boolean Whether registration was successful.
function game.registerEnemyClass(className, classTable) end

--- Gets a registered enemy class table.
--- @param className string Class name.
--- @return table|nil Registered enemy class table or `nil`.
function game.getEnemyClass(className) end

--- Gives cards to the player.
--- @param cardId string Card identifier.
--- @param level number Card level.
--- @param count number|nil Optional number of cards to add. Default is 1.
function game.giveCard(cardId, level, count) end

--- Checks if the backpack has at least `needCount` empty slots.
--- @param needCount number Required number of empty slots.
--- @return boolean `true` if there are enough empty slots, `false` otherwise.
function game.checkCardBagSize(needCount) end

--- Gets the name of a card based on its ID.
--- @param cardId string Card identifier.
--- @return string Card name, or empty string if not found.
function game.getCardName(cardId) end

--- Gets detailed information about a card in the player's backpack.
--- @param player userdata Player object.
--- @param index number Card slot index (starting from 0).
--- @return table|nil Table containing card information on success, `nil` on failure.
--- Fields in returned table:
--- - `level` (number)
--- - `baseId` (string)
--- - `cost` (number)
--- - `isPlus` (boolean)
function game.getCardInfo(player, index) end

--- Sets the level of a specific card.
--- @param player userdata Player object.
--- @param index number Card index.
--- @param newLevel number New level.
--- @return boolean `true` if successful, `false` otherwise.
function game.setCardLevel(player, index, newLevel) end

--- Removes a card from a specific slot (clears it).
--- @param player userdata Player object.
--- @param index number Card index.
--- @return boolean `true` if successful, `false` otherwise.
function game.removeCard(player, index) end

--- Gets a property of a card in the backpack.
--- @param player userdata Player object.
--- @param index number Card index.
--- @param propName string Property name (case-insensitive).
--- @return any|nil Property value (type depends on property), or `nil` if property doesn't exist.
--- Available properties:
--- - `idx` (string) - Card identifier
--- - `level` (number)
--- - `skilllevel` (number)
--- - `price` (number)
--- - `iscolddown` (boolean)
--- - `colddowntime` (number)
--- - `cooldownmaxtime` (number)
--- - `ident` (string) - Card unique identifier GUID
--- - `baseid` (string) - Base card ID (read-only)
function game.getBagCardProperty(player, index, propName) end

--- Sets a property of a card in the backpack (only some properties are writable).
--- @param player userdata Player object.
--- @param index number Card index.
--- @param propName string Property name.
--- @param value any New value.
--- @return boolean `true` if successful, `false` otherwise.
--- Writable properties:
--- - `level`
--- - `skilllevel`
--- - `price`
--- - `iscolddown`
--- - `colddowntime`
--- - `cooldownmaxtime`
--- - `idx` (will re-associate `base` after setting)
--- - `ident` (must be a valid GUID string)
function game.setBagCardProperty(player, index, propName, value) end

--- Swaps the positions of two cards in the backpack.
--- @param player userdata Player object.
--- @param index1 number First card index.
--- @param index2 number Second card index.
--- @return boolean `true` if successful, `false` otherwise.
function game.swapBagCards(player, index1, index2) end

--- Gets the current player object pointer.
--- @return userdata|nil Player object or `nil`.
function game.getPlayer() end

--- Gets the maximum capacity of the player's backpack (total number of card slots).
--- @param player userdata Player object.
--- @return number Maximum card slot count.
function game.getBagCardCount(player) end

--- Registers a map configuration by parsing a JSON string and storing it in the global map configuration.
--- @param ident string Map identifier.
--- @param jsonString string JSON string containing map configuration.
--- @return boolean `true` if successful (JSON parsed and stored), `false` otherwise.
function game.registerMap(ident, jsonString) end

--- Manages the registration and lifecycle of Lua-defined plant classes.
--- This manager handles the registration, retrieval, and instantiation of custom plant classes.
--- @usage
--- ```lua
--- -- Basic usage flow:
--- -- 1. Create a plant class
--- local MyPlant = PlantBase:new("MyPlant")
--- -- ... define init, run, render methods
---
--- -- 2. Register the class
--- PlantClassManager:registerClass("MyPlant", MyPlant, "MyMod")
---
--- -- 3. Create instances
--- local instance1 = PlantClassManager:createPlant("MyPlant", "instance_1")
--- local instance2 = PlantClassManager:createPlant("MyPlant", "instance_2")
---
--- -- 4. List all registered classes
--- local allClasses = PlantClassManager:listClasses()
--- for _, className in ipairs(allClasses) do
---     print("Registered: " .. className)
--- end
--- ```
PlantClassManager = {}

--- @type table<string, table> A table containing all registered plant classes, indexed by their class name.
--- This table directly references the internal `_PLANT_CLASSES` registry.
--- @usage
--- ```lua
--- for className, classTable in pairs(PlantClassManager.classes) do
---     print("Registered class: " .. className)
--- end
--- ```
PlantClassManager.classes = {}

--- Registers a new plant class. This is the primary method for mods to add new plant types.
--- It internally sends a 'register_plant_class' message via the event system.
--- @param className string The unique string name for this plant class. Must not conflict with existing class names.
--- @param classTable table The Lua table that defines the plant class (must contain at least `init`, `run`, and `render` methods).
--- @param modName string The name of the mod that is registering this plant class (for tracking and cleanup).
--- @return boolean `true` if the class was registered successfully, `false` otherwise (e.g., if name conflicts or classTable is invalid).
--- @usage
--- ```lua
--- local MyPlantClass = PlantBase:new("MyPlant")
--- MyPlantClass.init = function(self) print("Plant initialized!") end
--- MyPlantClass.run = function(self, delta) print("Updating...") end
--- MyPlantClass.render = function(self, progress, opacity) print("Rendering...") end
---
--- local success = PlantClassManager:registerClass("MyPlant", MyPlantClass, "MyMod")
--- ```
function PlantClassManager:registerClass(className, classTable, modName) end

--- Retrieves a registered plant class by its name.
--- This method directly accesses the `classes` table.
--- @param className string The name of the plant class to retrieve.
--- @return table|nil The plant class table if found, or `nil` if the class doesn't exist.
--- @usage
--- ```lua
--- local plantClass = PlantClassManager:getClass("Sunflower")
--- if plantClass then
---     print("Found Sunflower class!")
--- end
--- ```
function PlantClassManager:getClass(className) end

--- Returns a list of all registered plant class names.
--- @return string[] An array of all registered plant class names.
--- @usage
--- ```lua
--- local classList = PlantClassManager:listClasses()
--- for i, className in ipairs(classList) do
---     print(i .. ": " .. className)
--- end
--- ```
function PlantClassManager:listClasses() end

--- Creates a new instance of a plant.
--- This method internally triggers a 'create_plant' event via the event system.
--- @param className string The name of the plant class to instantiate (must be registered).
--- @param ident string A unique identifier for this plant instance (used for tracking and reference).
--- @return table|nil The created plant instance table, or `nil` if creation fails (e.g., class not found or ident conflict).
--- @usage
--- ```lua
--- local sunflower = PlantClassManager:createPlant("Sunflower", "sunflower_001")
--- if sunflower then
---     sunflower:init()
---     print("Created sunflower instance!")
--- end
--- ```
function PlantClassManager:createPlant(className, ident) end
