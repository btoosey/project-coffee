extends Control

@export var season_length: int = 14;

@onready var day: Label = $VBoxContainer/HBoxContainer/Day
@onready var date: Label = $VBoxContainer/HBoxContainer/Date
@onready var time: Label = $VBoxContainer/Time
@onready var timer: Timer = $Timer

var days: Array = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
var seasons: Array = ["Spring", "Summer", "Autumn", "Winter"]

var hour: int = 7
var minutes: int = 30
var current_day_index: int = 0
var current_date: int = 1
var current_season_index: int = 0


func _ready():
	update_ui()
	timer.timeout.connect(_on_timer_timeout)
	print(seasons[current_season_index])


func _on_timer_timeout():
	minutes += 10
	if minutes >= 60:
		minutes = 0
		hour += 1

	# End of day
	if hour >= 18 && minutes >= 30:
		hour = 7
		minutes = 30
		current_date += 1
		current_day_index = (current_day_index + 1) 
		if current_day_index >= days.size():
			current_day_index = 0

		# End of season
		if current_date > season_length:
			current_date = 1
			current_season_index = (current_season_index + 1)

		if current_season_index >= seasons.size():
					current_season_index = 0

	update_ui()


func update_ui():
	day.text = days[current_day_index]
	date.text = str(current_date)
	time.text = "%02d:%02d" % [hour, minutes]
