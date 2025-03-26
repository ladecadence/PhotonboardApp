extends Control

func _ready() -> void:
	for wall in Database.get_db_walls():
		$MarginContainer/Scroll/Lista/HBoxContainer6/OptionWall.add_item(wall.name)
	for grade in Grade.GRADES_FONT:
		$MarginContainer/Scroll/Lista/HBoxContainer4/OptionGrade.add_item(Grade.GRADES_FONT[grade])



func _on_panel_continue_gui_input(event: InputEvent) -> void:
	pass # Replace with function body.


func _on_panel_cancel_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		# Back to wall list
		AppManager.load_screen(AppManager.Screen.PROBLEM_LIST, null)
