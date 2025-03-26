extends MarginContainer

func _ready() -> void:
	$VBoxContainer/MarginContainer/WallWidget.change_mode(WallWidget.WALL_MODE.CREATE)
	$VBoxContainer/MarginContainer/WallWidget.change_offset($VBoxContainer/Header.get_rect().size)

func load_data(data):
	$VBoxContainer/MarginContainer/WallWidget.load_data(data)


func _on_button_undo_pressed() -> void:
	$VBoxContainer/MarginContainer/WallWidget.remove_last()


func _on_check_box_small_pressed() -> void:
	$VBoxContainer/MarginContainer/WallWidget.set_hold_size(Hold.HOLD_SIZE.SMALL)

func _on_check_medium_pressed() -> void:
	$VBoxContainer/MarginContainer/WallWidget.set_hold_size(Hold.HOLD_SIZE.MEDIUM)

func _on_check_box_big_pressed() -> void:
	$VBoxContainer/MarginContainer/WallWidget.set_hold_size(Hold.HOLD_SIZE.BIG)


func _on_button_config_pressed() -> void:
	AppManager.load_screen(AppManager.Screen.CONFIG, null)


func _on_button_walls_pressed() -> void:
	AppManager.load_screen(AppManager.Screen.WALL_LIST, null)

func _on_button_problems_pressed() -> void:
	AppManager.load_screen(AppManager.Screen.PROBLEM_LIST, null)
