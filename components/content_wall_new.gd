extends Control

@onready var file_dialog = $FileDialog

func _ready() -> void:
	file_dialog.add_filter("*.jpg", "JPG images")
	file_dialog.file_mode = FileDialog.FileMode.FILE_MODE_OPEN_FILE

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
		# var wall = Wall.new(null, "", "", true, 0, 0, null, 0, 0)
		# wall.fromJson(json)
		var wall = Database.get_db_wall("1fddf17c-3ddf-4dc7-a3d0-e3ac3d9f8b05")
		AppManager.load_screen(AppManager.Screen.WALL_EDIT_HOLDS, wall)


func _on_button_open_image_pressed() -> void:
	file_dialog.show()

func _on_file_dialog_file_selected(path: String) -> void:
	print("Image: ", path)


func _on_button_config_pressed() -> void:
	AppManager.load_screen(AppManager.Screen.CONFIG, null)


func _on_button_walls_pressed() -> void:
	AppManager.load_screen(AppManager.Screen.WALL_LIST, null)


func _on_button_problems_pressed() -> void:
	AppManager.load_screen(AppManager.Screen.PROBLEM_LIST, null)
