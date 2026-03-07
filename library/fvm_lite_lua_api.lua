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
--- @return T|nil The created plant instance table, or `nil` if creation fails.
function game.createLuaPlant(luaClassName, ident) end

--- Creates a new instance of a standard (non-Lua defined) plant.
--- @generic T:PlantBase
--- @param ident string A unique identifier for this plant instance.
--- @return T|nil The created plant instance, or `nil` if creation fails.
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
--- @param colorCode integer Color hex code (e.g., 0xFF0000 for red).
--- @return boolean `true` if the message was output successfully, `false` otherwise.
function game.outMessage(msg, colorCode) end

--- Call method of the plant instance(via Delphi).
--- @param instance PlantBase Plant instance.
--- @param methodName string Method name.
--- @param ... any[] Call parameters.
--- @return any The method return.
function game.callPlantMethod(instance, methodName, ...) end

--- Make a move message.
--- @param message string Message to make.
--- @return boolean `true` if the move message was created successfully, `false` otherwise.
function game.makeMoveMessage(message) end

--- Give card to player.
--- @param cardident string Card ident.
--- @param star number Card star.
--- @param count number Card count.
--- @return boolean `true` if the cards were given successfully, `false` otherwise.
function game.giveCard(cardident, star, count) end

--- Get the name of a card.
--- @param cardident string Card ident.
--- @return string The name of the card, or empty string if not found.
function game.getCardName(cardident) end

--- Check if card bag size is greater than the count.
--- @param count number Count to compare.
--- @return boolean `true` if card bag size is greater than the count, `false` otherwise.
function game.checkCardBagSize(count) end

--- Lists all files and subdirectories in the specified directory.
--- @param dir string The path of the directory to list.
--- @return string[] An array of file and directory names found in the specified directory, or an empty array if the directory doesn't exist or is empty.
function game.listDirectory(dir) end

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

--- @class EventSystemAPI
--- The global eventSystem object manages event dispatching and inter-mod communication.
--- @usage
--- ```lua
--- -- Registering an event listener
--- eventSystem:register("plant_created", function(plantInstance)
---     print("New plant created: " .. tostring(plantInstance))
---     return true -- Continue propagation
--- end, 0, "MyMod")
---
--- -- Triggering an event
--- local success = eventSystem:trigger("custom_event", "data1", "data2")
---
--- -- Inter-mod communication
--- eventSystem:subscribe("chat_message", function(sender, data)
---     print("Message from " .. sender .. ": " .. data.message)
--- end, "MyMod")
---
--- eventSystem:sendMessage("MyMod", "chat_message", {message = "Hello from MyMod!"})
--- ```
--- @field register fun(self: EventSystemAPI, eventName:string, callback:fun(arg1:any, ...:any):boolean|nil, priority:integer?, modName:string?):nil Registers an event listener. Return false from callback to stop propagation.
--- @field trigger fun(self: EventSystemAPI, eventName:string, ...:any):boolean Triggers an event. Returns true if all listeners processed it, false if propagation stopped.
--- @field sendMessage fun(self: EventSystemAPI, sender:string, msgType:string, data:any):nil Send message to other mods.
--- @field subscribe fun(self: EventSystemAPI, msgType:string, callback:fun(sender:string, data:any), modName:string?):nil Subscribe to receive messages from other mods.
--- @field unsubscribe fun(self: EventSystemAPI, msgType:string, modName:string):nil Unsubscribe from receiving messages.
--- @field processMessages fun(self: EventSystemAPI):nil Process pending messages in the queue.
--- @field unregisterByMod fun(self: EventSystemAPI, modName:string):nil Unregister all event listeners and message subscriptions for a specific mod.

