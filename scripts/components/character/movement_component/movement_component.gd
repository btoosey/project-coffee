extends Node

@export var character: Node2D = null
@export var velocity_component: VelocityComponent = null
@export var pathfinder_component: AStarPathfinderComponent = null

var can_move: bool = false
var path_to_target: Array = []


func _ready() -> void:
	pathfinder_component.character_to_target_path_acquired.connect(_on_path_acquired)


func _process(delta: float) -> void:
	if !can_move:
		return

	velocity_component.current_speed += velocity_component.acceleration
	velocity_component.current_speed = clamp(velocity_component.current_speed, 0, velocity_component.max_speed)

	var target_position = path_to_target.front() + Vector2(Globals.HALF_TILE_SIZE, Globals.HALF_TILE_SIZE)
	character.global_position = character.global_position.move_toward(target_position, velocity_component.current_speed * delta)

	if character.global_position == target_position:
		path_to_target.pop_front()

	if path_to_target.is_empty():
		can_move = false
		velocity_component.current_speed = 0


func _on_path_acquired(path) -> void:
		_allow_movement(path)


func _allow_movement(path: Array) -> void:
	if path.is_empty():
		return
	else:
		path_to_target = path

	can_move = true
