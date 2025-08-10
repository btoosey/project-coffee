class_name AStarPathfinderComponent
extends Node

signal character_to_target_path_acquired(path)

const line_color: Color = Color8(255, 255, 255, 60)

@export var tilemap_layer_walls: TileMapLayer = null
@export var character: Node2D = null
@export var visual_path_line2D: Line2D = null
@export var velocity_component: VelocityComponent = null

@onready var target_timer: Timer = $TargetTimer

var pathfinding_grid: AStarGrid2D = AStarGrid2D.new()
var path_to_target: Array = []
var target_tile: Vector2i


func _ready() -> void:
	visual_path_line2D.global_position = Vector2(Globals.HALF_TILE_SIZE, Globals.HALF_TILE_SIZE)

	target_timer.timeout.connect(_on_target_timer_timeout)

	pathfinding_grid.region = tilemap_layer_walls.get_used_rect()
	pathfinding_grid.cell_size = Vector2(Globals.TILE_SIZE, Globals.TILE_SIZE)
	pathfinding_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES
	pathfinding_grid.update()

#TODO Currently all cells are being set as solid, may want to allow different tile types to be negated from this list
	for cell in tilemap_layer_walls.get_used_cells():
		pathfinding_grid.set_point_solid(cell, true)

	target_timer.start()


func _establish_path_to_target() -> void:
	path_to_target = pathfinding_grid.get_point_path(character.global_position / Globals.TILE_SIZE, target_tile, true)
	visual_path_line2D.points = path_to_target

	if path_to_target.size() >= 1:
		visual_path_line2D.points = path_to_target
		path_to_target.remove_at(0)

	character_to_target_path_acquired.emit(path_to_target)


func _on_target_timer_timeout() -> void:
	_select_character_target()
	_establish_path_to_target()


func _select_character_target() -> void:
	var x = randi_range(pathfinding_grid.region.position.x, pathfinding_grid.region.size.x + pathfinding_grid.region.position.x - 1)
	var y = randi_range(pathfinding_grid.region.position.y, pathfinding_grid.region.size.y + pathfinding_grid.region.position.y - 1)

	if tilemap_layer_walls.get_used_cells().has(Vector2i(x, y)):
		_select_character_target()

	target_tile = Vector2(x, y)
