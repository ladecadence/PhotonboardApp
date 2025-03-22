extends Control

@onready var lista = $Scroll/Lista
@onready var card = preload("res://components/problem_card.tscn")

#const Wall = preload("res://scripts/Wall.gd")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# delete cards
	for child in lista.get_children():
		child.queue_free()
	
	# load data
	var file = FileAccess.open("res://data/problems.json", FileAccess.READ)
	var content = file.get_as_text()
	var jsonData = JSON.parse_string(content)
	
	for p in jsonData:
		var c = card.instantiate()
		#var problem = Problem.new(p["wallid"], p["name"], p["description"],
		# p["rating"], p["grade"], p["sends"])
		var problem = Problem.new("", "", "", 0, "", 0)
		problem.fromJson(JSON.stringify(p))
		
		c.load_data(problem)
		lista.add_child(c)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_button_problems_pressed() -> void:
	AppManager.load_screen(AppManager.Screen.PROBLEM_LIST, null)


func _on_button_walls_pressed() -> void:
	# TODO: remove after wall widget is ready
	var file = FileAccess.open("res://data/wall.json", FileAccess.READ)
	var json = file.get_as_text()
	# var wall = Wall.new("Rocuadramo", "Best wall", true, 5, 40, "user://wall01.jpg")
	var wall = Wall.new("", "", true, 0, 0, "")
	wall.fromJson(json)
	AppManager.load_screen(AppManager.Screen.TEST_WALLWIDGET, wall)


func _on_panel_add_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		AppManager.load_screen(AppManager.Screen.WALL_EDIT, null)


func _on_button_config_pressed() -> void:
	AppManager.load_screen(AppManager.Screen.CONFIG, null)
