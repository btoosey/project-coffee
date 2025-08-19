extends TileMapLayer

var highlight_enabled: bool = false
var previously_placed_highlight_tile: Vector2i
var current_hovered_tile: Vector2i


func _process(_delta: float) -> void:
	if !highlight_enabled:
		return

	current_hovered_tile = local_to_map(get_global_mouse_position())

	if previously_placed_highlight_tile == current_hovered_tile:
		return

	set_cell(local_to_map(get_global_mouse_position()), 0, Vector2i.ZERO)
	erase_cell(previously_placed_highlight_tile)
	previously_placed_highlight_tile = current_hovered_tile
