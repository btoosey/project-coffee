class_name HoverComponent
extends Node

@export var outline_highlighter: OutlineHighlighter = null
@export var focus_component: FocusComponent = null

var is_hovered: bool = false


func _on_hover_area_mouse_entered() -> void:
	is_hovered = true

	if outline_highlighter:
		outline_highlighter.highlight()


func _on_hover_area_mouse_exited() -> void:

	is_hovered = false

	if focus_component && focus_component.is_focused:
		return

	if outline_highlighter:
		outline_highlighter.clear_highlight()
