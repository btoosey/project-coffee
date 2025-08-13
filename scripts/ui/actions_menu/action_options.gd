extends HBoxContainer

signal deactivate_action_modes

#TODO make ui invisible if character is selected

func _ready():
	var buttons := _get_buttons()

	for button in buttons:
		button.connect("pressed", _on_button_pressed.bind(button))

	for submenu in get_parent().get_children():
		if submenu != self:
			submenu.visible = false


func _on_button_pressed(button: Button):
	_open_submenu(button.text)


func _open_submenu(menu: String):
	for submenu in get_parent().get_children():
		if submenu == self:
			continue

		if menu == submenu.name:
			if submenu.is_visible():
				submenu.set_visible(false)
				deactivate_action_modes.emit()
			else:
				submenu.set_visible(true)
		else:
			submenu.set_visible(false)
			deactivate_action_modes.emit()


func _get_buttons() -> Array:
	var buttons := []

	for child in get_children():
		if child is Button:
			buttons.append(child)

	return buttons
