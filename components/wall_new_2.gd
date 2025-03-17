extends MarginContainer

func _ready() -> void:
	$VBoxContainer/MarginContainer/WallWidget.setOffset($VBoxContainer/Header.get_rect().size)

func loadData(data):
	$VBoxContainer/MarginContainer/WallWidget.loadData(data)


func _on_button_pressed() -> void:
	$VBoxContainer/MarginContainer/WallWidget.remove_last()


func _on_check_box_small_pressed() -> void:
	$VBoxContainer/MarginContainer/WallWidget.set_hold_size(Hold.HOLD_SIZE.SMALL)

func _on_check_medium_pressed() -> void:
	$VBoxContainer/MarginContainer/WallWidget.set_hold_size(Hold.HOLD_SIZE.MEDIUM)

func _on_check_box_big_pressed() -> void:
	$VBoxContainer/MarginContainer/WallWidget.set_hold_size(Hold.HOLD_SIZE.BIG)
