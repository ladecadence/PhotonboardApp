extends Control

#const Hold = preload("res://scripts/Hold.gd")
#const Problem = preload("res://scripts/Problem.gd")

@onready var star1 = $Scroll/MarginPrincipal/Lista/HBoxProblemInfo/Stars/Star1
@onready var star2 = $Scroll/MarginPrincipal/Lista/HBoxProblemInfo/Stars/Star2
@onready var star3 = $Scroll/MarginPrincipal/Lista/HBoxProblemInfo/Stars/Star3
@onready var star4 = $Scroll/MarginPrincipal/Lista/HBoxProblemInfo/Stars/Star4
@onready var star5 = $Scroll/MarginPrincipal/Lista/HBoxProblemInfo/Stars/Star5
@onready var stars = [star1, star2, star3, star4, star5]

var current_problem: Problem
var current_wall: Wall
var problems_list: Array[Problem]
var last_problem_hscroll: int = Time.get_ticks_msec()

func _ready() -> void:
	$Scroll/MarginPrincipal/Lista/MarginImage/WallWidget.change_mode(WallWidget.WALL_MODE.SHOW)
	$Scroll/MarginPrincipal/Lista/MarginImage/WallWidget.change_offset($Scroll/MarginPrincipal/Lista/MarginImage/WallWidget.global_position)
	
	# calculate stars
	for s in current_problem.rating:
		stars[s].add_theme_color_override("font_color", "#000000")
	
	Database.get_problems(
		AppManager.filter_problem,
		func(problems):
			if problems:
				problems_list = problems
	)
		
func load_data(data):
	current_problem = data
	Database.get_wall(current_problem.wallid,
		func(wall):
			current_wall = wall
			$Scroll/MarginPrincipal/Lista/MarginImage/WallWidget.load_data(current_wall)
			$Scroll/MarginPrincipal/Lista/MarginImage/WallWidget.load_problem(current_problem)
			$Scroll/MarginPrincipal/Lista/HBoxProblemInfo/HBoxContainerNombre/Name.text = data.name
			if AppManager.grade_system == Grade.GRADE_SYSTEMS.FONT:
				$Scroll/MarginPrincipal/Lista/HBoxProblemInfo/HBoxContainerNombre/MarginContainer/CenterContainer/Panel/Grade.text = Grade.GRADES_FONT[data.grade]
			else:
				$Scroll/MarginPrincipal/Lista/HBoxProblemInfo/HBoxContainerNombre/MarginContainer/CenterContainer/Panel/Grade.text = Grade.GRADES_HUECO[data.grade]
			$Scroll/MarginPrincipal/Lista/HBoxProblemInfo/Description.text = data.description
			$Scroll/MarginPrincipal/Lista/HBoxProblemInfo/HBoxContainer/Sends/Number.text = str(current_problem.sends)
			current_problem.create_problem_image(current_wall)
	)

func _on_sends_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		current_problem.sends += 1
		$Scroll/MarginPrincipal/Lista/HBoxProblemInfo/HBoxContainer/Sends/Number.text = str(current_problem.sends)
		Database.upsert_problem(current_problem,
			func(result: bool):
				print("problem saved result ", result)
		)

func _on_star_1_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		for s in current_problem.rating:
			stars[s].add_theme_color_override("font_color", "#ebebeb")
		current_problem.rating = 1
		for s in current_problem.rating:
			stars[s].add_theme_color_override("font_color", "#000000")
		Database.upsert_problem(current_problem,
			func(result: bool):
				print("problem saved result ", result)
		)

func _on_star_2_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		for s in current_problem.rating:
			stars[s].add_theme_color_override("font_color", "#ebebeb")
		current_problem.rating = 2
		for s in current_problem.rating:
			stars[s].add_theme_color_override("font_color", "#000000")
		Database.upsert_problem(current_problem,
			func(result: bool):
				print("problem saved result ", result)
		)

func _on_star_3_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		for s in current_problem.rating:
			stars[s].add_theme_color_override("font_color", "#ebebeb")
		current_problem.rating = 3
		for s in current_problem.rating:
			stars[s].add_theme_color_override("font_color", "#000000")
		Database.upsert_problem(current_problem,
			func(result: bool):
				print("problem saved result ", result)
		)

func _on_star_4_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		for s in current_problem.rating:
			stars[s].add_theme_color_override("font_color", "#ebebeb")
		current_problem.rating = 4
		for s in current_problem.rating:
			stars[s].add_theme_color_override("font_color", "#000000")
		Database.upsert_problem(current_problem,
			func(result: bool):
				print("problem saved result ", result)
		)

func _on_star_5_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		for s in current_problem.rating:
			stars[s].add_theme_color_override("font_color", "#ebebeb")
		current_problem.rating = 5
		for s in current_problem.rating:
			stars[s].add_theme_color_override("font_color", "#000000")
		Database.upsert_problem(current_problem,
			func(result: bool):
				print("problem saved result ", result)
		)

func _on_h_box_problem_info_gui_input(event: InputEvent) -> void:
	var wait_millis = 100  # time to wait after last scroll to allow a new problem scroll
	var scroll_vel = 1000  # X velocity threshold to detect an scroll
	var elapsed = Time.get_ticks_msec() - last_problem_hscroll
	if event is InputEventMouseMotion and event.pressure > 0 and abs(event.velocity[0]) > scroll_vel and elapsed > wait_millis:
		var index = problems_list.find_custom(
			func(problem):
				return problem.uid == current_problem.uid
		)
		var new_problem: Problem
		if event.velocity[0] < 0: # right scroll (next problem)
			new_problem = problems_list[min(index + 1, len(problems_list)-1)]
		else: # left scroll (prev. problem)
			new_problem = problems_list[max(index - 1, 0)]
		AppManager.load_screen(AppManager.Screen.PROBLEM_VIEW, new_problem)
