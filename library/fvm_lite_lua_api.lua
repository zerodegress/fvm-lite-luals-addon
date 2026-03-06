--! @meta
--
-- FVM-Lite - LuaLS Addon

---@class GameAPI
--- The global 'game' object provides an interface to the underlying game engine.
_G.game = {}

--- Logs a message to the game's console or log file.
---@param message string The message to log.
function _G.game.logMessage(message) end

--- Gets the platform the game is currently running on.
---@return string "windows"|"android"|"linux" The name of the platform.
function _G.game.getPlatform() end

--- Gets the external storage path (primarily relevant for Android).
---@return string The external storage path.
function _G.game.getExternalStoragePath() end

--- Checks if a file exists at the given path.
---@param path string The path to the file.
---@return boolean `true` if the file exists, `false` otherwise.
function _G.game.fileExists(path) end

--- Checks if a directory exists at the given path.
---@param path string The path to the directory.
---@return boolean `true` if the directory exists, `false` otherwise.
function _G.game.dirExists(path) end

--- Registers a plant class with the game engine. Usually called internally by PlantClassManager.
---@param className string The unique name of the plant class.
---@param classTable table The Lua table defining the plant class logic.
function _G.game.registerPlantClass(className, classTable) end

--- Creates a new instance of a Lua-defined plant.
---@param luaClassName string The name of the Lua plant class to create (must be registered).
---@param ident string A unique identifier for this plant instance.
---@return table|nil The created plant instance table, or `nil` if creation fails.
function _G.game.createLuaPlant(luaClassName, ident) end

--- Creates a new instance of a standard (non-Lua defined) plant.
---@param ident string A unique identifier for this plant instance.
---@return table|nil The created plant instance table, or `nil` if creation fails.
function _G.game.createPlant(ident) end

--- Registers a map with the game.
---@param ident string A unique identifier for the map.
---@param mapDataJsonString string A JSON string representing the map data.
---@return boolean `true` if registered successfully, `false` otherwise.
function _G.game.registerMap(ident, mapDataJsonString) end

--- Gets a property from a plant instance.
---@param selfPtr table The plant instance table.
---@param propName string The name of the property to get.
---@return any The value of the property.
function _G.game.getPlantProperty(selfPtr, propName) end

--- Sets a property on a plant instance.
---@param selfPtr table The plant instance table.
---@param propName string The name of the property to set.
---@param value any The new value for the property.
---@return boolean `true` if the property was set successfully, `false` otherwise.
function _G.game.setPlantProperty(selfPtr, propName, value) end

---@class PlantClassManagerAPI
--- Manages the registration and lifecycle of Lua-defined plant classes.
_G.PlantClassManager = {}

---@type table<string, table> A table containing all registered plant classes, indexed by their class name.
--- This table directly references `_G._PLANT_CLASSES`.
_G.PlantClassManager.classes = {}

--- Registers a new plant class. This is the primary method for mods to add new plant types.
--- It internally sends a 'register_plant_class' message via the event system.
---@param className string The unique string name for this plant class.
---@param classTable table The Lua table that defines the plant class (e.g., containing `new`, `update` methods).
---@param modName string The name of the mod that is registering this plant class.
---@return boolean `true` if the class was registered successfully, `false` otherwise. (Actual return depends on event listener)
function _G.PlantClassManager:registerClass(className, classTable, modName) end

--- Retrieves a registered plant class by its name.
--- This method directly accesses the `classes` table.
---@param className string The name of the plant class to retrieve.
---@return table|nil The plant class table if found, or `nil` otherwise.
function _G.PlantClassManager:getClass(className) end

--- Returns a list of all registered plant class names.
---@return string[] A list of class names.
function _G.PlantClassManager:listClasses() end

--- Creates a new instance of a plant.
--- This method internally triggers a 'create_plant' event via the event system.
---@param className string The name of the plant class to instantiate (must be registered).
---@param ident string A unique identifier for this plant instance.
---@return table|nil The created plant instance table, or `nil` if creation fails.
function _G.PlantClassManager:createPlant(className, ident) end


---@type table<string, table>
--- A global table used by the game engine (possibly Delphi/C++ backend) to store all registered plant class definitions.
--- Mods usually interact with this indirectly via `PlantClassManager`.
_G._PLANT_CLASSES = {}

---@class EventSystemAPI
---The global eventSystem object manages event dispatching and inter-mod communication.
---
---Methods:
---@field register fun(eventName:string, callback:fun(arg1:any, ...:any):boolean|nil, priority:integer?, modName:string?):nil
---  Registers an event listener. Return false from callback to stop propagation.
---@field trigger fun(eventName:string, ...:any):boolean
---  Triggers an event. Returns true if all listeners processed it, false if propagation stopped.
---@field sendMessage fun(sender:string, msgType:string, data:any):nil
---@field subscribe fun(msgType:string, callback:fun(sender:string, data:any), modName:string?):nil
---@field unsubscribe fun(msgType:string, modName:string):nil
---@field processMessages fun():nil
---@field unregisterByMod fun(modName:string):nil
