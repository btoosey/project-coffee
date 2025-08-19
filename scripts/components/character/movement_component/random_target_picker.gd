extends Node

@export var enabled: bool = false

@onready var target_timer: Timer = $TargetTimer


func _ready() -> void:
	target_timer.timeout.connect(_on_target_timer_timeout)

	if enabled:
		target_timer.start()


func _on_target_timer_timeout() -> void:
	get_parent()._select_character_target()
	get_parent().establish_path_to_target(get_parent().target_tile)
