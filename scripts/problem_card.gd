extends MarginContainer

#const Problem = preload("res://scripts/Problem.gd")
var problem: Problem
var lastTouchedCords: Vector2

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
	var problem_texture = ImageTexture.create_from_image(problem.create_problem_image())
	$Fondo/HBoxContainer/MarginContainer/TextureRect.set_texture(problem_texture)

func _on_panel_events_gui_input(event: InputEvent) -> void:
	# use touch instead of mouse event so we can scroll if it's a drag (no distance moved when released)
	if event is InputEventScreenTouch:
		if event.pressed:
			# save for when the touch is released
			lastTouchedCords = event.position
		else: # released
			# if the vector of movement (drag) is very small, it was just a touch
			# so load the screen
			if (event.position.abs() - lastTouchedCords.abs()).length() < 2:
				AppManager.load_screen(AppManager.Screen.PROBLEM_VIEW, problem)
