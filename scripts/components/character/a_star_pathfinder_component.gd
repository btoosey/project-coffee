class_name AStarPathfinderComponent
extends Node

signal character_to_target_path_acquired(path)

const line_color: Color = Color8(255, 255, 255, 60)

@export var tilemap_layer_walls: TileMapLayer = null
@export var tilemap_layer_zones: TileMapLayer = null
@export var character: Node2D = null
@export var visual_path_line2D: Line2D = null
@export var velocity_component: VelocityComponent = null
@export var zone_manager: ZoneManager = null

@onready var target_timer: Timer = $TargetTimer

var pathfinding_grid: AStarGrid2D = AStarGrid2D.new()
var path_to_target: Array = []
var target_tile: Vector2i


func _ready() -> void:
	visual_path_line2D.global_position = Vector2(Globals.HALF_TILE_SIZE, Globals.HALF_TILE_SIZE)

	target_timer.timeout.connect(_on_target_timer_timeout)
	zone_manager.zone_tile_added.connect(_on_zone_tile_added)
	zone_manager.zone_tile_removed.connect(_on_zone_tile_removed)

	pathfinding_grid.region = tilemap_layer_walls.get_used_rect()
	pathfinding_grid.cell_size = Vector2(Globals.TILE_SIZE, Globals.TILE_SIZE)
	pathfinding_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES
	pathfinding_grid.update()

#TODO Currently all cells are being set as solid, may want to allow different tile types to be negated from this list
	for cell in tilemap_layer_walls.get_used_cells():
		pathfinding_grid.set_point_solid(cell, true)

	target_timer.start()


func establish_path_to_target(target: Vector2i) -> void:
	path_to_target = pathfinding_grid.get_point_path(character.global_position / Globals.TILE_SIZE, target, true)
	visual_path_line2D.points = path_to_target

	if path_to_target.size() >= 1:
		visual_path_line2D.points = path_to_target
		path_to_target.remove_at(0)

	character_to_target_path_acquired.emit(path_to_target)


func _on_target_timer_timeout() -> void:
	_select_character_target()
	establish_path_to_target(target_tile)


func _select_character_target() -> void:
	var x = randi_range(pathfinding_grid.region.position.x, pathfinding_grid.region.size.x + pathfinding_grid.region.position.x - 1)
	var y = randi_range(pathfinding_grid.region.position.y, pathfinding_grid.region.size.y + pathfinding_grid.region.position.y - 1)

	if tilemap_layer_walls.get_used_cells().has(Vector2i(x, y)):
		_select_character_target()

	target_tile = Vector2(x, y)


func _on_zone_tile_added() -> void:
	if character.is_staff == false:
		var current_cell: Vector2i = tilemap_layer_zones.local_to_map(tilemap_layer_zones.get_global_mouse_position())
		var data = tilemap_layer_zones.get_cell_tile_data(current_cell)
		if data && data.get_custom_data("type") == "STAFF":
			pathfinding_grid.set_point_solid(current_cell, true)


func _on_zone_tile_removed() -> void:
	var current_cell: Vector2i = tilemap_layer_zones.local_to_map(tilemap_layer_zones.get_global_mouse_position())
	pathfinding_grid.set_point_solid(current_cell, false)
	if tilemap_layer_walls.get_cell_tile_data(current_cell):
		pathfinding_grid.set_point_solid(current_cell, true)
