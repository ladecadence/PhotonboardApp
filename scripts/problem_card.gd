extends MarginContainer

#const Problem = preload("res://scripts/Problem.gd")
var problem: Problem

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func load_data(data: Problem):
	problem = data
	$Fondo/HBoxContainer/Descr/Name.text = data.name
	$Fondo/HBoxContainer/Descr/Description.text = data.description
	# calculate stars
	var stars = ""
	for i in data.rating:
		stars += "⭐"
	$Fondo/HBoxContainer/Descr/Stars.text = stars
	$Fondo/HBoxContainer/Data/MarginContainer/CenterContainer/Panel/Grade.text = data.grade
	$Fondo/HBoxContainer/Data/Sends/Number.text = str(data.sends)
	

func _on_panel_events_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		print(event.position)
		# load problem scene
		AppManager.load_screen(AppManager.Screen.PROBLEM_VIEW, problem)
		
