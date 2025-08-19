class_name ClickToMoveComponent
extends Node

@export var tilemap_layer_world: TileMapLayer
@export var tilemap_layer_walls: TileMapLayer
@export var enabled: bool = false
@export var a_star_pathfinder_component: AStarPathfinderComponent 

var target_tile: Vector2i


func _input(event: InputEvent) -> void:
	if !enabled:
		return

	if event.is_action_pressed("click_to_move"):
		if tilemap_layer_world.get_used_cells().has(tilemap_layer_walls.local_to_map(tilemap_layer_walls.get_global_mouse_position())):
			return
		target_tile = tilemap_layer_world.local_to_map(tilemap_layer_world.get_global_mouse_position())
		a_star_pathfinder_component.establish_path_to_target(target_tile)
