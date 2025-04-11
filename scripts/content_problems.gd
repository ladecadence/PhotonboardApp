extends Control

@onready var lista = $Scroll/Lista
@onready var card = preload("res://components/problem_card.tscn")

#const Wall = preload("res://scripts/Wall.gd")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# delete cards
	for child in lista.get_children():
		child.queue_free()

	# load problems
	Database.get_problems(
		AppManager.filter_problem,
		func(problems):
			if problems:
				for p in problems:
					var c = card.instantiate()
					c.load_data(p)
					lista.add_child(c)
	)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_button_problems_pressed() -> void:
	AppManager.load_screen(AppManager.Screen.PROBLEM_LIST, null)

func _on_button_walls_pressed() -> void:
	AppManager.load_screen(AppManager.Screen.WALL_LIST, null)

func _on_panel_add_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		AppManager.load_screen(AppManager.Screen.PROBLEM_EDIT, null)

func _on_button_config_pressed() -> void:
	AppManager.load_screen(AppManager.Screen.CONFIG, null)

func _on_panel_filter_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		AppManager.load_screen(AppManager.Screen.PROBLEM_FILTER, null)
