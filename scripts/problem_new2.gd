extends Node

@onready var wall_widget = $VBoxContainer/MarginContainer/WallWidget

func _ready() -> void:
	$VBoxContainer/MarginContainer/WallWidget.change_mode(WallWidget.WALL_MODE.EDIT)
	$VBoxContainer/MarginContainer/WallWidget.change_offset($VBoxContainer/Header.get_rect().size)

func load_data(data):
	var wall = Database.get_db_wall(data.wallid)
	$VBoxContainer/MarginContainer/WallWidget.load_problem(data)
	$VBoxContainer/MarginContainer/WallWidget.load_data(wall)

func _on_button_cancel_pressed() -> void:
	AppManager.load_screen(AppManager.Screen.PROBLEM_LIST, null)


func _on_button_save_pressed() -> void:
	var problem = wall_widget.get_problem()
	Database.insert_db_problem(problem)


func _on_button_config_pressed() -> void:
	AppManager.load_screen(AppManager.Screen.CONFIG, null)

func _on_button_walls_pressed() -> void:
	AppManager.load_screen(AppManager.Screen.WALL_LIST, null)


func _on_button_problems_pressed() -> void:
	AppManager.load_screen(AppManager.Screen.PROBLEM_LIST, null)
