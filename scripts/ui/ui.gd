extends CanvasLayer

signal plan_zone_button_pressed
signal staff_zone_button_pressed
signal disable_action_modes

@onready var button_staff_zone: Button = %ButtonStaffZone
@onready var button_planning_zone: Button = %ButtonPlanningZone
@onready var action_options: HBoxContainer = $Control/VBoxContainer/ActionOptions


func _ready() -> void:
	button_staff_zone.pressed.connect(_on_button_staff_zone_pressed)
	button_planning_zone.pressed.connect(_on_button_plan_zone_pressed)
	action_options.deactivate_action_modes.connect(_on_deactivate_action_modes)


func _on_button_staff_zone_pressed() -> void:
	staff_zone_button_pressed.emit()


func _on_button_plan_zone_pressed() -> void:
	plan_zone_button_pressed.emit()


func _on_deactivate_action_modes() -> void:
	disable_action_modes.emit()