--- Plant base class, all plants should inherit from this base class.
--- @class PlantBase
--- @usage
--- ```lua
--- -- Creating a custom plant class
--- local MyPlant = PlantBase:new("MyPlant")
---
--- -- Defining required methods
--- MyPlant.init = function(self)
---     self.health = 100
---     self:log("MyPlant initialized!")
--- end
---
--- MyPlant.run = function(self, delta)
---     -- Update logic here
---     self.health = self.health - delta * 0.1
--- end
---
--- MyPlant.render = function(self, progress, opacity)
---     -- Rendering logic here
--- end
---
--- -- Registering the class
--- MyPlant:register("MyPlant", "MyMod")
---
--- -- Creating an instance
--- local myPlantInstance = PlantClassManager:createPlant("MyPlant", "plant_001")
--- if myPlantInstance then
---     myPlantInstance:init()
---     -- Accessing properties
---     local health = myPlantInstance:get("health")
---     print("Plant health: " .. tostring(health))
--- end
--- ```
--- @field name string Plant class name.
--- @field init fun(self: PlantBase) Initializes the plant instance. This method is typically called when a new plant instance is created. Should be overridden.
--- @field run fun(self: PlantBase, delta: number) Run the plant instance's update logic. Should be overridden.
--- @field render fun(self: PlantBase, progress: number, opacity: number) Render the plant instance. Should be overridden.
--- @field log fun(self: PlantBase, message: string) Log a message associated with the plant instance.
--- @field getSelfPtr fun(self: PlantBase): unknown Get the internal Delphi object pointer for this plant instance. This is a convenience wrapper for `PlantBase:getSelf(self)`.
--- @field get fun(self: PlantBase, propName: string): any Get a property of this plant instance. This is a convenience wrapper for `PlantBase:getProperty(self, propName)`.
--- @field set fun(self: PlantBase, propName: string, value: any): boolean Set a property of this plant instance. This is a convenience wrapper for `PlantBase:setProperty(self, propName, value)`.
--- @field call fun(self: PlantBase, methodName: string, ...: any[]): any Call a method on this plant instance. This is a convenience wrapper for `PlantBase:callMethod(self, methodName, ...)`.

PlantBase = {}

--- Create a new plant class definition (not an instance).
--- This method creates a new table that inherits from PlantBase, suitable for defining custom plant classes.
--- @generic T:PlantBase
--- @param className string The name for the new plant class.
--- @return T A new table representing the plant class, ready for method definitions.
function PlantBase:new(className) end

--- Register a plant class with the game engine.
--- This is the recommended way to register plant classes as it handles the registration process.
--- @param className string The unique name of the plant class to register.
--- @param modName string The name of the mod registering this class.
--- @return PlantBase The registered plant class table, or nil if registration failed.
function PlantBase:register(className, modName) end

--- Get the internal Delphi object pointer for a plant instance.
--- This method provides access to the underlying Delphi object for advanced operations.
--- @param instance PlantBase The plant instance to get the internal pointer for.
--- @return unknown The internal Delphi object pointer, or nil if not available.
function PlantBase:getSelf(instance) end

--- Get a property from a plant instance via the Delphi backend.
--- This method directly accesses properties defined in the Delphi game engine.
--- @param instance PlantBase The plant instance to get the property from.
--- @param propName string The name of the property to retrieve.
--- @return any The value of the property, or nil if the property doesn't exist.
function PlantBase:getProperty(instance, propName) end

--- Set a property on a plant instance via the Delphi backend.
--- This method directly modifies properties defined in the Delphi game engine.
--- @param instance PlantBase The plant instance to set the property on.
--- @param propName string The name of the property to set.
--- @param value any The new value for the property.
--- @return boolean true if the property was set successfully, false otherwise.
function PlantBase:setProperty(instance, propName, value) end

--- Call a method on a plant instance via the Delphi backend.
--- This method invokes methods defined in the Delphi game engine.
--- @param instance PlantBase The plant instance to call the method on.
--- @param methodName string The name of the method to call.
--- @param ... any[] The parameters to pass to the method.
--- @return any The return value from the method, or nil if the method call failed.
function PlantBase:callMethod(instance, methodName, ...) end
