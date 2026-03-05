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


---@class EventSystemAPI
--- The global 'eventSystem' object manages event dispatching and inter-mod communication.
_G.eventSystem = {}

--- Registers an event listener for a specific event.
---@param eventName string The name of the event to listen for (e.g., "OnGameStart", "OnPlantCreated").
---@param callback fun(arg1:any, ...:any):boolean|nil The function to call when the event is triggered.
---   Return `false` from the callback to stop event propagation to subsequent listeners.
---@param priority integer? Optional priority for the listener (higher number = called sooner). Defaults to 0.
---@param modName string? Optional name of the mod registering this listener, used for automatic unregistration.
function _G.eventSystem.register(eventName, callback, priority, modName) end

--- Triggers an event, notifying all registered listeners.
---@param eventName string The name of the event to trigger.
---@param ... any Arguments to pass to the event listeners.
---@return boolean `true` if all listeners processed the event, `false` if any listener returned `false` to stop propagation.
function _G.eventSystem.trigger(eventName, ...) end

--- Sends a message to other mods.
---@param sender string The name of the mod sending the message.
---@param msgType string The type of the message (a custom string identifier).
---@param data any The data payload to send with the message.
function _G.eventSystem.sendMessage(sender, msgType, data) end

--- Subscribes to messages of a specific type from other mods.
---@param msgType string The type of message to subscribe to.
---@param callback fun(sender:string, data:any) The function to call when a message of this type is received.
---   `sender` is the name of the sending mod, `data` is the message payload.
---@param modName string? Optional name of the mod subscribing, used for automatic unsubscription.
function _G.eventSystem.subscribe(msgType, callback, modName) end

--- Unsubscribes a mod from a specific message type.
---@param msgType string The message type to unsubscribe from.
---@param modName string The name of the mod whose subscription should be removed.
function _G.eventSystem.unsubscribe(msgType, modName) end

--- Processes all pending messages in the internal message queue.
--- This function is typically called by the game engine at regular intervals (e.g., per frame).
function _G.eventSystem.processMessages() end

--- Unregisters all event listeners and message subscriptions associated with a given mod.
--- This is crucial for proper cleanup during mod unloading or hot-reloading.
---@param modName string The name of the mod to unregister.
function _G.eventSystem.unregisterByMod(modName) end


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
function _G.PlantClassManager.registerClass(className, classTable, modName) end

--- Retrieves a registered plant class by its name.
--- This method directly accesses the `classes` table.
---@param className string The name of the plant class to retrieve.
---@return table|nil The plant class table if found, or `nil` otherwise.
function _G.PlantClassManager.getClass(className) end

--- Returns a list of all registered plant class names.
---@return string[] A list of class names.
function _G.PlantClassManager.listClasses() end

--- Creates a new instance of a plant.
--- This method internally triggers a 'create_plant' event via the event system.
---@param className string The name of the plant class to instantiate (must be registered).
---@param ident string A unique identifier for this plant instance.
---@return table|nil The created plant instance table, or `nil` if creation fails.
function _G.PlantClassManager.createPlant(className, ident) end


---@type table<string, table>
--- A global table used by the game engine (possibly Delphi/C++ backend) to store all registered plant class definitions.
--- Mods usually interact with this indirectly via `PlantClassManager`.
_G._PLANT_CLASSES = {}


---@type table
--- The JSON library, typically providing `decode` and `encode` functions.
_G.json = {
    ---Decodes a JSON string into a Lua table.
    ---@param jsonString string The JSON string to decode.
    ---@return table|nil The decoded Lua table, or `nil` on error.
    decode = function(jsonString) return {} end,
    ---Encodes a Lua table into a JSON string.
    ---@param luaTable table The Lua table to encode.
    ---@return string The JSON string representation of the table.
    encode = function(luaTable) return "" end,
}

---@type table
--- The Teal language runtime library. Provides utility functions related to Teal.
_G.tl = {
    ---Gets the current version of the Teal runtime.
    ---@return string The Teal version string.
    version = function() return "" end,
}

---@type table?
--- The LuaJIT global object, providing access to LuaJIT specific features.
--- Only available when the Lua runtime is LuaJIT.
_G.jit = {
    ---@type string The version string of LuaJIT.
    version = "",
}

---@class ModManifest
---@field name string The unique name of the mod.
---@field version string The version string of the mod.
---@field description string? A brief description of the mod.
---@field author string? The author(s) of the mod.
---@field dependencies string[]? A list of other mod names this mod depends on.
---@field path string The file system path to the mod's directory.

---@class ModMain
---@field init fun(eventSystem: EventSystemAPI, modName: string) The initialization function for the mod.
---@field unload fun(eventSystem: EventSystemAPI, modName: string)? The optional cleanup function for the mod.

-- Override global 'require' for better type inference when loading mod's main files.
---@param moduleName string The name of the module to require.
---@return any The module's return value.
---@overload fun(moduleName: "json"): table
---@overload fun(moduleName: "stable"): table
---@overload fun(moduleName: "tl"): table
---@overload fun(moduleName: string): ModMain # For mod main files
local require = require
