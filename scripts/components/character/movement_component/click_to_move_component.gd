class_name ClickToMoveComponent
extends Node

@export var walls_tilemap_layer: TileMapLayer
@export var enabled: bool = false
@export var a_star_pathfinder_component: AStarPathfinderComponent 

var target_tile: Vector2i


func _input(event: InputEvent) -> void:
	if !enabled:
		return

	if event.is_action_pressed("click_to_move"):
		if walls_tilemap_layer.get_used_cells().has(walls_tilemap_layer.local_to_map(walls_tilemap_layer.get_global_mouse_position())):
			return
		target_tile = walls_tilemap_layer.local_to_map(walls_tilemap_layer.get_global_mouse_position())
		a_star_pathfinder_component.establish_path_to_target(target_tile)
