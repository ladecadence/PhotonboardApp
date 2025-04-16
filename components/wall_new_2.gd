extends MarginContainer

func _ready() -> void:
	$VBoxContainer/Header2.set_title("New wall")
	$VBoxContainer/MarginContainer/WallWidget.change_mode(WallWidget.WALL_MODE.CREATE)
	$VBoxContainer/MarginContainer/WallWidget.change_offset($VBoxContainer/Header2.get_rect().size)
	
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

func _on_button_save_pressed() -> void:
	var wall = $VBoxContainer/MarginContainer/WallWidget.get_wall()
	Database.upsert_wall(wall,
		func(result: bool):
			print("wall saved result ", result)
	)
