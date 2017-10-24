-- Default general surface owner
remote.add_interface( "default_general_surface_interface", {
    get_owner_mod = function ( )
        return "unknown"
    end
} )

-- Initializes all global variables of this mod.
local function init(  )
    
    -- Table mapping surface index to interface name of the mod owning it.
    global.surface_owners = {}

    -- Name of the surface that is currently getting created by the library, needed to ignore the creation event of it.
    global.currently_processing_surface = ""

    -- Default owners
    global.default_owner_interface = {
        general = "default_general_surface_interface"
    }
end

-- Interface housing all functions of this library.
remote.add_interface( "surface_owner", {

    -- Retrieves owner of a surface for a given category.
    retrieve_owner = function ( surface, category )
        local surface_index = 0

        if type(surface) == "number" then
            surface_index = surface
        elseif type(surface) == "string" then
            surface_index = game.surfaces[surface].index
        else
            return nil
        end

        if not global.surface_owners[surface_index] then
            return nil
        end

        return global.surface_owners[surface_index][category]
    end,

    -- Retrieves list of owner categories given surface contains.
    list_owner_categories = function ( surface )
        local surface_index = 0
        
        if type(surface) == "number" then
            surface_index = surface
        elseif type(surface) == "string" then
            surface_index = game.surfaces[surface].index
        else
            return nil
        end

        if not global.surface_owners[surface_index] then
            return nil
        end

        local keys = {}

        for key,_ in pairs(global.surface_owners) do
            table.insert( keys, key )
        end

        return keys
    end,

    -- Used to assing owner to a category of a given surface.
    assign_owner = function ( surface, owner_category, owner_interface_name )
        local surface_index = 0
        
        if type(surface) == "number" then
            surface_index = surface
        elseif type(surface) == "string" then
            surface_index = game.surfaces[surface].index
        else
            return nil
        end

        if not global.surface_owners[surface_index] then
            global.surface_owners[surface_index] = {}
        end

        global.surface_owners[surface_index][owner_category] = owner_interface_name
    end,

    -- Used to set default owner for given category.
    set_default_owner = function ( owner_category, owner_interface_name )
        global.default_owner_interface[owner_category] = owner_interface_name
    end,
} )

-- Used to register the default owner for surfaces creating using the standard way (`game.create_surface`).
local function on_surface_created( event )
    if not game.surfaces[event.surface_index].name == global.currently_processing_surface then
        global.surface_owners[event.surface_index] = global.default_owner_interface
    end
end

-- Used to clean up after an surface is deleted.
local function on_surface_deleted( event )
    global.surface_owners[event.surface_index] = nil
end

script.on_event( defines.events.on_surface_created, on_surface_created )
script.on_event( defines.events.on_surface_deleted, on_surface_deleted )