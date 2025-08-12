extends HBoxContainer

@onready var button_staff_zone: Button = %ButtonStaffZone
@onready var button_queue_zone: Button = %ButtonQueueZone
@onready var button_plan_zone: Button = %ButtonPlanningZone

@export var boundary_rect: Rect2
@export var zoning_layer: TileMapLayer
@export var enabled: bool = false

var is_creating_zone: bool = false
var is_removing_zone: bool = false
var is_editing_staff: bool = false
var is_editing_queue: bool = false
var is_editing_plan: bool = false
var current_hovered_tile: Vector2i
var previously_placed_hovered_tile: Vector2i
var previously_removed_hovered_tile: Vector2i


func _ready() -> void:
	button_staff_zone.pressed.connect(_on_button_staff_zone_pressed)
	button_queue_zone.pressed.connect(_on_button_queue_zone_pressed)
	button_plan_zone.pressed.connect(_on_button_plan_zone_pressed)


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

	elif is_removing_zone:
		zoning_layer.erase_cell(current_hovered_tile)
		if previously_removed_hovered_tile == current_hovered_tile:
			return
		previously_removed_hovered_tile = current_hovered_tile


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


func _on_button_queue_zone_pressed() -> void:
	_deactivate_zone_buttons()
	enabled = true
	_toggle_is_editing_queue()


func _toggle_is_editing_queue() -> void:
	is_editing_queue = !is_editing_queue


func _on_button_plan_zone_pressed() -> void:
	_deactivate_zone_buttons()
	enabled = true
	_toggle_is_editing_plan()


func _toggle_is_editing_plan() -> void:
	is_editing_plan = !is_editing_plan


func _deactivate_zone_buttons() -> void:
	enabled = false
	is_editing_staff = false
	is_editing_queue = false
