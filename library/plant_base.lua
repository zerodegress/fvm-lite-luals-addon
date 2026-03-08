
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

local PlantBase = {}

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

return PlantBase
