# SurfaceOwnerLib

Library which allows mods to share data about surfaces using interfaces.

## Concepts

This library exposes all of it's functioality in one interface, called `surface_owners`. This interface is used to register other interfaces as surface owners of a certain category.

Surface owner - An interface providing data about one or more surfaces but only about one category.

Owner category - String under which an surface owner is registered, the string should be short and explainatory.

## Interface outline

 - `retrieve_owner`
    - Returns name of the interface of the given category for the given surface.
    - Parameters
        - `surface` [number | string] Surface to be retrieved from.
        - `category` [string] Category ot retrieve.
 - `list_owner_categories`
    - Returns list of owner categories that are registered on the given surface.
    - Parameters
        - `surface` [number | string] Surface to be retrieved from.
 - `assign_owner`
    - Assigns the owner of given surface for given category to the interface given.
    - Parameters
        - `surface` [number | string] Surface to be retrieved from.
        - `owner_category` [string] Category to be registered.
        - `owner_interface_name` [string] Name of the interface to be registered.
 - `set_default_owner`
    - Assigns the default owner for given category.
    - Parameters
        - `owner_category` [string] Category to be registered.
        - `owner_interface_name` [string] Name of the interface to be registered.

## General owner category

Every surface must have an owner for an "general" category which contains some basic information about the surface. The default one assigned when the surface is created.

Functions that should be provided by "general" interface:
 - `get_owner_mod`
    - Returns name of the mod owning the surface.