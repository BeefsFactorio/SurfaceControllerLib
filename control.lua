-- Default general surface owner
remote.add_interface( default_owner_interface_name, {
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

    global.default_owner_interface = {}
end

-- Interface housing all functions of this library.
remote.add_interface( "surface_owner", {

    -- Custom wrapper around `game.create_surface` method which also registers the owning mod.
    create_surface = function ( owner_interface_name, surface_name, surface_options )
        global.currently_processing_surface = surface_name

        surface = game.create_surface( surface_name, surface_options )

        global.surface_owners[surface.index] = owner_interface_name

        return surface
    end,

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

    get_list_of_owners = function ( surface )
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