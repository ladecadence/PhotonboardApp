extends Control


func _on_panel_cancel_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		# Back to wall list
		AppManager.load_screen(AppManager.Screen.PROBLEM_LIST, null)


func _on_panel_continue_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		# continue to edit wall holds
		# TODO: remove after wall widget is ready
		var file = FileAccess.open("res://data/wall.json", FileAccess.READ)
		var json = file.get_as_text()
		# var wall = Wall.new("Rocuadramo", "Best wall", true, 5, 40, "user://wall01.jpg")
		var wall = Wall.new("", "", true, 0, 0, "")
		wall.fromJson(json)
		AppManager.load_screen(AppManager.Screen.WALL_EDIT_HOLDS, wall)
