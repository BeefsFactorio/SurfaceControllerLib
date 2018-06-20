-- Default general surface controller
remote.add_interface(
	"default_general_surface_interface",
	{
		get_controller_mod = function()
			return "unknown"
		end
	}
)

-- Initializes all global variables of this mod.
local function init()
	-- Table mapping surface index to interface name of the mod owning it.
	global.surface_controllers = {}

	-- Name of the surface that is currently getting created by the library, needed to ignore the creation event of it.
	global.currently_processing_surface = ""

	-- Default controllers
	global.default_controller_interface = {
		general = "default_general_surface_interface"
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

			if type(surface) == "number" then
				surface_index = surface
			elseif type(surface) == "string" then
				surface_index = game.surfaces[surface].index
			else
				return nil
			end

			if not global.surface_controllers[surface_index] then
				return nil
			end

			return global.surface_controllers[surface_index][category]
		end,
		--
		-- Retrieves list of controller categories the given surface contains.
		list_controller_categories = function(surface)
			local surface_index = 0

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

			if not global.surface_controllers[surface_index] then
				return nil
			end

			local keys = {}

			for key, _ in pairs(global.surface_controllers) do
				table.insert(keys, key)
			end

			return keys
		end,
		-- Used to assing controller to a category of a given surface.
		assign_controller = function(surface, controller_category, controller_interface_name)
			local surface_index = 0

			if type(surface) == "number" then
				surface_index = surface
			elseif type(surface) == "string" then
				surface_index = game.surfaces[surface].index
			else
				return nil
			end

			if not global.surface_controllers[surface_index] then
				global.surface_controllers[surface_index] = {}
			end

			global.surface_controllers[surface_index][controller_category] = controller_interface_name
		end,
		-- Used to set default controller for given category.
		set_default_controller = function(controller_category, controller_interface_name)
			global.default_controller_interface[controller_category] = controller_interface_name
		end
	}
)

-- Used to register the default controller for surfaces creating using the standard way (`game.create_surface`).
local function on_surface_created(event)
	if not game.surfaces[event.surface_index].name == global.currently_processing_surface then
		global.surface_controllers[event.surface_index] = global.default_controller_interface
	end
end

-- Used to clean up after an surface is deleted.
local function on_surface_deleted(event)
	global.surface_controllers[event.surface_index] = nil
end

script.on_event(defines.events.on_surface_created, on_surface_created)
script.on_event(defines.events.on_surface_deleted, on_surface_deleted)
