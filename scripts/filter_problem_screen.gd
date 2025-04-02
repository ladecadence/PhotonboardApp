extends MarginContainer

@onready var labelOk = $VBoxContainer/Control/MarginContainer/Scroll/Lista/CenterContainer/LabelOk
@onready var optionWall = $VBoxContainer/Control/MarginContainer/Scroll/Lista/HBoxContainer/OptionWall
@onready var optionGradeMin = $VBoxContainer/Control/MarginContainer/Scroll/Lista/HBoxContainer2/OptionGradeMin
@onready var optionGradeMax = $VBoxContainer/Control/MarginContainer/Scroll/Lista/HBoxContainer2/OptionGradeMax

func _ready() -> void:
	for wall in Database.get_db_walls():
		optionWall.add_item(wall.name)
	if AppManager.grade_system == Grade.GRADE_SYSTEMS.FONT:
		for grade in Grade.GRADES_FONT:
			optionGradeMin.add_item(Grade.GRADES_FONT[grade])
			optionGradeMax.add_item(Grade.GRADES_FONT[grade])
	else:
		for grade in Grade.GRADES_FONT:
			optionGradeMin.add_item(Grade.GRADES_HUECO[grade])
			optionGradeMax.add_item(Grade.GRADES_HUECO[grade])
		
func _on_timer_timeout() -> void:
	labelOk.text = ""

func _on_button_problems_pressed() -> void:
	AppManager.load_screen(AppManager.Screen.PROBLEM_LIST, null)

func _on_button_walls_pressed() -> void:
	AppManager.load_screen(AppManager.Screen.WALL_LIST, null)

func _on_button_config_pressed() -> void:
	pass # Replace with function body.


func _on_panel_filter_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		# get selected wall
		if optionWall.selected:
			var wallids = Database.get_db_wall_ids()
			var wallid = wallids[optionWall.get_selected_id()]
			AppManager.filter_problem.set_wallid(wallid)
		if optionGradeMin.selected and optionGradeMax.selected:
			var grade_min = optionGradeMin.selected+1
			var grade_max = optionGradeMax.selected+1
			AppManager.filter_problem.set_grade_range(grade_min, grade_max)

		

func _on_panel_clear_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		optionWall.select(-1)
		optionGradeMax.select(-1)
		optionGradeMin.select(-1)
		AppManager.filter_problem.clear()
