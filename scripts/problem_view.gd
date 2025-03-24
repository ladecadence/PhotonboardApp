extends MarginContainer

class_name ProblemView

#const Problem = preload("res://scripts/Problem.gd")

func load_data(data):
	$VBoxContainer/ContentProblem.load_data(data)

func _on_button_problems_pressed() -> void:
	AppManager.load_screen(AppManager.Screen.PROBLEM_LIST, null)


func _on_panel_send_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		AppManager.send_problem($VBoxContainer/ContentProblem.current_problem)
