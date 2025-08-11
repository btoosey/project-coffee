@tool
extends CanvasLayer

var buttons = []

func _ready():
	for button in buttons:
		button.connect("pressed", OnButtonPressed(button))
	
	
func OnButtonPressed(button: Button):
	print(button.text)
