extends Control

@onready var nameEdit = $MarginContainer/Scroll/Lista/HBoxContainer/LineEditName
@onready var descriptionEdit = $MarginContainer/Scroll/Lista/HBoxContainer2/TextEdit
@onready var gradeOption = $MarginContainer/Scroll/Lista/HBoxContainer4/OptionGrade
@onready var wallSelect = $MarginContainer/Scroll/Lista/HBoxContainer6/OptionWall

var walls: Array[Wall]

func _ready() -> void:
	for wall in Database.get_db_walls():
		$MarginContainer/Scroll/Lista/HBoxContainer6/OptionWall.add_item(wall.name)
		walls.append(wall)
	$MarginContainer/Scroll/Lista/HBoxContainer6/OptionWall.select(0)
	
	if AppManager.grade_system == Grade.GRADE_SYSTEMS.FONT:
		for grade in Grade.GRADES_FONT:
			$MarginContainer/Scroll/Lista/HBoxContainer4/OptionGrade.add_item(Grade.GRADES_FONT[grade])
	else:
		for grade in Grade.GRADES_HUECO:
			$MarginContainer/Scroll/Lista/HBoxContainer4/OptionGrade.add_item(Grade.GRADES_HUECO[grade])
	$MarginContainer/Scroll/Lista/HBoxContainer4/OptionGrade.select(0)

func _on_panel_continue_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		# check all fields
		if nameEdit.text == "" or descriptionEdit.text ==  "":
			$MarginContainer/Scroll/Lista/HBoxContainer3/LabelInfo.text = "Please fill all the fields"
		else: 
			var wall = Database.get_db_wall(walls[wallSelect.get_selected_id()].id)
			var grade = gradeOption.selected+1
			var problem = Problem.new(wall.id, nameEdit.text, descriptionEdit.text, 0, grade, AppManager.grade_system, 0)
			AppManager.load_screen(AppManager.Screen.PROBLEM_EDIT_HOLDS, problem)


func _on_panel_cancel_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		# Back to wall list
		AppManager.load_screen(AppManager.Screen.PROBLEM_LIST, null)


func _on_button_config_pressed() -> void:
	AppManager.load_screen(AppManager.Screen.CONFIG, null)


func _on_button_walls_pressed() -> void:
	AppManager.load_screen(AppManager.Screen.WALL_LIST, null)


func _on_button_problems_pressed() -> void:
	AppManager.load_screen(AppManager.Screen.PROBLEM_LIST, null)
