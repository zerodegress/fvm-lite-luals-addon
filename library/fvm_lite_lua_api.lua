--! @meta
--
-- FVM-Lite - LuaLS Addon

--- @class GameAPI
--- The global 'game' object provides an interface to the underlying game engine.
game = {}

--- Logs a message to the game's console or log file.
--- @param message string The message to log.
function game.logMessage(message) end

--- Gets the platform the game is currently running on.
--- @return string "windows"|"android"|"linux" The name of the platform.
function game.getPlatform() end

--- Gets the external storage path (primarily relevant for Android).
--- @return string The external storage path.
function game.getExternalStoragePath() end

--- Checks if a file exists at the given path.
--- @param path string The path to the file.
--- @return boolean `true` if the file exists, `false` otherwise.
function game.fileExists(path) end

--- Checks if a directory exists at the given path.
--- @param path string The path to the directory.
--- @return boolean `true` if the directory exists, `false` otherwise.
function game.dirExists(path) end

--- Registers a plant class with the game engine. Usually called internally by PlantClassManager.
--- @param className string The unique name of the plant class.
--- @param classTable table The Lua table defining the plant class logic.
function game.registerPlantClass(className, classTable) end

--- Creates a new instance of a Lua-defined plant.
--- @generic T:PlantBase
--- @param luaClassName string The name of the Lua plant class to create (must be registered).
--- @param ident string A unique identifier for this plant instance.
--- @return T|T @ The created plant instance table, or `nil` if creation fails.
function game.createLuaPlant(luaClassName, ident) end

--- Creates a new instance of a standard (non-Lua defined) plant.
--- @generic T:PlantBase
--- @param ident string A unique identifier for this plant instance.
--- @return T|nil @ The created plant instance, or `nil` if creation fails.
function game.createPlant(ident) end

--- Registers a map with the game.
--- @param ident string A unique identifier for the map.
--- @param mapDataJsonString string A JSON string representing the map data.
--- @return boolean `true` if registered successfully, `false` otherwise.
function game.registerMap(ident, mapDataJsonString) end

--- Gets a property from a plant instance.
--- @param selfPtr table The plant instance table.
--- @param propName string The name of the property to get.
--- @return any The value of the property.
function game.getPlantProperty(selfPtr, propName) end

--- Sets a property on a plant instance.
--- @param selfPtr table The plant instance table.
--- @param propName string The name of the property to set.
--- @param value any The new value for the property.
--- @return boolean `true` if the property was set successfully, `false` otherwise.
function game.setPlantProperty(selfPtr, propName, value) end

--- Output Message in game window.
--- @param msg string Message to output.
--- @param colorCode integer Color hex code.
--- @return boolean `true` if the property was set successfully, `false` otherwise.
function game.outMessage(msg, colorCode) end

--- Call method of the plant instance(via Delphi).
--- @param instance PlantBase Plant instance.
--- @param methodName string Method name.
--- @param ... any[] Call parameters.
--- @return any The method return.
function game.callPlantMethod(instance, methodName, ...) end

--- Make a move message.
--- @param message string Message to make.
function game.makeMoveMessage(message) end

--- Give card to player.
--- @param cardident string Card ident.
--- @param star number Card star.
--- @param count number Card count.
function game.giveCard(cardident, star, count) end

--- Get the name of a card.
--- @param cardident string Card ident.
function game.getCardName(cardident) end

--- Check if card bag size is greater than the count.
--- @param count string Count to compare.
function game.checkCardBagSize(count) end

--- Manages the registration and lifecycle of Lua-defined plant classes.
PlantClassManager = {}

--- @type table<string, table> A table containing all registered plant classes, indexed by their class name.
--- This table directly references `_PLANT_CLASSES`.
PlantClassManager.classes = {}

--- Registers a new plant class. This is the primary method for mods to add new plant types.
--- It internally sends a 'register_plant_class' message via the event system.
--- @param className string The unique string name for this plant class.
--- @param classTable table The Lua table that defines the plant class (e.g., containing `new`, `update` methods).
--- @param modName string The name of the mod that is registering this plant class.
--- @return boolean `true` if the class was registered successfully, `false` otherwise. (Actual return depends on event listener)
function PlantClassManager:registerClass(className, classTable, modName) end

