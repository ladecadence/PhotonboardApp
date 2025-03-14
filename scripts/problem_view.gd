extends VBoxContainer

class_name ProblemView

const Problem = preload("res://scripts/Problem.gd")

func loadData(data: Problem):
	$ContentProblem.loadData(data)
	


func _on_button_problems_pressed() -> void:
		get_tree().change_scene_to_file("res://main.tscn")
