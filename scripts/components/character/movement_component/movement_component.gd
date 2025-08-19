class_name MovementComponent
extends Node

const LINE_COLOR: Color = Color8(255, 255, 255, 60)

@export var character: Node2D = null
@export var velocity_component: VelocityComponent = null
@export var pathfinder_component: AStarPathfinderComponent = null
@export var visual_path_line2D: Line2D = null

@onready var path_update_timer: Timer = $PathUpdateTimer

var can_move: bool = false
var path_to_target: Array = []


func _ready() -> void:
	pathfinder_component.character_to_target_path_acquired.connect(_on_path_acquired)
	visual_path_line2D.global_position = Vector2(Globals.HALF_TILE_SIZE, Globals.HALF_TILE_SIZE)
	visual_path_line2D.points = path_to_target


func _process(delta: float) -> void:
	if !can_move:
		return

	velocity_component.current_speed += velocity_component.acceleration
	velocity_component.current_speed = clamp(velocity_component.current_speed, 0, velocity_component.max_speed)

	var target_position = path_to_target.front() + Vector2(Globals.HALF_TILE_SIZE, Globals.HALF_TILE_SIZE)
	character.global_position = character.global_position.move_toward(target_position, velocity_component.current_speed * delta)

	if character.global_position == target_position:
		visual_path_line2D.points = path_to_target
		path_to_target.pop_front()

	if path_to_target.is_empty():
		can_move = false
		velocity_component.current_speed = 0


func _on_path_acquired(path) -> void:
		_allow_movement(path)
		visual_path_line2D.points = path_to_target
		if path_to_target.size() > 1:
			visual_path_line2D.points = path_to_target


func _allow_movement(path: Array) -> void:
	if path.is_empty():
		return
	else:
		path_to_target = path
		path_to_target.push_front(character.position - Vector2(Globals.HALF_TILE_SIZE, Globals.HALF_TILE_SIZE))

	can_move = true
	path_update_timer.start()


func _on_path_update_timer_timeout() -> void:
	path_to_target.push_front(character.position - Vector2(Globals.HALF_TILE_SIZE, Globals.HALF_TILE_SIZE))
	visual_path_line2D.points = path_to_target

	if !can_move:
		path_update_timer.stop()