--- Retrieves a registered plant class by its name.
--- This method directly accesses the `classes` table.
--- @param className string The name of the plant class to retrieve.
--- @return table|nil The plant class table if found, or `nil` otherwise.
function PlantClassManager:getClass(className) end

--- Returns a list of all registered plant class names.
--- @return string[] A list of class names.
function PlantClassManager:listClasses() end

--- Creates a new instance of a plant.
--- This method internally triggers a 'create_plant' event via the event system.
--- @param className string The name of the plant class to instantiate (must be registered).
--- @param ident string A unique identifier for this plant instance.
--- @return table|nil The created plant instance table, or `nil` if creation fails.
function PlantClassManager:createPlant(className, ident) end

--- @class EventSystemAPI
--- The global eventSystem object manages event dispatching and inter-mod communication.
---
--- Registers an event listener. Return false from callback to stop propagation.
--- @field register fun(self: EventSystemAPI, eventName:string, callback:fun(arg1:any, ...:any):boolean|nil, priority:integer?, modName:string?):nil
--- Triggers an event. Returns true if all listeners processed it, false if propagation stopped.
--- @field trigger fun(self: EventSystemAPI, eventName:string, ...:any):boolean
--- Send message to other mods.
--- @field sendMessage fun(self: EventSystemAPI, sender:string, msgType:string, data:any):nil
--- receive message from other mods.
--- @field subscribe fun(self: EventSystemAPI, msgType:string, callback:fun(sender:string, data:any), modName:string?):nil
--- @field unsubscribe fun(self: EventSystemAPI, msgType:string, modName:string):nil
--- @field processMessages fun(self: EventSystemAPI):nil
--- @field unregisterByMod fun(self: EventSystemAPI, modName:string):nil

--- Plant base class, all plants should inherit from this base class.
--- @class PlantBase
--- @field name string Plant class name.
--- @field init fun(self: PlantBase) Initializes the plant instance. This method is typically called when a new plant instance is created. Should be overrided.
--- @field run fun(self: PlantBase, delta: number) Run the plant instance's update logic. Should be overrided.
--- @field render fun(self: PlantBase, progress: number, opacity: number) Render the plant instance. Should be overrided.
--- @field log fun(self: PlantBase, message: string) Log a message associated with the plant instance.
--- @field getSelfPtr fun(self: PlantBase): unknown Get the internal Delphi object pointer for this plant instance. This is a convenience method that calls `PlantBase:getSelf(self)`.
--- @field get fun(self: PlantBase, propName: string): any Get a property of this plant instance. This is a convenience method that calls `PlantBase:getProperty(self, propName)`.
--- @field set fun(self: PlantBase, propName: string, value: any): boolean Set a property of this plant instance. This is a convenience method that calls `PlantBase:setProperty(self, propName, value)`.
--- @field call fun(self: PlantBase, methodName: string, ...: any[]): any Call a method on this plant instance. This is a convenience method that calls `PlantBase:callMethod(self, methodName, ...)`.

PlantBase = {}

--- Create new plant class(not instance).
--- @generic T:PlantBase
--- @param className string Plant class name.
--- @return T
function PlantBase:new(className) end

--- Register a plant class(recommended to use)
--- @param className string Plant class name.
--- @param modName string Mod name.
--- @return PlantBase
function PlantBase:register(className, modName) end

--- Get the delphi object of a plant instance.
--- @param instance PlantBase Plant instance.
--- @return unknown
function PlantBase:getSelf(instance) end

--- Get property of a plant instance(via Delphi).
--- @param instance PlantBase Plant instance.
--- @param propName string Property name.
--- @return any Property value.
function PlantBase:getProperty(instance, propName) end

--- Set property of a plant instance(via Delphi).
--- @param instance PlantBase Plant instance.
--- @param propName string Property name.
--- @param value any Property value.
--- @return boolean if the operation succeed.
function PlantBase:setProperty(instance, propName, value) end

--- Call method of the plant instance(via Delphi).
--- @param instance PlantBase Plant instance.
--- @param methodName string Method name.
--- @param ... any[] Call parameters.
--- @return any The method return.
function PlantBase:callMethod(instance, methodName, ...) end
