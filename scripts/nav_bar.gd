extends MarginContainer


func _on_button_problems_pressed() -> void:
	AppManager.load_screen(AppManager.Screen.PROBLEM_LIST, null)


func _on_button_walls_pressed() -> void:
	AppManager.load_screen(AppManager.Screen.WALL_LIST, null)


func _on_button_config_pressed() -> void:
	AppManager.load_screen(AppManager.Screen.CONFIG, null)
