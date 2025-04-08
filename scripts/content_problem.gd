extends Control

#const Hold = preload("res://scripts/Hold.gd")
#const Problem = preload("res://scripts/Problem.gd")

var current_problem: Problem
var current_wall: Wall

func _ready() -> void:
	$Scroll/MarginPrincipal/Lista/MarginImage/WallWidget.change_mode(WallWidget.WALL_MODE.SHOW)
	$Scroll/MarginPrincipal/Lista/MarginImage/WallWidget.change_offset($Scroll/MarginPrincipal/Lista/MarginImage/WallWidget.global_position)
	
func load_data(data):
	current_problem = data
	Database.get_wall(current_problem.wallid,
		func(wall):
			current_wall = wall
			$Scroll/MarginPrincipal/Lista/MarginImage/WallWidget.load_data(current_wall)
			$Scroll/MarginPrincipal/Lista/MarginImage/WallWidget.load_problem(current_problem)
			$Scroll/MarginPrincipal/Lista/HBoxContainerNombre/Name.text = data.name
			if AppManager.grade_system == Grade.GRADE_SYSTEMS.FONT:
				$Scroll/MarginPrincipal/Lista/HBoxContainerNombre/MarginContainer/CenterContainer/Panel/Grade.text = Grade.GRADES_FONT[data.grade]
			else:
				$Scroll/MarginPrincipal/Lista/HBoxContainerNombre/MarginContainer/CenterContainer/Panel/Grade.text = Grade.GRADES_HUECO[data.grade]
			$Scroll/MarginPrincipal/Lista/Description.text = data.description
			# calculate stars
			var stars = ""
			for i in data.rating:
				stars += "⭐"
			$Scroll/MarginPrincipal/Lista/Stars.text = stars
			$Scroll/MarginPrincipal/Lista/HBoxContainer/Sends/Number.text = str(current_problem.sends)
			current_problem.create_problem_image(current_wall)
	)


func _on_sends_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		current_problem.sends += 1
		$Scroll/MarginPrincipal/Lista/HBoxContainer/Sends/Number.text = str(current_problem.sends)
		Database.upsert_problem(current_problem,
			func(result: bool):
				print("problem saved result ", result)
		)
