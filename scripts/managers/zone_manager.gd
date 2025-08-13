class_name ZoneManager
extends Node

signal zone_tile_added
signal zone_tile_removed

@onready var ui: CanvasLayer = $"../ActionModeUI"

@export var boundary_rect: Rect2
@export var zoning_layer: TileMapLayer
@export var enabled: bool = false

var is_creating_zone: bool = false
var is_removing_zone: bool = false
var is_editing_staff: bool = false
var current_hovered_tile: Vector2i
var previously_placed_hovered_tile: Vector2i
var previously_removed_hovered_tile: Vector2i


func _ready() -> void:
	ui.staff_zone_button_pressed.connect(_on_button_staff_zone_pressed)
	ui.disable_action_modes.connect(_on_disable_action_mode)


func _process(_delta: float) -> void:
	if !is_editing_staff:
		return

	if !is_creating_zone && !is_removing_zone:
		return

	current_hovered_tile = zoning_layer.local_to_map(zoning_layer.get_global_mouse_position())

	if !boundary_rect.has_point(current_hovered_tile):
		return

	if is_creating_zone:
		zoning_layer.set_cell(current_hovered_tile, 0, Vector2i.ZERO)
		if previously_placed_hovered_tile == current_hovered_tile:
			return
		previously_placed_hovered_tile = current_hovered_tile
		zone_tile_added.emit()

	elif is_removing_zone:
		zoning_layer.erase_cell(current_hovered_tile)
		if previously_removed_hovered_tile == current_hovered_tile:
			return
		previously_removed_hovered_tile = current_hovered_tile
		zone_tile_removed.emit()


func _input(event: InputEvent) -> void:
	if !enabled:
		return

	if event.is_action_pressed("zone_creating"):
		is_creating_zone = true

	if event.is_action_released("zone_creating"):
		is_creating_zone = false

	if event.is_action_pressed("zone_removing"):
		is_removing_zone = true

	if event.is_action_released("zone_removing"):
		is_removing_zone = false


func _on_button_staff_zone_pressed() -> void:
	_deactivate_zone_buttons()
	enabled = true
	_toggle_is_editing_staff()


func _toggle_is_editing_staff() -> void:
	is_editing_staff = !is_editing_staff


func _deactivate_zone_buttons() -> void:
	enabled = false
	is_editing_staff = false


func _on_disable_action_mode() -> void:
	_deactivate_zone_buttons()


func _on_button_zones_pressed() -> void:
	toggle_zones_visibility()


func toggle_zones_visibility() -> void:
	if !zoning_layer.visible:
		zoning_layer.show()
	else:
		zoning_layer.hide()
