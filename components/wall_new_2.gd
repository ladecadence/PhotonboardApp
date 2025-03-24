extends MarginContainer

func _ready() -> void:
	$VBoxContainer/MarginContainer/WallWidget.change_mode(WallWidget.WALL_MODE.EDIT)
	$VBoxContainer/MarginContainer/WallWidget.change_offset($VBoxContainer/Header.get_rect().size)

func load_data(data):
	$VBoxContainer/MarginContainer/WallWidget.load_data(data)


func _on_button_pressed() -> void:
	$VBoxContainer/MarginContainer/WallWidget.remove_last()


func _on_check_box_small_pressed() -> void:
	$VBoxContainer/MarginContainer/WallWidget.set_hold_size(Hold.HOLD_SIZE.SMALL)

func _on_check_medium_pressed() -> void:
	$VBoxContainer/MarginContainer/WallWidget.set_hold_size(Hold.HOLD_SIZE.MEDIUM)

func _on_check_box_big_pressed() -> void:
	$VBoxContainer/MarginContainer/WallWidget.set_hold_size(Hold.HOLD_SIZE.BIG)
