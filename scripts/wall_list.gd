extends MarginContainer

func _ready() -> void:
	$VBoxContainer/Header2.set_title("Walls")

func _on_panel_add_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		AppManager.load_screen(AppManager.Screen.WALL_EDIT, null)
