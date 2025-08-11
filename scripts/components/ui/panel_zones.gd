extends Panel

@export var reset : bool = false

var buttons = []

var columnCount : int = 3

func _process(_delta: float):
	if reset:
		reset = false
		LoadButtons()
		ArrangeSelf()
		ArrangeButtons()

func LoadButtons():
	buttons = []
	for child in get_children():
		if child is Button:
			buttons.append(child)
			
func ArrangeSelf():
	anchor_left = 0.134
	anchor_bottom = 0.839
	anchor_top = 0.755
	
	offset_bottom = 0
	offset_top = 0
	offset_left = 0
	offset_right = 0
	
			
func ArrangeButtons():
	var div : float = float(1) / len(buttons)
	
	for i in range(len(buttons)):
		buttons[i].anchor_left = div * i
		buttons[i].anchor_right = (div * i) + div
		buttons[i].anchor_top = 0
		buttons[i].anchor_bottom = 1
	
		buttons[i].offset_bottom = 0
		buttons[i].offset_top = 0
		buttons[i].offset_left = 0
		buttons[i].offset_right = 0
