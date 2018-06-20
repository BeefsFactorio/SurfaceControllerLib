local default_general_surface_interface_name = "default_general_surface_interface"

-- Default general surface controller
remote.add_interface(
	default_general_surface_interface_name,
	{
		get_controller_mod = function()
			return "unknown"
		end
	}
)

-- Initializes all global variables of this mod.
local function init()
	-- Table mapping surface index to categories and interface names of the controllers.
	global.surface_controllers = {}

	-- Default controllers
	global.default_controller_interface = {
		general = default_general_surface_interface_name
	}
end

-- Interface housing all functions of this library.
remote.add_interface(
	"surface_controller",
	{
		--
		-- Retrieves controller of a surface for a given category.
		retrieve_controller = function(surface, category)
			local surface_index = 0

			-- Resolving the actual surface index
			if type(surface) == "number" then
				surface_index = surface
			elseif type(surface) == "string" then
				surface_index = game.surfaces[surface].index
			else
				return nil
			end

			-- Retirning nil if the surface isn't registred at all
			if not global.surface_controllers[surface_index] then
				return nil
			end

			return global.surface_controllers[surface_index][category]
		end,
		--
		-- Retrieves list of controller categories the given surface contains.
		list_controller_categories = function(surface)
			local surface_index = 0

			-- Resolving the actual surface index
			if type(surface) == "number" then
				surface_index = surface
			elseif type(surface) == "string" then
				if game.surfaces[surface] == nil then
					return nil
				end
				surface_index = game.surfaces[surface].index
			else
				return nil
			end

			-- Returning nil if the surface isn't registred at all
			if not global.surface_controllers[surface_index] then
				return nil
			end

			-- Creating a list of all controllers assigned
			local keys = {}

			for key, _ in pairs(global.surface_controllers) do
				table.insert(keys, key)
			end

			return keys
		end,
		--
		-- Used to assing controller to a category of a given surface.
		assign_controller = function(surface, controller_category, controller_interface_name)
			local surface_index = 0

			-- Resolving the actual surface index
			if type(surface) == "number" then
				surface_index = surface
			elseif type(surface) == "string" then
				surface_index = game.surfaces[surface].index
			else
				return nil
			end

			-- Creating the surface table if not created already.
			if not global.surface_controllers[surface_index] then
				global.surface_controllers[surface_index] = {}
			end

			-- The actual assignment
			global.surface_controllers[surface_index][controller_category] = controller_interface_name
		end,
		--
		-- Used to set default controller for given category.
		set_default_controller = function(controller_category, controller_interface_name)
			global.default_controller_interface[controller_category] = controller_interface_name
		end
	}
)

-- Used to register the default controller for surfaces creating using the standard way (`game.create_surface`).
local function on_surface_created(event)
	--
	-- Add all default controllers
	for category, interface in pairs(global.default_controller_interface) do
		remote.call("surface_controller", "assign_controller", event.surface_index, category, interface)
	end
end

-- Used to clean up after an surface is deleted.
local function on_surface_deleted(event)
	global.surface_controllers[event.surface_index] = nil
end

-- Listening to surface related events.
script.on_event(defines.events.on_surface_created, on_surface_created)
script.on_event(defines.events.on_surface_deleted, on_surface_deleted)

-- Listen for initialization event
script.on_init(init)
