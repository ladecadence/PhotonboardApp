extends MarginContainer

class_name ProblemView

#const Problem = preload("res://scripts/Problem.gd")

func loadData(data):
	$VBoxContainer/ContentProblem.loadData(data)

func _on_button_problems_pressed() -> void:
	AppManager.load_screen(AppManager.Screen.PROBLEM_LIST, null)
