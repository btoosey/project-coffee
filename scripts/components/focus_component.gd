class_name FocusComponent
extends Node

@export var target: Node2D = null
@export var hover_component: HoverComponent = null
@export var outline_highlighter: OutlineHighlighter = null
@export var pathfinder_component: AStarPathfinderComponent = null
@export var click_to_move_component: ClickToMoveComponent = null

var is_focused: bool = false


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("character_focus_toggle") && hover_component.is_hovered:
		_clear_focused_characters_group()
		target.add_to_group("focused_characters")
		is_focused = true
		outline_highlighter.highlight()

		if pathfinder_component:
			pathfinder_component.visual_path_line2D.default_color = pathfinder_component.LINE_COLOR

		if click_to_move_component:
			click_to_move_component.enabled = true

	if event.is_action_pressed("character_focus_toggle") && !hover_component.is_hovered:
		_clear_focused_characters_group()
		is_focused = false
		outline_highlighter.clear_highlight()

		if pathfinder_component:
			pathfinder_component.visual_path_line2D.default_color = Color.TRANSPARENT

		if click_to_move_component:
			click_to_move_component.enabled = false


func _clear_focused_characters_group() -> void:
	for characters in get_tree().get_nodes_in_group("focused_characters"):
		characters.remove_from_group("focused_characters")
