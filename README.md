# SurfaceControllerLib

Library which allows mods to share data about surfaces using interfaces.

## Concepts

This library exposes all of it's functioality in one interface, called `surface_controllers`. This interface is used to register other interfaces as surface controllers of a certain category.

Surface controller - An interface providing data about one or more surfaces but only about one category.

Controller category - String under which an surface controller is registered, the string should be short and explainatory.

## Interface outline

- `retrieve_controller`
  - Returns name of the interface of the given category for the given surface.
  - Parameters
    - `surface` [number | string] Surface to be retrieved from.
    - `category` [string] Category ot retrieve.
- `list_controller_categories`
  - Returns list of controller categories that are registered on the given surface.
  - Parameters
    - `surface` [number | string] Surface to be retrieved from.
- `assign_controller`
  - Assigns the controller of given surface for given category to the interface given.
  - Parameters
    - `surface` [number | string] Surface to be retrieved from.
    - `controller_category` [string] Category to be registered.
    - `controller_interface_name` [string] Name of the interface to be registered.
- `set_default_controller`
  - Assigns the default controller for given category.
  - Parameters
    - `controller_category` [string] Category to be registered.
    - `controller_interface_name` [string] Name of the interface to be registered.

## General controller category

Every surface must have an controller for an "general" category which contains some basic information about the surface. The default one assigned when the surface is created will provide values indicating an error.

Functions that should be provided by "general" interface:

- `get_controller_mod`
  - Returns name of the mod owning the surface.
