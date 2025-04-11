extends MarginContainer

@onready var labelOk = $VBoxContainer/Control/MarginContainer/Scroll/Lista/CenterContainer/LabelOk
@onready var optionWall = $VBoxContainer/Control/MarginContainer/Scroll/Lista/HBoxContainer/OptionWall
@onready var optionGradeMin = $VBoxContainer/Control/MarginContainer/Scroll/Lista/HBoxContainer2/OptionGradeMin
@onready var optionGradeMax = $VBoxContainer/Control/MarginContainer/Scroll/Lista/HBoxContainer2/OptionGradeMax
@onready var optionOrder = $VBoxContainer/Control/MarginContainer/Scroll/Lista/HBoxContainer3/OptionOrder
@onready var buttonDown = $VBoxContainer/Control/MarginContainer/Scroll/Lista/HBoxContainer3/CheckBoxDown

var order_dir : ProblemFilter.ORDER_DIR = ProblemFilter.ORDER_DIR.ASC

func _ready() -> void:
	Database.get_walls(
		func(walls):
			# fill walls
			for wall in walls:
				optionWall.add_item(wall.name)
			# if we have a filter for walls, select the one on the filter
			if AppManager.filter_problem.has_wall_uid():
				Database.get_walls_ids(
					func(walls_ids):
						optionWall.select(walls_ids.find(AppManager.filter_problem.wall_uid))
				)
			else:
				optionWall.select(-1)
				
			# fill grades
			if AppManager.grade_system == Grade.GRADE_SYSTEMS.FONT:
				for grade in Grade.GRADES_FONT:
					optionGradeMin.add_item(Grade.GRADES_FONT[grade])
					optionGradeMax.add_item(Grade.GRADES_FONT[grade])
			else:
				for grade in Grade.GRADES_FONT:
					optionGradeMin.add_item(Grade.GRADES_HUECO[grade])
					optionGradeMax.add_item(Grade.GRADES_HUECO[grade])
					
			# if we have a filter for grades, select them
			if AppManager.filter_problem.has_grade():
				optionGradeMin.select(AppManager.filter_problem.grade_min - 1)
				optionGradeMax.select(AppManager.filter_problem.grade_max - 1)
			else:
				# unselect
				optionGradeMin.select(-1)
				optionGradeMax.select(-1)
			
			# select order
			if AppManager.filter_problem.has_order_by():
				optionOrder.select(AppManager.filter_problem.order_by)
			# select direction
			if AppManager.filter_problem.order_dir == ProblemFilter.ORDER_DIR.DESC:
				buttonDown.button_pressed = true
	)

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
		if optionWall.selected != -1:
			Database.get_walls_ids(
				func(walls_ids):
					var wall_uid = walls_ids[optionWall.get_selected_id()]
					AppManager.filter_problem.wall_uid = wall_uid
			)
		if optionGradeMin.selected != -1 and optionGradeMax.selected != -1:
			var grade_min = optionGradeMin.selected+1
			var grade_max = optionGradeMax.selected+1
			AppManager.filter_problem.grade_min = grade_min
			AppManager.filter_problem.grade_max = grade_max
		if optionOrder.selected != 0:
			AppManager.filter_problem.order_by = optionOrder.selected
			AppManager.filter_problem.order_dir = order_dir
		# go to screen
		AppManager.load_screen(AppManager.Screen.PROBLEM_LIST, null)
		

func _on_panel_clear_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		optionWall.select(-1)
		optionGradeMax.select(-1)
		optionGradeMin.select(-1)
		optionOrder.select(0)
		buttonDown.button_pressed = false
		AppManager.filter_problem.clear()

func _on_check_box_up_pressed() -> void:
	order_dir = ProblemFilter.ORDER_DIR.ASC

func _on_check_box_down_pressed() -> void:
	order_dir = ProblemFilter.ORDER_DIR.DESC
