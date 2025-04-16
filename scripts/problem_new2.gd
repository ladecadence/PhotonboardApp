extends Node

@onready var wall_widget = $VBoxContainer/MarginContainer/WallWidget

func _ready() -> void:
	$VBoxContainer/Header.set_title("New problem")
	$VBoxContainer/MarginContainer/WallWidget.change_mode(WallWidget.WALL_MODE.EDIT)
	#print("Header offset: ", $VBoxContainer/Header.get_rect().size)
	$VBoxContainer/MarginContainer/WallWidget.change_offset($VBoxContainer/Header.get_rect().size)

func load_data(data):
	Database.get_wall(data.wallid,
		func(wall: Wall):
			$VBoxContainer/MarginContainer/WallWidget.load_problem(data)
			$VBoxContainer/MarginContainer/WallWidget.load_data(wall)
	)

func _on_button_cancel_pressed() -> void:
	AppManager.load_screen(AppManager.Screen.PROBLEM_LIST, null)


func _on_button_save_pressed() -> void:
	var problem = wall_widget.get_problem()
	Database.upsert_problem(problem,
		func(result: bool):
			print("problem saved result ", result)
	)
